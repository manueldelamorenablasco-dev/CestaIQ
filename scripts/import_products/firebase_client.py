"""
Cliente de Firestore para operaciones de upsert por lotes.

Schema Firestore:
  products/{productId}
    id, supermarketId, externalId, name, brand,
    category, subcategory, imageUrl, format, updatedAt

  prices/{productId}          ← una entrada por producto-supermercado
    productId, supermarketId, amount, unitPrice, updatedAt
"""

import logging
from pathlib import Path

import firebase_admin
from firebase_admin import credentials, firestore
from google.cloud.firestore_v1 import WriteBatch

from .models import Product, Price

logger = logging.getLogger(__name__)

_BATCH_SIZE = 400  # Firestore permite máx. 500 operaciones por batch; 400 = margen de seguridad


def init_firebase(service_account_path: str | Path) -> None:
    if not firebase_admin._apps:
        cred = credentials.Certificate(str(service_account_path))
        firebase_admin.initialize_app(cred)
        logger.info("Firebase inicializado correctamente")


def get_db():
    return firestore.client()


def upsert_batch(
    pairs: list[tuple[Product, Price]],
    db,
) -> int:
    """
    Escribe una lista de (Product, Price) en Firestore usando batches atómicos.
    Devuelve el número de productos escritos.
    """
    total = 0
    for i in range(0, len(pairs), _BATCH_SIZE):
        chunk = pairs[i : i + _BATCH_SIZE]
        batch: WriteBatch = db.batch()

        for product, price in chunk:
            _set_product(batch, db, product)
            _set_price(batch, db, price)

        batch.commit()
        total += len(chunk)
        logger.debug("Batch %d/%d commiteado (%d productos)", i // _BATCH_SIZE + 1,
                     -(-len(pairs) // _BATCH_SIZE), len(chunk))

    return total


def _set_product(batch: WriteBatch, db, p: Product) -> None:
    ref = db.collection("products").document(p.id)
    batch.set(
        ref,
        {
            "id": p.id,
            "supermarketId": p.supermarket_id,
            "externalId": p.external_id,
            "name": p.name,
            "brand": p.brand,
            "category": p.category,
            "subcategory": p.subcategory,
            "imageUrl": p.image_url,
            "format": p.format,
            "updatedAt": p.updated_at,
        },
        merge=True,  # upsert: solo actualiza los campos presentes
    )


def _set_price(batch: WriteBatch, db, p: Price) -> None:
    ref = db.collection("prices").document(p.product_id)
    batch.set(
        ref,
        {
            "productId": p.product_id,
            "supermarketId": p.supermarket_id,
            "amount": p.amount,
            "unitPrice": p.unit_price,
            "updatedAt": p.updated_at,
        },
        merge=True,
    )
