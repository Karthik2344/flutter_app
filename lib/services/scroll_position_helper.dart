import 'package:shared_preferences/shared_preferences.dart';

class ScrollPositionHelper {
  static const String _scrollPositionKey = 'scrollPosition';

  // Save scroll position
  static Future<void> saveScrollPosition(double position) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_scrollPositionKey, position);
  }

  // Get saved scroll position
  static Future<double> getScrollPosition() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_scrollPositionKey) ?? 0.0;
  }
}
