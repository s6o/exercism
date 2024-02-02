import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../routes/[message].dart' as route;

class _MockRequestContext extends Mock implements RequestContext {}

void main() {
  group('GET /', () {
    test('responds with a 200 and given parameter: ping.', () {
      final context = _MockRequestContext();
      final response = route.onRequest(context, 'ping');
      expect(response.statusCode, equals(HttpStatus.ok));
      expect(
        response.body(),
        completion(equals('ping')),
      );
    });
    test('responds with a 200 and given parameter: pong.', () {
      final context = _MockRequestContext();
      final response = route.onRequest(context, 'pong');
      expect(response.statusCode, equals(HttpStatus.ok));
      expect(
        response.body(),
        completion(equals('pong')),
      );
    });
  });
}
