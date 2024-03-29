import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider.dart';
import '../model/board_data.dart';
import '../model/user_score.dart';
import 'firestore.dart';

class GamingService {
  static GamingService? _instance;

  GamingService._();

  factory GamingService() {
    _instance ??= GamingService._();
    return _instance!;
  }

  Future<bool> saveScore(WidgetRef ref, int score, BoardData boardData) async {
    final userState = ref.read(AppProvider().userProvider.notifier);
    var user = userState.user;
    user ??= await userState.googleSignIn();
    if (user != null) {
      final userScore =
          UserScore(uid: user.uid, name: user.displayName ?? '-', score: score);
      await FirestoreService().saveScore(userScore, boardData.boardStr);
      return true;
    }
    return false;
  }
}
