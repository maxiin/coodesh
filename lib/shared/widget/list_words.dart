import 'package:coodesh/modules/info/info_page.dart';
import 'package:coodesh/shared/model/word.dart';
import 'package:flutter/material.dart';

class ListWords extends StatelessWidget {
  final List<Word> words;
  Function? onNavigationBack;

  ListWords(this.words, {super.key, this.onNavigationBack});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: words.length,
      itemBuilder: (context, index) {
        return InkWell(
          child: SizedBox(
            height: 48.0, // Adjust the height as needed
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    words[index].word, // Button text
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Theme.of(context).colorScheme.primary),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.chevron_right, // Right arrow icon
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => InfoPage(words[index].word)),
            );
            if(onNavigationBack != null){
              onNavigationBack!();
            }
          },
        );
      },
    );
  }

}