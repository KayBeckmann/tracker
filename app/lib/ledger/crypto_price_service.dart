import 'dart:convert';

import 'package:http/http.dart' as http;

import '../data/local/app_database.dart';

class CryptoPriceService {
  CryptoPriceService({required this.database, http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client();

  final AppDatabase database;
  final http.Client _httpClient;

  static const Duration cacheDuration = Duration(hours: 1);

  static const Map<String, String> _symbolToId = {
    'BTC': 'bitcoin',
    'ETH': 'ethereum',
    'ADA': 'cardano',
    'SOL': 'solana',
    'DOT': 'polkadot',
    'BNB': 'binancecoin',
    'LTC': 'litecoin',
    'DOGE': 'dogecoin',
    'MATIC': 'matic-network',
    'XRP': 'ripple',
  };

  Future<double?> getCurrentPrice({
    required String symbol,
    String vsCurrency = 'EUR',
  }) async {
    final normalizedSymbol = symbol.toUpperCase();
    final normalizedCurrency = vsCurrency.toUpperCase();
    final cached = await database.getCachedCryptoPrice(
      symbol: normalizedSymbol,
      currencyCode: normalizedCurrency,
    );
    final now = DateTime.now().toUtc();
    if (cached != null && now.difference(cached.fetchedAt) <= cacheDuration) {
      return cached.price;
    }

    final fetched = await _fetchFromApi(
      symbol: normalizedSymbol,
      vsCurrency: normalizedCurrency,
    );
    if (fetched != null) {
      await database.upsertCryptoPrice(
        symbol: normalizedSymbol,
        currencyCode: normalizedCurrency,
        price: fetched,
        fetchedAt: now,
      );
    }
    return fetched ?? cached?.price;
  }

  Future<double?> _fetchFromApi({
    required String symbol,
    required String vsCurrency,
  }) async {
    final id = _symbolToId[symbol] ?? symbol.toLowerCase();
    final uri = Uri.https('api.coingecko.com', '/api/v3/simple/price', {
      'ids': id,
      'vs_currencies': vsCurrency.toLowerCase(),
    });
    final response = await _httpClient.get(uri);
    if (response.statusCode != 200) {
      return null;
    }
    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      return null;
    }
    final data = decoded[id];
    if (data is! Map<String, dynamic>) {
      return null;
    }
    final priceValue = data[vsCurrency.toLowerCase()];
    if (priceValue is num) {
      return priceValue.toDouble();
    }
    return null;
  }

  void dispose() {
    _httpClient.close();
  }
}
