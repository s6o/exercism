import 'dart:convert';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

part 'todo.mapper.dart';

/// When a client sends a JSON payload for a [Todo] without an `id` member, this
/// dart_mapper hook is used to auto-generate the `id` value before decoding.
class _IdHook extends MappingHook {
  const _IdHook();

  @override
  Object? beforeDecode(Object? value) {
    if (value is Map<String, dynamic> && value.containsKey('id') == false) {
      value['id'] = const Uuid().v4();
    }
    return value;
  }
}

String _checkTitle(Map<String, dynamic> m, String fallback) {
  return m.containsKey('title') && (m['title'] as String).isNotEmpty
      ? m['title'] as String
      : fallback;
}

String _checkDescription(Map<String, dynamic> m, String fallback) {
  return m.containsKey('description') ? m['description'] as String : fallback;
}

bool _checkCompleted(Map<String, dynamic> m, bool fallback) {
  return m.containsKey('isCompleted') ? m['isCompleted'] as bool : fallback;
}

/// An immutable [Todo] item.
///
/// [Todo] serialization is provided via [dart_mappable](https://pub.dev/packages/dart_mappable)
/// which alreay will generate the `copyWith` method, expicitly implemented in
/// the [official example](https://dartfrog.vgv.dev/docs/tutorials/todos#creating-the-todo-model)
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
