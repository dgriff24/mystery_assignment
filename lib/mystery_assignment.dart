import 'dart:io';
import 'dart:math';
import 'package:csv/csv.dart';

List<List<String>> readCsvFileSync(String path) {
  final file = File(path);
  final content = file.readAsStringSync();
  final rows = const CsvToListConverter().convert(content);
  return rows.map((row) => row.map((e) => e.toString()).toList()).toList();
}

void main() {
  final data = readCsvFileSync('assets/data.csv');

  _evaluateQuality(data);

  final prep = _getGrades(data: data, text: 'Prep');
  final hw = _getGrades(data: data, text: 'HW');
  final exam1 = _getGrades(data: data, text: 'Exam I ');
  final exam2 = _getGrades(data: data, text: 'Exam II');
  final finals = _getGrades(data: data, text: 'Final');

  for (int i = 0; i < prep.length; i++) {
    final avg = average(
        exam1: exam1[i],
        hw: hw[i],
        exam2: exam2[i],
        prep: prep[i],
        finals: finals[i]);

    final roundedAverage = (avg * 10).round() / 10;
    print('${data[i + 1][0]}:\t$roundedAverage');
  }
}

double average({
  required double prep,
  required double hw,
  required double exam1,
  required double exam2,
  required double finals,
}) {
  final minimum = min(exam1, exam2);
  final maximum = max(exam1, exam2);
  if (finals != 0.0) {
    return (prep * .2 + hw * .2 + minimum * .15 + maximum * .2 + finals * .2) /
        .85 *
        100;
  }
  return (prep * .2 + hw * .2 + minimum * .15 + maximum * .2) / .65 * 100;
}

List<double> _getGrades(
    {required List<List<String>> data, required String text}) {
  final cols = _getColumnsWithData(data: data, text: text);
  return data.skip(1).map((row) {
    double numerator = 0;
    int denominator = 0;
    for (final col in cols) {
      final cell = row[col];
      if (cell == 'Needs Grading') {
        continue;
      }

      final header = data[0][col];
      final start = header.indexOf('Total Pts: ') + 'Total Pts: '.length;
      final end = header.indexOf(' ', start);
      final colDenominator = int.parse(header.substring(start, end));

      if (cell.isNotEmpty) {
        try {
          numerator += double.parse(cell);
        } on FormatException {
          continue;
        }
      }
      denominator += colDenominator;
    }

    return numerator / denominator;
  }).toList();
}

List<int> _getColumnsWithData(
    {required List<List<String>> data, required String text}) {
  final all = getColumnsWithText(data: data, text: text);

  return all.where((col) {
    return data.any((row) => row[col].contains(RegExp(r'^\d+$')));
  }).toList();
}

void _evaluateQuality(List<List<String>> data) {
  final prep = getColumnsWithText(data: data, text: 'Preparation');
  final hw = getColumnsWithText(data: data, text: 'HW');
  final exam1 = getColumnsWithText(data: data, text: 'Exam I ');
  final exam2 = getColumnsWithText(data: data, text: 'Exam II');
  final finals = getColumnsWithText(data: data, text: 'Final');

  // _evaluateQuality(data);
  final all = <int>[];
  all.addAll(prep);
  all.addAll(hw);
  all.addAll(exam1);
  all.addAll(exam2);
  all.addAll(finals);

  print('Duplicates: ${all.length != all.toSet().length}');

  final oneThroughN = List.generate(data.first.length, (index) => index);
  for (final i in all) {
    oneThroughN.remove(i);
  }
  // 18 is Interpreted Language
  print('Missing: $oneThroughN');
}

List<int> getColumnsWithText(
    {required List<List<String>> data, required String text}) {
  return data.first
      .asMap()
      .entries
      .where((entry) => entry.value.contains(text))
      .map((entry) => entry.key)
      .toList();
}
