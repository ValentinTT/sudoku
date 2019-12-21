import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/models/currentCell.dart';
import 'package:sudoku/models/sudoku.dart';
import 'package:sudoku/theme.dart';

class Controls extends StatefulWidget {
  @override
  _ControlsState createState() => _ControlsState();
}

class _ControlsState extends State<Controls> {
  @override
  Widget build(BuildContext context) {
    Sudoku sudoku = Provider.of<Sudoku>(context, listen: false);
    CurrentCell currentCell = Provider.of<CurrentCell>(context, listen: false);
    List<String> controls = currentCell.controls;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              for (String c in controls.sublist(0, 5)) Control(text: c)
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              for (String c in controls.sublist(5)) Control(text: c)
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SpecialControl(icon: Icons.edit, onPress: () {
                currentCell.updatesEnabled = false;
                sudoku.restart();
                sudoku.solveVisual(0).then((v) {
                  sudoku.isSolved = true;
                });
              }),
              SpecialControl(icon: Icons.check, onPress: sudoku.check),
              SpecialControl(icon: Icons.settings_backup_restore, onPress: () {
                currentCell.updatesEnabled = true;
                sudoku.restart();
              }),
            ],
          )
        ],
      ),
    );
  }
}

class SpecialControl extends StatelessWidget {
  final IconData icon;
  Function onPress;

  SpecialControl({this.icon, this.onPress});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: RaisedButton(
        onPressed: onPress,
        child: Icon(
          icon,
          color: MyTheme.controlText,
        ),
        color: MyTheme.control,
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(18.0),
            side: BorderSide(color: MyTheme.controlFocus)),
      ),
    );
  }
}

class Control extends StatelessWidget {
  String text;
  int _value;

  Control({this.text}) : super() {
    _value = text != "X" ? int.parse(text) : 0;
  }

  @override
  Widget build(BuildContext context) {
    CurrentCell currentCell = Provider.of<CurrentCell>(context, listen: false);
    Sudoku sudoku = Provider.of<Sudoku>(context, listen: false);

    return Container(
      decoration:
          BoxDecoration(shape: BoxShape.circle, color: MyTheme.controlFocus),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: FloatingActionButton(
          heroTag: text,
          onPressed: () {
            currentCell.currentControl = text;
            sudoku.update(currentCell.row, currentCell.col, _value);
          },
          backgroundColor: MyTheme.control,
          splashColor: MyTheme.controlFocus,
          child: Text(
            text,
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w300,
                color: MyTheme.controlText),
          ),
        ),
      ),
    );
  }
}
