import 'package:advanced_mobile_app/components/providers/auth_provider.dart';
import 'package:advanced_mobile_app/components/providers/load_provider.dart';
import 'package:advanced_mobile_app/components/providers/wallet_provider.dart';
import 'package:advanced_mobile_app/requests/wallet_requests.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateWalletPage extends StatefulWidget {
  const CreateWalletPage({super.key});

  @override
  State<CreateWalletPage> createState() => _CreateWalletPageState();
}

class _CreateWalletPageState extends State<CreateWalletPage> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  String? selectedEmoji;
  bool saving = false;

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!formKey.currentState!.validate()) return;

    final walletProvider = context.read<WalletProvider>();
    final isPremium = context.read<AuthProvider>().isPremium;

    if (!isPremium && walletProvider.wallets.length >= 2) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Upgrade to Premium'),
          content: const Text('You have reached the wallet limit'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // push to premium
                Navigator.pop(context);
                Navigator.pushNamed(context, '/premium');
              },
              child: const Text('Upgrade Now'),
            ),
          ],
        ),
      );
      return;
    }

    setState(() => saving = true);

    try {
      await createWalletApi({
        'name': nameController.text.trim(),
        'icon': selectedEmoji,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wallet created successfully!')),
      );

      context.read<LoadProvider>().refresh();
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to create wallet')));
    } finally {
      setState(() => saving = false);
    }
  }

  void showEmojiPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SizedBox(
          height: 500,
          child: EmojiPicker(
            onEmojiSelected: (category, emoji) {
              setState(() {
                selectedEmoji = emoji.emoji;
              });
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Wallet',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Wallet Name
              const Text(
                "Name",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: InputDecoration(
                  hintText: '...',
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 16,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 0.5,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                controller: nameController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 21),

              // Icon
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Icon (optional)",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: showEmojiPicker,
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: selectedEmoji != null
                          ? Text(
                              selectedEmoji!,
                              style: const TextStyle(fontSize: 60),
                            )
                          : const Icon(
                              Icons.emoji_emotions,
                              size: 60,
                              color: Colors.grey,
                            ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              // explanation
              const Text(
                "This is how your wallet will appear in the app",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),

              const SizedBox(height: 24),

              // Save button
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                spacing: 21,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancel"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: saving ? null : _handleSave,
                    child: saving
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(
                            'Save',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
