// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    RandomWords(),    SavedItems(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Startup Name Generator'),
      ),
      body: _homePages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "Saved",
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  State<RandomWords> createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};


  void _goToSavedItems() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          return SavedItems(saved: _saved);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Startup Name Generator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: _goToSavedItems,
            tooltip: 'Saved Suggestions',
          ),
        ],
      ),
      body:
      ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (context, i) {
          if (i.isOdd) return const Divider();        /*2*/

          final index = i ~/ 2; /*3*/
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10)); /*4*/
          }

          final alreadySaved = _saved.contains(_suggestions[index]);
          return ListTile(
            title: Text(
              _suggestions[index].asPascalCase,
              // style: _biggerFont,
            ),
            trailing: Icon(
              alreadySaved ? Icons.favorite : Icons.favorite_border,
              color: alreadySaved ? Colors.red : null,
              semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
            ),
            onTap: () {
              setState(() {
                if (alreadySaved) {
                  _saved.remove(_suggestions[index]);
                }
                else {
                  _saved.add(_suggestions[index]);
                }
              });
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton (
        onPressed: _goToSavedItems,
        child: const Icon(Icons.list),
      ),
      bottomNavigationBar: NavBar(saved: _saved),
    );
  }
}

class SavedItems extends StatefulWidget {
  final Set<WordPair> saved;
  const SavedItems({Key? key, required this.saved}) : super(key: key);

  @override
  State<SavedItems> createState() => _SavedItemsState();
}

class _SavedItemsState extends State<SavedItems> {
  final _biggerFont = const TextStyle(fontSize: 18);
  late final tiles = widget.saved.map(
        (pair) {
      return ListTile(
        title: Text(
          pair.asPascalCase,
          style: _biggerFont,
        ),
      );
    },
  );
  late final divided = tiles.isNotEmpty
      ? ListTile.divideTiles(
    context: context,
    tiles: tiles,
  ).toList()
      : <Widget>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Suggestions'),
      ),
      body: ListView(children: divided),
      bottomNavigationBar: NavBar(saved: widget.saved),
    );
  }
}

class NavBar extends StatefulWidget {
  final Set<WordPair> saved;
  const NavBar({Key? key, required this.saved}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;

      if (_currentIndex == 0) {
        _goToHomePage();
      }
      if (_currentIndex == 1) {
        _goToSavedItems();
      }
    });
  }

  void _goToSavedItems() {
    print("we're in _goToSavedItems");
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          return SavedItems(saved: widget.saved);
        },
      ),
    );
  }

  void _goToHomePage() {
    print("we're in _goToHomePage");
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: 'Saved',
        ),
      ],
      currentIndex: _currentIndex,
      selectedItemColor: Colors.blue,
      onTap: _onItemTapped,
    );
  }
}




