import 'package:advanced_mobile_app/components/date_range_segments.dart';
import 'package:advanced_mobile_app/utils/string.dart';
import 'package:flutter/material.dart';

class HistoryHeader extends StatefulWidget {
  final String selectedChartType;
  final Function(String) onSelectChartType;
  final String segment;
  final Function(String) onChangeSegment;

  const HistoryHeader({
    super.key,
    required this.selectedChartType,
    required this.onSelectChartType,
    required this.segment,
    required this.onChangeSegment,
  });

  @override
  State<HistoryHeader> createState() => _HistoryHeaderState();
}

class _HistoryHeaderState extends State<HistoryHeader> {
  @override
  Widget build(BuildContext context) {
    return DateRangeSegments(
      segment: widget.segment,
      segments: ['week', 'month', 'year'],
      onChangeSegment: widget.onChangeSegment,
      next: () {},
      prev: () {},
      reset: () {},
      from: DateTime.now(),
      to: DateTime.now(),
    );
  }
}
