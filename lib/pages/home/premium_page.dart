import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PremiumPage extends StatefulWidget {
  const PremiumPage({super.key});

  @override
  State<PremiumPage> createState() => _PremiumPageState();
}

class _PremiumPageState extends State<PremiumPage> {
  bool purchasing = false;
  String? selectedPackage;
  late final List<String> packages;

  @override
  void initState() {
    super.initState();

    packages = ["Annual", "Monthly", "Lifetime"];
    selectedPackage = packages.first;
  }

  void handleBuy() async {
    if (selectedPackage == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select a package")));
      return;
    }
    setState(() => purchasing = true);

    try {
      await Future.delayed(const Duration(seconds: 2));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Purchased $selectedPackage successfully")),
      );
    } catch (e) {
      print("Purchase failed: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Purchase failed")));
    } finally {
      setState(() => purchasing = false);
    }
  }

  Widget buildFeatureList(List<String> features, {bool premium = false}) {
    return Column(
      children: features
          .map(
            (feature) => Row(
              children: [
                Icon(
                  premium ? Icons.check : Icons.close,
                  color: premium ? Colors.pinkAccent : Colors.grey,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(child: Text(feature)),
              ],
            ),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final freeFeatures = [
      'Max 2 wallets',
      'Max 4 budgets',
      'Annoying ads',
      '10.000 AI tokens every day',
      '3 receipt scans per day',
      "Can't export data",
      'Bar chart only',
      'Mobile only',
    ];
    final premiumFeatures = [
      'Unlimited wallets',
      'Unlimited budgets',
      'No advertisement',
      'Unlimited AI tokens',
      'Unlimited receipt scans',
      'Export data to CSV, Excel',
      'Unlock advanced charts',
      'Mobile and web',
    ];

    final reviews = [
      {
        "name": "John Doe",
        "desc":
            "This app is amazing! It has changed the way I manage my finances.",
        "rating": 5,
      },
      {
        "name": "Jane Smith",
        "desc":
            "I love the AI features! They help me make better financial decisions.",
        "rating": 5,
      },
      {
        "name": "Alice Johnson",
        "desc":
            "The app is user-friendly and has a lot of great features. Highly recommend!",
        "rating": 5,
      },
    ];

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // intro
                Column(
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      "DEEWAS Premium",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Unlock premium to access all powerful features!",
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),

                // comparisons
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.onSurface,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              const Text(
                                "FREE",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              buildFeatureList(freeFeatures),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.onSurface,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        color: Colors.lightBlue,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              const Text(
                                "PREMIUM",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              buildFeatureList(premiumFeatures, premium: true),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // MARK: Reviews
                const Text(
                  "What are users talking about Deewas?",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 150,
                  child: PageView.builder(
                    itemCount: reviews.length,
                    controller: PageController(viewportFraction: 0.8),
                    itemBuilder: (_, i) {
                      final r = reviews[i];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              Text(
                                (r['name'] as String? ?? ""),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                (r['desc'] as String? ?? ""),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  r['rating'] as int? ?? 5,
                                  (_) => const Icon(
                                    Icons.star,
                                    color: Colors.orange,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // contact
                ElevatedButton.icon(
                  onPressed: () async {
                    final uri = Uri.parse("mailto:deewas.now@gmail.com");
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    }
                  },
                  icon: const Icon(Icons.email),
                  label: const Text("Contact Customer Service"),
                ),
                const SizedBox(height: 300),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => debugPrint("navigate to privacy"),
                      child: const Text(
                        "Privacy Policy",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    const Text(" and "),
                    GestureDetector(
                      onTap: () => debugPrint("navigate to terms"),
                      child: const Text(
                        "Terms & Conditions",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),

            // fixed package selector
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(
                      color: Theme.of(context).colorScheme.onSurface,
                      width: 2,
                    ),
                  ),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: packages
                          .map(
                            (p) => Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedPackage = p;
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: selectedPackage == p
                                        ? Colors.blue
                                        : Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    p,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: selectedPackage == p
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: purchasing ? null : handleBuy,
                      child: purchasing
                          ? const CircularProgressIndicator()
                          : Text(
                              selectedPackage == "Lifetime"
                                  ? "Go Premium Now"
                                  : "Start 1 Week Free Trial",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                    const SizedBox(height: 4),
                    TextButton(
                      onPressed: purchasing
                          ? null
                          : () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Restore clicked"),
                                ),
                              );
                            },
                      child: const Text(
                        "Restore purchase",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
