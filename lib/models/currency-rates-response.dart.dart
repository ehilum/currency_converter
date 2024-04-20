class CurrencyRatesResponse {
  final Map<String, double> rates;

  CurrencyRatesResponse({
    required this.rates,
  });

  factory CurrencyRatesResponse.fromJson(Map<String, dynamic> json) {
    Map<String, double> tempRates = {};
    if (json['data'] != null) {
      json['data'].forEach((key, value) {
        tempRates[key] = (value is int) ? value.toDouble() : value as double;
      });
    }
    return CurrencyRatesResponse(rates: tempRates);
  }
}
