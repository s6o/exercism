# Todos

This is an implementation of the [Dart Frog's Todos tutorial](https://dartfrog.vgv.dev/docs/tutorials/todos)
with design fixes and alternative JSON serialization package: [dart_mappable](https://pub.dev/packages/dart_mappable)

## Issues & The Old Todo Model

Issues:

* asserts are development/debug mode only
* the `id` does not have to be nullable and is not storage dependent
* a `Todo` with an empty `String` for `title` can be created, but this makes no sense
* propagating invalid input into the system is bad (garbage in -> garbage out)
* API layer error messages

Removed comments for brevity.

```dart
@immutable
@JsonSerializable()
class Todo extends Equatable {
  Todo({
    this.id,
    required this.title,
    this.description = '',
    this.isCompleted = false,
  }) : assert(id == null || id.isNotEmpty, 'id cannot be empty');

  final String? id;
  final String title;
  final String description;
  final bool isCompleted;

  Todo copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  static Todo fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);

  Map<String, dynamic> toJson() => _$TodoToJson(this);

  @override
  List<Object?> get props => [id, title, description, isCompleted];
}
```

## The New Todo Model

With `id` as a required field and with validations.

```dart
// ...
@MappableClass(hook: _IdHook())
class Todo extends Equatable with TodoMappable {
  /// The default constructor (for deserialization and serialization).
  /// Calling this by setting `id` to an empty [String] or an invalid UUID v4
  /// value will throw an [ArgumentError] for `id`.
  /// Calling this by setting `title` to an emtpy [String] will throw an
  /// [ArgumentError] for `title`.
  Todo({
    required this.id,
    required this.title,
    this.description = '',
    this.isCompleted = false,
  }) {
    if (id.isEmpty || Uuid.isValidUUID(fromString: id) == false) {
      throw ArgumentError(
        'The `id` must a non-empty String resolving into a valid UUID v4',
        'id',
      );
    }
    if (title.isEmpty) {
      throw ArgumentError('The `title` must be non-empty String', 'title');
    }
  }

  /// Constuct a [Todo] item with auto-generated unique UUID v4 for the `id`.
  factory Todo.create({
    required String title,
    String description = '',
    bool isCompleted = false,
  }) {
    return Todo(
      id: const Uuid().v4(),
      title: title,
      description: description,
      isCompleted: isCompleted,
    );
  }

  /// Create an updated [Todo] instance from a base [Todo] and JSON input.
  /// Once the JSON input is validated the valid [Todo] member fields are used
  /// to create a new [Todo] instance by combining the input [Todo] and field
  /// updates from the JSON.
  /// Validation:
  /// - `id` from `json` is ignored
  /// - `title` from `json` is only used when it is not an empty [String]
  /// - `description` is allowd to be an empty [String] in `json`
  static Todo? update({required Todo todo, required String json}) {
    try {
      final mapped = jsonDecode(json) as Map<String, dynamic>;
      final newTodo = Todo(
        id: todo.id,
        title: _checkTitle(mapped, todo.title),
        description: _checkDescription(mapped, todo.description),
        isCompleted: _checkCompleted(mapped, todo.isCompleted),
      );
      return newTodo;
    } catch (e) {
      return null;
    }
  }

  /// Unique [Todo] `id`, a UUID v4.
  final String id;

  /// Title of the [Todo] item.
  final String title;

  /// Description of the [Todo] item, defaults to an empty [String].
  final String description;

  /// Wether the [Todo] is completed, defaults to `false`.
  final bool isCompleted;

  @override
  List<Object?> get props => [id, title, description, isCompleted];
}
```

## Refs

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]
[![Powered by Dart Frog](https://img.shields.io/endpoint?url=https://tinyurl.com/dartfrog-badge)](https://dartfrog.vgv.dev)

An example application built with dart_frog

[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
