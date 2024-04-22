import 'package:flutter/material.dart';
import 'dart:math';
import '../models/nurse.dart';
import '../models/work_schedule.dart';
import '../models/work_schedule_storage.dart';

class NurseSchedulePage extends StatefulWidget {
  final Nurse nurse;

  NurseSchedulePage({required this.nurse});

  @override
  _NurseSchedulePageState createState() => _NurseSchedulePageState();
}

class _NurseSchedulePageState extends State<NurseSchedulePage>
    with AutomaticKeepAliveClientMixin {
  List<String>? nurseSchedule;
  int selectedMonth = 1;
  int selectedOffDays = 6;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadWorkSchedule(); // 페이지 로드시 저장된 근무표 불러오기
  }

  void _generateAndSaveWorkSchedule() async {
    WorkSchedule workSchedule = WorkSchedule();
    List<String> schedule = workSchedule.generateWorkSchedule(
        DateTime.now().year, selectedMonth, selectedOffDays);
    await WorkScheduleStorage.saveWorkSchedule(schedule); // 생성된 일정을 저장
    setState(() {
      nurseSchedule = schedule; // 근무표 갱신
    });
  }

  void _loadWorkSchedule() async {
    List<String>? savedSchedule = await WorkScheduleStorage.loadWorkSchedule();
    if (savedSchedule != null) {
      setState(() {
        nurseSchedule = savedSchedule; // 저장된 일정 불러오기
      });
    } else {
      _generateAndSaveWorkSchedule(); // 저장된 일정이 없으면 새로 생성 후 저장
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.nurse.name} Schedule'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('무슨 달의 근무 일자를 보고 싶으신가요: '),
              DropdownButton<int>(
                value: selectedMonth,
                items: List.generate(
                  12,
                  (index) => DropdownMenuItem<int>(
                    value: index + 1,
                    child: Text('월 ${index + 1}'),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    selectedMonth = value!;
                    _generateAndSaveWorkSchedule(); // 선택된 달이 변경될 때마다 근무표 생성 후 저장
                  });
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Select Off Days: '),
              DropdownButton<int>(
                value: selectedOffDays,
                items: List.generate(
                  6,
                  (index) => DropdownMenuItem<int>(
                    value: index + 1,
                    child: Text('${index + 1}'),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    selectedOffDays = value!;
                    _generateAndSaveWorkSchedule(); // 선택된 휴무일수가 변경될 때마다 근무표 생성 후 저장
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
              ),
              itemCount: nurseSchedule?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                  ),
                  child: Center(
                    child: Text(
                      nurseSchedule?[index] ?? '',
                      style: TextStyle(
                        fontWeight: nurseSchedule?[index] == 'Off'
                            ? FontWeight.normal
                            : FontWeight.bold,
                        color: nurseSchedule?[index] == 'Off'
                            ? Colors.grey
                            : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
