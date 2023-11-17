class TagModel {
  late int id;
  late String text;

  TagModel({
    required this.id,
    required this.text,
  });

  // from json factory
  factory TagModel.fromJson(Map<String, dynamic> json) {
    return TagModel(
      id: json['id'],
      text: json['text'],
    );
  }

  // to json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
    };
  }
}
