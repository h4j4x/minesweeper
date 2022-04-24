import 'dart:math';

import 'package:minesweeper/src/exception/game_over.dart';
import 'package:minesweeper/src/model/cell.dart';
import 'package:minesweeper/src/model/game_event.dart';

class Board {
  final int size;
  final List<List<Cell>> _cells;

  var _minesCount = 0;
  var _minesCleared = 0;
  var _safeCellsCleared = 0;
  var _unexploredCount = 0;

  Board({required this.size}) : _cells = [] {
    for (var rowIndex = 0; rowIndex < size; rowIndex++) {
      var row = <Cell>[];
      for (var columnIndex = 0; columnIndex < size; columnIndex++) {
        row.add(Cell(rowIndex: rowIndex, columnIndex: columnIndex));
      }
      _cells.add(row);
    }
  }

  void setMines(int minesCount) {
    _clear();
    _minesCount = minesCount;
    final random = Random();
    for (var mineIndex = 0; mineIndex < minesCount; mineIndex++) {
      Cell? cell;
      do {
        final rowIndex = random.nextInt(size);
        final columnIndex = random.nextInt(size);
        cell = cellAt(rowIndex: rowIndex, columnIndex: columnIndex);
      } while (cell == null || cell.mined);
      cell.mined = true;
      final cellsAround = _cellsAround(cell);
      for (var cellAround in cellsAround) {
        cellAround.minesAround++;
      }
    }
  }

  Cell? cellAt({required int rowIndex, required int columnIndex}) {
    if (rowIndex >= 0 &&
        rowIndex < size &&
        columnIndex >= 0 &&
        columnIndex < size) {
      return _cells[rowIndex][columnIndex];
    }
    return null;
  }

  void _clear() {
    _minesCount = 0;
    _minesCleared = 0;
    _safeCellsCleared = 0;
    _unexploredCount = size * size;
    for (var rowIndex = 0; rowIndex < size; rowIndex++) {
      for (var columnIndex = 0; columnIndex < size; columnIndex++) {
        _cells[rowIndex][columnIndex].clear();
      }
    }
  }

  List<Cell> _cellsAround(Cell cell) {
    final cellsAround = <Cell>[];
    for (var rowIndex = cell.rowIndex - 1;
        rowIndex < cell.rowIndex + 2;
        rowIndex++) {
      for (var columnIndex = cell.columnIndex - 1;
          columnIndex < cell.columnIndex + 2;
          columnIndex++) {
        final cellAround = cellAt(rowIndex: rowIndex, columnIndex: columnIndex);
        if (cellAround != null && cellAround != cell) {
          cellsAround.add(cellAround);
        }
      }
    }
    return cellsAround;
  }

  bool get _hasMinesCleared =>
      _minesCount == _minesCleared || _unexploredCount <= _minesCount;

  bool get _hasNotSafeCellsCleared => _safeCellsCleared == 0;

  void toggleClear(Cell cell) {
    final step = cell.cleared ? -1 : 1;
    cell.cleared = !cell.cleared;
    if (cell.mined) {
      _minesCleared += step;
    } else {
      _safeCellsCleared += step;
    }
    _checkWin();
  }

  void explore(Cell cell) => _explore(cell, checkWin: true);

  void _explore(Cell cell, {bool checkWin = false}) {
    if (!cell.explored) {
      cell.explored = true;
      _unexploredCount--;

      if (cell.mined && !cell.cleared) {
        throw GameOverEvent(event: GameEvent.mineStepped);
      }
      if (cell.minesAround == 0) {
        final cellsAround = _cellsAround(cell);
        for (var cellAround in cellsAround) {
          _explore(cellAround);
        }
      }
      if (checkWin) {
        _checkWin();
      }
    }
  }

  void _checkWin() {
    if (_hasMinesCleared && _hasNotSafeCellsCleared) {
      throw GameOverEvent(event: GameEvent.minesCleared);
    }
  }
}
