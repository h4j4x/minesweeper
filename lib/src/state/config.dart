import 'package:flutter/material.dart';
import '../model/board_data.dart';
import '../model/config.dart';

class AppConfigState extends ChangeNotifier {
  final AppConfig config;

  AppConfigState(this.config);

  void changeExploreOnTap(bool value) {
    config.exploreOnTap = value;
    _save();
  }

  void changeBoardData(BoardData value) {
    value.fixMinesCount();
    config.boardData = value;
    _save();
  }

  void changeThemeMode(ThemeMode value) {
    config.themeMode = value;
    _save();
  }

  void _save() {
    if (config.dirty) {
      config.save();
      notifyListeners();
    }
  }
}
