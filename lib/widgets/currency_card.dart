import 'package:flutter/material.dart';

class CurrencyCard extends StatelessWidget {
  final String currency;
  final List<String> currencies;
  final Function(String?) onChanged;
  final TextEditingController controller;
  final String hint;
  final String balance;

  const CurrencyCard({
    super.key,
    required this.currency,
    required this.currencies,
    required this.onChanged,
    required this.controller,
    required this.hint,
    required this.balance,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Currency Dropdown
          DropdownButton<String>(
            value: currency,
            isExpanded: true,
            underline: const SizedBox(),
            items: currencies.map((String value) {
              return DropdownMenuItem(value: value, child: Text(value));
            }).toList(),
            onChanged: onChanged,
          ),

          const SizedBox(height: 20),

          /// Input
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
            ),
          ),

          Container(height: 2, color: Colors.teal),
        ],
      ),
    );
  }
}
