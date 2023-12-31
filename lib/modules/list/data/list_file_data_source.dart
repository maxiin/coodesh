import 'dart:convert';
import 'package:coodesh/failures.dart';
import 'package:flutter/services.dart';

class ListFileDataSource {
  Future<List<String>> getLines(int startLine, int endLine) async {
    if (startLine > endLine) {
      throw ArgumentFailure(message: 'Start line must be less than or equal to end line');
    }

    final linesInRange = <String>[];
    int currentLine = 0;
    final ByteData data = await rootBundle.load('assets/english_frequency_10k.csv');
    final List<String> lines = utf8.decode(data.buffer.asUint8List()).split(',');

    for (var line in lines) {
      currentLine++;
      if (currentLine >= startLine && currentLine <= endLine) {
        linesInRange.add(line);
      }
      if (currentLine > endLine) {
        break; // Stop reading after reaching the end line
      }
    }

    return linesInRange;
  }
}
