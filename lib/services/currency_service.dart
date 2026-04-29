import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyService {
  final String baseUrl = "https://api.exchangerate-api.com/v4/latest/";

  Future<double> getRate(String from, String to) async {
    final response = await http.get(Uri.parse("$baseUrl$from"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["rates"][to];
    } else {
      throw Exception("Failed to load rate");
    }
  }
}
