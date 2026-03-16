class Getsubjectdata {
  String subject_name;
  int classes, report, unit;
  int? id;

  Getsubjectdata({
    this.id,
    required this.subject_name,
    required this.classes,
    required this.report,
    required this.unit,
  });

  Map<String, Object?> toMap() {
    return {
      "id": id,
      "subject_name": subject_name,
      "class": classes,
      "report": report,
      "unit": unit,
    };
  }
}
