import 'package:flutter/material.dart';
import 'package:sudoku/screens/game/board/cell.dart';
import 'package:sudoku/theme.dart';

class Square extends StatelessWidget {
  final int row, col;
  static final double dividerThickness = 2;
  static final double size = Cell.size * 3 + dividerThickness * 2;

  Square({this.row, this.col});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (int squareRow = 0; squareRow < 3; squareRow++)
            Container(
              width: size,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      for (int squareCol = 0; squareCol < 3; squareCol++)
                        IntrinsicHeight(
                          child: Row(
                            children: <Widget>[
                              Cell(
                                row: row * 3 + squareRow,
                                col: col * 3 + squareCol,
                              ),
                              if (squareCol != 2)
                                VerticalDivider(
                                  color: MyTheme.cellDivider,
                                  width: Square.dividerThickness,
                                  thickness: Square.dividerThickness,
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  if (squareRow != 2)
                    Divider(
                      color: MyTheme.cellDivider,
                      height: Square.dividerThickness,
                      thickness: Square.dividerThickness,
                    )
                ],
              ),
            )
        ],
      ),
    );
  }
}
