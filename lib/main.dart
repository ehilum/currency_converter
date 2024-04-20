import 'package:currency_converter/currency_converter-utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'api_service.dart';
import 'models/currency.dart';
import 'models/currency-rates-response.dart.dart';
import 'models/currency-response.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Currency converter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ApiService _apiService = ApiService();
  final CurrencyConverterUtils _currencyConverterUtils =
      CurrencyConverterUtils();

  Map<String, Currency>? _currencies; // This will hold the fetched data
  bool isCurrenciesLoading = true; // To handle loading state
  String? dropdownAmountFromCurrencyValue;
  String? dropdownAmountToCurrencyValue;

  CurrencyRatesResponse?
      _currencyRatesResponse; // This will hold the fetched data
  bool isRatesLoading = false;

  // TextEditingController for managing the text input
  final TextEditingController amountController = TextEditingController();

  // State variable to hold the parsed amount value
  double amountValue = 0.0;

  @override
  void initState() {
    super.initState();
    fetchCurrencyData();
  }

  void fetchCurrencyData() async {
    try {
      CurrenciesResponse response = await _apiService.fetchCurrenciesData();
      setState(() {
        _currencies = response.currencies;
        if (_currencies != null && _currencies!.isNotEmpty) {
          dropdownAmountFromCurrencyValue = _currencies!.keys.first;
          dropdownAmountToCurrencyValue =
              _currencies?.keys.firstWhere((element) => element == "USD");

          // Set the first currency as the default and fetch exchange rates
          fetchCurrencyRatesData(_currencies!.keys.first);
        }
        isCurrenciesLoading = false; // Update loading state
      });
    } catch (e) {
      setState(() {
        isCurrenciesLoading = false; // Update loading state
        print('Failed to load currency data: $e'); // Handle error
      });
    }
  }

  void fetchCurrencyRatesData(String baseCurrency) async {
    isRatesLoading = true;
    try {
      CurrencyRatesResponse? currencyRatesResponse =
          await _apiService.fetchCurrencyRatesData(baseCurrency);
      setState(() {
        _currencyRatesResponse = currencyRatesResponse;
        isRatesLoading = false; // Update loading state
      });
    } catch (e) {
      setState(() {
        isRatesLoading = false; // Update loading state
        print('Failed to load currency data: $e'); // Handle error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            title: Container(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                              color: Colors.deepPurple.shade900,
                              fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "Check live rates fetched from freeapicurrency",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ))),
        body: _buildCurrencyRatesView());
  }

  Widget _buildCurrencyRatesView() {
    String convertedAmount = _currencyConverterUtils.getConvertedAmount(
        currencyFrom: dropdownAmountFromCurrencyValue,
        currencyTo: dropdownAmountToCurrencyValue,
        amount: amountValue,
        currencyRatesResponse: _currencyRatesResponse);

    String convertedExchangeRate = _currencyConverterUtils.getConvertedAmount(
        currencyFrom: dropdownAmountFromCurrencyValue,
        currencyTo: dropdownAmountToCurrencyValue,
        amount: 1,
        currencyRatesResponse: _currencyRatesResponse);

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Amount",
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DropdownButton<String>(
                value: dropdownAmountFromCurrencyValue,
                elevation: 16,
                onChanged: (String? value) {
                  // This is called when the user selects an item.
                  if (value != null) {
                    setState(() {
                      dropdownAmountFromCurrencyValue = value;
                      fetchCurrencyRatesData(value);
                    });
                  }
                },
                selectedItemBuilder: (BuildContext context) =>
                    _currencies?.keys
                        .map<Widget>((String key) => Container(
                              alignment: Alignment.center,
                              child: Text(key,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                          color: Colors.deepPurple.shade900)),
                            ))
                        .toList() ??
                    [],
                items: _currencies?.keys
                        .map<DropdownMenuItem<String>>((String key) {
                      return DropdownMenuItem<String>(
                        value: key,
                        child: Text(key,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: Colors.grey.shade900)),
                      );
                    }).toList() ??
                    [],
              ),
              const SizedBox(width: 10),
              Expanded(
                // Makes TextField flexible in width within the Row
                child: TextField(
                  controller: amountController,
                  textAlign: TextAlign.right,
                  decoration: const InputDecoration(
                    hintText: 'Enter amount',
                    border: OutlineInputBorder(),
                  ),
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w700),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (value) {
                    setState(() {
                      amountValue = double.tryParse(value) ?? 0.0;
                    });
                  },
                ),
              )
            ],
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 34, bottom: 24),
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade900,
              shape: BoxShape.circle,
            ),
            padding: EdgeInsets.all(10),
            child: const Icon(
              Icons.swap_vert,
              color: Colors.white,
              size: 24,
            ),
          ),
          Text(
            "Converted amount",
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DropdownButton<String>(
                value: dropdownAmountToCurrencyValue,
                elevation: 16,
                onChanged: (String? value) {
                  // This is called when the user selects an item.
                  if (value != null) {
                    setState(() {
                      dropdownAmountToCurrencyValue = value;
                    });
                  }
                },
                selectedItemBuilder: (BuildContext context) =>
                    _currencies?.keys
                        .map<Widget>((String key) => Container(
                              alignment: Alignment.center,
                              child: Text(key,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                          color: Colors.deepPurple.shade900)),
                            ))
                        .toList() ??
                    [],
                items: _currencies?.keys
                        .map<DropdownMenuItem<String>>((String key) {
                      return DropdownMenuItem<String>(
                        value: key,
                        child: Text(key,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: Colors.grey.shade900)),
                      );
                    }).toList() ??
                    [],
              ),
              const SizedBox(width: 10),
              Text(convertedAmount,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w700)),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 48, bottom: 16),
            child: Text(
              "Exchange rate",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          Text(
              '1 $dropdownAmountFromCurrencyValue = '
              '$convertedExchangeRate $dropdownAmountToCurrencyValue',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w700))
        ],
      ),
    );
  }
}
