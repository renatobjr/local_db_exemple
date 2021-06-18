import 'package:flutter/material.dart';
import 'package:local_db_exemple/models/user.dart';
import 'package:local_db_exemple/providers/users_provider.dart';
import 'package:local_db_exemple/screens/home.dart';

class FormUser extends StatefulWidget {
  const FormUser({Key? key}) : super(key: key);

  static const route = '/form_user';

  @override
  _FormUserState createState() => _FormUserState();
}

class _FormUserState extends State<FormUser> {
  User _newUser = User();
  final _userKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwdController = TextEditingController();

  @override
  void didChangeDependencies() {
    Map args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    if (args['idUser'] != null) {
      getUserById(args['idUser']).then((res) {
        setState(() {
          _newUser.idUser = res.idUser as int;
          emailController.text = res.email as String;
          passwdController.text = res.passwd as String;
        });
      });
    }
    super.didChangeDependencies();
  }

  void _saveUser() async {
    if (_userKey.currentState!.validate()) {
      _userKey.currentState!.save();
      if (_newUser.idUser == null) {
        await insertUser(
          User(
            email: _newUser.email,
            passwd: _newUser.passwd,
          ),
        );
      } else {
        await updateUser(
          User(
            idUser: _newUser.idUser,
            email: _newUser.email,
            passwd: _newUser.passwd,
          ),
        );
      }
      Navigator.popAndPushNamed(context, Home.route);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Data Insert'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () => Navigator.pushNamed(context, Home.route),
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Insert'),
              onTap: () => Navigator.pushNamed(
                context,
                FormUser.route,
                arguments: {
                  'title': 'new',
                },
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: args['title'] == 'edit' ? Text('Edit') : Text('New'),
      ),
      body: Container(
        child: Form(
          key: _userKey,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                  ),
                  onSaved: (value) => _newUser.email = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Field is required';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: passwdController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                  onSaved: (value) => _newUser.passwd = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Field is required';
                    }
                    return null;
                  },
                  obscureText: true,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(
                    onPressed: () => _saveUser(),
                    child: const Text('Save'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
