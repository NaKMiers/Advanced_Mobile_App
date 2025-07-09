import 'package:advanced_mobile_app/components/ai/message_item.dart';
import 'package:advanced_mobile_app/components/pulse_dot.dart';
import 'package:flutter/material.dart';

class MessagesPage extends StatefulWidget {
  final List<Map<String, dynamic>> messages;
  final bool isStreaming;
  final bool isRefreshing;
  final Function() onRefresh;
  final String status;
  final dynamic error;

  const MessagesPage({
    super.key,
    required this.messages,
    required this.status,
    required this.onRefresh,
    required this.isRefreshing,
    required this.error,
    required this.isStreaming,
  });

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isAtBottom = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    final maxScroll = _scrollController.position.maxScrollExtent;

    setState(() {
      _isAtBottom = maxScroll - offset < 100;
    });
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void didUpdateWidget(covariant MessagesPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isStreaming && _isAtBottom) {
      scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    final messages = widget.messages;

    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: () async => widget.onRefresh(),
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: messages.length + 1,
            itemBuilder: (context, index) {
              if (index < messages.length) {
                final message = messages[index];
                return MessageItem(
                  role: message['role'],
                  content: message['content'],
                  parts: message['parts'],
                  error: widget.error,
                );
              } else if (widget.status == 'submitted') {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      PulseDot(),
                      SizedBox(width: 8),
                      Text('Loading...', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
        if (!_isAtBottom)
          Positioned(
            bottom: 100,
            right: 16,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Theme.of(context).colorScheme.secondary,
              onPressed: scrollToBottom,
              child: const Icon(Icons.arrow_downward),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
