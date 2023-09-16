class Word {
  final String word;
  final Map<String, List<String>> definitions;
  final String pronunciation;

  Word({
    required this.word,
    required this.definitions,
    required this.pronunciation,
  });

  factory Word.fromJson(Map<String, dynamic> json) {
    final results = (json['results'] as List<dynamic>);
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

    return Word(
      word: json['word'],
      definitions: definitionMap,
      pronunciation: json['pronunciation']['all'],
    );
  }
}
