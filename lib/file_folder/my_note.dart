import 'package:flutter/material.dart';

import '../file_constant/constant.dart';
import '../get/controller.dart';

import 'store_data.dart';
import '../button_and_bar/icon_button.dart';

class MyNotesScreen extends StatefulWidget {
  @override
  State<MyNotesScreen> createState() => _MyNotesScreenState();
}

class _MyNotesScreenState extends State<MyNotesScreen> {
  List<Map<String, dynamic>>  note ;
  void initState(){
    super.initState();

    fetchnotes();
  }
  fetchnotes() async{
    final data = await StoreData.fetchAll();

    setState((){note=data;});

  }
  void _delete(int id) async {
    await StoreData.deleteItem(id);

    fetchnotes();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text('My Notes', style: fontStyle),
            ),
            body:note!=null? ListView.builder(
                itemCount: note.length,
                itemBuilder: (context, index) {
                  return Card(

                      elevation: 5,
                      margin: EdgeInsets.all(5),
                      child:ListTile(title:Text("${note[index]['title']}"),
                          subtitle:Text("${note[index]['description']}"),
                          trailing:iconButton(icons:Icons.delete,onPress:(){_delete(note[index]['id']);}))
                  );




                }
            ):Container(margin: EdgeInsets.all(20), child: Text("There is no Note", style: fontStyle))));
  }
}