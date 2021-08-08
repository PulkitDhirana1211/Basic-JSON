import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "JSON",
      debugShowCheckedModeBanner: false,
      home: homepage(),
    );
  }
}
class homepage extends StatefulWidget {
  const homepage({Key? key}) : super(key: key);

  @override
  _homepageState createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  Future<List<User>> _getUsers()  async {
    var data=await http.get(Uri.parse("https://jsonplaceholder.typicode.com/users"));
    var jsondata=json.decode(data.body);
    List<User> users=[];
    for (var u in jsondata){
      User user=User(u["id"],u["name"],u["username"],u["email"],u["website"]);
    users.add(user);
    }
    return users;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Data Fetch"),
        ),
      ),
      body: Container(
        child: FutureBuilder(
          future: _getUsers(),
          builder: (BuildContext context,AsyncSnapshot snapshot){
              return ListView.builder(
                itemBuilder: (BuildContext context,int index){
                  return ListTile(
                    leading: FlutterLogo(),
                    title: Text(snapshot.data[index].name),
                    subtitle: Text(snapshot.data[index].email),
                    onTap: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context)=> Info(snapshot.data[index]))
                      );
                    },
                    );
                  },
                itemCount: snapshot.data==null?0:snapshot.data.length,
              );
            }
        ),
      ),
    );
  }
}
class Info extends StatelessWidget {
  final User user;
  Info(this.user);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.name),
      ),
    );
  }
}

class User{
  final int id;
  final String name;
  final String username;
  final String email;
  final String website;
User(this.id,this.name,this.username,this.email,this.website);
}