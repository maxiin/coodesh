import 'dart:io';
import 'package:args/args.dart';

void main(List<String> arguments) {
  final parser = ArgParser()
    ..addOption('key', abbr: 'k', help: 'API key to write to .env file', mandatory: true);

  final argResults = parser.parse(arguments);

  final apiKey = argResults['key'];

  if (apiKey == null || apiKey.isEmpty) {
    print('Please provide an API key.');
    return;
  }

  final envContent = 'RAPIDAPI_KEY:$apiKey';

  try {
    final file = File('.env');
    file.writeAsStringSync(envContent);
    print('The .env file has been created successfully.');
  } catch (e) {
    print('An error occurred: $e');
  }
}
