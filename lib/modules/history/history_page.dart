import 'package:coodesh/shared/model/word.dart';
import 'package:coodesh/shared/widget/list_words.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<StatefulWidget> createState() => HistoryPageState();
}

class HistoryPageState extends State<HistoryPage> {
  List<Word> words = [];

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  void loadHistory() async {
    var box = await Hive.openBox('historyList');
    List<Word> history = box.get('list', defaultValue: <Word>[])!.cast<Word>();
    setState(() {
      words = history.reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListWords(words, onNavigationBack: loadHistory)
    );
  }
}
