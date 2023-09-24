class Subject {
  int? id;
  String? subjectId;
  String? subjectName;
  String? detail;
  int? credit;

  Subject({
    this.id,
    this.subjectId,
    this.subjectName,
    this.detail,
    this.credit,
  });

  Map<String, dynamic> formSubjectToJson() {
    return <String, dynamic>{
      'id': id,
      'subjectId': subjectId,
      'subjectName': subjectName,
      'detail': detail,
      'credit': credit,
    };
  }

  factory Subject.formJsonToSubject(Map<String, dynamic> json) {
    return Subject(
      id: json["id"],
      subjectId: json["subjectId"],
      subjectName: json["subjectName"],
      detail: json["detail"],
      credit: json["credit"],
    );
  }
}
