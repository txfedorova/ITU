

class ContentModel {
  String content;

  ContentModel({this.content = ''});

  factory ContentModel.fromJson(Map<String, dynamic> json) {
    return ContentModel(content: json['content']);
  }

  Map<String, dynamic> toJson() {
    return {'content': content};
  }
}