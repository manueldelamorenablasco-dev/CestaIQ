import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._();
  factory AnalyticsService() => _instance;
  AnalyticsService._();

  final _analytics = FirebaseAnalytics.instance;

  Future<void> logAppOpen() async {
    try {
      await _analytics.logAppOpen();
    } catch (_) {}
  }

  Future<void> logSearch(String term) async {
    if (term.trim().length < 2) return;
    try {
      await _analytics.logSearch(searchTerm: term.trim());
    } catch (_) {}
  }

  Future<void> logAddToCart({
    required String productId,
    required String productName,
    required String category,
  }) async {
    try {
      await _analytics.logAddToCart(
        items: [
          AnalyticsEventItem(
            itemId: productId,
            itemName: productName,
            itemCategory: category,
          ),
        ],
      );
    } catch (_) {}
  }

  Future<void> logCartCompleted({
    required String cheapestSupermarket,
    required double cheapestPrice,
    required double saving,
    required int itemCount,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'cart_completed',
        parameters: {
          'cheapest_supermarket': cheapestSupermarket,
          'cheapest_price': cheapestPrice,
          'saving': saving,
          'item_count': itemCount,
        },
      );
    } catch (_) {}
  }

  Future<void> logScreenView(String screenName) async {
    try {
      await _analytics.logScreenView(screenName: screenName);
    } catch (_) {}
  }
}
