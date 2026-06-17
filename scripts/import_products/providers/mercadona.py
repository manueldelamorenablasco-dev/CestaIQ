"""
MercadonaProvider — importa productos de la API interna de tienda.mercadona.es

La API de Mercadona no es oficial ni está documentada públicamente.
Puede cambiar sin previo aviso. Si falla, revisa los endpoints en:
  https://tienda.mercadona.es  (Network tab del navegador)

Flujo:
  1. POST /postal-codes/actions/change-pc/  → establece el almacén
  2. GET  /categories/?lang=es              → categorías de primer nivel
  3. GET  /categories/{subcategory_id}/     → subcategorías con productos
"""

import time
import logging
from typing import Iterator

import requests

from .base import SupermarketProvider
from ..models import Product, Price, now_utc

logger = logging.getLogger(__name__)

_HEADERS = {
    "User-Agent": (
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) "
        "AppleWebKit/537.36 (KHTML, like Gecko) "
        "Chrome/124.0 Safari/537.36"
    ),
    "Accept": "application/json, text/plain, */*",
    "Accept-Language": "es-ES,es;q=0.9",
    "Origin": "https://tienda.mercadona.es",
    "Referer": "https://tienda.mercadona.es/",
}


class MercadonaProvider(SupermarketProvider):
    BASE_URL = "https://tienda.mercadona.es/api"
    POSTAL_CODE = "28001"       # Madrid — ajusta si prefieres otro almacén
    DELAY_BETWEEN_REQUESTS = 0.4  # segundos entre llamadas
    MAX_RETRIES = 3

    def __init__(self, postal_code: str = POSTAL_CODE):
        self._postal_code = postal_code
        self._session = requests.Session()
        self._session.headers.update(_HEADERS)
        self._init_warehouse()

    # ── Identificación ─────────────────────────────────────────────────────

    @property
    def supermarket_id(self) -> str:
        return "mercadona"

    @property
    def name(self) -> str:
        return "Mercadona"

    # ── Inicialización de almacén ───────────────────────────────────────────

    def _init_warehouse(self) -> None:
        """Establece el almacén mediante código postal para que los precios sean correctos."""
        try:
            resp = self._session.post(
                f"{self.BASE_URL}/postal-codes/actions/change-pc/",
                json={"new_postal_code": self._postal_code},
                timeout=10,
            )
            if resp.ok:
                logger.info("Almacén configurado para CP %s", self._postal_code)
            else:
                logger.warning(
                    "No se pudo configurar almacén (status %s) — continuando sin él",
                    resp.status_code,
                )
        except requests.RequestException as exc:
            logger.warning("Error al configurar almacén: %s — continuando", exc)

    # ── HTTP helper con reintentos ──────────────────────────────────────────

    def _get(self, url: str) -> dict | list | None:
        for attempt in range(1, self.MAX_RETRIES + 1):
            try:
                time.sleep(self.DELAY_BETWEEN_REQUESTS)
                resp = self._session.get(url, timeout=15)
                resp.raise_for_status()
                return resp.json()
            except requests.HTTPError as exc:
                if exc.response is not None and exc.response.status_code == 429:
                    wait = 5 * attempt
                    logger.warning("Rate limit — esperando %ss (intento %s)", wait, attempt)
                    time.sleep(wait)
                else:
                    logger.error("HTTP %s al pedir %s", exc.response.status_code if exc.response else "?", url)
                    return None
            except requests.RequestException as exc:
                logger.error("Error de red en intento %s/%s: %s", attempt, self.MAX_RETRIES, exc)
                if attempt < self.MAX_RETRIES:
                    time.sleep(2 * attempt)
        return None

    # ── Implementación de SupermarketProvider ──────────────────────────────

    def get_top_categories(self) -> list[dict]:
        """
        Devuelve la lista de categorías de primer nivel.
        Cada una incluye "categories" con los IDs de subcategorías.
        """
        data = self._get(f"{self.BASE_URL}/categories/?lang=es")
        if data is None:
            logger.error("No se pudieron obtener las categorías de Mercadona")
            return []
        return data if isinstance(data, list) else data.get("results", [])

    def get_products_in_category(
        self, category_id: str, top_name: str
    ) -> Iterator[tuple[Product, Price]]:
        """
        Llama a /categories/{category_id}/ que devuelve:
          {
            "id": ...,
            "name": "Aceites y vinagres",
            "categories": [
              {
                "id": ...,
                "name": "Aceite de oliva",
                "products": [ {...}, ... ]
              }
            ]
          }
        """
        data = self._get(f"{self.BASE_URL}/categories/{category_id}/?lang=es")
        if not data or not isinstance(data, dict):
            return

        subcategory_name = data.get("name", "")
        now = now_utc()

        for leaf in data.get("categories", []):
            for raw in leaf.get("products", []):
                result = self._parse_product(raw, top_name, subcategory_name, now)
                if result:
                    yield result

    # ── Transformación de datos ─────────────────────────────────────────────

    @staticmethod
    def _build_format(pi: dict) -> str:
        """
        Construye una cadena legible del formato/tamaño del producto.

        Casos reales observados:
          - unit_size=1,  size_format="l",  is_pack=False → "1 l"
          - unit_size=5,  size_format="l",  is_pack=False → "5 l"
          - unit_size=6,  size_format="l",  is_pack=True,  total_units=6, pack_size=1 → "6 x 1 l"
          - unit_size=500, size_format="g", is_pack=False → "500 g"
        """
        size = pi.get("unit_size")
        fmt = (pi.get("size_format") or pi.get("reference_format") or "").strip()
        is_pack = pi.get("is_pack", False)
        pack_size = pi.get("pack_size")
        total_units = pi.get("total_units")

        if is_pack and total_units and pack_size:
            pack_str = int(pack_size) if pack_size == int(pack_size) else pack_size
            return f"{int(total_units)} x {pack_str} {fmt}".strip()

        if size is not None and fmt:
            size_str = int(size) if size == int(size) else size
            return f"{size_str} {fmt}".strip()

        return fmt

    def _parse_product(
        self, raw: dict, category: str, subcategory: str, now
    ) -> tuple[Product, Price] | None:
        try:
            external_id = str(raw["id"])
            product_id = f"{self.supermarket_id}_{external_id}"
            pi = raw.get("price_instructions", {})

            product = Product(
                id=product_id,
                supermarket_id=self.supermarket_id,
                external_id=external_id,
                name=raw.get("display_name") or raw.get("slug", ""),
                brand=raw.get("brand") or "",
                category=category,
                subcategory=subcategory,
                image_url=raw.get("thumbnail") or "",
                format=self._build_format(pi),
                updated_at=now,
            )

            # unit_price = precio que pagas por la unidad (p.ej. 0,84€ por un brick de leche)
            # bulk_price  = precio de referencia por kg/l (para comparar)
            bulk = pi.get("bulk_price") or pi.get("reference_price")
            price = Price(
                product_id=product_id,
                supermarket_id=self.supermarket_id,
                amount=float(pi.get("unit_price", 0)),
                unit_price=float(bulk) if bulk else None,
                updated_at=now,
            )

            return product, price

        except (KeyError, ValueError, TypeError) as exc:
            logger.debug("Producto omitido (id=%s): %s", raw.get("id", "?"), exc)
            return None
