import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Chart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final String chartType; // 'bar', 'line', 'pie'
  final String transactionType;

  const Chart({
    super.key,
    required this.data,
    required this.chartType,
    required this.transactionType,
  });

  @override
  Widget build(BuildContext context) {
    switch (chartType) {
      case 'bar':
        return _buildBarChart();
      case 'line':
        return _buildLineChart();
      case 'pie':
        return _buildPieChart();
      default:
        return const SizedBox();
    }
  }

  Widget _buildBarChart() {
    return BarChart(
      BarChartData(
        barGroups: data
            .asMap()
            .entries
            .map(
              (entry) => BarChartGroupData(
                x: entry.key,
                barRods: [
                  BarChartRodData(
                    toY: entry.value['value'].toDouble(),
                    color: Colors.blue,
                  ),
                ],
              ),
            )
            .toList(),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                return Text(
                  data.length > index ? data[index]['label'] : '',
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLineChart() {
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: data
                .asMap()
                .entries
                .map(
                  (entry) => FlSpot(
                    entry.key.toDouble(),
                    entry.value['value'].toDouble(),
                  ),
                )
                .toList(),
            isCurved: true,
            barWidth: 2,
            color: Colors.green,
            dotData: FlDotData(show: false),
          ),
        ],
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                return Text(
                  data.length > index ? data[index]['label'] : '',
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPieChart() {
    final total = data.fold<double>(
      0,
      (sum, item) => sum + item['value'].abs().toDouble(),
    );
    return PieChart(
      PieChartData(
        sections: data
            .map(
              (item) => PieChartSectionData(
                value: item['value'].abs().toDouble(),
                title:
                    "${((item['value'].abs() / total) * 100).toStringAsFixed(1)}%",
                color: _getColor(item['type']),
              ),
            )
            .toList(),
      ),
    );
  }

  Color _getColor(String? type) {
    switch (type) {
      case 'income':
        return Colors.green;
      case 'expense':
        return Colors.red;
      case 'saving':
        return Colors.blue;
      case 'invest':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
