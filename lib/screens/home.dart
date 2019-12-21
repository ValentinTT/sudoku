import 'package:flutter/material.dart';
import 'package:sudoku/screens/game/game.dart';
import 'package:sudoku/theme.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: MyTheme.controlText,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Sudoku",
              style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  color: MyTheme.appBar),
            ),
            SizedBox(height: 60.0),
            RaisedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => Game(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      var begin = Offset(0.0, 1.0);
                      var end = Offset.zero;
                      var curve = Curves.ease;
                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                  )
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 30.0, vertical: 10.0),
                child: Text(
                  "Play",
                  style: TextStyle(color: MyTheme.normalValue, fontSize: 30),
                ),
              ),
              color: MyTheme.appBar,
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(60.0),
                  side: BorderSide(color: MyTheme.normalValue)),
              highlightColor: MyTheme.focus,
            )
          ],
        ),
      ),
    );
  }
}
