import 'package:flutter/material.dart';
import 'package:local_db_exemple/models/user.dart';
import 'package:local_db_exemple/providers/users_provider.dart';
import 'package:local_db_exemple/screens/form_user.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  static const route = '/home';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void _deleteUser(int idUser) {
    Navigator.pop(context);
    removeUser(idUser);
    Navigator.popAndPushNamed(context, Home.route);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('User Deleted'),
      ),
    );
  }

  void dialogDeleteUser(User u) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('Delete User?'),
          content: Text('Do you want to Delete the User?'),
          actions: [
            ButtonBar(
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => _deleteUser(u.idUser as int),
                  child: Text('Delete'),
                )
              ],
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
        title: const Text('Local DB Exemple'),
      ),
      body: FutureBuilder(
        future: fetchAllUsers(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List<User> users = snapshot.data as List<User>;
            if (users.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.separated(
                  separatorBuilder: (BuildContext context, int i) =>
                      const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  itemCount: users.length,
                  itemBuilder: (BuildContext context, int i) {
                    return Container(
                      height: 70,
                      color: Colors.grey.shade200,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () => dialogDeleteUser(users[i]),
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.popAndPushNamed(
                              context,
                              FormUser.route,
                              arguments: {
                                'title': 'edit',
                                'idUser': users[i].idUser,
                              },
                            ),
                            icon: Icon(
                              Icons.edit,
                              color: Colors.green,
                            ),
                          ),
                          Text(users[i].email as String),
                        ],
                      ),
                    );
                  },
                ),
              );
            } else {
              return Center(
                child: Text('No data. Insert User to view data'),
              );
            }
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
