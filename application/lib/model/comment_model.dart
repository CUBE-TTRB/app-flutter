class CommentModel{
  CommentModel(this.userString, this.text, this.date);
  String userString;
  String text;
  String date;

  CommentModel.fromJson(dynamic json) :
    userString = "Utilisateur",
    text = json["text"]?? "",
    date = json["updatedAt"]
  ;
}