import 'package:coodesh/modules/favorites/favorite_page.dart';
import 'package:coodesh/modules/history/history_page.dart';
import 'package:coodesh/modules/list/list_page.dart';
import 'package:coodesh/shared/model/word.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  await Hive.initFlutter();
  Hive.registerAdapter(WordAdapter());
  
  final GetIt getIt = GetIt.instance;
  FlutterTts flutterTts = FlutterTts();
  if(await flutterTts.isLanguageAvailable("en-US")){
    await flutterTts.setLanguage("en-US");
  }
  getIt.registerLazySingleton<FlutterTts>(() => flutterTts);
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  AppState createState() => AppState();
}

class AppState extends State<App> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorSchemeSeed: const Color(0xff254f5f),
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: DefaultTabController(
        length: 3, // Number of tabs
        child: Scaffold(
          appBar: AppBar(
            title: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'List'),
                Tab(text: 'History'),
                Tab(text: 'Favorites'),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: const [
              ListPage(),
              HistoryPage(),
              FavoritePage()
            ],
          ),
        ),
      ),
    );
  }
}