import 'package:flutter/material.dart';
import '../services/currency_service.dart';

class CurrencyProvider extends ChangeNotifier {
  final CurrencyService service = CurrencyService();

  String fromCurrency = "USD";
  String toCurrency = "EUR";

  String result = "";
  bool isLoading = false;

  Future<void> convert(String input) async {
    double amount = double.tryParse(input) ?? 0;

    isLoading = true;
    notifyListeners();

    try {
      double rate = await service.getRate(fromCurrency, toCurrency);
      double res = amount * rate;

      result = res.toStringAsFixed(2);
    } catch (e) {
      result = "Error";
    }

    isLoading = false;
    notifyListeners();
  }

  void swap() {
    final temp = fromCurrency;
    fromCurrency = toCurrency;
    toCurrency = temp;

    notifyListeners();
  }

  void setFrom(String value) {
    fromCurrency = value;
    notifyListeners();
  }

  void setTo(String value) {
    toCurrency = value;
    notifyListeners();
  }
}
