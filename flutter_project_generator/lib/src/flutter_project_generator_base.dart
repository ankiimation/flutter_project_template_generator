import 'dart:convert';
import 'dart:io';

import 'package:flutter_project_generator/src/models.dart';
import 'package:yaml/yaml.dart';
import 'package:yaml_edit/yaml_edit.dart';

class FlutterProjectGenerator {
  final ProjectConfigs configs;
  final String? projectName;
  FlutterProjectGenerator({
    required this.configs,
    this.projectName,
  });

  factory FlutterProjectGenerator.jsonString({
    required String json,
    String? projectName,
  }) {
    return FlutterProjectGenerator(
      configs: ProjectConfigs.fromJson(json),
      projectName: projectName,
    );
  }

  String get generatedProjectName =>
      projectName ?? configs.name ?? (throw 'Please config a project name 👍');
  String get currentPath => Directory.current.path;
  String get generatedProjectPath =>
      Directory('$currentPath/$generatedProjectName').path;

  Future<void> generate() async {
    try {
      print('==================================');
      print('🚀 FlutterProjectGenerator STARTED...');
      print('==================================');
      print('🟢 FlutterProjectGenerator Configs:');
      print('- $configs');
      print('==================================');
      print('');
      print('👉 Version');
      print('Flutter: ${await _getFlutterVersion()}');
      print('');
      print('👉 Create project');
      await _createProject();
      print('');
      print('👉 Config pubspec.yaml');
      await _configPubspecYaml();
      print('');
      print('👉 Add Dependencies');
      await _addDependencies();
      print('');
      print('👉 Create files/folders');
      await _createFilesAndFolders();
      print('==================================');
      print('✅ Generated Project Path: $generatedProjectPath');
      print('✅ FlutterProjectGenerator FINISHED');
      print('==================================');
    } catch (e) {
      print('==================================');
      print('❌ FlutterProjectGenerator Error: $e');
      print('==================================');
    }
  }

  Future<void> _createFilesAndFolders() async {
    final files = configs.files;
    for (final path in files) {
      final absolutePath =
          '$currentPath/$generatedProjectName/$path'.replaceAll('//', '/');
      if (absolutePath.endsWith('/')) {
        //create folder
        final dir = await Directory(absolutePath).create();
        print('Created ${dir.path}');
      } else {
        //create file
        final file = await File(absolutePath).create();
        print('Created ${file.path}');
      }
    }
  }

  Future<void> _addDependencies() async {
    final dependencies = configs.dependencies;
    final addDependencies = await _runFlutter(
      'pub add ${dependencies.join(' ')}',
      workingDirectory: generatedProjectPath,
    );
    await stdout.addStream(addDependencies.stdout);
    await stderr.addStream(addDependencies.stderr);

    final devDependencies = configs.dev_dependencies;
    final addDevDependencies = await _runFlutter(
      'pub add ${devDependencies.join(' ')} --dev',
      workingDirectory: generatedProjectPath,
    );
    await stdout.addStream(addDevDependencies.stdout);
    await stderr.addStream(addDevDependencies.stderr);
  }

  Future<void> _configPubspecYaml() async {
    final yamlFile = File('$generatedProjectName/pubspec.yaml');
    final yamlContent = yamlFile.readAsStringSync();
    final yamlData = Map<String, dynamic>.from(await loadYaml(yamlContent));
    yamlData['name'] = generatedProjectName;
    yamlData['description'] = configs.description ?? yamlData['description'];

    // Convert jsonValue to YAML
    final yamlEditor = YamlEditor('');
    yamlEditor.update([], yamlData);
    final flutterVersion = await _getFlutterVersion();
    final flutterVersionYamlContent =
        flutterVersion == null ? '' : flutterVersion.split('\n').join('\n# ');
    final fileContent = '''
# generated with flutter_project_generator 🤖
# $flutterVersionYamlContent
${yamlEditor.toString()}
''';
    yamlFile.writeAsStringSync(fileContent);
  }

  Future<void> _createProject() async {
    final org = configs.org;

    final args = [
      if (org != null) '--org=$org',
    ].join(' ');

    final fullCommand = "flutter create $args $generatedProjectName"
        .replaceAll('  ', ' ')
        .trim();
    print(fullCommand);
    final process = await Process.start(
      'flutter',
      fullCommand.split(' ').sublist(1),
      workingDirectory: currentPath,
      runInShell: true,
    );
    await stdout.addStream(process.stdout);
    await stderr.addStream(process.stderr);
  }

  Future<String?> _getFlutterVersion() async {
    final processResult = await _runFlutter('--version');
    if (await processResult.exitCode == 0) {
      return utf8.decodeStream(processResult.stdout);
    }
    return null;
  }

  Future<String?> _getDartVersion() async {
    final processResult = await _runDart('--version');
    if (await processResult.exitCode == 0) {
      return utf8.decodeStream(processResult.stdout);
    }
    return null;
  }

  Future<Process> _runFlutter(String command,
      {String? workingDirectory}) async {
    final process = await Process.start(
      'flutter',
      command.split(' '),
      workingDirectory: workingDirectory ?? currentPath,
      runInShell: true,
    );
    return process;
  }

  Future<Process> _runDart(String command, {String? workingDirectory}) async {
    final process = await Process.start(
      'dart',
      command.split(' '),
      workingDirectory: workingDirectory ?? currentPath,
      runInShell: true,
    );
    return process;
  }
}
