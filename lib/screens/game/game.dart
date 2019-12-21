import 'package:flutter/material.dart';
import 'package:sudoku/models/currentCell.dart';
import 'package:sudoku/screens/game/clock.dart';
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
          title: Clock(),
          backgroundColor: MyTheme.appBar,
          centerTitle: true,
        ),
        body: SafeArea(
          child: Selector<CurrentCell, bool>(
              selector: (_, _currentCell) => _currentCell.updatesEnabled,
              builder: (_, _updatesEnabled, __) => AbsorbPointer(
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
                  )),
        ),
      ),
    );
  }
}
