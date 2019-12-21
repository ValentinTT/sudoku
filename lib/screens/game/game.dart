import 'package:flutter/material.dart';
import 'package:sudoku/models/currentCell.dart';
import 'package:sudoku/screens/game/controls.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/models/sudoku.dart';
import 'package:sudoku/screens/game/board/grid.dart';
import 'package:sudoku/theme.dart';

class Game extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Sudoku>.value(value: Sudoku()),
        ChangeNotifierProvider<CurrentCell>.value(value: CurrentCell())
      ],
      child: Scaffold(
        appBar: AppBar(
          title: AppBarTitle(),
          backgroundColor: MyTheme.appBar,
          centerTitle: true,
          actions: <Widget>[AppBarOptions()],
        ),
        body: SafeArea(
          child: Selector<CurrentCell, bool>(
            selector: (_, _currentCell) => _currentCell.updatesEnabled,
            builder: (_, _updatesEnabled, __) {
              print("Rebuild: $_updatesEnabled");
              return AbsorbPointer(
                absorbing: !_updatesEnabled,
                child: Container(
                  color: MyTheme.background,
                  child: Column(
                    children: <Widget>[
                      Expanded(child: Center(child: Grid())),
                      Controls(),
                    ],
                  ),
                ),
               );
            }
          ),
        ),
      ),
    );
  }
}

class AppBarTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<Sudoku, bool>(
        selector: (_, _sudoku) => _sudoku.isSolved,
        builder: (_, isSolved, __) {
          if (isSolved) {
            CurrentCell currentCell =
                Provider.of<CurrentCell>(context, listen: false);
            currentCell.updatesEnabled = false;
            currentCell.setPosition(0, 0);
          }
          return Text(isSolved ? "Winner" : "Sudoku");
        });
  }
}

class AppBarOptions extends StatelessWidget {
  List<String> popUpOptions = ["Check", "Restart", "Resolve"];

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      initialValue: popUpOptions[0],
      tooltip: "Options",
      itemBuilder: (BuildContext context) => popUpOptions.map((String option) {
        return PopupMenuItem<String>(
          value: option,
          child: Text(option),
        );
      }).toList(),
      onSelected: (String option) {
        CurrentCell currentCell =
            Provider.of<CurrentCell>(context, listen: false);
        Sudoku sudoku = Provider.of<Sudoku>(context, listen: false);
        switch (option) {
          case "Check":
            sudoku.check();
            break;
          case "Restart":
            currentCell.updatesEnabled = true;
            sudoku.restart();
            break;
          case "Resolve":
            currentCell.setPosition(0, 0);
            currentCell.updatesEnabled = false;
            sudoku.restart();
            sudoku.solveVisual(0).then((v) => sudoku.isSolved = true);
            break;
        }
      },
    );
  }
}
