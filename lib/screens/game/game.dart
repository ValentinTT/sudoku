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

class AppBarTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<Sudoku, bool>(
        selector: (_, _sudoku) => _sudoku.isSolved,
        builder: (_, isSolved, __) {
          if (isSolved) {
            CurrentCell currentCell =
                Provider.of<CurrentCell>(context, listen: false);
            /* TODO: Resolve this state problem
               There is a problem with updating currentCell here, because the
               listener Selector<CurrentCell, bool> (from the Scaffold) is being
               built at the time of the update, which cause an exception.
               Momentarily the delay resolves this, waiting for the body to
               rebuild before the CurrentCell updates.
             */
            Future.delayed(Duration(milliseconds: 10), currentCell.restart);
          }
          return Text(isSolved ? "Winner" : "Sudoku");
        });
  }
}
