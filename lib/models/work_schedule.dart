// work_schedule.dart
import 'dart:math';

class WorkSchedule {
  List<String> shifts = ['Day', 'Evening', 'Night'];
  List<String> daysOfWeek = ['월', '화', '수', '목', '금', '토', '일'];

  List<String> generateWorkSchedule(int month, int offDays) {
    List<String> schedule = [];
    int consecutiveNightShifts = 0;
    int consecutiveMorningAfternoonShifts = 0;
    int daysInMonth = _getDaysInMonth(month);

    for (int i = 0; i < daysInMonth; i++) {
      if (consecutiveMorningAfternoonShifts >= 5) {
        schedule.add('Night');
        consecutiveMorningAfternoonShifts = 0;
        consecutiveNightShifts = 1;
      } else {
        String shift = shifts[Random().nextInt(shifts.length)];
        if (shift == 'Night') {
          consecutiveNightShifts++;
          consecutiveMorningAfternoonShifts = 0;
        } else {
          consecutiveMorningAfternoonShifts++;
          consecutiveNightShifts = 0;
        }
        schedule.add(shift);
      }
    }

    int offDaysAdded = 0;
    while (offDaysAdded < offDays) {
      int randomIndex = Random().nextInt(daysInMonth);
      if (schedule[randomIndex] != 'Off') {
        schedule[randomIndex] = 'Off';
        offDaysAdded++;
      }
    }

    return schedule;
  }

  int _getDaysInMonth(int month) {
    return DateTime(DateTime.now().year, month + 1, 0).day;
  }
}
