import 'package:advanced_mobile_app/components/providers/load_provider.dart';
import 'package:advanced_mobile_app/components/wrapper.dart';
import 'package:advanced_mobile_app/models/category_model.dart' as app_models;
import 'package:advanced_mobile_app/requests/category_requests.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateCategoryPage extends StatefulWidget {
  final app_models.Category category;

  const UpdateCategoryPage({super.key, required this.category});

  @override
  State<UpdateCategoryPage> createState() => _UpdateCategoryPageState();
}

class _UpdateCategoryPageState extends State<UpdateCategoryPage> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();

  String? selectedEmoji;

  bool saving = false;

  @override
  void initState() {
    super.initState();
    // prefill
    nameController.text = widget.category.name;
    selectedEmoji = widget.category.icon;
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!formKey.currentState!.validate()) return;

    // check change
    if (widget.category.name == nameController.text.trim() &&
        widget.category.icon == selectedEmoji) {
      Navigator.pop(context);
      return;
    }

    setState(() => saving = true);

    try {
      await updateCategoryApi(widget.category.id, {
        'name': nameController.text.trim(),
        'icon': selectedEmoji,
        'type': widget.category.type,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Category updated successfully')),
      );

      context.read<LoadProvider>().refresh();
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update category')),
      );
    } finally {
      setState(() => saving = false);
    }
  }

  void showEmojiPicker() {
    showModalBottomSheet(
      context: context,
      builder: (_) => EmojiPicker(
        onEmojiSelected: (category, emoji) {
          setState(() => selectedEmoji = emoji.emoji);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Update Category',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
        ),
      ),
      body: Wrapper(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name
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

                // Icon
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Icon (optional)",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
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
                const SizedBox(height: 8),
                const Text(
                  "This is how your category will appear in the app",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),

                const SizedBox(height: 24),

                // Save button
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                    const SizedBox(width: 16),
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
      ),
    );
  }
}
