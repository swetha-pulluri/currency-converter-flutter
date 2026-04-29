import 'package:flutter/material.dart';
import '../services/currency_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Widget _rateRow(String from, String to, double? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// Left side
          Row(
            children: [
              Image.asset(getFlagAsset(from), width: 24, height: 24),
              const SizedBox(width: 6),

              Text(from, style: const TextStyle(fontWeight: FontWeight.w600)),

              const SizedBox(width: 6),
              const Icon(Icons.arrow_forward, size: 16),
              const SizedBox(width: 6),

              Image.asset(getFlagAsset(to), width: 24, height: 24),
              const SizedBox(width: 6),

              Text(to, style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),

          /// Right side
          Text(
            value != null ? value.toStringAsFixed(2) : "-",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            ),
          ),
        ],
      ),
    );
  }

  String getFlagAsset(String currency) {
    switch (currency) {
      case "USD":
        return "assets/flags/us.png";
      case "INR":
        return "assets/flags/in.png";
      case "EUR":
        return "assets/flags/eu.png";
      case "GBP":
        return "assets/flags/gb.png";
      case "JPY":
        return "assets/flags/jp.png";
      default:
        return "assets/flags/us.png";
    }
  }

  final service = CurrencyService();

  double? usdToInr;
  double? usdToEur;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadRates();
  }

  Future<void> loadRates() async {
    try {
      double inr = await service.getRate("USD", "INR");
      double eur = await service.getRate("USD", "EUR");

      setState(() {
        usdToInr = inr;
        usdToEur = eur;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard"), centerTitle: true),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEEF2FF), Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title
              const Text(
                "Welcome Back 👋",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              /// 🔥 Premium Balance Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4F46E5), Color(0xFF6366F1)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.indigo.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total Balance",
                      style: TextStyle(color: Colors.white70),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "\$12,450",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              /// Section Title
              const Text(
                "Live Exchange Rates",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 15),

              /// 🔥 Exchange Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 8),
                  ],
                ),
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        children: [
                          _rateRow("USD", "INR", usdToInr),
                          const Divider(),
                          _rateRow("USD", "EUR", usdToEur),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
