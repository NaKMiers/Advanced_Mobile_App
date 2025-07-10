import 'package:advanced_mobile_app/utils/string.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateRangeSegments extends StatelessWidget {
  final String segment;
  final List<String> segments;
  final Function(String) onChangeSegment;
  final DateTime from;
  final DateTime to;
  final VoidCallback next;
  final VoidCallback prev;
  final VoidCallback reset;
  final bool disabledNext;
  final bool disabledPrev;

  const DateRangeSegments({
    super.key,
    required this.segment,
    required this.segments,
    required this.onChangeSegment,
    required this.from,
    required this.to,
    required this.next,
    required this.prev,
    required this.reset,
    this.disabledNext = false,
    this.disabledPrev = false,
  });

  String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final int selectedIndex = segments.indexOf(segment);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 34,
                child: SegmentedButton(
                  segments: segments,
                  selectedIndex: selectedIndex,
                  onChanged: (index) => onChangeSegment(segments[index]),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: reset,
              icon: const Icon(Icons.replay_outlined, size: 18),
              style: IconButton.styleFrom(
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.primary.withAlpha(50),
                shape: const CircleBorder(),
              ),
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              onPressed: disabledPrev ? null : prev,
              icon: const Icon(Icons.chevron_left, color: Colors.white),
              style: IconButton.styleFrom(
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.primary.withAlpha(80),
                shape: const CircleBorder(),
              ),
            ),
            Expanded(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('MMM dd').format(from),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text('-', style: TextStyle(fontSize: 14)),
                    const SizedBox(width: 6),
                    Text(
                      formatDate(to),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: disabledNext ? null : next,
              icon: const Icon(Icons.chevron_right, color: Colors.white),
              style: IconButton.styleFrom(
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.primary.withAlpha(80),
                shape: const CircleBorder(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Custom replacement for SegmentedControl in Flutter
class SegmentedButton extends StatelessWidget {
  final List<String> segments;
  final int selectedIndex;
  final Function(int) onChanged;

  const SegmentedButton({
    super.key,
    required this.segments,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 4,
      children: segments
          .asMap()
          .entries
          .map(
            (entry) => Expanded(
              child: GestureDetector(
                onTap: () => onChanged(entry.key),
                child: Container(
                  height: 34,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selectedIndex == entry.key
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  child: Text(
                    capitalize(entry.value),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: selectedIndex == entry.key
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
