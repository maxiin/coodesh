import 'package:coodesh/failures.dart';
import 'package:coodesh/modules/info/info_page.dart';
import 'package:coodesh/modules/list/data/list_file_data_source.dart';
import 'package:coodesh/modules/list/domain/list_repository.dart';
import 'package:coodesh/modules/list/domain/list_usecase.dart';
import 'package:dartz/dartz.dart' as dz;
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  ListPageState createState() => ListPageState();
}

class ListPageState extends State<ListPage> {
  final List<String> _items = [];
  final GetIt _getIt = GetIt.instance;
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;


  @override
  void initState() {
    super.initState();

    // Setup get.it dependencies
    _getIt.registerLazySingleton<ListFileDataSource>(() => ListFileDataSource());
    _getIt.registerLazySingleton<ListRepository>(() => ListRepository(_getIt<ListFileDataSource>()));
    _getIt.registerLazySingleton<ListUseCase>(() => ListUseCase(_getIt<ListRepository>()));

    // Listen to scroll events and load more data when reaching the end.
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMoreItems();
      }
    });
    _loadMoreItems();
  }

  // Simulate loading more items.
  Future<void> _loadMoreItems() async {
    final getListUseCase = _getIt<ListUseCase>();
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });

      dz.Either<Failure, List<String>> response = await getListUseCase.call(_items.length);

      setState(() {
        if(response.isRight()){
          List<String> list = response.getOrElse(() => []);
          _items.addAll(list);
        } else {
          Failure fail = response.fold((l) => l, (r) => GenericFailure(message: 'Other'));
          debugPrint('${fail.runtimeType}: ${fail.message}');
        }
        _isLoading = false;
        debugPrint(_items.length.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        shrinkWrap: true,
        controller: _scrollController,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 2
        ),
        itemCount: _items.length + 1, // Add 1 for loading indicator.
        itemBuilder: (context, index) {
          if (index < _items.length) {
            return GridTile(
              child: Center(
                child: OutlinedButton(
                  onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => InfoPage(_items[index])),
                      );
                  },
                  child: Text(_items[index]),
                )
              ),
            );
          } else if (_isLoading) {
            // Loading indicator when loading more data.
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            // Reached the end of the list.
            return const Center(
              child: Text('End of List'),
            );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}