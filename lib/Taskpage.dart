import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class TaskPage extends StatefulWidget {
  final Database database;

  const TaskPage({Key? key, required this.database}) : super(key: key);

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final TextEditingController _taskController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Manager'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _taskController,
              decoration: InputDecoration(
                labelText: 'Add Task',
                suffixIcon: IconButton(
                  onPressed: () {
                    _addTask();
                  },
                  icon: Icon(Icons.add),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: getTasks(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  List<Map<String, dynamic>> tasks = snapshot.data!;
                  return ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(tasks[index]['name']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                _editTask(tasks[index]['id']);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                _deleteTask(tasks[index]['id']);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addTask() async {
    String taskName = _taskController.text;
    if (taskName.isNotEmpty) {
      await widget.database.transaction((txn) async {
        await txn.rawInsert(
          'INSERT INTO tasks(name) VALUES(?)',
          [taskName],
        );
      });
      _taskController.clear();
      // Atualiza a lista de tarefas após a adição
      setState(() {});
    }
  }

  Future<List<Map<String, dynamic>>> getTasks() async {
    return await widget.database.query('tasks');
  }

  Future<void> _editTask(int taskId) async {
    // Obter os detalhes da tarefa atual
    List<Map<String, dynamic>> tasks = await widget.database.query(
      'tasks',
      where: 'id = ?',
      whereArgs: [taskId],
    );

    // Verificar se a tarefa existe
    if (tasks.isNotEmpty) {
      // Exibir um diálogo para editar a tarefa
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Editar Tarefa'),
          content: TextFormField(
            initialValue: tasks[0]['name'], // Nome da tarefa atual
            onChanged: (value) {
              tasks[0]['name'] = value; // Atualizar o nome da tarefa
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Fechar o diálogo sem salvar
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                // Salvar as alterações da tarefa
                await widget.database.update(
                  'tasks',
                  tasks[0],
                  where: 'id = ?',
                  whereArgs: [taskId],
                );
                Navigator.pop(context); // Fechar o diálogo após salvar
                setState(() {}); // Atualizar a interface após a edição
              },
              child: Text('Salvar'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _deleteTask(int taskId) async {
    await widget.database.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [taskId],
    );
    setState(() {});
  }
}
