import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class RegisterPage extends StatefulWidget {
  final Database database;

  const RegisterPage({required Key key, required this.database}) : super(key: key);

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
                _register(); // Chama a função de registro quando o botão é pressionado
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }

  // Função para registrar um novo usuário
  Future<void> _register() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    // Verifica se o usuário já existe no banco de dados
    List<Map<String, dynamic>> users = await widget.database.query(
      'users',
      where: "username = ?",
      whereArgs: [username],
    );

    if (users.isNotEmpty) {
      // Se o usuário já existe, exibe uma mensagem de erro
      _showAlertDialog('Error', 'Username already exists.');
    } else {
      // Se o usuário não existe, registra o novo usuário no banco de dados
      await widget.database.insert(
        'users',
        {'username': username, 'password': password},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      // Exibe uma mensagem de sucesso após o registro
      _showAlertDialog('Success', 'User registered successfully.');
      // Você pode adicionar aqui a navegação de volta para a tela de login ou outra página
    }
  }

  // Função para exibir um diálogo de alerta
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
