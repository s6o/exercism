// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'product_item.dart';

class ProductItemMapper extends ClassMapperBase<ProductItem> {
  ProductItemMapper._();

  static ProductItemMapper? _instance;
  static ProductItemMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ProductItemMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ProductItem';

  static int _$availableCount(ProductItem v) => v.availableCount;
  static const Field<ProductItem, int> _f$availableCount =
      Field('availableCount', _$availableCount, key: 'available_count');
  static int _$id(ProductItem v) => v.id;
  static const Field<ProductItem, int> _f$id = Field('id', _$id);
  static DateTime _$insertedAt(ProductItem v) => v.insertedAt;
  static const Field<ProductItem, DateTime> _f$insertedAt =
      Field('insertedAt', _$insertedAt, key: 'inserted_at');
  static int _$productId(ProductItem v) => v.productId;
  static const Field<ProductItem, int> _f$productId =
      Field('productId', _$productId, key: 'product_id');
  static String _$size(ProductItem v) => v.size;
  static const Field<ProductItem, String> _f$size = Field('size', _$size);
  static String _$sku(ProductItem v) => v.sku;
  static const Field<ProductItem, String> _f$sku = Field('sku', _$sku);
  static DateTime _$updatedAt(ProductItem v) => v.updatedAt;
  static const Field<ProductItem, DateTime> _f$updatedAt =
      Field('updatedAt', _$updatedAt, key: 'updated_at');

  @override
  final Map<Symbol, Field<ProductItem, dynamic>> fields = const {
    #availableCount: _f$availableCount,
    #id: _f$id,
    #insertedAt: _f$insertedAt,
    #productId: _f$productId,
    #size: _f$size,
    #sku: _f$sku,
    #updatedAt: _f$updatedAt,
  };
  @override
  final bool ignoreNull = true;

  static ProductItem _instantiate(DecodingData data) {
    return ProductItem(
        data.dec(_f$availableCount),
        data.dec(_f$id),
        data.dec(_f$insertedAt),
        data.dec(_f$productId),
        data.dec(_f$size),
        data.dec(_f$sku),
        data.dec(_f$updatedAt));
  }

  @override
  final Function instantiate = _instantiate;

  static ProductItem fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ProductItem>(map);
  }

  static ProductItem fromJson(String json) {
    return ensureInitialized().decodeJson<ProductItem>(json);
  }
}

mixin ProductItemMappable {
  String toJson() {
    return ProductItemMapper.ensureInitialized()
        .encodeJson<ProductItem>(this as ProductItem);
  }

  Map<String, dynamic> toMap() {
    return ProductItemMapper.ensureInitialized()
        .encodeMap<ProductItem>(this as ProductItem);
  }

  ProductItemCopyWith<ProductItem, ProductItem, ProductItem> get copyWith =>
      _ProductItemCopyWithImpl(this as ProductItem, $identity, $identity);
  @override
  String toString() {
    return ProductItemMapper.ensureInitialized()
        .stringifyValue(this as ProductItem);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            ProductItemMapper.ensureInitialized()
                .isValueEqual(this as ProductItem, other));
  }

  @override
  int get hashCode {
    return ProductItemMapper.ensureInitialized().hashValue(this as ProductItem);
  }
}

extension ProductItemValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ProductItem, $Out> {
  ProductItemCopyWith<$R, ProductItem, $Out> get $asProductItem =>
      $base.as((v, t, t2) => _ProductItemCopyWithImpl(v, t, t2));
}

abstract class ProductItemCopyWith<$R, $In extends ProductItem, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {int? availableCount,
      int? id,
      DateTime? insertedAt,
      int? productId,
      String? size,
      String? sku,
      DateTime? updatedAt});
  ProductItemCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ProductItemCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ProductItem, $Out>
    implements ProductItemCopyWith<$R, ProductItem, $Out> {
  _ProductItemCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ProductItem> $mapper =
      ProductItemMapper.ensureInitialized();
  @override
  $R call(
          {int? availableCount,
          int? id,
          DateTime? insertedAt,
          int? productId,
          String? size,
          String? sku,
          DateTime? updatedAt}) =>
      $apply(FieldCopyWithData({
        if (availableCount != null) #availableCount: availableCount,
        if (id != null) #id: id,
        if (insertedAt != null) #insertedAt: insertedAt,
        if (productId != null) #productId: productId,
        if (size != null) #size: size,
        if (sku != null) #sku: sku,
        if (updatedAt != null) #updatedAt: updatedAt
      }));
  @override
  ProductItem $make(CopyWithData data) => ProductItem(
      data.get(#availableCount, or: $value.availableCount),
      data.get(#id, or: $value.id),
      data.get(#insertedAt, or: $value.insertedAt),
      data.get(#productId, or: $value.productId),
      data.get(#size, or: $value.size),
      data.get(#sku, or: $value.sku),
      data.get(#updatedAt, or: $value.updatedAt));

  @override
  ProductItemCopyWith<$R2, ProductItem, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _ProductItemCopyWithImpl($value, $cast, t);
}
