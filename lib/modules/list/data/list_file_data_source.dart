import 'dart:convert';
import 'package:coodesh/failures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ListFileDataSource {
  Future<List<String>> getLines(int startLine, int endLine) async {
    if (startLine > endLine) {
      throw ArgumentFailure(message: 'Start line must be less than or equal to end line');
    }

    final linesInRange = <String>[];
    int currentLine = 0;
    final ByteData data = await rootBundle.load('assets/english_frequency_10k.txt');
    final List<String> lines = utf8.decode(data.buffer.asUint8List()).split('\n');

    for (var line in lines) {
      currentLine++;
      if (currentLine >= startLine && currentLine <= endLine) {
        linesInRange.add(line.replaceAll('\r', ''));
      }
      if (currentLine > endLine) {
        break; // Stop reading after reaching the end line
      }
      debugPrint(currentLine.toString());
    }

    return linesInRange;
  }
}
