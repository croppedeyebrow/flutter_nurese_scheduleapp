import 'dart:math';

class WorkSchedule {
  List<String> shifts = ['아침', '오후', '야간'];
  List<String> daysOfWeek = ['월', '화', '수', '목', '금', '토', '일'];

  List<String> generateWorkSchedule(int year, int month, int offDays) {
    List<String> schedule = [];
    int daysInMonth = _getDaysInMonth(year, month);
    int offDaysRequired = _calculateMinimumOffDays(year, month);

    int consecutiveNightShifts = 0;
    int consecutiveMorningAfternoonShifts = 0;
    bool isAfternoonShiftBeforeMorning = false; // 오후 근무 후 오전 근무 여부

    for (int i = 1; i <= daysInMonth; i++) {
      // 야간 근무가 연속 3일을 초과하면 휴무로 설정
      if (consecutiveNightShifts >= 3) {
        schedule.add('Off');
        consecutiveNightShifts = 0;
        consecutiveMorningAfternoonShifts = 0;
        isAfternoonShiftBeforeMorning = false;
        continue;
      }

      String shift = shifts[Random().nextInt(shifts.length)];

      // 야간-오프-오전 조합이 불가능하도록 설정
      if (shift == '오후' &&
          consecutiveNightShifts == 1 &&
          schedule.last == 'Off') {
        shift = '아침';
      }

      // 오후 이후에 오전 근무 불가
      if (shift == '아침' && isAfternoonShiftBeforeMorning) {
        shift = '오후';
      }

      // 오후 근무 후 오전 근무 여부 확인
      if (shift == '오후') {
        isAfternoonShiftBeforeMorning = true;
      } else if (shift == '아침') {
        isAfternoonShiftBeforeMorning = false;
      }

      // 야간 근무인 경우 연속 야간 근무일 수 증가
      if (shift == '야간') {
        consecutiveNightShifts++;
      } else {
        consecutiveNightShifts = 0;
      }

      // 오후 혹은 오전 근무인 경우 연속 오전/오후 근무일 수 증가
      if (shift == '아침' || shift == '오후') {
        consecutiveMorningAfternoonShifts++;
      } else {
        consecutiveMorningAfternoonShifts = 0;
      }

      schedule.add(shift);
    }

    // 휴무 일정 추가
    int offDaysAdded = 0;
    while (offDaysAdded < offDaysRequired) {
      int randomIndex = Random().nextInt(daysInMonth) + 1;
      if (schedule[randomIndex - 1] != 'Off') {
        schedule[randomIndex - 1] = 'Off';
        offDaysAdded++;
      }
    }

    return schedule;
  }

  int _getDaysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  int _calculateMinimumOffDays(int year, int month) {
    // 토요일과 일요일이 휴무인 일 수
    int weekendsOff = _countWeekends(year, month);

    // 총 휴무 일 수 = 토요일+일요일 + 2 (주중 최소 휴무일 수)
    return weekendsOff + 2;
  }

  int _countWeekends(int year, int month) {
    int firstDayOfMonth = DateTime(year, month, 1).weekday;
    int daysInMonth = _getDaysInMonth(year, month);
    int weekends = 0;

    for (int i = 0; i < daysInMonth; i++) {
      int dayOfWeek = (firstDayOfMonth + i) % 7;
      if (dayOfWeek == 6 || dayOfWeek == 0) {
        weekends++;
      }
    }

    return weekends;
  }
}
