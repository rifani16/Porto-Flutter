import 'package:flutter/material.dart';
import 'dart:async';

class MatchTile extends StatefulWidget {
  const MatchTile({super.key});

  @override
  State<MatchTile> createState() => _MatchTileState();
}

class _MatchTileState extends State<MatchTile> {
  List<int> tileNumbers = [];
  List<Color> tileColors = [];
  List<bool> tileMatched = [];
  int? selectedTileIndex;
  bool isMatching = false;
  int score = 0;

  @override
  void initState() {
    super.initState();
    initializeGame();
  }

  void initializeGame() {
    List<int> initialTileNumbers = List.generate(16, (index) => index + 1)
      ..addAll(List.generate(16, (index) => index + 1));
    tileNumbers = List.of(initialTileNumbers);
    tileNumbers.shuffle();
    tileColors = List.generate(32, (index) => Colors.white);
    tileMatched = List.generate(32, (index) => false);
  }

  void checkMatch(int index) {
    if (tileMatched[index] || isMatching || selectedTileIndex == index) {
      return;
    }

    if (selectedTileIndex == null) {
      setState(() {
        selectedTileIndex = index;
      });
    } else {
      if (tileNumbers[selectedTileIndex!] == tileNumbers[index]) {
        setState(() {
          tileMatched[selectedTileIndex!] = true;
          tileMatched[index] = true;
          score++;
          selectedTileIndex = null;
        });
        if (score == 16) {
          showAdaptiveDialog(
            context: context,
            builder: (context) {
              return AlertDialog.adaptive(
                title: const Text("Congratulations!"),
                content: const Text("You've won the game!"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {
                        initializeGame();
                        score = 0;
                      });
                    },
                    child: const Text("Play Again"),
                  ),
                ],
              );
            },
          );
        }
      } else {
        setState(() {
          isMatching = true;
        });
        Timer(const Duration(milliseconds: 500), () {
          setState(() {
            selectedTileIndex = null;
            isMatching = false;
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Match Tiles', style: TextStyle(color: Colors.white)),
      ),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            int count = 4;
            double fontSize = 18;

            if (constraints.maxWidth > 800) {
              count = 8;
              fontSize = 30;
            }
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: GridView.builder(
                scrollDirection: Axis.vertical,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: count,
                ),
                itemCount: tileNumbers.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      if (!tileMatched[index]) {
                        checkMatch(index);
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: tileMatched[index]
                            ? tileColors[index] = Colors.transparent
                            : tileColors[index] = Colors.white,
                      ),
                      child: Center(
                        child: Text(
                          tileMatched[index] ? '' : tileNumbers[index].toString(),
                          style: TextStyle(
                            fontSize: fontSize,
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }),
    );
  }
}