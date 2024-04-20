import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class RegisterPage extends StatefulWidget {
  final Future<Database> database;

  const RegisterPage({required this.database});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
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
                _register();
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _register() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    final db = await widget.database;
    List<Map<String, dynamic>> users = await db.query(
      'users',
      where: "username = ?",
      whereArgs: [username],
    );

    if (users.isNotEmpty) {
      // Usuário já existe, mostrar mensagem de erro
      _showAlertDialog('Error', 'Username already exists.');
    } else {
      // Usuário não existe, prosseguir com o registro
      await db.insert(
        'users',
        {'username': username, 'password': password},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      _showAlertDialog('Success', 'User registered successfully.');
      // Navegue para a próxima página, por exemplo, LoginPage
      Navigator.pop(context);
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
