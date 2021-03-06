class Note{

  String noteID;
  String noteTitle;
  String noteContent;
  DateTime createDateTime;
  DateTime lastEditDateTime;

  Note({
    this.noteID,
    this.noteTitle,
    this.noteContent,
    this.createDateTime,
    this.lastEditDateTime
  });



  factory Note.fromJson(Map<String,dynamic> item){
    return Note(
      noteID: item['noteID'],
      noteTitle: item['noteTitle'],
      noteContent: item['noteContent'],
      createDateTime: DateTime.parse(item['createDateTime']),
      lastEditDateTime: item['latestEditDateTime'] != null ? DateTime.parse(item['latestEditDateTime']): null,
    );
  }


}