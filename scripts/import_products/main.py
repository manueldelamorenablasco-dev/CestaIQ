"""
Script de importación de productos a Firebase.

Uso:
  cd scripts
  python -m import_products.main

Requiere:
  - service_account.json en el directorio scripts/
  - pip install -r requirements.txt

Para añadir un nuevo supermercado:
  1. Crea providers/nombre.py implementando SupermarketProvider
  2. Importa e incluye la instancia en PROVIDERS
"""

import logging
import sys
import time
from pathlib import Path

from .firebase_client import init_firebase, get_db, upsert_batch, write_metadata
from .models import Product, Price
from .providers.mercadona import MercadonaProvider

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s  %(levelname)-7s  %(message)s",
    datefmt="%H:%M:%S",
)
logger = logging.getLogger(__name__)

# ── Lista de proveedores activos ────────────────────────────────────────────
# Para activar un nuevo supermercado, instanciarlo aquí:
#   from .providers.carrefour import CarrefourProvider
#   from .providers.lidl import LidlProvider
PROVIDERS = [
    MercadonaProvider(),
    # CarrefourProvider(),
    # LidlProvider(),
]

# Tamaño del buffer antes de hacer flush a Firestore
FLUSH_EVERY = 300


def import_provider(provider, db) -> tuple[int, list[str]]:
    """Importa todos los productos del proveedor. Devuelve (total, categorías)."""
    logger.info("─" * 60)
    logger.info("Iniciando importación: %s (%s)", provider.name, provider.supermarket_id)

    top_categories = provider.get_top_categories()
    logger.info("Categorías de primer nivel encontradas: %d", len(top_categories))

    buffer: list[tuple[Product, Price]] = []
    seen_categories: set[str] = set()
    total = 0
    errors = 0

    for top_cat in top_categories:
        top_name = top_cat.get("name", "Sin categoría")
        seen_categories.add(top_name)
        sub_cats = top_cat.get("categories", [top_cat])
        logger.info("  [%s] → %d subcategorías", top_name, len(sub_cats))

        for sub_cat in sub_cats:
            sub_id = str(sub_cat.get("id", ""))
            sub_name = sub_cat.get("name", sub_id)

            try:
                for product, price in provider.get_products_in_category(sub_id, top_name):
                    buffer.append((product, price))

                    if len(buffer) >= FLUSH_EVERY:
                        written = upsert_batch(buffer, db)
                        total += written
                        logger.info("    Guardados %d productos (total acumulado: %d)", written, total)
                        buffer.clear()

            except Exception as exc:
                errors += 1
                logger.error("    Error en subcategoría '%s': %s", sub_name, exc)

        time.sleep(0.5)  # pausa entre categorías principales

    # Flush del buffer restante
    if buffer:
        written = upsert_batch(buffer, db)
        total += written

    logger.info(
        "✓ %s finalizado — %d productos importados, %d errores",
        provider.name, total, errors,
    )
    return total, sorted(seen_categories)


def main() -> None:
    service_account = Path(__file__).parent.parent / "service_account.json"

    if not service_account.exists():
        logger.error(
            "No se encontró service_account.json en %s\n"
            "Descárgalo desde Firebase Console → Configuración del proyecto → "
            "Cuentas de servicio → Generar nueva clave privada",
            service_account,
        )
        sys.exit(1)

    logger.info("Inicializando Firebase...")
    init_firebase(service_account)
    db = get_db()

    grand_total = 0
    all_categories: list[str] = []
    all_supermarket_ids: list[str] = []
    start = time.time()

    for provider in PROVIDERS:
        count, categories = import_provider(provider, db)
        grand_total += count
        all_categories.extend(categories)
        all_supermarket_ids.append(provider.supermarket_id)

    # Escribe metadata/cestaiq: 1 documento que la app lee en vez de
    # escanear toda la colección products para obtener las categorías.
    write_metadata(db, all_categories, all_supermarket_ids)

    elapsed = time.time() - start
    logger.info("═" * 60)
    logger.info(
        "Importación completada en %.1fs — %d productos en total",
        elapsed, grand_total,
    )


if __name__ == "__main__":
    main()
