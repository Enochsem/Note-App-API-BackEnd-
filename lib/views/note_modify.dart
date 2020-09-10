import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:note_api_todo/models/note.dart';
import 'package:note_api_todo/models/note_insert.dart';
import 'package:note_api_todo/services/note_service.dart';

class NoteModify extends StatefulWidget {
  final noteID;
  NoteModify({this.noteID});

  @override
  _NoteModifyState createState() => _NoteModifyState();
}

class _NoteModifyState extends State<NoteModify> {
  bool get isEditing =>widget.noteID != null;

  NotesService get notesService => GetIt.instance<NotesService>();


  String errorMessage;
  Note note;


  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();


  bool _isLoading = false;

  @override
  void initState() {
    super.initState();


    if(isEditing){

      setState(() {
        _isLoading = true;
      });

      notesService.getNote(widget.noteID)
          .then((response) {

        setState(() {
          _isLoading = false;
        });

        if(response.error){
          errorMessage = response.errorMessage ?? 'An error occurred';
        }
        note = response.data;
        _titleController.text = note.noteTitle;
        _contentController.text = note.noteContent;
      });

    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editing note':'Create note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _isLoading ? Center(child:CircularProgressIndicator()) : ListView(
          children: <Widget>[
            SizedBox(height: 30.0,),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                //Note title
                hintText: 'Name',
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 15.0,),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                //Note content
                  hintText: 'Contact details',
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 10.0,),
            RaisedButton(
              child: Text(
                'Submit',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              onPressed: () async {

                if(isEditing){
                  //update note

                  setState(() {
                    _isLoading = true;
                  });

                  final note = NoteInsert(noteTitle: _titleController.text, noteContent: _contentController.text);
                  final result = await notesService.updateNote(widget.noteID, note);

                  setState(() {
                    _isLoading = false;
                  });

                  final title = 'Done';
                  final text = result.error ? (result.errorMessage ?? 'An error occurred') : 'Your note was Updated Successfully';

                  showDialog(
                      context: context,
                      builder: (_)=> AlertDialog(
                        title: Text(title),
                        content: Text(text),
                        actions: <Widget>[
                          FlatButton(onPressed: (){Navigator.of(context).pop();}, child: Text('Ok'))
                        ],
                      )
                  ).then((data) {
                    if (result.data){
                      Navigator.of(context).pop();
                    }

                  });

                }else{

                  setState(() {
                    _isLoading = true;
                  });

                  final note = NoteInsert(noteTitle: _titleController.text, noteContent: _contentController.text);
                  final result = await notesService.createNote(note);

                  setState(() {
                    _isLoading = false;
                  });

                  final title = 'Done';
                  final text = result.error ? (result.errorMessage ?? 'An error occurred') : 'Your note was created';

                  showDialog(
                      context: context,
                      builder: (_)=> AlertDialog(
                        title: Text(title),
                        content: Text(text),
                        actions: <Widget>[
                          FlatButton(onPressed: (){Navigator.of(context).pop();}, child: Text('Ok'))
                        ],
                      )
                  ).then((data) {
                    if (result.data){
                      Navigator.of(context).pop();
                    }

                  });

                }

                },
              color: Colors.blueAccent,
            ),
          ],
        ),
      ),
    );
  }
}
