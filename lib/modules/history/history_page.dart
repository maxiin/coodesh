import 'package:coodesh/shared/model/word.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<StatefulWidget> createState() => HistoryPageState();
}

class HistoryPageState extends State<HistoryPage> {
  final List<String> buttonLabels = ["Button 1", "Button 2", "Button 3", "Button 4", "Button 5"];
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
      body: ListView.builder(
        itemCount: words.length,
        itemBuilder: (context, index) {
          return InkWell(
            child: SizedBox(
              height: 48.0, // Adjust the height as needed
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        words[index].word, // Button text
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Theme.of(context).colorScheme.primary),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      // Text(
                      //   "Last seen", // Button text
                      //   style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Theme.of(context).primaryColor, fontStyle: FontStyle.italic),
                      // ),
                      Icon(
                        Icons.chevron_right, // Right arrow icon
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            onTap: () {},
          );
        },
      ),
    );
  }
}
