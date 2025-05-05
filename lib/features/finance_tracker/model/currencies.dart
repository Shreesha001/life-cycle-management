import 'package:merge_app/features/finance_tracker/core/constants/app_constants.dart';
import 'package:flutter/material.dart';

class Currencies {
  final String code;
  final String symbol;
  final String flag;

  Currencies({required this.code, required this.symbol, required this.flag});
}

class CurrencySelector extends StatefulWidget {
  final Function(Currencies) onCurrencyChanged;
  const CurrencySelector({Key? key, required this.onCurrencyChanged})
    : super(key: key);

  @override
  _CurrencySelectorState createState() => _CurrencySelectorState();
}

class _CurrencySelectorState extends State<CurrencySelector> {
  final List<Currencies> currencies = [
    Currencies(code: 'USD', symbol: '\$', flag: '🇺🇸'),
    Currencies(code: 'EUR', symbol: '€', flag: '🇪🇺'),
    Currencies(code: 'INR', symbol: '₹', flag: '🇮🇳'),
    Currencies(code: 'GBP', symbol: '£', flag: '🇬🇧'),
    // Add more as needed
  ];

  late Currencies selectedCurrency;

  @override
  void initState() {
    super.initState();
    selectedCurrency = currencies[0];
  }

  void _showCurrencyPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView(
          children:
              currencies.map((currency) {
                return ListTile(
                  leading: Text(currency.flag, style: TextStyle(fontSize: 24)),
                  title: Text('${currency.symbol} ${currency.code}'),
                  onTap: () {
                    setState(() {
                      selectedCurrency = currency;
                    });
                    widget.onCurrencyChanged(currency); // <-- Notify parent
                    Navigator.pop(context);
                  },
                );
              }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showCurrencyPicker,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Text(selectedCurrency.flag, style: TextStyle(color: Colors.black)),
            const SizedBox(width: 4),
            Text(
              selectedCurrency.symbol,
              style: TextStyle(color: Colors.black),
            ),
            const SizedBox(width: 4),
            Text(
              selectedCurrency.code,
              style: TextStyle(
                color: Colors.black,
                fontFamily: AppConstants.fontFamily,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_down, color: Colors.black),
          ],
        ),
      ),
    );
  }
}
