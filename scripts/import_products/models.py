from dataclasses import dataclass, field
from datetime import datetime, timezone
from typing import Optional


def now_utc() -> datetime:
    return datetime.now(timezone.utc)


@dataclass
class Product:
    id: str                   # "{supermarket_id}_{external_id}"
    supermarket_id: str
    external_id: str
    name: str
    brand: str
    category: str             # top-level category (e.g. "Alimentación")
    subcategory: str          # second-level (e.g. "Aceites y vinagres")
    image_url: str
    format: str               # e.g. "1 l", "500 g"
    updated_at: datetime = field(default_factory=now_utc)


@dataclass
class Price:
    product_id: str
    supermarket_id: str
    amount: float
    unit_price: Optional[float]   # price per kg/l reference
    updated_at: datetime = field(default_factory=now_utc)
