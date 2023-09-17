import 'package:coodesh/shared/model/word.dart';
import 'package:coodesh/shared/widget/list_words.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<StatefulWidget> createState() => FavoritePageState();
}

class FavoritePageState extends State<FavoritePage> {
  List<String> wordKeys = [];
  List<Word> words = [];

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  void loadHistory() async {
    var box = await Hive.openBox<bool>('favoriteBox');
    setState(() {
      wordKeys = box.keys.toList().cast<String>();
    });
    List<Word> localWords = await getWordsFromHistory();
    setState(() {
      words = localWords;
    });
  }

  Future<List<Word>> getWordsFromHistory() async {
    var box = await Hive.openBox<Word>('wordList');
    List<Word> localWords = [];
    for (var key in wordKeys) {
      if(box.get(key) != null){
        localWords.add(box.get(key)!);
      }
    }
    return localWords;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListWords(words)
    );
  }
}
