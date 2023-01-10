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
      title: 'Word Generator',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
      ),
      home: const HomePage(title: 'Word Generator'),
    );
  }
}

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
  int _selectedIndex = 0;
  bool _gridViewBool = false;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _addToSaved(WordPair pair) {
    setState(() {
      _saved.add(pair);
    });
  }

  void _removeFromSaved(WordPair pair) {
    setState(() {
      _saved.remove(pair);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          !_gridViewBool ?
          IconButton(
              onPressed: () {
                setState(() {
                  _gridViewBool = true;
                });
              },
              icon: const Icon(Icons.grid_4x4)
          )
          : IconButton(
              onPressed: () {
                setState(() {
                  _gridViewBool = !_gridViewBool;
                });
              },
              icon: const Icon(Icons.list)),
        ],
      ),
      body: _selectedIndex == 0 ? (_gridViewBool == true ? _buildWordPairsGrid() : _buildWordPairsList()) : _buildSavedList(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "Words",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Saved",
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _wordPairsGridItem(pair) {
    return Center(
      child: Text(pair.asPascalCase),
    );
  }

  Widget _buildWordPairsGrid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 0,
        crossAxisSpacing: 0,
        childAspectRatio: 1
      ),

      itemBuilder: (BuildContext context, int index) {
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(100));
        }
        WordPair pair = _suggestions[index];
        final alreadySaved = _saved.contains(pair);
        return GridTile(
          child: Column (
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                radius: 10,
                enableFeedback: true,
                child: Column (
                  children: [
                    _wordPairsGridItem(pair),
                    Icon(
                      alreadySaved ? Icons.favorite : Icons.favorite_border,
                      color: alreadySaved ? Colors.red : null,
                      semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
                    ),
                  ]
                ),
                onTap: () {
                  setState(() {
                    if (alreadySaved) {
                      _removeFromSaved(pair);
                    }
                    else {
                      _addToSaved(pair);
                    }
                  });
                }
              ),
            ]
          )
        );
      },
    );
  }

  Widget _buildWordPairsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: /*1*/ (context, i) {
        if (i.isOdd) return const Divider();        /*2*/

        final index = i ~/ 2; /*3*/
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(20)); /*4*/
        }
        WordPair pair = _suggestions[index];
        final alreadySaved = _saved.contains(pair);
        return ListTile(
          title: Text(pair.asPascalCase),
          trailing: Icon(
            alreadySaved ? Icons.favorite : Icons.favorite_border,
            color: alreadySaved ? Colors.red : null,
            semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
          ),
          onTap: () {
            setState(() {
              if (alreadySaved) {
                _removeFromSaved(pair);
              }
              else {
                _addToSaved(pair);
              }
            });
          },
        );
      },
    );
  }

  Widget _buildSavedList() {
    return ListView(
      children: _saved.map((pair) {
        return ListTile(
          title: Text(pair.asPascalCase),
          trailing: const Icon(Icons.favorite, color: Colors.red),
          onTap: () {
            _removeFromSaved(pair);
          },
        );
      }).toList(),
    );
  }
}


