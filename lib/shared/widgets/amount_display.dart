import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AmountDisplay extends StatelessWidget {
  final double amount;
  final TextStyle? style;
  final String currency;

  const AmountDisplay({
    super.key,
    required this.amount,
    this.style,
    this.currency = '₹',
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(
      symbol: currency,
      decimalDigits: 2,
    );

    return Text(
      formatter.format(amount),
      style: style,
    );
  }
}
