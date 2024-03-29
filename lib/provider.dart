import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'src/model/config.dart';
import 'src/state/config.dart';
import 'src/state/user.dart';

class AppProvider {
  final ChangeNotifierProvider<AppConfigState> configProvider;
  final ChangeNotifierProvider<UserState> userProvider;

  AppProvider._(this.configProvider, this.userProvider);

  factory AppProvider() => _instance!;

  static AppProvider? _instance;

  static Future<void> create() async {
    if (_instance == null) {
      final config = AppConfig();
      await config.load();
      final configProvider =
          ChangeNotifierProvider((_) => AppConfigState(config));
      final userProvider = ChangeNotifierProvider((_) => UserState());
      _instance = AppProvider._(configProvider, userProvider);
    }
  }
}
