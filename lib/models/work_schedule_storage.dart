import 'package:shared_preferences/shared_preferences.dart';

class WorkScheduleStorage {
  static const String _key = 'work_schedule';

  static Future<void> saveWorkSchedule(List<String> schedule) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, schedule);
  }

  static Future<List<String>?> loadWorkSchedule() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key);
  }
}
