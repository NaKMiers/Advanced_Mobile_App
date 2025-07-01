import 'package:advanced_mobile_app/components/providers/load_provider.dart';
import 'package:advanced_mobile_app/models/wallet_model.dart';
import 'package:advanced_mobile_app/requests/wallet_requests.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateWalletPage extends StatefulWidget {
  final Wallet wallet;

  const UpdateWalletPage({super.key, required this.wallet});

  @override
  State<UpdateWalletPage> createState() => _UpdateWalletPageState();
}

class _UpdateWalletPageState extends State<UpdateWalletPage> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  String? selectedEmoji;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.wallet.name;
    selectedEmoji = widget.wallet.icon;
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!formKey.currentState!.validate()) return;

    // check if data changed
    if (widget.wallet.name == nameController.text.trim() &&
        widget.wallet.icon == selectedEmoji) {
      Navigator.pop(context);
      return;
    }

    setState(() => saving = true);

    try {
      await updateWalletApi(widget.wallet.id, {
        'name': nameController.text.trim(),
        'icon': selectedEmoji,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wallet updated successfully!')),
      );

      // refresh
      context.read<LoadProvider>().refresh();
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to update wallet')));
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
          'Update Wallet',
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
              // NAME
              const Text(
                "Name",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: nameController,
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
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // ICON
              const Text("Icon (optional)", style: TextStyle(fontSize: 14)),
              GestureDetector(
                onTap: showEmojiPicker,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      selectedEmoji ?? "😊",
                      style: const TextStyle(fontSize: 60),
                    ),
                  ),
                ),
              ),
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
