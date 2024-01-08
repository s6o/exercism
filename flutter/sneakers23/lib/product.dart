import 'package:dart_mappable/dart_mappable.dart';
import 'package:sneakers23/product_item.dart';

part 'product.mapper.dart';

@MappableClass()
class Product with ProductMappable {
  String brand;
  String color;
  int id;
  DateTime insertedAt;
  List<ProductItem> items;
  String mainImageUrl;
  String name;
  int order;
  int priceUsd;
  bool released;
  String sku;
  DateTime updatedAt;

  Product(
    this.brand,
    this.color,
    this.id,
    this.insertedAt,
    this.items,
    this.mainImageUrl,
    this.name,
    this.order,
    this.priceUsd,
    this.released,
    this.sku,
    this.updatedAt,
  );

  static const fromMap = ProductMapper.fromMap;
  static const fromJson = ProductMapper.fromJson;

  static List<Product> fromJsonArray(String json) {
    MapperContainer.globals.use(ProductMapper.ensureInitialized());
    final ps = MapperContainer.globals.fromJson<List<Product>>(json);
    return ps;
  }

  String get assetPath => 'assets$mainImageUrl';
}
