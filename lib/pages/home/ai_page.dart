import 'dart:convert';

import 'package:advanced_mobile_app/components/ai/message_item.dart';
import 'package:advanced_mobile_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AIPage extends StatefulWidget {
  const AIPage({super.key});

  @override
  State<AIPage> createState() => _AIPageState();
}

class _AIPageState extends State<AIPage> {
  final _controller = TextEditingController();
  final List<Map<String, dynamic>> messages = [];
  bool loading = false;

  // MARK: Send Message
  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty) return;

    final token = await getToken();
    if (token == null) throw Exception('No token found');

    setState(() {
      messages.add({'role': 'user', 'content': content});
      loading = true;
    });

    try {
      final request = http.Request(
        'POST',
        Uri.parse("${dotenv.env['WEB_SERVER_URL']}/api/ai"),
      );
      request.headers.addAll({
        'Content-Type': 'application/json',
        'x-language': 'English',
        'x-timezone': DateTime.now().timeZoneName,
        'x-personalities': jsonEncode([0]),
        'Authorization': 'Bearer $token',
      });
      request.body = jsonEncode({'messages': messages});

      final streamedResponse = await request.send();

      String buffer = '';

      await for (final chunk in streamedResponse.stream.transform(
        utf8.decoder,
      )) {
        buffer += chunk;

        final parts = buffer.split('\n\n');
        buffer = parts.removeLast();

        for (final part in parts) {
          final trimmed = part.trim();
          if (trimmed.isEmpty) continue;

          try {
            final jsonPart = jsonDecode(trimmed);

            final delta = jsonPart['delta']?['content'];
            if (delta != null) {
              if (messages.isNotEmpty && messages.last['role'] == 'assistant') {
                messages.last['content'] += delta;
              } else {
                messages.add({'role': 'assistant', 'content': delta});
              }
              setState(() {});
            }

            // Ghi nhận phản hồi từ tool
            final tool = jsonPart['toolResult'];
            if (tool != null) {
              messages.add({
                'role': 'tool',
                'content': '',
                'parts': [
                  null,
                  {'toolInvocation': tool},
                ],
              });
              setState(() {});
            }
          } catch (e) {
            debugPrint('⚠️ Error parsing chunk: $e');
          }
        }
      }
    } catch (e) {
      setState(() {
        messages.add({'role': 'assistant', 'content': '⚠️ Error: $e'});
      });
    } finally {
      setState(() {
        loading = false;
      });
    }

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return MessageItem(
                  role: msg['role'],
                  content: msg['content'],
                  parts: msg['parts'],
                );
              },
            ),
          ),
          if (loading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: CircularProgressIndicator(),
            ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: sendMessage,
                    decoration: InputDecoration(
                      hintText: 'Ask something...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => sendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
