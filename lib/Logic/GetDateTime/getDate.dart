import 'package:flutter/material.dart';

DateTime? selectedDate;

Future<DateTime?> getDate(BuildContext context) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
  );

  if (picked != null) {
    selectedDate = picked;
    print(selectedDate); // ← 取得できる

    return selectedDate;
  }
}