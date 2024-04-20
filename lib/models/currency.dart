class Currency {
  final String symbol;
  final String name;
  final String symbolNative;
  final int decimalDigits;
  final int rounding;
  final String code;
  final String namePlural;

  Currency({
    required this.symbol,
    required this.name,
    required this.symbolNative,
    required this.decimalDigits,
    required this.rounding,
    required this.code,
    required this.namePlural,
  });

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      symbol: json['symbol'] as String,
      name: json['name'] as String,
      symbolNative: json['symbol_native'] as String,
      decimalDigits: json['decimal_digits'] as int,
      rounding: json['rounding'] as int,
      code: json['code'] as String,
      namePlural: json['name_plural'] as String,
    );
  }
}
