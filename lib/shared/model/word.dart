import 'package:hive_flutter/hive_flutter.dart';

part 'word.g.dart';

@HiveType(typeId: 1)
class Word extends HiveObject {
  @HiveField(0)
  final String word;
  @HiveField(1)
  final Map<String, List<String>> definitions;
  @HiveField(2)
  final String pronunciation;

  Word({
    required this.word,
    required this.definitions,
    required this.pronunciation,
  });

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      word: json['word'],
      definitions: Map<String, List<String>>.from(json['definitions']),
      pronunciation: json['pronunciation'],
    );
  }

  factory Word.fromApiJson(Map<String, dynamic> json) {
    List<dynamic> results = [];
    if(json['results'] != null){
      results = (json['results'] as List<dynamic>);
    }
    final definitionMap = <String, List<String>>{};

    for (final result in results) {
      final partOfSpeech = result['partOfSpeech'];
      final definition = result['definition'];
      if (partOfSpeech != null && definition != null) {
        if(definitionMap[partOfSpeech] == null) {
          definitionMap[partOfSpeech] = [];
        }
        definitionMap[partOfSpeech]!.add(definition);
      }
    }

    String pronunciation;
    if(json['pronunciation'].runtimeType == String){
      pronunciation = json['pronunciation'];
    } else {
      pronunciation = json['pronunciation']['all'];
    }

    return Word(
      word: json['word'],
      definitions: definitionMap,
      pronunciation: pronunciation,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'definitions': definitions,
      'pronunciation': pronunciation,
    };
  }
}
