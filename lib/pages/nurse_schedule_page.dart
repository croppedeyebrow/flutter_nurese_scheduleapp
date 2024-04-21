// nurse_schedule_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../models/nurse.dart';
import '../models/work_schedule.dart';

class NurseSchedulePage extends StatefulWidget {
  final Nurse nurse;

  NurseSchedulePage({required this.nurse});

  @override
  _NurseSchedulePageState createState() => _NurseSchedulePageState();
}

class _NurseSchedulePageState extends State<NurseSchedulePage> {
  late List<String> nurseSchedule;
  int selectedMonth = 1;
  int selectedOffDays = 6;

  @override
  void initState() {
    super.initState();
    _generateWorkSchedule();
  }

  void _generateWorkSchedule() {
    WorkSchedule workSchedule = WorkSchedule();
    nurseSchedule =
        workSchedule.generateWorkSchedule(selectedMonth, selectedOffDays);
  }

  @override
  Widget build(BuildContext context) {
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
                    _generateWorkSchedule();
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
                    _generateWorkSchedule();
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
              itemCount: nurseSchedule.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                  ),
                  child: Center(
                    child: Text(
                      nurseSchedule[index],
                      style: TextStyle(
                        fontWeight: nurseSchedule[index] == 'Off'
                            ? FontWeight.normal
                            : FontWeight.bold,
                        color: nurseSchedule[index] == 'Off'
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
