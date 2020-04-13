import 'package:flutter/material.dart';

bool isNumeric(String value) {
  if (value.isEmpty) return false;

  final n = num.tryParse(value);

  return n != null;
}

void showAlert(BuildContext context, String title, String message){
  showDialog(
    context: context,
    
  );  
}
