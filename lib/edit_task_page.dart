import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class EditTaskPage extends StatefulWidget {
  final Database database;
  final int taskId;
  final String taskName;

  const EditTaskPage({Key? key, required this.database, required this.taskId, required this.taskName}) : super(key: key);

  @override
  _EditTaskPageState createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  late TextEditingController _taskController;

  @override
  void initState() {
    super.initState();
    _taskController = TextEditingController(text: widget.taskName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _taskController,
              decoration: InputDecoration(
                labelText: 'Task Name',
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _saveTaskChanges();
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveTaskChanges() async {
    String newTaskName = _taskController.text;
    if (newTaskName.isNotEmpty) {
      // Atualizar a tarefa no banco de dados
      await widget.database.update(
        'tasks',
        {'name': newTaskName},
        where: 'id = ?',
        whereArgs: [widget.taskId],
      );
      // Voltar para a página anterior
      Navigator.pop(context);
    }
  }
}
