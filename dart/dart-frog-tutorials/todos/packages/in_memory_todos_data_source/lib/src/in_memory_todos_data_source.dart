import 'package:todos_data_source/todos_data_source.dart';

/// An in-memory implementation of the [TodosDataSource] interface.
class InMemoryTodosDataSource implements TodosDataSource {
  /// Map of [Todo.id] -> [Todo]
  final _cache = <String, Todo>{};

  @override
  Future<Todo> create(Todo todo) async {
    _cache[todo.id] = todo;
    return todo;
  }

  @override
  Future<List<Todo>> readAll() async => _cache.values.toList();

  @override
  Future<Todo?> read(String id) async => _cache[id];

  @override
  Future<Todo> update(Todo todo) async {
    return _cache.update(todo.id, (value) => todo);
  }

  @override
  Future<void> delete(String id) async => _cache.remove(id);
}
