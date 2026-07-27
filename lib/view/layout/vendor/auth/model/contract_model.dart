class ContractModel {
  int? id;
  String? template;

  ContractModel({this.id, this.template});

  ContractModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    template = json['template'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['template'] = template;
    return data;
  }
}
