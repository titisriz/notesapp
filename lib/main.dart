import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:notes_ddd/injection.dart';
import 'package:notes_ddd/presentation/core/app_widget.dart';

void main() {
  configureInjection(Environment.prod);
  runApp(const AppWidget());
}
