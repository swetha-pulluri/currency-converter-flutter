import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/currency_provider.dart';
import '../widgets/currency_card.dart';
import '../widgets/swap_button.dart';
import '../widgets/convert_button.dart';
import '../models/history_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = TextEditingController();
  final resultController = TextEditingController();

  List<ConversionHistory> history = [];
  List<String> currencies = ["USD", "INR", "EUR", "GBP", "JPY"];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CurrencyProvider>(context);

    resultController.text = provider.result;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Currency Converter"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CurrencyCard(
              currency: provider.fromCurrency,
              currencies: currencies,
              onChanged: (value) => provider.setFrom(value!),
              controller: controller,
              hint: "Enter amount",
              balance: "",
            ),

            SwapButton(
              onTap: () {
                provider.swap();

                String temp = controller.text;
                controller.text = resultController.text;
                resultController.text = temp;
              },
            ),

            CurrencyCard(
              currency: provider.toCurrency,
              currencies: currencies,
              onChanged: (value) => provider.setTo(value!),
              controller: resultController,
              hint: "Converted",
              balance: "",
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final item = history[index];

                  return ListTile(
                    leading: const Icon(Icons.history),
                    title: Text("${item.from} → ${item.to}"),
                    subtitle: Text(
                      "${item.amount} → ${item.result.toStringAsFixed(2)}",
                    ),
                  );
                },
              ),
            ),

            provider.isLoading
                ? const CircularProgressIndicator()
                : ConvertButton(
                    onTap: () async {
                      await provider.convert(controller.text);

                      history.insert(
                        0,
                        ConversionHistory(
                          from: provider.fromCurrency,
                          to: provider.toCurrency,
                          amount: double.tryParse(controller.text) ?? 0,
                          result: double.tryParse(provider.result) ?? 0,
                        ),
                      );

                      setState(() {});
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
