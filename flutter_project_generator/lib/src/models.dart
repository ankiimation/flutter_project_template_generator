import 'dart:convert';

class ProjectConfigs {
  final String? name;
  final String? description;
  final List<String> dependencies;
  final List<String> dev_dependencies;
  final List<String> files;
  final String? org;
  ProjectConfigs({
    required this.name,
    required this.description,
    required this.dependencies,
    required this.dev_dependencies,
    required this.files,
    required this.org,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'dependencies': dependencies,
      'dev_dependencies': dev_dependencies,
      'files': files,
      'org': org,
    };
  }

  factory ProjectConfigs.fromMap(Map<String, dynamic> map) {
    return ProjectConfigs(
      name: map['name'],
      description: map['description'],
      dependencies: List<String>.from(map['dependencies']),
      dev_dependencies: List<String>.from(map['dev_dependencies']),
      files: List<String>.from(map['files']),
      org: map['org'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ProjectConfigs.fromJson(String source) =>
      ProjectConfigs.fromMap(json.decode(source));

  @override
  String toString() {
    return toMap().entries.map((e) => '${e.key}: ${e.value}').join('\n- ');
  }
}
