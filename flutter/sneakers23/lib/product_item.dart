import 'package:dart_mappable/dart_mappable.dart';

part 'product_item.mapper.dart';

enum ProductAvailability { out, low, medium, high }

@MappableClass()
class ProductItem with ProductItemMappable {
  int availableCount;
  int id;
  DateTime insertedAt;
  int productId;
  String size;
  String sku;
  DateTime updatedAt;

  ProductItem(
    this.availableCount,
    this.id,
    this.insertedAt,
    this.productId,
    this.size,
    this.sku,
    this.updatedAt,
  );

  static const fromMap = ProductItemMapper.fromMap;
  static const fromJson = ProductItemMapper.fromJson;

  static List<ProductItem> fromJsonArray(String json) {
    MapperContainer.globals.use(ProductItemMapper.ensureInitialized());
    final ps = MapperContainer.globals.fromJson<List<ProductItem>>(json);
    return ps;
  }

  ProductAvailability availability(int count) {
    if (count <= 0) return ProductAvailability.out;
    if (count < 150) return ProductAvailability.low;
    if (count < 500) return ProductAvailability.medium;
    return ProductAvailability.high;
  }
}
