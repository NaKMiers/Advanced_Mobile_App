import 'package:flutter/material.dart';

class SearchInput extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;
  final String placeholder;

  const SearchInput({
    super.key,
    required this.value,
    required this.onChanged,
    this.placeholder = "Search...",
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value,
      onChanged: onChanged,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: placeholder,
        prefixIcon: const Icon(Icons.search),
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            width: 0.5,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
