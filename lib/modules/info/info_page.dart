import 'package:coodesh/failures.dart';
import 'package:coodesh/modules/info/data/info_words_api_data_source.dart';
import 'package:coodesh/modules/info/domain/info_repository.dart';
import 'package:coodesh/modules/info/domain/info_usecase.dart';
import 'package:coodesh/modules/info/domain/model/word.dart';
import 'package:dartz/dartz.dart' as dz;
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:collection/collection.dart';

class InfoPage extends StatefulWidget {
  final String word;

  const InfoPage(this.word, {super.key});

  @override
  State<StatefulWidget> createState() => InfoPageState();
}

class InfoPageState extends State<InfoPage> {
  final GetIt _getIt = GetIt.instance;
  Word? _wordObj;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    // Setup get.it dependencies
    try{
      _getIt.registerLazySingleton<InfoWordsApiDataSource>(() => InfoWordsApiDataSource());
      _getIt.registerLazySingleton<InfoRepository>(() => InfoRepository(_getIt<InfoWordsApiDataSource>()));
      _getIt.registerLazySingleton<InfoUseCase>(() => InfoUseCase(_getIt<InfoRepository>()));
    } catch (e){
      debugPrint(e.toString());
    }

    _wordObj = Word(word: widget.word, definitions: {}, pronunciation: '');

    getWord();
  }

  void getWord() async {
    final getWordUseCase = _getIt<InfoUseCase>();
    dz.Either<Failure, Word> response = await getWordUseCase.call(widget.word);

    setState(() {
      if(response.isRight()){
        _wordObj = response.getOrElse(() => Word(word: widget.word, definitions: {}, pronunciation: ''));
      } else {
        Failure fail = response.fold((l) => l, (r) => GenericFailure(message: 'Other'));
        debugPrint('${fail.runtimeType}: ${fail.message}');
      }
      _isLoading = false;
      debugPrint(_wordObj!.definitions.toString());
    });
  }

  // ignore: non_constant_identifier_names
  Widget WordBox() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0), // Rounded corners
        border: Border.all(
          color: Colors.blue, // Border color
          width: 2.0, // Border width
        ),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _wordObj!.word,
                  style: const TextStyle(
                    fontSize: 36.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _wordObj!.pronunciation,
                  style: const TextStyle(
                    fontSize: 18.0,
                    color: Colors.black54,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget MeaningList() {
    if(_wordObj == null){
      return Text('No Meaning saved, need to prepare');
    }
    List<Widget> widgets = [];

    for(String key in _wordObj!.definitions.keys) {
      widgets.add(MeaningBox(key, _wordObj!.definitions[key] ?? []));
    }

    return Column(
      children: widgets,
    );
  }

  // ignore: non_constant_identifier_names
  Widget MeaningBox(String key, List<String> meanings) {
    return Row(
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  key,
                  style: const TextStyle(
                    fontSize: 12.0,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                ...meanings.mapIndexed((index, e) => 
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      '${index+1} - $e'
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Builder(
          builder: (context) {
            if(_isLoading){
              return const Center(child: CircularProgressIndicator(),);
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WordBox(),
                const SizedBox(height: 16,),
                MeaningList(),
              ],
            );
          }
        ),
      ),
    );
  }

}