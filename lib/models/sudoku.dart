import 'package:flutter/material.dart';

class Sudoku with ChangeNotifier {
  List<List<int>> initialBoard;
  List<List<int>> currentBoard = List();
  List<List<int>> solvedBoard = List();
  List<List<bool>> statusBoard = List();
  bool _isSolved = false;

  Sudoku() {
    initialBoard = [
      [4, 2, 7, 1, 3, 9, 0, 6, 8], //3 9
      [0, 0, 5, 8, 7, 6, 3, 0, 0], //8 7
      [6, 0, 3, 5, 4, 2, 1, 0, 0], //5 4 2
      [2, 0, 0, 0, 1, 0, 4, 0, 0],
      [3, 4, 0, 0, 6, 7, 0, 5, 1],
      [8, 0, 1, 0, 5, 0, 0, 2, 0],
      [0, 9, 0, 0, 0, 0, 7, 3, 0],
      [7, 0, 4, 3, 0, 0, 2, 0, 9],
      [0, 3, 2, 0, 9, 4, 6, 0, 0],
    ];
    initialBoard.forEach((List<int> row) {
      currentBoard.add(List.from(row));
      solvedBoard.add(List.from(row));
      statusBoard.add(List.generate(row.length, (i) => true));
    });
    solve(0);
    restartStatus();
  }

  int getItem(int index) => currentBoard[index ~/ 9][index % 9];

  int getElement(int row, int col) {
    return currentBoard[row][col];
  }

  void update(int row, int col, int number) {
    if (row < 0 || row > 8 || col < 0 || col > 8 || number < 0 || number > 9)
      return;
    if (initialBoard[row][col] != 0) return;
    currentBoard[row][col] = number;
    notifyListeners();
    restartStatus();
  }

  void restartStatus() {
    _isSolved = true;
    for(int row = 0; row < currentBoard.length; row++) {
      for(int col = 0; col < currentBoard[row].length; col++) {
        if (currentBoard[row][col] != solvedBoard[row][col])
          _isSolved = false;
        statusBoard[row][col] = true;
      }
    }
  }

  set isSolved(bool newValue) {
    _isSolved = newValue;
    notifyListeners();
  }
  get isSolved => _isSolved;

  void restart() {
    _isSolved = false;
    currentBoard.clear();
    initialBoard.forEach((List<int> row) => currentBoard.add(List.from(row)));
    notifyListeners();
  }

  void check() {
    for (int row = 0; row < currentBoard.length; row++)
      for (int col = 0; col < currentBoard[0].length; col++)
        statusBoard[row][col] =
            currentBoard[row][col] == solvedBoard[row][col] ||
                currentBoard[row][col] == 0;
    notifyListeners();
  }

  Future<bool> solveVisual(int prevRow) async{
    for (int row = prevRow; row < currentBoard.length; row++) {
      for (int col = 0; col < currentBoard[row].length; col++) {
        if (currentBoard[row][col] != 0) continue;
        while (await solveCellVisual(row, col)) if (await solveVisual(row))
          return true;
        return false;
      }
    }
    return true;
  }

  Future<bool> solveCellVisual(int row, int col) async{
    await Future.delayed(Duration(milliseconds: 10));
    for (int number = currentBoard[row][col] + 1; number <= 9; number++) {
      if (!isInRow(row, number, currentBoard) &&
          !isInColumn(col, number, currentBoard) &&
          !isInSquare(row, col, number, currentBoard)) {
        currentBoard[row][col] = number;
        notifyListeners();
        return true;
      }
    }

    currentBoard[row][col] = 0;
    notifyListeners();
    return false;
  }

  Future<bool> solve(int prevRow) async {
    for (int row = prevRow; row < solvedBoard.length; row++) {
      for (int col = 0; col < solvedBoard[row].length; col++) {
        if (solvedBoard[row][col] != 0) continue;
        while (solveCell(row, col)) if (await solve(row)) return true;
        return false;
      }
    }
    return true;
  }

  bool solveCell(int row, int col) {
    for (int number = solvedBoard[row][col] + 1; number <= 9; number++) {
      if (!isInRow(row, number, solvedBoard) &&
          !isInColumn(col, number, solvedBoard) &&
          !isInSquare(row, col, number, solvedBoard)) {
        solvedBoard[row][col] = number;
        return true;
      }
    }
    solvedBoard[row][col] = 0;
    return false;
  }

  bool isInRow(int row, int number, List<List<int>> board) {
    for (int i in board[row]) if (i == number) return true;
    return false;
  }

  bool isInColumn(int col, int number, List<List<int>> board) {
    for (List<int> row in board) if (row[col] == number) return true;
    return false;
  }

  bool isInSquare(int row, int col, int number, List<List<int>> board) {
    int startCol = (col ~/ 3) * 3;
    int startRow = (row ~/ 3) * 3;

    for (List<int> row in board.sublist(startRow, startRow + 3))
      if (row.sublist(startCol, startCol + 3).contains(number)) return true;
    return false;
  }
}
