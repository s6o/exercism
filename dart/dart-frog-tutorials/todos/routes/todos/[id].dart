import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:todos_data_source/todos_data_source.dart';

FutureOr<Response> onRequest(RequestContext context, String id) async {
  final dataSource = context.read<TodosDataSource>();
  final todo = await dataSource.read(id);

  if (todo == null) {
    return Response(statusCode: HttpStatus.notFound, body: 'Not found');
  }

  switch (context.request.method) {
    case HttpMethod.get:
      return _get(context, todo);
    case HttpMethod.put:
      return _put(context, todo);
    case HttpMethod.delete:
      return _delete(context, todo);
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.post:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _get(RequestContext context, Todo todo) async {
  return Response.json(body: todo.toMap());
}

Future<Response> _put(RequestContext context, Todo todo) async {
  final dataSource = context.read<TodosDataSource>();
  final updatedTodo = Todo.update(
    todo: todo,
    json: await context.request.body(),
  );
  final newTodo =
      updatedTodo != null ? await dataSource.update(updatedTodo) : todo;
  return Response.json(body: newTodo.toMap());
}

Future<Response> _delete(RequestContext context, Todo todo) async {
  final dataSource = context.read<TodosDataSource>();
  await dataSource.delete(todo.id);
  return Response(statusCode: HttpStatus.noContent);
}
