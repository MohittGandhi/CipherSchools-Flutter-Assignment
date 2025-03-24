// widgets/income_expense_bar_chart.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class IncomeExpenseBarChart extends StatelessWidget {
  // Income and expense data provided as maps with category names as keys.
  final Map<String, double> incomeData;
  final Map<String, double> expenseData;

  const IncomeExpenseBarChart({
    Key? key,
    required this.incomeData,
    required this.expenseData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Combine keys from both maps to list all categories.
    final categories = <String>{...incomeData.keys, ...expenseData.keys}.toList();

    // Create bar groups for each category.
    List<BarChartGroupData> barGroups = [];
    for (int i = 0; i < categories.length; i++) {
      final category = categories[i];
      final double incomeValue = incomeData[category] ?? 0.0;
      final double expenseValue = expenseData[category] ?? 0.0;

      barGroups.add(
        BarChartGroupData(
          x: i,
          barsSpace: 4,
          barRods: [
            // Income bar (green)
            BarChartRodData(
              toY: incomeValue,
              width: 12,
              color: Colors.green,
              borderRadius: BorderRadius.circular(4),
            ),
            // Expense bar (red)
            BarChartRodData(
              toY: expenseValue,
              width: 12,
              color: Colors.red,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      );
    }

    // Define bottom axis titles using the new AxisTitles API.
    final bottomTitles = AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 40,
        getTitlesWidget: (double value, TitleMeta meta) {
          int index = value.toInt();
          if (index < 0 || index >= categories.length) return Container();
          return SideTitleWidget(
            fitInside: SideTitleFitInsideData(
              enabled: true,
              axisPosition: 10 ,
              parentAxisSize: 40.0, // adjust as needed
              distanceFromEdge: 8.0,
            ), // use default values or customize as needed
            meta: meta,
            space: 8.0,
            angle: 0.0,
            child: Text(
              categories[index],
              style: const TextStyle(fontSize: 10),
            ),
          );
        },
      ),
    );

    // Define left axis titles.
    final leftTitles = AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 40,
        getTitlesWidget: (double value, TitleMeta meta) {
          return Text(
            value.toInt().toString(),
            style: const TextStyle(fontSize: 10),
          );
        },
      ),
    );

    // Assemble titles data.
    final titlesData = FlTitlesData(
      show: true,
      bottomTitles: bottomTitles,
      leftTitles: leftTitles,
      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );

    return AspectRatio(
      aspectRatio: 1.5,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: BarChart(
          BarChartData(
            barGroups: barGroups,
            alignment: BarChartAlignment.spaceAround,
            maxY: _calculateMaxY(incomeData, expenseData),
            gridData: FlGridData(show: true),
            borderData: FlBorderData(show: false),
            titlesData: titlesData,
          ),
        ),
      ),
    );
  }

  // Helper method to calculate a suitable maximum Y-axis value.
  double _calculateMaxY(Map<String, double> income, Map<String, double> expense) {
    final allValues = <double>[];
    allValues.addAll(income.values);
    allValues.addAll(expense.values);
    final maxValue = allValues.isEmpty ? 10.0 : allValues.reduce((a, b) => a > b ? a : b);
    return maxValue + (maxValue * 0.2);
  }
}

