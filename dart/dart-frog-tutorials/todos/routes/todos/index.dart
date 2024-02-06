import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:todos_data_source/todos_data_source.dart';

FutureOr<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return _get(context);
    case HttpMethod.post:
      return _post(context);
    case HttpMethod.delete:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.put:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _get(RequestContext context) async {
  final dataSource = context.read<TodosDataSource>();
  final todos = await dataSource.readAll();
  return Response.json(body: todos.map((e) => e.toMap()).toList());
}

Future<Response> _post(RequestContext context) async {
  final dataSource = context.read<TodosDataSource>();
  try {
    final todo = TodoMapper.fromJson(await context.request.body());

    return Response.json(
      statusCode: HttpStatus.created,
      body: (await dataSource.create(todo)).toMap(),
    );
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'error': e.toString()},
    );
  }
}
