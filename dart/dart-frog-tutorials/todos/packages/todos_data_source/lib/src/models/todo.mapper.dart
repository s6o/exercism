// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'todo.dart';

class TodoMapper extends ClassMapperBase<Todo> {
  TodoMapper._();

  static TodoMapper? _instance;
  static TodoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TodoMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'Todo';

  static String _$id(Todo v) => v.id;
  static const Field<Todo, String> _f$id = Field('id', _$id);
  static String _$title(Todo v) => v.title;
  static const Field<Todo, String> _f$title = Field('title', _$title);
  static String _$description(Todo v) => v.description;
  static const Field<Todo, String> _f$description =
      Field('description', _$description, opt: true, def: '');
  static bool _$isCompleted(Todo v) => v.isCompleted;
  static const Field<Todo, bool> _f$isCompleted =
      Field('isCompleted', _$isCompleted, opt: true, def: false);

  @override
  final MappableFields<Todo> fields = const {
    #id: _f$id,
    #title: _f$title,
    #description: _f$description,
    #isCompleted: _f$isCompleted,
  };

  @override
  final MappingHook hook = const _IdHook();
  static Todo _instantiate(DecodingData data) {
    return Todo(
        id: data.dec(_f$id),
        title: data.dec(_f$title),
        description: data.dec(_f$description),
        isCompleted: data.dec(_f$isCompleted));
  }

  @override
  final Function instantiate = _instantiate;

  static Todo fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Todo>(map);
  }

  static Todo fromJson(String json) {
    return ensureInitialized().decodeJson<Todo>(json);
  }
}

mixin TodoMappable {
  String toJson() {
    return TodoMapper.ensureInitialized().encodeJson<Todo>(this as Todo);
  }

  Map<String, dynamic> toMap() {
    return TodoMapper.ensureInitialized().encodeMap<Todo>(this as Todo);
  }

  TodoCopyWith<Todo, Todo, Todo> get copyWith =>
      _TodoCopyWithImpl(this as Todo, $identity, $identity);
  @override
  String toString() {
    return TodoMapper.ensureInitialized().stringifyValue(this as Todo);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            TodoMapper.ensureInitialized().isValueEqual(this as Todo, other));
  }

  @override
  int get hashCode {
    return TodoMapper.ensureInitialized().hashValue(this as Todo);
  }
}

extension TodoValueCopy<$R, $Out> on ObjectCopyWith<$R, Todo, $Out> {
  TodoCopyWith<$R, Todo, $Out> get $asTodo =>
      $base.as((v, t, t2) => _TodoCopyWithImpl(v, t, t2));
}

abstract class TodoCopyWith<$R, $In extends Todo, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? id, String? title, String? description, bool? isCompleted});
  TodoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _TodoCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Todo, $Out>
    implements TodoCopyWith<$R, Todo, $Out> {
  _TodoCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Todo> $mapper = TodoMapper.ensureInitialized();
  @override
  $R call(
          {String? id,
          String? title,
          String? description,
          bool? isCompleted}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (title != null) #title: title,
        if (description != null) #description: description,
        if (isCompleted != null) #isCompleted: isCompleted
      }));
  @override
  Todo $make(CopyWithData data) => Todo(
      id: data.get(#id, or: $value.id),
      title: data.get(#title, or: $value.title),
      description: data.get(#description, or: $value.description),
      isCompleted: data.get(#isCompleted, or: $value.isCompleted));

  @override
  TodoCopyWith<$R2, Todo, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _TodoCopyWithImpl($value, $cast, t);
}
