import 'dart:convert';

import 'package:coodesh/failures.dart';
import 'package:coodesh/modules/list/data/list_file_data_source.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() {
    WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized once for all tests
  });
  group('ListFileDataSource', () {
    late ListFileDataSource dataSource;

    setUp(() {
      dataSource = ListFileDataSource();
    });

    test('getLines returns lines within the specified range', () async {
      const startLine = 1;
      const endLine = 3;

      final lines = await dataSource.getLines(startLine, endLine);

      expect(lines, hasLength(endLine - startLine + 1));
      expect(lines[0], 'about');
      expect(lines[1], 'search');
      expect(lines[2], 'other');
    });

    test('getLines throws ArgumentFailure if startLine > endLine', () async {
      const startLine = 3;
      const endLine = 1;

      try {
        await dataSource.getLines(startLine, endLine);
        // The line above should throw an ArgumentFailure, so this line should not be reached.
        fail('Expected ArgumentFailure, but no exception was thrown.');
      } catch (e) {
        expect(e, isA<ArgumentFailure>());
        expect((e as ArgumentFailure).message, 'Start line must be less than or equal to end line');
      }
    });

    test('getLines reads lines from the file', () async {
      // You should have a test file (e.g., 'test_assets/test_data.txt') with sample data for this test.
      const startLine = 1;
      const endLine = 5;

      // Load a test file from the 'test_assets' directory for this test.
      final ByteData data = await rootBundle.load('test_assets/test_list.txt');
      final List<String> expectedLines = utf8.decode(data.buffer.asUint8List()).split('\n');

      final lines = await dataSource.getLines(startLine, endLine);

      expect(lines, hasLength(endLine - startLine + 1));
      expect(lines, equals(expectedLines.sublist(startLine - 1, endLine)));
    });
  });
}
