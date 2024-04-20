import 'package:app_todolist/login_page.dart';
import 'package:app_todolist/register_page.dart';
import 'package:app_todolist/taskpage.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'Taskpage.dart'; // Importe a classe TaskPage
import 'package:path/path.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final Future<Database> database = openDatabase(
    join(await getDatabasesPath(), 'tasks_database.db'),
    onCreate: (db, version) {
      db.execute(
        "CREATE TABLE IF NOT EXISTS users(id INTEGER PRIMARY KEY, username TEXT, password TEXT)",
      );
      db.execute(
        "CREATE TABLE IF NOT EXISTS tasks(id INTEGER PRIMARY KEY, name TEXT)",
      );
    },
    version: 1,
  );

  runApp(MainApp(database: database));
}

class MainApp extends StatelessWidget {
  final Future<Database> database;

  const MainApp({Key? key, required this.database}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(database: database),
        '/register': (context) => RegisterPage(database: database),
        '/task_list': (context) => Taskpage(database: database), // Use TaskPage corretamente
      },
    );
  }
  
  Taskpage({required Future<Database> database}) {}
}
