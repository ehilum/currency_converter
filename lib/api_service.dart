import 'dart:convert';
import 'package:http/http.dart' as http;

import 'models/currency-rates-response.dart.dart';
import 'models/currency-response.dart';

class ApiService {
  final String apiKey = "fca_live_BvauPz2lJnzKWDaBNsAAuvERH7Uv4xC76yffGT4x";
  final String baseUrl = 'https://api.freecurrencyapi.com/v1';

  Future<CurrenciesResponse> fetchCurrenciesData() async {
    // Example query parameters
    Map<String, String> queryParams = {
      'apikey': apiKey,
    };

    final Uri fetchCurrenciesUri =
        Uri.parse("$baseUrl/currencies").replace(queryParameters: queryParams);

    try {
      final response = await http.get(fetchCurrenciesUri);
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        CurrenciesResponse currenciesResponse =
            CurrenciesResponse.fromJson(jsonResponse);

        return currenciesResponse;
      } else {
        print('Failed to load currency data');
        return Future.error(response.body);
      }
    } catch (error) {
      print('Failed to load currency data: $error');
      return Future.error(error);
    }
  }

  Future<CurrencyRatesResponse> fetchCurrencyRatesData(
      String baseCurrency) async {
    // Example query parameters
    Map<String, String> queryParams = {
      'apikey': apiKey,
      'base_currency': baseCurrency
    };

    final Uri fetchCurrenciesUri =
        Uri.parse("$baseUrl/latest").replace(queryParameters: queryParams);

    try {
      final response = await http.get(fetchCurrenciesUri);
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        CurrencyRatesResponse currencyRates =
            CurrencyRatesResponse.fromJson(jsonResponse);

        return currencyRates;
      } else {
        throw Exception('Failed to load currency rates data');
      }
    } catch (e) {
      throw Exception('Failed to load currency rate data: $e');
    }
  }
}
