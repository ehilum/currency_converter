import 'currency.dart';

class CurrenciesResponse {
  final Map<String, Currency> currencies;

  CurrenciesResponse({
    required this.currencies,
  });

  factory CurrenciesResponse.fromJson(Map<String, dynamic> json) {
    Map<String, Currency> tempCurrencies = {};
    if (json['data'] != null) {
      json['data'].forEach((key, value) {
        tempCurrencies[key] = Currency.fromJson(value);
      });
    }
    return CurrenciesResponse(currencies: tempCurrencies);
  }
}
