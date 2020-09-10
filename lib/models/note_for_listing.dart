

class NoteForListing{
  String noteID;
  String noteTitle;
  DateTime createDateTime;
  DateTime lastEditDateTime;

  NoteForListing({
    this.noteID,
    this.noteTitle,
    this.createDateTime,
    this.lastEditDateTime
  });


  factory NoteForListing.fromJson(Map<String,dynamic> item){
    return NoteForListing(
        noteID: item['noteID'],
        noteTitle: item['noteTitle'],
        createDateTime: DateTime.parse(item['createDateTime']),
        lastEditDateTime: item['latestEditDateTime'] != null ? DateTime.parse(item['latestEditDateTime']): null,
      );
  }


}