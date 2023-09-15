import 'package:flutter/material.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  ListPageState createState() => ListPageState();
}

class ListPageState extends State<ListPage> {
  final List<int> _items = List.generate(40, (index) => index); // Initial list of items.

  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // Listen to scroll events and load more data when reaching the end.
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMoreItems();
      }
    });
  }

  // Simulate loading more items.
  Future<void> _loadMoreItems() async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });

      // Simulate loading delay (you can replace this with your data fetching logic).
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _items.addAll(List.generate(20, (index) => index + _items.length));
        _isLoading = false;
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
                      // Respond to button press
                  },
                  child: Text('Item: ${_items[index]}'),
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