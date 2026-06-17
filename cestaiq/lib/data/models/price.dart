class Price {
  final String productId;
  final String supermarketId;
  final double amount;
  final double? unitPrice; // precio por unidad de referencia (€/kg, €/l…)

  const Price({
    required this.productId,
    required this.supermarketId,
    required this.amount,
    this.unitPrice,
  });

  factory Price.fromFirestore(String productId, Map<String, dynamic> data) =>
      Price(
        productId: productId,
        supermarketId: data['supermarketId'] as String,
        amount: (data['amount'] as num).toDouble(),
        unitPrice: data['unitPrice'] != null
            ? (data['unitPrice'] as num).toDouble()
            : null,
      );
}
