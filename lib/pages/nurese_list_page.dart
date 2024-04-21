// nurse_list_page.dart
import 'package:flutter/material.dart';
import 'nurse_schedule_page.dart';
import '../models/nurse.dart';

class NurseListPage extends StatefulWidget {
  @override
  _NurseListPageState createState() => _NurseListPageState();
}

class _NurseListPageState extends State<NurseListPage> {
  final List<Nurse> nurses = [];
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('간호사 목록'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: nurses.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(nurses[index].name),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _showDeleteConfirmationDialog(index);
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            NurseSchedulePage(nurse: nurses[index]),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: '간호사 이름',
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    String name = _nameController.text;
                    if (name.isNotEmpty) {
                      setState(() {
                        nurses.add(Nurse(name));
                        _nameController.clear();
                      });
                    }
                  },
                  child: Text('간호사 등록'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('간호사 삭제'),
          content: Text('${nurses[index].name}을(를) 삭제하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  nurses.removeAt(index);
                });
                Navigator.of(context).pop();
              },
              child: Text('삭제'),
            ),
          ],
        );
      },
    );
  }
}
