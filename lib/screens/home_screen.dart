import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TASC'),
        centerTitle: true,
      ),
      body: ListView.separated(
        separatorBuilder: (_, __)=>Divider(height: 1,),
        itemBuilder: (_, index){
          return ListTile(
            title: Text(
                'hellow',
              style: TextStyle(
                color: Theme.of(context).primaryColor
              ),
            ),
            subtitle: Text('Last edited'),
          );
        },
        itemCount: 30,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        tooltip: 'create new task',
        child: Icon(Icons.add),
      ),
    );
  }
}
