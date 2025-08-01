import 'dart:convert';
import 'dart:ui';

import 'package:advanced_mobile_app/components/ai/message_item.dart';
import 'package:advanced_mobile_app/components/providers/init_provider.dart';
import 'package:advanced_mobile_app/components/providers/settings_provider.dart';
import 'package:advanced_mobile_app/components/wrapper.dart';
import 'package:advanced_mobile_app/constants/index.dart';
import 'package:advanced_mobile_app/requests/index.dart';
import 'package:advanced_mobile_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class AIPage extends StatefulWidget {
  const AIPage({super.key});

  @override
  State<AIPage> createState() => _AIPageState();
}

class _AIPageState extends State<AIPage> {
  final controller = TextEditingController();
  bool hasText = false;
  final List<Map<String, dynamic>> messages = [];
  bool loading = false;
  late stt.SpeechToText speech;
  bool isListening = false;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    speech = stt.SpeechToText();

    scrollToBottom();

    controller.addListener(() {
      setState(() {
        hasText = controller.text.isNotEmpty;
      });
    });
  }

  // MARK: Send Message
  void sendMessage(String content) async {
    if (content.trim().isEmpty) return;

    // dismiss keyboard
    FocusScope.of(context).unfocus();

    final token = await getToken();
    if (token == null) throw Exception('No token found');

    setState(() {
      messages.add({'role': 'user', 'content': content});
      loading = true;
    });
    controller.clear();

    final aiPersonalities =
        context.read<SettingsProvider>().settings?.personalities ?? [0];

    try {
      final request = http.Request('POST', Uri.parse("$baseUrl/api/ai"));

      request.headers.addAll({
        'Content-Type': 'application/json',
        'x-language': 'English',
        'x-timezone': DateTime.now().timeZoneName,
        'x-personalities': jsonEncode(aiPersonalities),
        'Authorization': 'Bearer $token',
      });

      request.body = jsonEncode({'messages': messages});

      final streamedResponse = await request.send();
      String buffer = '';

      Map<String, dynamic>? toolData = {};

      await for (final chunk in streamedResponse.stream.transform(
        utf8.decoder,
      )) {
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
      setState(() => loading = false);
      scrollToBottom();
    }
  }

  // MARK: Clear Chat
  void clearChat() {
    setState(() {
      messages.clear();
    });
  }

  // MARK: Changer Personality
  void changePersonality(int id) async {
    final selected = personalities.firstWhere(
      (p) => p['id'] == id,
      orElse: () => {'id': 0, 'title': 'Default'},
    );

    try {
      await updateMySettingsApi({
        "personalities": [selected['id']],
      });

      context.read<InitProvider>().refreshSettings();

      clearChat();
    } catch (e) {
      print("Error changing personality: $e");
    }
  }

  // MARK: Show Personality Picker
  void showPersonalityPicker() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: personalities
              .map(
                (p) => ListTile(
                  leading: Text(
                    p['title'],
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  onTap: () {
                    changePersonality(p['id']);
                    Navigator.pop(context);
                  },
                ),
              )
              .toList(),
        );
      },
    );
  }

  //MARK: Request Microphone Permission
  Future<bool> requestMicrophonePermission(BuildContext context) async {
    var status = await Permission.microphone.status;

    if (status.isGranted) return true;

    if (status.isDenied) {
      final result = await Permission.microphone.request();
      if (result.isGranted) return true;
    }

    if (status.isPermanentlyDenied) {
      final openSettings = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Microphone permission required"),
          content: const Text(
            "You have denied microphone access. Please enable it in settings to use voice input.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                openAppSettings();
                Navigator.of(context).pop(true);
              },
              child: const Text("Open Settings"),
            ),
          ],
        ),
      );

      return openSettings == true ? false : false;
    }

    return false;
  }

  // MARK: Start Listening
  void startListening() async {
    bool granted = await requestMicrophonePermission(context);
    if (!granted) return;

    bool available = await speech.initialize(
      onStatus: (val) => print('Speech status: $val'),
      onError: (val) => print('Speech error: $val'),
    );

    if (available) {
      setState(() => isListening = true);
      speech.listen(
        onResult: (val) {
          setState(() {
            controller.text = val.recognizedWords;
          });
        },
      );
    } else {
      setState(() => isListening = false);
      speech.stop();
    }
  }

  // MARK: Stop Listening
  void stopListening() {
    speech.stop();
    setState(() => isListening = false);
  }

  // MARK:
  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final personalityId = context
        .watch<SettingsProvider>()
        .settings
        ?.personalities[0];
    final personality = personalities.firstWhere(
      (p) => p['id'] == personalityId,
    );

    return Scaffold(
      body: Wrapper(
        child: Column(
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
                            'AMA',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: theme.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'AMA is a personal finance assistant that helps you manage your money wisely.',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            // MARK: Messages
            Expanded(
              child: ListView.builder(
                controller: scrollController,
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
              child: Column(
                spacing: 4,
                children: [
                  Row(
                    children: [
                      if (hasText)
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            controller.clear();
                            FocusScope.of(context).unfocus();
                          },
                        ),
                      Expanded(
                        child: TextField(
                          controller: controller,
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
                        onPressed: () => sendMessage(controller.text),
                      ),
                    ],
                  ),
                  Row(
                    spacing: 8,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // MARK: Clear Chat
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: theme.secondary,
                        ),
                        onPressed: clearChat,
                        child: Text(
                          "Clear chat",
                          style: TextStyle(color: theme.onSecondary),
                        ),
                      ),

                      // MARK: Change Personality
                      Expanded(
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: theme.secondary,
                          ),
                          onPressed: showPersonalityPicker,
                          child: Text(
                            personality['title'] ?? "Change personality",
                            style: TextStyle(color: theme.onSecondary),
                          ),
                        ),
                      ),

                      // MARK: Voice
                      IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: theme.secondary,
                        ),
                        onPressed: isListening ? stopListening : startListening,
                        icon: Icon(isListening ? Icons.square : Icons.mic),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
