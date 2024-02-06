import 'package:todos_data_source/todos_data_source.dart';

/// An interface for a todos data source.
/// A todos data source supports basic C.R.U.D operations.
/// * C - Create
/// * R - Read
/// * U - Update
/// * D - Delete
abstract class TodosDataSource {
  /// Store a newly created [Todo].
  Future<Todo> create(Todo todo);

  /// Return all todos.
  Future<List<Todo>> readAll();

  /// Return a [Todo] with the provided [id] if one exists.
  Future<Todo?> read(String id);

  /// Update stored [Todo] with a new instance and return the new instance.
  Future<Todo> update(Todo todo);

  /// Delete the [Todo] with the provided [id] if one exists.
  Future<void> delete(String id);
}
