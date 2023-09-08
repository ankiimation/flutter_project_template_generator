flutter_project_generator

A Dart package for generating Flutter projects based on a configuration file.

## Installation

You can install the flutter_project_generator package either globally using Dart's pub global or as a dependency in your Dart project's pubspec.yaml file.

### Global Installation

To install globally, use the following command:

```
dart pub global activate flutter_project_generator
```

### Project Dependency

To include flutter_project_generator as a dependency in your Dart project, add it to your pubspec.yaml file:

```yaml
dev_dependencies:
  flutter_project_generator: # Use the latest version
```

## Configuration

To generate a Flutter project, you need to create a configuration file in JSON format. Here's an example of a configuration file:

```json
{
  "name": "my_generated_project",
  "description": "my_generated_project description",
  "dependencies": [
    "rxdart",
    "flutter_bloc",
    "freezed_annotation",
    "json_annotation"
  ],
  "dev_dependencies": [
    "build_runner",
    "freezed",
    "json_serializable",
    "flutter_gen_runner"
  ],
  "files": [
    "lib/",
    "lib/features/",
    "lib/core/",
    "lib/assets/"
  ]
}
```

- ```name```: The name of your generated project.
- ```description```: A brief description of your generated project.
- ```dependencies```: A list of dependencies for your Flutter project.
- ```dev_dependencies```: A list of development dependencies for your Flutter project.
- ```files```: A list of directories and files to include in the generated project.

## Usage

### Config file from URL:
```
dart pub global run flutter_project_generator --url=https://url/to/your/config.json
```
### Config file from PATH:
```
dart pub global run flutter_project_generator --path=path/to/your/config.json
```

### Custom project name
Pass you custom project name at the end of the command, example:
```
dart pub global run flutter_project_generator --path=path/to/your/config.json my_custom_project_name
```

### Project Dependency Run 
Just replace ```dart pub global run``` to ```dart pub run```

## License

This package is open-source and available under the MIT License.
