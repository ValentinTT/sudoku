
import 'package:flutter/cupertino.dart';

class CurrentCell with ChangeNotifier {
  int _row = 0,
      _col = 0;
  bool _updatesEnabled = true;
  String _currentControl = "0";

  set updatesEnabled(bool newValue) {
    _updatesEnabled = newValue;
    notifyListeners();
  }

  get updatesEnabled => _updatesEnabled;

  final List<String> controls = [
    "1", "2", "3", "4", "5",
    "6", "7", "8", "9", "X"];

  set currentControl(String s) {
    if(! controls.contains(s))
      return;
    _currentControl = s;
    notifyListeners();
  }

  get currentControl => _currentControl;

  void setPosition(int row, int col) {
    if(!_updatesEnabled) return;
    if(row > 8 || row < 0) return;
    if(col > 8 || col < 0) return;
    _row = row;
    _col = col;
    notifyListeners();
  }

  get row => _row;
  get col => _col;

}