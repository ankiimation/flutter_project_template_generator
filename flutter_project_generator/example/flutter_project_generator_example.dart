import 'dart:io';

import 'package:flutter_project_generator/flutter_project_generator.dart';

Future<void> main() async {
  final json = await File('template.json').readAsString();
  final generator = FlutterProjectGenerator.jsonString(json: json);
  generator.generate();
}
