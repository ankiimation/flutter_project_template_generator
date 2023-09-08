flutter_project_generator
## Features

Easily generate Flutter project from configs json file

## Installation

### Pub Global (Recommended):
```
$ dart pub global activate flutter_project_generator
```
### Pubspec.yaml:
```
dev_dependencies:
  flutter_project_generator:
```


## Usage

sample_configs.json
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

run generator:
```
dart pub global run flutter_project_generator --path=path/to/config.json
```
