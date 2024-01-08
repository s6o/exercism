import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';

import 'package:sneakers23/product.dart';
import 'package:sneakers23/product_item.dart';

void main() {
  group('Product API fetch', () {
    final Dio dio = Dio(
      BaseOptions(
        baseUrl: 'http://localhost:4000/api/v1',
        responseType: ResponseType.plain,
      ),
    );

    setUp(() {});

    test('All products', () async {
      final response = await dio.get('/products');
      expect(response.data, isInstanceOf<String>());

      List<Product> ps = Product.fromJsonArray(response.data);
      expect(ps, isInstanceOf<List<Product>>());
    });
  }, /* To enable this make sure the local backend is running */ skip: false);

  group('Product serialization/deserialization', () {
    const productJson =
        '{"brand":"Snks 23","color":"yellow/blue","id":1,"inserted_at":"2023-12-17T17:37:34.000","items":[{"available_count":0,"id":1,"inserted_at":"2023-12-17T17:37:34.000","product_id":1,"size":"6","sku":"SHU6001","updated_at":"2023-12-17T17:37:34.000"}],"main_image_url":"/images/hopman.png","name":"Hop Man 3","order":0,"price_usd":120,"released":true,"sku":"SHU6000","updated_at":"2023-12-17T17:45:33.000"}';

    final testProduct = Product(
      'Snks 23',
      'yellow/blue',
      1,
      DateTime.parse('2023-12-17T17:37:34'),
      [
        ProductItem(
          0,
          1,
          DateTime.parse('2023-12-17T17:37:34'),
          1,
          "6",
          "SHU6001",
          DateTime.parse('2023-12-17T17:37:34'),
        )
      ],
      '/images/hopman.png',
      'Hop Man 3',
      0,
      120,
      true,
      'SHU6000',
      DateTime.parse('2023-12-17T17:45:33'),
    );

    DateTimeMapper.encodingMode = DateTimeEncoding.iso8601String;

    setUp(() {});

    test('- to JSON', () {
      final json = testProduct.toJson();
      expect(json, equals(productJson));
    });

    test('- from JSON', () {
      final p = Product.fromJson(productJson);
      expect(p.id, equals(1));
      expect(p.brand, equals('Snks 23'));
      expect(p.color, equals('yellow/blue'));
      expect(p.insertedAt, isInstanceOf<DateTime>());
      expect(p.insertedAt.toString(), equals("2023-12-17 17:37:34.000"));
    });
  });
}
