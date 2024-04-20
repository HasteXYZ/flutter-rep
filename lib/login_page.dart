import 'package:app_todolist/register_page.dart';
import 'package:app_todolist/taskpage.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'taskpage.dart'; // Importe a classe TaskPage

class LoginPage extends StatefulWidget {
  final Future<Database> database;

  const LoginPage({required this.database});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _login();
              },
              child: Text('Login'),
            ),
            SizedBox(height: 10.0),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage(database: widget.database )),
                );
              },
              child: Text('Create an Account'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    final db = await widget.database;
    List<Map<String, dynamic>> users = await db.query(
      'users',
      where: "username = ? AND password = ?",
      whereArgs: [username, password],
    );

    if (users.isNotEmpty) {
      // Login bem-sucedido, navegue para a página TaskPage
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TaskPage(database: db)),
      );
    } else {
      // Login falhou
      _showAlertDialog('Error', 'Invalid username or password.');
    }
  }

  void _showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
