// import 'package:flutter/material.dart';
// import 'dart:math';

// void main() {
//   runApp(MyApp());
// }

// class Nurse {
//   final String name;

//   Nurse(this.name);
// }

// class WorkSchedule {
//   List<String> shifts = ['Day', 'Evening', 'Night'];
//   List<String> daysOfWeek = ['월', '화', '수', '목', '금', '토', '일'];

//   List<String> generateWorkSchedule(int month, int offDays) {
//     List<String> schedule = [];
//     int consecutiveNightShifts = 0;
//     int consecutiveMorningAfternoonShifts = 0;
//     int daysInMonth = _getDaysInMonth(month);

//     for (int i = 0; i < daysInMonth; i++) {
//       if (consecutiveMorningAfternoonShifts >= 5) {
//         schedule.add('Night');
//         consecutiveMorningAfternoonShifts = 0;
//         consecutiveNightShifts = 1;
//       } else {
//         String shift = shifts[Random().nextInt(shifts.length)];
//         if (shift == 'Night') {
//           consecutiveNightShifts++;
//           consecutiveMorningAfternoonShifts = 0;
//         } else {
//           consecutiveMorningAfternoonShifts++;
//           consecutiveNightShifts = 0;
//         }
//         schedule.add(shift);
//       }
//     }

//     int offDaysAdded = 0;
//     while (offDaysAdded < offDays) {
//       int randomIndex = Random().nextInt(daysInMonth);
//       if (schedule[randomIndex] != 'Off') {
//         schedule[randomIndex] = 'Off';
//         offDaysAdded++;
//       }
//     }

//     return schedule;
//   }

//   int _getDaysInMonth(int month) {
//     return DateTime(DateTime.now().year, month + 1, 0).day;
//   }
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: NurseListPage(),
//     );
//   }
// }

// class NurseListPage extends StatefulWidget {
//   @override
//   _NurseListPageState createState() => _NurseListPageState();
// }

// class _NurseListPageState extends State<NurseListPage> {
//   final List<Nurse> nurses = [];
//   final TextEditingController _nameController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('월간 근무표'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: nurses.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(nurses[index].name),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) =>
//                             NurseSchedulePage(nurse: nurses[index]),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.all(16.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _nameController,
//                     decoration: InputDecoration(
//                       labelText: '간호사 이름',
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 ElevatedButton(
//                   onPressed: () {
//                     String name = _nameController.text;
//                     if (name.isNotEmpty) {
//                       setState(() {
//                         nurses.add(Nurse(name));
//                         _nameController.clear();
//                       });
//                     }
//                   },
//                   child: Text('신규 간호사 등록'),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class NurseSchedulePage extends StatefulWidget {
//   final Nurse nurse;

//   NurseSchedulePage({required this.nurse});

//   @override
//   _NurseSchedulePageState createState() => _NurseSchedulePageState();
// }

// class _NurseSchedulePageState extends State<NurseSchedulePage> {
//   List<String> nurseSchedule = [];
//   int selectedMonth = 1;
//   int selectedOffDays = 6;

//   void _generateWorkSchedule() {
//     WorkSchedule workSchedule = WorkSchedule();
//     nurseSchedule =
//         workSchedule.generateWorkSchedule(selectedMonth, selectedOffDays);
//   }

//   @override
//   void initState() {
//     super.initState();
//     _generateWorkSchedule();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('${widget.nurse.name} Schedule'),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text('무슨 달의 근무 일자를 보고 싶으신가요: '),
//               DropdownButton<int>(
//                 value: selectedMonth,
//                 items: List.generate(
//                   12,
//                   (index) => DropdownMenuItem<int>(
//                     value: index + 1,
//                     child: Text('월 ${index + 1}'),
//                   ),
//                 ),
//                 onChanged: (value) {
//                   setState(() {
//                     selectedMonth = value!;
//                     _generateWorkSchedule();
//                   });
//                 },
//               ),
//             ],
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text('Select Off Days: '),
//               DropdownButton<int>(
//                 value: selectedOffDays,
//                 items: List.generate(
//                   6,
//                   (index) => DropdownMenuItem<int>(
//                     value: index + 1,
//                     child: Text('${index + 1}'),
//                   ),
//                 ),
//                 onChanged: (value) {
//                   setState(() {
//                     selectedOffDays = value!;
//                     _generateWorkSchedule();
//                   });
//                 },
//               ),
//             ],
//           ),
//           SizedBox(height: 20),
//           Expanded(
//             child: GridView.builder(
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 7,
//               ),
//               itemCount: nurseSchedule.length,
//               itemBuilder: (BuildContext context, int index) {
//                 return Container(
//                   decoration: BoxDecoration(
//                     border: Border.all(),
//                   ),
//                   child: Center(
//                     child: Text(
//                       nurseSchedule[index],
//                       style: TextStyle(
//                         fontWeight: nurseSchedule[index] == 'Off'
//                             ? FontWeight.normal
//                             : FontWeight.bold,
//                         color: nurseSchedule[index] == 'Off'
//                             ? Colors.grey
//                             : Colors.black,
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// main.dart
import 'package:flutter/material.dart';
import './pages/nurese_list_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NurseListPage(),
    );
  }
}
