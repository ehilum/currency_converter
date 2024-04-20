import 'models/currency-rates-response.dart.dart';
import 'package:intl/intl.dart';

class CurrencyConverterUtils {
  String getConvertedAmount(
      {String? currencyFrom,
      String? currencyTo,
      double? amount,
      CurrencyRatesResponse? currencyRatesResponse}) {
    // Try parsing the amount and rate to double
    var rate = currencyRatesResponse?.rates[currencyTo];

    // Check if all required values are valid
    if (currencyFrom != null &&
        currencyTo != null &&
        amount != null &&
        rate != null) {
      // Calculate the converted amount
      double convertedAmount = amount * rate;

      // Format the number with two decimal places and commas for thousands
      final formatter = NumberFormat('#,##0.00', 'en_US');

      // Return the formatted converted amount as a string
      return formatter.format(convertedAmount);
    }

    // Return "0.00" if any value is not valid
    return "0.00";
  }
}
