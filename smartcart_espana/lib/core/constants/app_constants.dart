class AppConstants {
  static const String appName = 'SmartCart España';
  static const String appVersion = '1.0.0';

  // Firestore collections
  static const String usersCollection = 'users';
  static const String productsCollection = 'products';
  static const String supermarketsCollection = 'supermarkets';
  static const String pricesCollection = 'prices';
  static const String priceHistoryCollection = 'price_history';
  static const String shoppingListsCollection = 'shopping_lists';
  static const String listItemsCollection = 'list_items';
  static const String alertsCollection = 'alerts';
  static const String categoriesCollection = 'categories';

  // Remote Config keys
  static const String rcPremiumPrice = 'premium_price_eur';
  static const String rcMaxFreeAlerts = 'max_free_alerts';
  static const String rcAiEnabled = 'ai_optimization_enabled';

  // SharedPreferences keys
  static const String spOnboardingDone = 'onboarding_done';
  static const String spUserPremium = 'user_premium';
  static const String spLastSync = 'last_sync';
  static const String spSelectedSupermarkets = 'selected_supermarkets';

  // Business
  static const double premiumPriceEur = 24.99;
  static const int freeMaxLists = 1;
  static const int premiumMaxLists = 50;
  static const int freeMaxAlerts = 0;
  static const int premiumMaxAlerts = 20;
  static const int priceHistoryDaysFree = 0;
  static const int priceHistoryDaysPremium = 365;

  // Supported supermarkets
  static const List<String> supportedSupermarkets = [
    'mercadona',
    'carrefour',
    'lidl',
    'aldi',
    'alcampo',
    'eroski',
    'dia',
    'consum',
    'hipercor',
    'el_corte_ingles',
  ];

  // Cache TTL
  static const Duration productCacheTtl = Duration(hours: 6);
  static const Duration priceCacheTtl = Duration(hours: 2);
}
