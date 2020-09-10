import 'dart:convert';

import 'package:note_api_todo/models/api_response.dart';
import 'package:note_api_todo/models/note.dart';
import 'package:note_api_todo/models/note_for_listing.dart';
import 'package:http/http.dart' as http;
import 'package:note_api_todo/models/note_insert.dart';


class NotesService{

//  List<NoteForListing> getNotesList(){
//    return [
//      NoteForListing(
//        noteID: '1',
//        noteTitle: 'Note 1',
//        createDateTime: DateTime.now(),
//        lastEditDateTime: DateTime.now(),
//      ),
//      NoteForListing(
//        noteID: '2',
//        noteTitle: 'Note 2',
//        createDateTime: DateTime.now(),
//        lastEditDateTime: DateTime.now(),
//      ),
//    ];
//  }

//  Future<APIResponse<List<NoteForListing>>> getNotesList(){
//    return http.get(API + '/notes', headers:headers)
//        .then((data){
//      if(data.statusCode == 200){
//        final jsonData = json.decode(data.body);
//        final notes = <NoteForListing>[];
//        for(var item in jsonData){
//          final note = NoteForListing(
//            noteID: item['noteID'],
//            noteTitle: item['noteTitle'],
//            createDateTime: DateTime.parse(item['createDateTime']),
//            lastEditDateTime: item['latestEditDateTime'] != null ? DateTime.parse(item['latestEditDateTime']): null,
//          );
//          notes.add(note);
//        }
//        return APIResponse<List<NoteForListing>>(data : notes);
//      }
//      return APIResponse<List<NoteForListing>>(error: true, errorMessage: 'An error occured');
//    })
//        .catchError((_) => APIResponse<List<NoteForListing>>(error: true, errorMessage: 'An error occured')) ;
//  }


  ///TODO
  static const API = 'http://api.notes.programmingaddict.com';
  static const headers ={
  "apiKey": "528cbebc-a6e7-4ef9-bf5f-94168830ecb1",
    'Content-Type' : 'application/json'
  };
 Future<APIResponse<List<NoteForListing>>> getNotesList(){
    return http.get(API + '/notes', headers:headers)
    .then((data){
      if(data.statusCode == 200){
        final jsonData = json.decode(data.body);
        final notes = <NoteForListing>[];
        for(var item in jsonData){
          notes.add(NoteForListing.fromJson(item));
        }
        return APIResponse<List<NoteForListing>>(data : notes);
      }
      return APIResponse<List<NoteForListing>>(error: true, errorMessage: 'An error occurred');
    })
   .catchError((_) => APIResponse<List<NoteForListing>>(error: true, errorMessage: 'An error occurred')) ;
  }



//TO GET THE NOTES BY ID
  Future<APIResponse<Note>> getNote( String noteID){
    return http.get(API + '/notes/'+noteID, headers:headers).then((data){
      if(data.statusCode == 200){
        final jsonData = json.decode(data.body);
        return APIResponse<Note>(data : Note.fromJson(jsonData));
      }
      return APIResponse<Note>(error: true, errorMessage: 'An error occurred');
    })
        .catchError((_) => APIResponse<Note>(error: true, errorMessage: 'An error occurred')) ;
  }





  //create note
  Future<APIResponse<bool>> createNote(NoteInsert item ){
    return http.post(API + '/notes', headers:headers, body: json.encode(item.toJson())).then((data){
      if(data.statusCode == 201){
        return APIResponse<bool>(data : true);
      }
      return APIResponse<bool>(error: true, errorMessage: 'An error occurred');
    })
        .catchError((_) => APIResponse<bool>(error: true, errorMessage: 'An error occurred')) ;
  }





  //update note
  Future<APIResponse<bool>> updateNote(String noteID, NoteInsert item ){
    return http.put(API + '/notes/'+noteID, headers:headers, body: json.encode(item.toJson())).then((data){
      if(data.statusCode == 204){
        return APIResponse<bool>(data : true);
      }
      return APIResponse<bool>(error: true, errorMessage: 'An error occurred');
    })
        .catchError((_) => APIResponse<bool>(error: true, errorMessage: 'An error occurred')) ;
  }






  //deleting notes
  Future<APIResponse<bool>> deleteNote(String noteID){
    return http.delete(API + '/notes/'+noteID, headers:headers).then((data){
      if(data.statusCode == 204){
        return APIResponse<bool>(data : true);
      }
      return APIResponse<bool>(error: true, errorMessage: 'An error occurred');
    })
        .catchError((_) => APIResponse<bool>(error: true, errorMessage: 'An error occurred')) ;
  }





}





