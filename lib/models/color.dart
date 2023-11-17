class ColorModel {
  late int id;
  late String value;
  late String name;

  ColorModel({
    required this.id,
    required this.value,
    required this.name,
  });

  // from json factory
  factory ColorModel.fromJson(Map<String, dynamic> json) {
    return ColorModel(
      id: json['id'],
      value: json['value'],
      name: json['name'],
    );
  }

  // to json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'value': value,
      'name': name,
    };
  }
}
