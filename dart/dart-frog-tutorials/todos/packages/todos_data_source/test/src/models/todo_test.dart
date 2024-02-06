// ignore_for_file: prefer_const_constructors
import 'package:test/test.dart';
import 'package:todos_data_source/todos_data_source.dart';
import 'package:uuid/uuid.dart';

void main() {
  group('Todo item creation', () {
    test('a new Todo with a unique id', () {
      final todo = Todo.create(title: 'First todo');
      expect(todo, isNotNull);
      expect(todo.id.length, 36);
    });

    test('two Todo-s with the same title still have different id-s', () {
      final todoA = Todo.create(title: 'A todo');
      final todoB = Todo.create(title: 'A todo');
      expect(todoA.id != todoB.id, true);
    });

    test('the copyWith method keeps the old id if not explictly changed', () {
      final todoA = Todo.create(title: 'A todo');
      expect(todoA.description, '');
      final todoB = todoA.copyWith(description: 'Copied from TodoA');
      expect(todoA.id == todoB.id, true);
      expect(todoB.description, 'Copied from TodoA');
    });

    test('an explicit empty String `id` will throw', () {
      expect(
        () => Todo(id: '', title: 'Testing empty string id'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('an invalid UUID v4 value for `id` will throw', () {
      expect(
        () => Todo(id: 'aldkjfowekdodkls', title: 'Testing empty string id'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('an empty String for `title` will throw', () {
      expect(
        () => Todo.create(title: ''),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group('Todo item serialization', () {
    test('serialize a Todo into JSON', () {
      final id = Uuid().v4();

      final json =
          '''{"id":"$id","title":"First todo","description":"The very first item","isCompleted":false}''';

      final todo = TodoMapper.fromJson(json);
      expect(todo.toJson(), json);
    });

    test('deserialize from client JSON without an `id`', () {
      const json =
          '''{"title":"First todo","description":"The very first item","isCompleted":false}''';

      expect(() => TodoMapper.fromJson(json), returnsNormally);

      final todo = TodoMapper.fromJson(json);
      expect(Uuid.isValidUUID(fromString: todo.id), true);
    });

    test('the `title` update to an empty String is not allowed', () {
      final todo = Todo.create(title: 'Testing');
      const json = '''{"title":"","description":"with the test suite"}''';
      final updated = Todo.update(todo: todo, json: json);
      expect(updated != null, true);
      expect(updated!.title, todo.title);
      expect(updated.description, 'with the test suite');
    });
  });
}
