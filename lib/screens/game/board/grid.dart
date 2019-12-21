import 'package:flutter/material.dart';
import 'package:sudoku/screens/game/board/square.dart';
import 'package:sudoku/theme.dart';

class Grid extends StatelessWidget {
  static final double dividerThickness = 3;
  static final double size = Square.size * 3 + dividerThickness * 2;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        new BoxShadow(
          color: Colors.black,
          blurRadius: 10.0,
        )
      ]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (int row = 0; row < 3; row++)
            Container(
              width: size,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      for (int col = 0; col < 3; col++)
                        IntrinsicHeight(
                          child: Row(
                            children: <Widget>[
                              Square(row: row, col: col),
                              if (col != 2)
                                VerticalDivider(
                                  color: MyTheme.squareDivider,
                                  width: dividerThickness,
                                  thickness: dividerThickness,
                                )
                            ],
                          ),
                        )
                    ],
                  ),
                  if (row != 2)
                    Divider(
                      color: MyTheme.squareDivider,
                      height: dividerThickness,
                      thickness: dividerThickness,
                    )
                ],
              ),
            )
        ],
      ),
    );
  }
}
