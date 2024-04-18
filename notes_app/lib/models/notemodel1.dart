class Note {
  final String ?id;
  final String ?userId;
  final String ?title;
  final String ?description;
  final bool ?isRecycled;
  final String ?isPassword;

  Note({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.isRecycled,
    required this.isPassword,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['_id'],
      userId: json['userId'],
      title: json['title'],
      description: json['description'],
      isRecycled: json['isRecycled'],
      isPassword: json['isPassword'],
    );
  }
}
