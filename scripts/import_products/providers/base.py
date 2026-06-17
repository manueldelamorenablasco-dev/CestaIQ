from abc import ABC, abstractmethod
from typing import Iterator
from ..models import Product, Price


class SupermarketProvider(ABC):
    """
    Interfaz genérica para cualquier proveedor de supermercado.

    Para añadir un nuevo supermercado:
      1. Crea una clase que herede de SupermarketProvider.
      2. Implementa los tres métodos abstractos.
      3. Añade la instancia al lista PROVIDERS en main.py.
    """

    @property
    @abstractmethod
    def supermarket_id(self) -> str:
        """Identificador único, en minúsculas y sin espacios. Ej: 'mercadona'."""

    @property
    @abstractmethod
    def name(self) -> str:
        """Nombre para mostrar. Ej: 'Mercadona'."""

    @abstractmethod
    def get_top_categories(self) -> list[dict]:
        """
        Devuelve las categorías de primer nivel.
        Cada elemento debe tener al menos: {"id": ..., "name": ..., "categories": [...]}
        donde categories es la lista de subcategorías de segundo nivel.
        """

    @abstractmethod
    def get_products_in_category(
        self, category_id: str, top_name: str
    ) -> Iterator[tuple[Product, Price]]:
        """
        Itera sobre todos los productos de una categoría de segundo nivel.
        Yields (Product, Price) para cada producto encontrado.
        """

    def get_all_products(self) -> Iterator[tuple[Product, Price]]:
        """
        Template method: itera sobre todas las categorías y productos.
        No es necesario sobreescribir este método normalmente.
        """
        for top_cat in self.get_top_categories():
            for sub_cat in top_cat.get("categories", [top_cat]):
                sub_id = str(sub_cat.get("id", ""))
                if sub_id:
                    yield from self.get_products_in_category(
                        sub_id, top_cat.get("name", "")
                    )
