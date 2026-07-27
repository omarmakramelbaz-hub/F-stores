class HelpModel {
  int? id;
  String? question;
  String? answer;
  String? createdAt;

  HelpModel({this.id, this.question, this.answer, this.createdAt});

  HelpModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    answer = json['answer'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['question'] = question;
    data['answer'] = answer;
    data['created_at'] = createdAt;
    return data;
  }
}
