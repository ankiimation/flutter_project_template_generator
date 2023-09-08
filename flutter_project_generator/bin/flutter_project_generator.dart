import 'dart:convert';
import 'dart:io';

import 'package:flutter_project_generator/flutter_project_generator.dart';

Future<void> main(List<String> args) async {
  try {
    print('=================================');
    print('| flutter_project_generator START |');
    print('=================================');
    final parsedArgs = _getArgs(args);
    print('🌐 Args:');
    print(parsedArgs.entries.map((e) => '${e.key}: ${e.value}').join('\n'));

    // create generator
    final projectName = parsedArgs['name'];
    final jsonContent = await _readJsonContent(parsedArgs);

    final generator = FlutterProjectGenerator.jsonString(
      json: jsonContent,
      projectName: projectName,
    );
    await generator.generate();
  } catch (e) {
    print('❌ flutter_project_generator error: $e');
  }

  print('=================================');
  print('| flutter_project_generator END   |');
  print('=================================');
}

Future<String> _readJsonContent(Map<String, String> parsedArgs) async {
  final url = parsedArgs['url'];
  if (url != null &&
      url.startsWith('http') == true &&
      Uri.tryParse(url.toString()) != null) {
    final uri = Uri.parse(url);
    final client = HttpClient();

    try {
      final request = await client.getUrl(uri);
      final response = await request.close();

      if (response.statusCode == HttpStatus.ok) {
        final responseBody = await response.transform(utf8.decoder).join();
        return responseBody;
      }
    } catch (e) {
      ///
    } finally {
      client.close();
    }
  }

  final path = parsedArgs['path'] ?? 'flutter_project_generator.json';
  try {
    return File(path).readAsStringSync();
  } catch (e) {
    ///
  }

  throw "Can't get config json content 🔴";
}

Map<String, String> _getArgs(List<String> args) {
  final result = <String, String>{};
  for (final arg in args) {
    if (arg.startsWith('--')) {
      final pair = arg.replaceAll('--', '').split('=');
      if (pair.length == 2) {
        result[pair[0]] = pair[1].toString();
      }
    } else {
      result['name'] = arg;
    }
  }
  return result;
}
