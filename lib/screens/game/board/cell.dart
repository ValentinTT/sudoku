import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/models/currentCell.dart';
import 'package:sudoku/models/sudoku.dart';
import 'package:sudoku/theme.dart';
import 'package:tuple/tuple.dart';

class Cell extends StatefulWidget {
  final String content;
  static final double size = 35;
  final int row, col;

  Cell({this.content, this.row, this.col});

  @override
  _CellState createState() => _CellState();
}

class _CellState extends State<Cell> {
  bool isFocus = false;

  @override
  Widget build(BuildContext context) {
    CurrentCell currentCell = Provider.of<CurrentCell>(context);
    if (widget.row != currentCell.row || widget.col != currentCell.col)
      isFocus = false;

    return Selector<Sudoku, Tuple3<String, bool, bool>>(
        selector: (_, _sudoku) => Tuple3(
            _sudoku.getElement(widget.row, widget.col).toString(),
            _sudoku.statusBoard[widget.row][widget.col],
            _sudoku.initialBoard[widget.row][widget.col] != 0),
        builder: (_, data, __) {
          String _content = data.item1;
          bool _cellStatusOk = data.item2;
          bool _isInitialValue = data.item3;

          bool shouldHighlight =
              (isFocus || !_cellStatusOk) && currentCell.updatesEnabled;
          Color highlightColor =
              shouldHighlight ? MyTheme.error : Colors.transparent;
          if (isFocus) highlightColor = MyTheme.focus;

          return GestureDetector(
            onTap: () {
              setState(() {
                isFocus = true;
              });
              currentCell.setPosition(widget.row, widget.col);
            },
            child: Container(
              color: MyTheme.cellBackground,
              child: Stack(children: <Widget>[
                Center(
                  child: AnimatedContainer(
                    width: Cell.size,
                    height: shouldHighlight ? Cell.size : 0,
                    decoration: BoxDecoration(
                        color: highlightColor, shape: BoxShape.circle),
                    // Define how long the animation should take.
                    duration: Duration(milliseconds: 200),
                    // Provide an optional curve to make the animation feel smoother.
                    curve: Curves.easeInQuad,
                  ),
                ),
                Container(
                  width: Cell.size,
                  height: Cell.size,
                  color: shouldHighlight
                      ? Colors.transparent
                      : MyTheme.cellBackground,
                  child: Center(
                    child: Text(_content == '0' ? '' : _content,
                        style: TextStyle(
                          color: _isInitialValue
                              ? MyTheme.initialValue
                              : MyTheme.normalValue,
                          fontSize: 22.0,
                          fontWeight: _isInitialValue
                              ? FontWeight.w600
                              : FontWeight.w400,
                        )),
                  ),
                )
              ]),
            ),
          );
        });
  }
}
