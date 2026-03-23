class Getsubjectdata {
  String subject_name;
  int classes, report, unit, check;
  int? id;

  Getsubjectdata({
    this.id,
    required this.subject_name,
    required this.classes,
    required this.report,
    required this.unit,
    required this.check,
  });

  Map<String, dynamic> toMap() {
    return {
      "subject_name": subject_name,
      "class": classes,
      "report": report,
      "unit": unit,
      "checks": check,
    };
  }

  factory Getsubjectdata.fromMap(Map<String, dynamic> data) {
    return Getsubjectdata(
      id: data["id"],
      subject_name: data["subject_name"],
      classes: data["class"],
      report: data["report"],
      unit: data["unit"],
      check: data["checks"],
    );
  }
}

class SubDatabaseLogic {
  int subject_id, class_index,checks;
  String text, date;
  int? id;

  SubDatabaseLogic({
    this.id,
    required this.subject_id,
    required this.class_index,
    required this.checks,
    required this.text,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      "subject_id": subject_id,
      "class_index": class_index,
      "checks":checks,
      "date":date,
      "text":text
    };
  }

  factory SubDatabaseLogic.fromMap(Map<String, dynamic> data) {
    return SubDatabaseLogic(
      id: data["id"],
      subject_id: data["subject_id"],
      class_index: data["class_index"],
      checks: data["checks"],
      date: data["date"],
      text: data["text"],
    );
  }
}
