import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/services/analytics_service.dart';

final analyticsServiceProvider = Provider<AnalyticsService>(
  (_) => AnalyticsService(),
);
