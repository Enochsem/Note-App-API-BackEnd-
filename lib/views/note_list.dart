import 'package:flutter/material.dart';
import 'package:note_api_todo/models/api_response.dart';
import 'package:note_api_todo/models/note_for_listing.dart';
import 'package:note_api_todo/services/note_service.dart';
import 'package:note_api_todo/views/note_delete.dart';
import 'package:note_api_todo/views/note_modify.dart';
import 'package:get_it/get_it.dart';

class NoteList extends StatefulWidget {

  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {

  NotesService get service => GetIt.instance<NotesService>();

  APIResponse<List<NoteForListing>>_apiResponse;

  String formatDateTime(DateTime dateTime){
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  bool _isLoading = false;

  //test counter
  int count;

  @override
  void initState() {
    // TODO: implement initState
    _fetchNotes();
    super.initState();
  }

  _fetchNotes() async {
    setState(() {
      _isLoading = true;
    });
    _apiResponse = await service.getNotesList();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TASC'),
        centerTitle: true,
      ),
      body: Builder(
          builder: (_){
            if (_isLoading){
              return Center(child: CircularProgressIndicator(),);
            }

            if (_apiResponse.error){
              return Center(child: Text(_apiResponse.errorMessage),);
            }

            return ListView.separated(
              separatorBuilder: (_, __)=>Divider(height: 1,),
              itemBuilder: (_, index){
                return Dismissible(
                  key: ValueKey(_apiResponse.data[index].noteID),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (direction){

                  },
                  confirmDismiss: (direction) async{
                    final result = await showDialog(
                        context: context,
                        builder: (_)=>NoteDelete()
                    );

                    if (result){
                      final deleteResult = await service.deleteNote(_apiResponse.data[index].noteID);
                      var message;
                      if(deleteResult != null && deleteResult.data == true){
                        message = 'the note was deleted successfully';
                      }else{
                         message = deleteResult?.errorMessage ?? 'An error occurred';
                      }
                        //Scaffold.of(context).showSnackBar(SnackBar(content: Text(message), duration: Duration(milliseconds: 1000),));
                      showDialog(
                          context: context,
                          builder: (_)=> AlertDialog(
                            title: Text('Done'),
                            content: Text(message),
                            actions: <Widget>[
                              FlatButton(onPressed: (){Navigator.of(context).pop();}, child: Text('Ok'))
                            ],
                          ));

                      return deleteResult?.data ?? false;

                    }

                    return result ;
                  },
                  background: Container(
                    color: Colors.redAccent,
                    padding: EdgeInsets.only(left: 16.0),
                    child: Align(alignment: Alignment.centerLeft,child: Icon(Icons.delete_forever, color: Colors.white,)),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    margin: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: ListTile(
                      onTap: (){Navigator.push(context, MaterialPageRoute(builder: (_)=>NoteModify(noteID: _apiResponse.data[index].noteID,)))
                          .then((data) {_fetchNotes();})
                      ;},
                      title: Text(
                        _apiResponse.data[index].noteTitle,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor
                        ),
                      ),
                      subtitle: Text('Last edited on ${formatDateTime(_apiResponse.data[index].lastEditDateTime ?? _apiResponse.data[index].createDateTime)}'),
                      trailing: Column(
                        children: <Widget>[
                          Expanded(child: Text('Timer: ${DateTime.now()}',style: TextStyle(fontSize: 10.0),)),
                          Expanded(
                            child: RaisedButton(
                              onPressed: (){
                                ///TODO A function that will start and stop the timer counter
                                ///& A function that will disable the button for the timer button counter

                              },
                              child: Text('Start'),
                              color: Colors.blueAccent,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
              itemCount: _apiResponse.data.length,
            );
          }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (_)=>NoteModify())
        ).then((_) {_fetchNotes();});
        },
        tooltip: 'create new task',
        child: Icon(Icons.add),
      ),
    );
  }
}
