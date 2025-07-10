import 'dart:convert';
import 'dart:ui';

import 'package:advanced_mobile_app/components/ai/message_item.dart';
import 'package:advanced_mobile_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// 15 sample messages
List<Map<String, dynamic>> sampleMessages = [
  {'role': 'user', 'content': 'What is the weather like today?'},
  {'role': 'assistant', 'content': 'The weather is sunny with a high of 25°C.'},
  {'role': 'user', 'content': 'Can you help me with my budget?'},
  {'role': 'assistant', 'content': 'Sure! What are your income and expenses?'},
  {'role': 'user', 'content': 'I earn \$3000 a month and spend \$2500.'},
  {'role': 'assistant', 'content': 'You have a surplus of \$500 this month.'},
  {'role': 'user', 'content': 'How can I save more?'},
  // {
  //   'role': 'assistant',
  //   'content': 'Consider reducing dining out and entertainment expenses.',
  // },
  // {'role': 'user', 'content': 'What are some good investment options?'},
  // {
  //   'role': 'assistant',
  //   'content': 'You can consider stocks, bonds, or mutual funds.',
  // },
  // {'role': 'user', 'content': 'Can you track my expenses?'},
  // {
  //   'role': 'assistant',
  //   'content': 'Yes, I can help you categorize and analyze your spending.',
  // },
  // {'role': 'user', 'content': 'What is my net worth?'},
  // {
  //   'role': 'assistant',
  //   'content':
  //       'Your net worth is the difference between your assets and liabilities.',
  // },
];

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
        Uri.parse("http://192.168.2.11:3000/api/ai"),
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

      Map<String, dynamic>? toolData = {};

      await for (final chunk in streamedResponse.stream.transform(
        utf8.decoder,
      )) {
        print('Received chunk: $chunk');
        final split = chunk.split(":");
        final data = split.sublist(1).join(":").trim();

        if (chunk.startsWith("f:") ||
            chunk.startsWith("d:") ||
            chunk.startsWith("e:"))
          continue;
        else if (chunk.startsWith("0:")) {
          final text = jsonDecode(data);

          setState(() {
            (messages.isNotEmpty && messages.last['role'] == 'assistant')
                ? messages.last['content'] += text
                : messages.add({'role': 'assistant', 'content': text});
          });
        } else if (chunk.startsWith("9:")) {
          final json = jsonDecode(split.sublist(1).join(":").trim());
          toolData = {
            'toolName': json['toolName'],
            'message': json['args']['message'],
            'errorCode': json['args']['errorCode'],
          };
        } else if (chunk.startsWith("a:")) {
          final jsonData = jsonDecode(split.sublist(1).join(":").trim());
          toolData?['result'] = jsonData['result'];

          print('Tool result: ${toolData}');

          setState(() {
            messages.add({
              'role': 'assistant',
              'content': buffer,
              'parts': toolData,
            });
          });
        }
      }
    } catch (e) {
      setState(
        () => messages.add({'role': 'assistant', 'content': '⚠️ Error: $e'}),
      );
    } finally {
      _controller.clear();
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Column(
        children: [
          if (messages.isEmpty)
            Container(
              padding: const EdgeInsets.all(21 / 2),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    padding: const EdgeInsets.all(21),
                    decoration: BoxDecoration(
                      color: theme.primary.withAlpha(10),
                      border: Border.all(
                        color: theme.primary.withAlpha(10),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Deewas',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: theme.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Deewas is a personal finance assistant that helps you manage your money wisely.',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

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
