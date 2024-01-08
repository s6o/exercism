// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'product.dart';

class ProductMapper extends ClassMapperBase<Product> {
  ProductMapper._();

  static ProductMapper? _instance;
  static ProductMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ProductMapper._());
      ProductItemMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'Product';

  static String _$brand(Product v) => v.brand;
  static const Field<Product, String> _f$brand = Field('brand', _$brand);
  static String _$color(Product v) => v.color;
  static const Field<Product, String> _f$color = Field('color', _$color);
  static int _$id(Product v) => v.id;
  static const Field<Product, int> _f$id = Field('id', _$id);
  static DateTime _$insertedAt(Product v) => v.insertedAt;
  static const Field<Product, DateTime> _f$insertedAt =
      Field('insertedAt', _$insertedAt, key: 'inserted_at');
  static List<ProductItem> _$items(Product v) => v.items;
  static const Field<Product, List<ProductItem>> _f$items =
      Field('items', _$items);
  static String _$mainImageUrl(Product v) => v.mainImageUrl;
  static const Field<Product, String> _f$mainImageUrl =
      Field('mainImageUrl', _$mainImageUrl, key: 'main_image_url');
  static String _$name(Product v) => v.name;
  static const Field<Product, String> _f$name = Field('name', _$name);
  static int _$order(Product v) => v.order;
  static const Field<Product, int> _f$order = Field('order', _$order);
  static int _$priceUsd(Product v) => v.priceUsd;
  static const Field<Product, int> _f$priceUsd =
      Field('priceUsd', _$priceUsd, key: 'price_usd');
  static bool _$released(Product v) => v.released;
  static const Field<Product, bool> _f$released = Field('released', _$released);
  static String _$sku(Product v) => v.sku;
  static const Field<Product, String> _f$sku = Field('sku', _$sku);
  static DateTime _$updatedAt(Product v) => v.updatedAt;
  static const Field<Product, DateTime> _f$updatedAt =
      Field('updatedAt', _$updatedAt, key: 'updated_at');

  @override
  final Map<Symbol, Field<Product, dynamic>> fields = const {
    #brand: _f$brand,
    #color: _f$color,
    #id: _f$id,
    #insertedAt: _f$insertedAt,
    #items: _f$items,
    #mainImageUrl: _f$mainImageUrl,
    #name: _f$name,
    #order: _f$order,
    #priceUsd: _f$priceUsd,
    #released: _f$released,
    #sku: _f$sku,
    #updatedAt: _f$updatedAt,
  };
  @override
  final bool ignoreNull = true;

  static Product _instantiate(DecodingData data) {
    return Product(
        data.dec(_f$brand),
        data.dec(_f$color),
        data.dec(_f$id),
        data.dec(_f$insertedAt),
        data.dec(_f$items),
        data.dec(_f$mainImageUrl),
        data.dec(_f$name),
        data.dec(_f$order),
        data.dec(_f$priceUsd),
        data.dec(_f$released),
        data.dec(_f$sku),
        data.dec(_f$updatedAt));
  }

  @override
  final Function instantiate = _instantiate;

  static Product fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Product>(map);
  }

  static Product fromJson(String json) {
    return ensureInitialized().decodeJson<Product>(json);
  }
}

mixin ProductMappable {
  String toJson() {
    return ProductMapper.ensureInitialized()
        .encodeJson<Product>(this as Product);
  }

  Map<String, dynamic> toMap() {
    return ProductMapper.ensureInitialized()
        .encodeMap<Product>(this as Product);
  }

  ProductCopyWith<Product, Product, Product> get copyWith =>
      _ProductCopyWithImpl(this as Product, $identity, $identity);
  @override
  String toString() {
    return ProductMapper.ensureInitialized().stringifyValue(this as Product);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            ProductMapper.ensureInitialized()
                .isValueEqual(this as Product, other));
  }

  @override
  int get hashCode {
    return ProductMapper.ensureInitialized().hashValue(this as Product);
  }
}

extension ProductValueCopy<$R, $Out> on ObjectCopyWith<$R, Product, $Out> {
  ProductCopyWith<$R, Product, $Out> get $asProduct =>
      $base.as((v, t, t2) => _ProductCopyWithImpl(v, t, t2));
}

abstract class ProductCopyWith<$R, $In extends Product, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, ProductItem,
      ProductItemCopyWith<$R, ProductItem, ProductItem>> get items;
  $R call(
      {String? brand,
      String? color,
      int? id,
      DateTime? insertedAt,
      List<ProductItem>? items,
      String? mainImageUrl,
      String? name,
      int? order,
      int? priceUsd,
      bool? released,
      String? sku,
      DateTime? updatedAt});
  ProductCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ProductCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, Product, $Out>
    implements ProductCopyWith<$R, Product, $Out> {
  _ProductCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Product> $mapper =
      ProductMapper.ensureInitialized();
  @override
  ListCopyWith<$R, ProductItem,
          ProductItemCopyWith<$R, ProductItem, ProductItem>>
      get items => ListCopyWith(
          $value.items, (v, t) => v.copyWith.$chain(t), (v) => call(items: v));
  @override
  $R call(
          {String? brand,
          String? color,
          int? id,
          DateTime? insertedAt,
          List<ProductItem>? items,
          String? mainImageUrl,
          String? name,
          int? order,
          int? priceUsd,
          bool? released,
          String? sku,
          DateTime? updatedAt}) =>
      $apply(FieldCopyWithData({
        if (brand != null) #brand: brand,
        if (color != null) #color: color,
        if (id != null) #id: id,
        if (insertedAt != null) #insertedAt: insertedAt,
        if (items != null) #items: items,
        if (mainImageUrl != null) #mainImageUrl: mainImageUrl,
        if (name != null) #name: name,
        if (order != null) #order: order,
        if (priceUsd != null) #priceUsd: priceUsd,
        if (released != null) #released: released,
        if (sku != null) #sku: sku,
        if (updatedAt != null) #updatedAt: updatedAt
      }));
  @override
  Product $make(CopyWithData data) => Product(
      data.get(#brand, or: $value.brand),
      data.get(#color, or: $value.color),
      data.get(#id, or: $value.id),
      data.get(#insertedAt, or: $value.insertedAt),
      data.get(#items, or: $value.items),
      data.get(#mainImageUrl, or: $value.mainImageUrl),
      data.get(#name, or: $value.name),
      data.get(#order, or: $value.order),
      data.get(#priceUsd, or: $value.priceUsd),
      data.get(#released, or: $value.released),
      data.get(#sku, or: $value.sku),
      data.get(#updatedAt, or: $value.updatedAt));

  @override
  ProductCopyWith<$R2, Product, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _ProductCopyWithImpl($value, $cast, t);
}
