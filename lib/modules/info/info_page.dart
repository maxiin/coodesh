import 'package:coodesh/failures.dart';
import 'package:coodesh/modules/info/data/info_words_api_data_source.dart';
import 'package:coodesh/modules/info/domain/info_repository.dart';
import 'package:coodesh/modules/info/domain/info_usecase.dart';
import 'package:coodesh/shared/model/word.dart';
import 'package:dartz/dartz.dart' as dz;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get_it/get_it.dart';
import 'package:collection/collection.dart';
import 'package:hive_flutter/hive_flutter.dart';

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
  bool _isFavorite = false;
  late Box<bool> favoriteBox;
  FlutterTts? _flutterTts;

  @override
  void initState() {
    super.initState();

    // Setup get.it dependencies
    try{
      _flutterTts = _getIt.get<FlutterTts>();
      _getIt.registerLazySingleton<http.Client>(() => http.Client());
      _getIt.registerLazySingleton<InfoWordsApiDataSource>(() => InfoWordsApiDataSource((_getIt<http.Client>())));
      _getIt.registerLazySingleton<InfoRepository>(() => InfoRepository(_getIt<InfoWordsApiDataSource>()));
      _getIt.registerLazySingleton<InfoUseCase>(() => InfoUseCase(_getIt<InfoRepository>()));
    } catch (e){
      debugPrint(e.toString());
    }

    getFavoriteBox();

    _wordObj = Word(word: widget.word, definitions: {}, pronunciation: '');

    getWord();
  }

  @override
  void dispose() {
    _stopTTS();
    super.dispose();
  }

  void getFavoriteBox() async {
    favoriteBox = await Hive.openBox<bool>('favoriteBox');
    _isFavorite = favoriteBox.get(widget.word, defaultValue: false)!;
  }

  void getWord() async {
    final getWordUseCase = _getIt<InfoUseCase>();
    dz.Either<Failure, Word> response = await getWordUseCase.call(widget.word);

    setState(() {
      if(response.isRight()){
        _wordObj = response.getOrElse(() => Word(word: widget.word, definitions: {}, pronunciation: ''));
      } else {
        Failure fail = response.fold((l) => l, (r) => GenericFailure(message: 'Other'));
        if(fail is ApiFailure){
          loadOffline();
        }
        debugPrint('${fail.runtimeType}: ${fail.message}');
      }
      _isLoading = false;
    });
    saveOffline();
  }

  void loadOffline() async {
    var box = await Hive.openBox<Word>('wordList');
    Word? word = box.get(widget.word);
    if(word == null){
      return;
    }
    setState(() {
      _wordObj = word;
    });
  }

  void saveOffline() async {
    var box = await Hive.openBox<Word>('wordList');
    var historyBox = await Hive.openBox('historyList');
    if(_wordObj != null){
      await box.put(_wordObj!.word, _wordObj!);

      final List<Word> historyList = historyBox.get('list', defaultValue: <Word>[])!.cast<Word>();
      if (historyList.isNotEmpty && historyList.length >= 30) {
        // Remove the oldest item (last item) if the limit is reached
        historyList.removeAt(0);
      }
      historyList.add(_wordObj!);
      await historyBox.put('list', historyList);
    }
  }

  Future _speak(String word) async{
    if(_flutterTts != null){
      await _flutterTts!.speak(word);
    }
  }

  Future _stopTTS() async{
    if(_flutterTts != null){
      await _flutterTts!.stop();
    }
  }

  // ignore: non_constant_identifier_names
  Widget WordBox() {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0), // Rounded corners
              border: Border.all(
                color: Theme.of(context).colorScheme.primary, // Border color
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
                        style: TextStyle(
                          fontSize: 36.0,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      Text(
                        _wordObj!.pronunciation,
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Column(
          children: [
            IconButton(
              icon: const Icon(Icons.volume_up),
              onPressed: (){
                _speak(_wordObj!.word);
              },
            ),
            IconButton(
              isSelected: _isFavorite,
              icon: const Icon(Icons.favorite_outline),
              selectedIcon: const Icon(Icons.favorite),
              onPressed: () {
                setState(() {
                  _isFavorite = !_isFavorite;
                });
                setFavorite(_isFavorite);
              },
            ),
          ],
        )
      ],
    );
  }

  void setFavorite(bool favoriteState) {
    if(favoriteState) {
      favoriteBox.put(widget.word, true);
    } else {
      favoriteBox.delete(widget.word);
    }
  }

  // ignore: non_constant_identifier_names
  Widget MeaningList() {
    if(_wordObj == null){
      return const Text('TODO Meaning Saving');
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
                  style: TextStyle(
                    fontSize: 12.0,
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context).colorScheme.primary,
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
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
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
      ),
    );
  }

}