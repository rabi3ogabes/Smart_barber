// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'catalog.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ServiceAddon {

 String get id;@LocalizedConverter() LocalizedText get name; Money get price; int get extraMinutes;
/// Create a copy of ServiceAddon
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServiceAddonCopyWith<ServiceAddon> get copyWith => _$ServiceAddonCopyWithImpl<ServiceAddon>(this as ServiceAddon, _$identity);

  /// Serializes this ServiceAddon to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ServiceAddon;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServiceAddon&&(identical(other.id, _this.id) || other.id == _this.id)&&const DeepCollectionEquality().equals(other.name, _this.name)&&(identical(other.price, _this.price) || other.price == _this.price)&&(identical(other.extraMinutes, _this.extraMinutes) || other.extraMinutes == _this.extraMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ServiceAddon;
  return Object.hash(runtimeType,_this.id,const DeepCollectionEquality().hash(_this.name),_this.price,_this.extraMinutes);
}

@override
String toString() {
  final _this = this as ServiceAddon;
  return 'ServiceAddon(id: ${_this.id}, name: ${_this.name}, price: ${_this.price}, extraMinutes: ${_this.extraMinutes})';
}


}

/// @nodoc
abstract mixin class $ServiceAddonCopyWith<$Res>  {
  factory $ServiceAddonCopyWith(ServiceAddon value, $Res Function(ServiceAddon) _then) = _$ServiceAddonCopyWithImpl;
@useResult
$Res call({
 String id,@LocalizedConverter() LocalizedText name, Money price, int extraMinutes
});


$MoneyCopyWith<$Res> get price;

}
/// @nodoc
class _$ServiceAddonCopyWithImpl<$Res>
    implements $ServiceAddonCopyWith<$Res> {
  _$ServiceAddonCopyWithImpl(this._self, this._then);

  final ServiceAddon _self;
  final $Res Function(ServiceAddon) _then;

/// Create a copy of ServiceAddon
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? price = null,Object? extraMinutes = null,}) {
  return _then(ServiceAddon(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as LocalizedText,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as Money,extraMinutes: null == extraMinutes ? _self.extraMinutes : extraMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of ServiceAddon
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneyCopyWith<$Res> get price {
  
  return $MoneyCopyWith<$Res>(_self.price, (value) {
    return _then(_self.copyWith(price: value));
  });
}
}


/// Adds pattern-matching-related methods to [ServiceAddon].
extension ServiceAddonPatterns on ServiceAddon {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServiceAddon value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServiceAddon() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServiceAddon value)  $default,){
final _that = this;
switch (_that) {
case _ServiceAddon():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServiceAddon value)?  $default,){
final _that = this;
switch (_that) {
case _ServiceAddon() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @LocalizedConverter()  LocalizedText name,  Money price,  int extraMinutes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServiceAddon() when $default != null:
return $default(_that.id,_that.name,_that.price,_that.extraMinutes);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @LocalizedConverter()  LocalizedText name,  Money price,  int extraMinutes)  $default,) {final _that = this;
switch (_that) {
case _ServiceAddon():
return $default(_that.id,_that.name,_that.price,_that.extraMinutes);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @LocalizedConverter()  LocalizedText name,  Money price,  int extraMinutes)?  $default,) {final _that = this;
switch (_that) {
case _ServiceAddon() when $default != null:
return $default(_that.id,_that.name,_that.price,_that.extraMinutes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ServiceAddon implements ServiceAddon {
  const _ServiceAddon({required this.id, @LocalizedConverter() required  LocalizedText name, required this.price, this.extraMinutes = 0}): _name = name;
  factory _ServiceAddon.fromJson(Map<String, dynamic> json) => _$ServiceAddonFromJson(json);

@override final  String id;
 final  LocalizedText _name;
@override@LocalizedConverter() LocalizedText get name {
  if (_name is EqualUnmodifiableMapView) return _name;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_name);
}

@override final  Money price;
@override@JsonKey() final  int extraMinutes;

/// Create a copy of ServiceAddon
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServiceAddonCopyWith<_ServiceAddon> get copyWith => __$ServiceAddonCopyWithImpl<_ServiceAddon>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ServiceAddonToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServiceAddon&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.name, _name)&&(identical(other.price, price) || other.price == price)&&(identical(other.extraMinutes, extraMinutes) || other.extraMinutes == extraMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_name),price,extraMinutes);
}

@override
String toString() {
    return 'ServiceAddon(id: $id, name: $name, price: $price, extraMinutes: $extraMinutes)';
}


}

/// @nodoc
abstract mixin class _$ServiceAddonCopyWith<$Res> implements $ServiceAddonCopyWith<$Res> {
  factory _$ServiceAddonCopyWith(_ServiceAddon value, $Res Function(_ServiceAddon) _then) = __$ServiceAddonCopyWithImpl;
@override @useResult
$Res call({
 String id,@LocalizedConverter() LocalizedText name, Money price, int extraMinutes
});


@override $MoneyCopyWith<$Res> get price;

}
/// @nodoc
class __$ServiceAddonCopyWithImpl<$Res>
    implements _$ServiceAddonCopyWith<$Res> {
  __$ServiceAddonCopyWithImpl(this._self, this._then);

  final _ServiceAddon _self;
  final $Res Function(_ServiceAddon) _then;

/// Create a copy of ServiceAddon
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? price = null,Object? extraMinutes = null,}) {
  return _then(_ServiceAddon(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self._name : name // ignore: cast_nullable_to_non_nullable
as LocalizedText,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as Money,extraMinutes: null == extraMinutes ? _self.extraMinutes : extraMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of ServiceAddon
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneyCopyWith<$Res> get price {
  
  return $MoneyCopyWith<$Res>(_self.price, (value) {
    return _then(_self.copyWith(price: value));
  });
}
}


/// @nodoc
mixin _$CatalogService {

 String get id;@LocalizedConverter() LocalizedText get name; int get durationMinutes; String? get category;@LocalizedOrNullConverter() LocalizedText? get description; String? get imageUrl; Money? get price; List<ServiceAddon> get addons;
/// Create a copy of CatalogService
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CatalogServiceCopyWith<CatalogService> get copyWith => _$CatalogServiceCopyWithImpl<CatalogService>(this as CatalogService, _$identity);

  /// Serializes this CatalogService to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CatalogService;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CatalogService&&(identical(other.id, _this.id) || other.id == _this.id)&&const DeepCollectionEquality().equals(other.name, _this.name)&&(identical(other.durationMinutes, _this.durationMinutes) || other.durationMinutes == _this.durationMinutes)&&(identical(other.category, _this.category) || other.category == _this.category)&&const DeepCollectionEquality().equals(other.description, _this.description)&&(identical(other.imageUrl, _this.imageUrl) || other.imageUrl == _this.imageUrl)&&(identical(other.price, _this.price) || other.price == _this.price)&&const DeepCollectionEquality().equals(other.addons, _this.addons));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CatalogService;
  return Object.hash(runtimeType,_this.id,const DeepCollectionEquality().hash(_this.name),_this.durationMinutes,_this.category,const DeepCollectionEquality().hash(_this.description),_this.imageUrl,_this.price,const DeepCollectionEquality().hash(_this.addons));
}

@override
String toString() {
  final _this = this as CatalogService;
  return 'CatalogService(id: ${_this.id}, name: ${_this.name}, durationMinutes: ${_this.durationMinutes}, category: ${_this.category}, description: ${_this.description}, imageUrl: ${_this.imageUrl}, price: ${_this.price}, addons: ${_this.addons})';
}


}

/// @nodoc
abstract mixin class $CatalogServiceCopyWith<$Res>  {
  factory $CatalogServiceCopyWith(CatalogService value, $Res Function(CatalogService) _then) = _$CatalogServiceCopyWithImpl;
@useResult
$Res call({
 String id,@LocalizedConverter() LocalizedText name, int durationMinutes, String? category,@LocalizedOrNullConverter() LocalizedText? description, String? imageUrl, Money? price, List<ServiceAddon> addons
});


$MoneyCopyWith<$Res>? get price;

}
/// @nodoc
class _$CatalogServiceCopyWithImpl<$Res>
    implements $CatalogServiceCopyWith<$Res> {
  _$CatalogServiceCopyWithImpl(this._self, this._then);

  final CatalogService _self;
  final $Res Function(CatalogService) _then;

/// Create a copy of CatalogService
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? durationMinutes = null,Object? category = freezed,Object? description = freezed,Object? imageUrl = freezed,Object? price = freezed,Object? addons = null,}) {
  return _then(CatalogService(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as LocalizedText,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as LocalizedText?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as Money?,addons: null == addons ? _self.addons : addons // ignore: cast_nullable_to_non_nullable
as List<ServiceAddon>,
  ));
}
/// Create a copy of CatalogService
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneyCopyWith<$Res>? get price {
    if (_self.price == null) {
    return null;
  }

  return $MoneyCopyWith<$Res>(_self.price!, (value) {
    return _then(_self.copyWith(price: value));
  });
}
}


/// Adds pattern-matching-related methods to [CatalogService].
extension CatalogServicePatterns on CatalogService {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CatalogService value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CatalogService() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CatalogService value)  $default,){
final _that = this;
switch (_that) {
case _CatalogService():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CatalogService value)?  $default,){
final _that = this;
switch (_that) {
case _CatalogService() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @LocalizedConverter()  LocalizedText name,  int durationMinutes,  String? category, @LocalizedOrNullConverter()  LocalizedText? description,  String? imageUrl,  Money? price,  List<ServiceAddon> addons)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CatalogService() when $default != null:
return $default(_that.id,_that.name,_that.durationMinutes,_that.category,_that.description,_that.imageUrl,_that.price,_that.addons);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @LocalizedConverter()  LocalizedText name,  int durationMinutes,  String? category, @LocalizedOrNullConverter()  LocalizedText? description,  String? imageUrl,  Money? price,  List<ServiceAddon> addons)  $default,) {final _that = this;
switch (_that) {
case _CatalogService():
return $default(_that.id,_that.name,_that.durationMinutes,_that.category,_that.description,_that.imageUrl,_that.price,_that.addons);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @LocalizedConverter()  LocalizedText name,  int durationMinutes,  String? category, @LocalizedOrNullConverter()  LocalizedText? description,  String? imageUrl,  Money? price,  List<ServiceAddon> addons)?  $default,) {final _that = this;
switch (_that) {
case _CatalogService() when $default != null:
return $default(_that.id,_that.name,_that.durationMinutes,_that.category,_that.description,_that.imageUrl,_that.price,_that.addons);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CatalogService implements CatalogService {
  const _CatalogService({required this.id, @LocalizedConverter() required  LocalizedText name, required this.durationMinutes, this.category, @LocalizedOrNullConverter()  LocalizedText? description, this.imageUrl, this.price,  List<ServiceAddon> addons = const []}): _name = name,_description = description,_addons = addons;
  factory _CatalogService.fromJson(Map<String, dynamic> json) => _$CatalogServiceFromJson(json);

@override final  String id;
 final  LocalizedText _name;
@override@LocalizedConverter() LocalizedText get name {
  if (_name is EqualUnmodifiableMapView) return _name;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_name);
}

@override final  int durationMinutes;
@override final  String? category;
 final  LocalizedText? _description;
@override@LocalizedOrNullConverter() LocalizedText? get description {
  final value = _description;
  if (value == null) return null;
  if (_description is EqualUnmodifiableMapView) return _description;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  String? imageUrl;
@override final  Money? price;
 final  List<ServiceAddon> _addons;
@override@JsonKey() List<ServiceAddon> get addons {
  if (_addons is EqualUnmodifiableListView) return _addons;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_addons);
}


/// Create a copy of CatalogService
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CatalogServiceCopyWith<_CatalogService> get copyWith => __$CatalogServiceCopyWithImpl<_CatalogService>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CatalogServiceToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CatalogService&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.name, _name)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.category, category) || other.category == category)&&const DeepCollectionEquality().equals(other.description, _description)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.price, price) || other.price == price)&&const DeepCollectionEquality().equals(other.addons, _addons));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_name),durationMinutes,category,const DeepCollectionEquality().hash(_description),imageUrl,price,const DeepCollectionEquality().hash(_addons));
}

@override
String toString() {
    return 'CatalogService(id: $id, name: $name, durationMinutes: $durationMinutes, category: $category, description: $description, imageUrl: $imageUrl, price: $price, addons: $addons)';
}


}

/// @nodoc
abstract mixin class _$CatalogServiceCopyWith<$Res> implements $CatalogServiceCopyWith<$Res> {
  factory _$CatalogServiceCopyWith(_CatalogService value, $Res Function(_CatalogService) _then) = __$CatalogServiceCopyWithImpl;
@override @useResult
$Res call({
 String id,@LocalizedConverter() LocalizedText name, int durationMinutes, String? category,@LocalizedOrNullConverter() LocalizedText? description, String? imageUrl, Money? price, List<ServiceAddon> addons
});


@override $MoneyCopyWith<$Res>? get price;

}
/// @nodoc
class __$CatalogServiceCopyWithImpl<$Res>
    implements _$CatalogServiceCopyWith<$Res> {
  __$CatalogServiceCopyWithImpl(this._self, this._then);

  final _CatalogService _self;
  final $Res Function(_CatalogService) _then;

/// Create a copy of CatalogService
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? durationMinutes = null,Object? category = freezed,Object? description = freezed,Object? imageUrl = freezed,Object? price = freezed,Object? addons = null,}) {
  return _then(_CatalogService(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self._name : name // ignore: cast_nullable_to_non_nullable
as LocalizedText,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self._description : description // ignore: cast_nullable_to_non_nullable
as LocalizedText?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as Money?,addons: null == addons ? _self._addons : addons // ignore: cast_nullable_to_non_nullable
as List<ServiceAddon>,
  ));
}

/// Create a copy of CatalogService
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneyCopyWith<$Res>? get price {
    if (_self.price == null) {
    return null;
  }

  return $MoneyCopyWith<$Res>(_self.price!, (value) {
    return _then(_self.copyWith(price: value));
  });
}
}


/// @nodoc
mixin _$ServiceBundle {

 String get id;@LocalizedConverter() LocalizedText get name; Money get price; int get durationMinutes; List<String> get services;@LocalizedOrNullConverter() LocalizedText? get description;
/// Create a copy of ServiceBundle
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServiceBundleCopyWith<ServiceBundle> get copyWith => _$ServiceBundleCopyWithImpl<ServiceBundle>(this as ServiceBundle, _$identity);

  /// Serializes this ServiceBundle to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ServiceBundle;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServiceBundle&&(identical(other.id, _this.id) || other.id == _this.id)&&const DeepCollectionEquality().equals(other.name, _this.name)&&(identical(other.price, _this.price) || other.price == _this.price)&&(identical(other.durationMinutes, _this.durationMinutes) || other.durationMinutes == _this.durationMinutes)&&const DeepCollectionEquality().equals(other.services, _this.services)&&const DeepCollectionEquality().equals(other.description, _this.description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ServiceBundle;
  return Object.hash(runtimeType,_this.id,const DeepCollectionEquality().hash(_this.name),_this.price,_this.durationMinutes,const DeepCollectionEquality().hash(_this.services),const DeepCollectionEquality().hash(_this.description));
}

@override
String toString() {
  final _this = this as ServiceBundle;
  return 'ServiceBundle(id: ${_this.id}, name: ${_this.name}, price: ${_this.price}, durationMinutes: ${_this.durationMinutes}, services: ${_this.services}, description: ${_this.description})';
}


}

/// @nodoc
abstract mixin class $ServiceBundleCopyWith<$Res>  {
  factory $ServiceBundleCopyWith(ServiceBundle value, $Res Function(ServiceBundle) _then) = _$ServiceBundleCopyWithImpl;
@useResult
$Res call({
 String id,@LocalizedConverter() LocalizedText name, Money price, int durationMinutes, List<String> services,@LocalizedOrNullConverter() LocalizedText? description
});


$MoneyCopyWith<$Res> get price;

}
/// @nodoc
class _$ServiceBundleCopyWithImpl<$Res>
    implements $ServiceBundleCopyWith<$Res> {
  _$ServiceBundleCopyWithImpl(this._self, this._then);

  final ServiceBundle _self;
  final $Res Function(ServiceBundle) _then;

/// Create a copy of ServiceBundle
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? price = null,Object? durationMinutes = null,Object? services = null,Object? description = freezed,}) {
  return _then(ServiceBundle(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as LocalizedText,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as Money,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,services: null == services ? _self.services : services // ignore: cast_nullable_to_non_nullable
as List<String>,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as LocalizedText?,
  ));
}
/// Create a copy of ServiceBundle
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneyCopyWith<$Res> get price {
  
  return $MoneyCopyWith<$Res>(_self.price, (value) {
    return _then(_self.copyWith(price: value));
  });
}
}


/// Adds pattern-matching-related methods to [ServiceBundle].
extension ServiceBundlePatterns on ServiceBundle {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServiceBundle value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServiceBundle() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServiceBundle value)  $default,){
final _that = this;
switch (_that) {
case _ServiceBundle():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServiceBundle value)?  $default,){
final _that = this;
switch (_that) {
case _ServiceBundle() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @LocalizedConverter()  LocalizedText name,  Money price,  int durationMinutes,  List<String> services, @LocalizedOrNullConverter()  LocalizedText? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServiceBundle() when $default != null:
return $default(_that.id,_that.name,_that.price,_that.durationMinutes,_that.services,_that.description);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @LocalizedConverter()  LocalizedText name,  Money price,  int durationMinutes,  List<String> services, @LocalizedOrNullConverter()  LocalizedText? description)  $default,) {final _that = this;
switch (_that) {
case _ServiceBundle():
return $default(_that.id,_that.name,_that.price,_that.durationMinutes,_that.services,_that.description);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @LocalizedConverter()  LocalizedText name,  Money price,  int durationMinutes,  List<String> services, @LocalizedOrNullConverter()  LocalizedText? description)?  $default,) {final _that = this;
switch (_that) {
case _ServiceBundle() when $default != null:
return $default(_that.id,_that.name,_that.price,_that.durationMinutes,_that.services,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ServiceBundle implements ServiceBundle {
  const _ServiceBundle({required this.id, @LocalizedConverter() required  LocalizedText name, required this.price, required this.durationMinutes,  List<String> services = const [], @LocalizedOrNullConverter()  LocalizedText? description}): _name = name,_services = services,_description = description;
  factory _ServiceBundle.fromJson(Map<String, dynamic> json) => _$ServiceBundleFromJson(json);

@override final  String id;
 final  LocalizedText _name;
@override@LocalizedConverter() LocalizedText get name {
  if (_name is EqualUnmodifiableMapView) return _name;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_name);
}

@override final  Money price;
@override final  int durationMinutes;
 final  List<String> _services;
@override@JsonKey() List<String> get services {
  if (_services is EqualUnmodifiableListView) return _services;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_services);
}

 final  LocalizedText? _description;
@override@LocalizedOrNullConverter() LocalizedText? get description {
  final value = _description;
  if (value == null) return null;
  if (_description is EqualUnmodifiableMapView) return _description;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of ServiceBundle
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServiceBundleCopyWith<_ServiceBundle> get copyWith => __$ServiceBundleCopyWithImpl<_ServiceBundle>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ServiceBundleToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServiceBundle&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.name, _name)&&(identical(other.price, price) || other.price == price)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&const DeepCollectionEquality().equals(other.services, _services)&&const DeepCollectionEquality().equals(other.description, _description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_name),price,durationMinutes,const DeepCollectionEquality().hash(_services),const DeepCollectionEquality().hash(_description));
}

@override
String toString() {
    return 'ServiceBundle(id: $id, name: $name, price: $price, durationMinutes: $durationMinutes, services: $services, description: $description)';
}


}

/// @nodoc
abstract mixin class _$ServiceBundleCopyWith<$Res> implements $ServiceBundleCopyWith<$Res> {
  factory _$ServiceBundleCopyWith(_ServiceBundle value, $Res Function(_ServiceBundle) _then) = __$ServiceBundleCopyWithImpl;
@override @useResult
$Res call({
 String id,@LocalizedConverter() LocalizedText name, Money price, int durationMinutes, List<String> services,@LocalizedOrNullConverter() LocalizedText? description
});


@override $MoneyCopyWith<$Res> get price;

}
/// @nodoc
class __$ServiceBundleCopyWithImpl<$Res>
    implements _$ServiceBundleCopyWith<$Res> {
  __$ServiceBundleCopyWithImpl(this._self, this._then);

  final _ServiceBundle _self;
  final $Res Function(_ServiceBundle) _then;

/// Create a copy of ServiceBundle
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? price = null,Object? durationMinutes = null,Object? services = null,Object? description = freezed,}) {
  return _then(_ServiceBundle(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self._name : name // ignore: cast_nullable_to_non_nullable
as LocalizedText,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as Money,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,services: null == services ? _self._services : services // ignore: cast_nullable_to_non_nullable
as List<String>,description: freezed == description ? _self._description : description // ignore: cast_nullable_to_non_nullable
as LocalizedText?,
  ));
}

/// Create a copy of ServiceBundle
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneyCopyWith<$Res> get price {
  
  return $MoneyCopyWith<$Res>(_self.price, (value) {
    return _then(_self.copyWith(price: value));
  });
}
}


/// @nodoc
mixin _$ServiceMenu {

 List<CatalogService> get services; List<ServiceBundle> get bundles;
/// Create a copy of ServiceMenu
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServiceMenuCopyWith<ServiceMenu> get copyWith => _$ServiceMenuCopyWithImpl<ServiceMenu>(this as ServiceMenu, _$identity);

  /// Serializes this ServiceMenu to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ServiceMenu;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServiceMenu&&const DeepCollectionEquality().equals(other.services, _this.services)&&const DeepCollectionEquality().equals(other.bundles, _this.bundles));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ServiceMenu;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.services),const DeepCollectionEquality().hash(_this.bundles));
}

@override
String toString() {
  final _this = this as ServiceMenu;
  return 'ServiceMenu(services: ${_this.services}, bundles: ${_this.bundles})';
}


}

/// @nodoc
abstract mixin class $ServiceMenuCopyWith<$Res>  {
  factory $ServiceMenuCopyWith(ServiceMenu value, $Res Function(ServiceMenu) _then) = _$ServiceMenuCopyWithImpl;
@useResult
$Res call({
 List<CatalogService> services, List<ServiceBundle> bundles
});




}
/// @nodoc
class _$ServiceMenuCopyWithImpl<$Res>
    implements $ServiceMenuCopyWith<$Res> {
  _$ServiceMenuCopyWithImpl(this._self, this._then);

  final ServiceMenu _self;
  final $Res Function(ServiceMenu) _then;

/// Create a copy of ServiceMenu
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? services = null,Object? bundles = null,}) {
  return _then(ServiceMenu(
services: null == services ? _self.services : services // ignore: cast_nullable_to_non_nullable
as List<CatalogService>,bundles: null == bundles ? _self.bundles : bundles // ignore: cast_nullable_to_non_nullable
as List<ServiceBundle>,
  ));
}

}


/// Adds pattern-matching-related methods to [ServiceMenu].
extension ServiceMenuPatterns on ServiceMenu {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServiceMenu value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServiceMenu() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServiceMenu value)  $default,){
final _that = this;
switch (_that) {
case _ServiceMenu():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServiceMenu value)?  $default,){
final _that = this;
switch (_that) {
case _ServiceMenu() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<CatalogService> services,  List<ServiceBundle> bundles)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServiceMenu() when $default != null:
return $default(_that.services,_that.bundles);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<CatalogService> services,  List<ServiceBundle> bundles)  $default,) {final _that = this;
switch (_that) {
case _ServiceMenu():
return $default(_that.services,_that.bundles);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<CatalogService> services,  List<ServiceBundle> bundles)?  $default,) {final _that = this;
switch (_that) {
case _ServiceMenu() when $default != null:
return $default(_that.services,_that.bundles);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ServiceMenu implements ServiceMenu {
  const _ServiceMenu({ List<CatalogService> services = const [],  List<ServiceBundle> bundles = const []}): _services = services,_bundles = bundles;
  factory _ServiceMenu.fromJson(Map<String, dynamic> json) => _$ServiceMenuFromJson(json);

 final  List<CatalogService> _services;
@override@JsonKey() List<CatalogService> get services {
  if (_services is EqualUnmodifiableListView) return _services;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_services);
}

 final  List<ServiceBundle> _bundles;
@override@JsonKey() List<ServiceBundle> get bundles {
  if (_bundles is EqualUnmodifiableListView) return _bundles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_bundles);
}


/// Create a copy of ServiceMenu
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServiceMenuCopyWith<_ServiceMenu> get copyWith => __$ServiceMenuCopyWithImpl<_ServiceMenu>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ServiceMenuToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServiceMenu&&const DeepCollectionEquality().equals(other.services, _services)&&const DeepCollectionEquality().equals(other.bundles, _bundles));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_services),const DeepCollectionEquality().hash(_bundles));
}

@override
String toString() {
    return 'ServiceMenu(services: $services, bundles: $bundles)';
}


}

/// @nodoc
abstract mixin class _$ServiceMenuCopyWith<$Res> implements $ServiceMenuCopyWith<$Res> {
  factory _$ServiceMenuCopyWith(_ServiceMenu value, $Res Function(_ServiceMenu) _then) = __$ServiceMenuCopyWithImpl;
@override @useResult
$Res call({
 List<CatalogService> services, List<ServiceBundle> bundles
});




}
/// @nodoc
class __$ServiceMenuCopyWithImpl<$Res>
    implements _$ServiceMenuCopyWith<$Res> {
  __$ServiceMenuCopyWithImpl(this._self, this._then);

  final _ServiceMenu _self;
  final $Res Function(_ServiceMenu) _then;

/// Create a copy of ServiceMenu
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? services = null,Object? bundles = null,}) {
  return _then(_ServiceMenu(
services: null == services ? _self._services : services // ignore: cast_nullable_to_non_nullable
as List<CatalogService>,bundles: null == bundles ? _self._bundles : bundles // ignore: cast_nullable_to_non_nullable
as List<ServiceBundle>,
  ));
}


}


/// @nodoc
mixin _$BarberRating {

 double get average; int get count;
/// Create a copy of BarberRating
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BarberRatingCopyWith<BarberRating> get copyWith => _$BarberRatingCopyWithImpl<BarberRating>(this as BarberRating, _$identity);

  /// Serializes this BarberRating to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BarberRating;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BarberRating&&(identical(other.average, _this.average) || other.average == _this.average)&&(identical(other.count, _this.count) || other.count == _this.count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BarberRating;
  return Object.hash(runtimeType,_this.average,_this.count);
}

@override
String toString() {
  final _this = this as BarberRating;
  return 'BarberRating(average: ${_this.average}, count: ${_this.count})';
}


}

/// @nodoc
abstract mixin class $BarberRatingCopyWith<$Res>  {
  factory $BarberRatingCopyWith(BarberRating value, $Res Function(BarberRating) _then) = _$BarberRatingCopyWithImpl;
@useResult
$Res call({
 double average, int count
});




}
/// @nodoc
class _$BarberRatingCopyWithImpl<$Res>
    implements $BarberRatingCopyWith<$Res> {
  _$BarberRatingCopyWithImpl(this._self, this._then);

  final BarberRating _self;
  final $Res Function(BarberRating) _then;

/// Create a copy of BarberRating
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? average = null,Object? count = null,}) {
  return _then(BarberRating(
average: null == average ? _self.average : average // ignore: cast_nullable_to_non_nullable
as double,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BarberRating].
extension BarberRatingPatterns on BarberRating {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BarberRating value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BarberRating() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BarberRating value)  $default,){
final _that = this;
switch (_that) {
case _BarberRating():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BarberRating value)?  $default,){
final _that = this;
switch (_that) {
case _BarberRating() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double average,  int count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BarberRating() when $default != null:
return $default(_that.average,_that.count);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double average,  int count)  $default,) {final _that = this;
switch (_that) {
case _BarberRating():
return $default(_that.average,_that.count);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double average,  int count)?  $default,) {final _that = this;
switch (_that) {
case _BarberRating() when $default != null:
return $default(_that.average,_that.count);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BarberRating implements BarberRating {
  const _BarberRating({required this.average, required this.count});
  factory _BarberRating.fromJson(Map<String, dynamic> json) => _$BarberRatingFromJson(json);

@override final  double average;
@override final  int count;

/// Create a copy of BarberRating
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BarberRatingCopyWith<_BarberRating> get copyWith => __$BarberRatingCopyWithImpl<_BarberRating>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BarberRatingToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BarberRating&&(identical(other.average, average) || other.average == average)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,average,count);
}

@override
String toString() {
    return 'BarberRating(average: $average, count: $count)';
}


}

/// @nodoc
abstract mixin class _$BarberRatingCopyWith<$Res> implements $BarberRatingCopyWith<$Res> {
  factory _$BarberRatingCopyWith(_BarberRating value, $Res Function(_BarberRating) _then) = __$BarberRatingCopyWithImpl;
@override @useResult
$Res call({
 double average, int count
});




}
/// @nodoc
class __$BarberRatingCopyWithImpl<$Res>
    implements _$BarberRatingCopyWith<$Res> {
  __$BarberRatingCopyWithImpl(this._self, this._then);

  final _BarberRating _self;
  final $Res Function(_BarberRating) _then;

/// Create a copy of BarberRating
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? average = null,Object? count = null,}) {
  return _then(_BarberRating(
average: null == average ? _self.average : average // ignore: cast_nullable_to_non_nullable
as double,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$BarberProfile {

 String get id;@LocalizedConverter() LocalizedText get displayName;@LocalizedOrNullConverter() LocalizedText? get bio; List<String> get specialties; int? get yearsExperience; String? get photoUrl; BarberRating? get rating;
/// Create a copy of BarberProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BarberProfileCopyWith<BarberProfile> get copyWith => _$BarberProfileCopyWithImpl<BarberProfile>(this as BarberProfile, _$identity);

  /// Serializes this BarberProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BarberProfile;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BarberProfile&&(identical(other.id, _this.id) || other.id == _this.id)&&const DeepCollectionEquality().equals(other.displayName, _this.displayName)&&const DeepCollectionEquality().equals(other.bio, _this.bio)&&const DeepCollectionEquality().equals(other.specialties, _this.specialties)&&(identical(other.yearsExperience, _this.yearsExperience) || other.yearsExperience == _this.yearsExperience)&&(identical(other.photoUrl, _this.photoUrl) || other.photoUrl == _this.photoUrl)&&(identical(other.rating, _this.rating) || other.rating == _this.rating));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BarberProfile;
  return Object.hash(runtimeType,_this.id,const DeepCollectionEquality().hash(_this.displayName),const DeepCollectionEquality().hash(_this.bio),const DeepCollectionEquality().hash(_this.specialties),_this.yearsExperience,_this.photoUrl,_this.rating);
}

@override
String toString() {
  final _this = this as BarberProfile;
  return 'BarberProfile(id: ${_this.id}, displayName: ${_this.displayName}, bio: ${_this.bio}, specialties: ${_this.specialties}, yearsExperience: ${_this.yearsExperience}, photoUrl: ${_this.photoUrl}, rating: ${_this.rating})';
}


}

/// @nodoc
abstract mixin class $BarberProfileCopyWith<$Res>  {
  factory $BarberProfileCopyWith(BarberProfile value, $Res Function(BarberProfile) _then) = _$BarberProfileCopyWithImpl;
@useResult
$Res call({
 String id,@LocalizedConverter() LocalizedText displayName,@LocalizedOrNullConverter() LocalizedText? bio, List<String> specialties, int? yearsExperience, String? photoUrl, BarberRating? rating
});


$BarberRatingCopyWith<$Res>? get rating;

}
/// @nodoc
class _$BarberProfileCopyWithImpl<$Res>
    implements $BarberProfileCopyWith<$Res> {
  _$BarberProfileCopyWithImpl(this._self, this._then);

  final BarberProfile _self;
  final $Res Function(BarberProfile) _then;

/// Create a copy of BarberProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? displayName = null,Object? bio = freezed,Object? specialties = null,Object? yearsExperience = freezed,Object? photoUrl = freezed,Object? rating = freezed,}) {
  return _then(BarberProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as LocalizedText,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as LocalizedText?,specialties: null == specialties ? _self.specialties : specialties // ignore: cast_nullable_to_non_nullable
as List<String>,yearsExperience: freezed == yearsExperience ? _self.yearsExperience : yearsExperience // ignore: cast_nullable_to_non_nullable
as int?,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as BarberRating?,
  ));
}
/// Create a copy of BarberProfile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BarberRatingCopyWith<$Res>? get rating {
    if (_self.rating == null) {
    return null;
  }

  return $BarberRatingCopyWith<$Res>(_self.rating!, (value) {
    return _then(_self.copyWith(rating: value));
  });
}
}


/// Adds pattern-matching-related methods to [BarberProfile].
extension BarberProfilePatterns on BarberProfile {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BarberProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BarberProfile() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BarberProfile value)  $default,){
final _that = this;
switch (_that) {
case _BarberProfile():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BarberProfile value)?  $default,){
final _that = this;
switch (_that) {
case _BarberProfile() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @LocalizedConverter()  LocalizedText displayName, @LocalizedOrNullConverter()  LocalizedText? bio,  List<String> specialties,  int? yearsExperience,  String? photoUrl,  BarberRating? rating)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BarberProfile() when $default != null:
return $default(_that.id,_that.displayName,_that.bio,_that.specialties,_that.yearsExperience,_that.photoUrl,_that.rating);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @LocalizedConverter()  LocalizedText displayName, @LocalizedOrNullConverter()  LocalizedText? bio,  List<String> specialties,  int? yearsExperience,  String? photoUrl,  BarberRating? rating)  $default,) {final _that = this;
switch (_that) {
case _BarberProfile():
return $default(_that.id,_that.displayName,_that.bio,_that.specialties,_that.yearsExperience,_that.photoUrl,_that.rating);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @LocalizedConverter()  LocalizedText displayName, @LocalizedOrNullConverter()  LocalizedText? bio,  List<String> specialties,  int? yearsExperience,  String? photoUrl,  BarberRating? rating)?  $default,) {final _that = this;
switch (_that) {
case _BarberProfile() when $default != null:
return $default(_that.id,_that.displayName,_that.bio,_that.specialties,_that.yearsExperience,_that.photoUrl,_that.rating);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BarberProfile implements BarberProfile {
  const _BarberProfile({required this.id, @LocalizedConverter() required  LocalizedText displayName, @LocalizedOrNullConverter()  LocalizedText? bio,  List<String> specialties = const [], this.yearsExperience, this.photoUrl, this.rating}): _displayName = displayName,_bio = bio,_specialties = specialties;
  factory _BarberProfile.fromJson(Map<String, dynamic> json) => _$BarberProfileFromJson(json);

@override final  String id;
 final  LocalizedText _displayName;
@override@LocalizedConverter() LocalizedText get displayName {
  if (_displayName is EqualUnmodifiableMapView) return _displayName;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_displayName);
}

 final  LocalizedText? _bio;
@override@LocalizedOrNullConverter() LocalizedText? get bio {
  final value = _bio;
  if (value == null) return null;
  if (_bio is EqualUnmodifiableMapView) return _bio;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  List<String> _specialties;
@override@JsonKey() List<String> get specialties {
  if (_specialties is EqualUnmodifiableListView) return _specialties;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_specialties);
}

@override final  int? yearsExperience;
@override final  String? photoUrl;
@override final  BarberRating? rating;

/// Create a copy of BarberProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BarberProfileCopyWith<_BarberProfile> get copyWith => __$BarberProfileCopyWithImpl<_BarberProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BarberProfileToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BarberProfile&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.displayName, _displayName)&&const DeepCollectionEquality().equals(other.bio, _bio)&&const DeepCollectionEquality().equals(other.specialties, _specialties)&&(identical(other.yearsExperience, yearsExperience) || other.yearsExperience == yearsExperience)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.rating, rating) || other.rating == rating));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_displayName),const DeepCollectionEquality().hash(_bio),const DeepCollectionEquality().hash(_specialties),yearsExperience,photoUrl,rating);
}

@override
String toString() {
    return 'BarberProfile(id: $id, displayName: $displayName, bio: $bio, specialties: $specialties, yearsExperience: $yearsExperience, photoUrl: $photoUrl, rating: $rating)';
}


}

/// @nodoc
abstract mixin class _$BarberProfileCopyWith<$Res> implements $BarberProfileCopyWith<$Res> {
  factory _$BarberProfileCopyWith(_BarberProfile value, $Res Function(_BarberProfile) _then) = __$BarberProfileCopyWithImpl;
@override @useResult
$Res call({
 String id,@LocalizedConverter() LocalizedText displayName,@LocalizedOrNullConverter() LocalizedText? bio, List<String> specialties, int? yearsExperience, String? photoUrl, BarberRating? rating
});


@override $BarberRatingCopyWith<$Res>? get rating;

}
/// @nodoc
class __$BarberProfileCopyWithImpl<$Res>
    implements _$BarberProfileCopyWith<$Res> {
  __$BarberProfileCopyWithImpl(this._self, this._then);

  final _BarberProfile _self;
  final $Res Function(_BarberProfile) _then;

/// Create a copy of BarberProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? displayName = null,Object? bio = freezed,Object? specialties = null,Object? yearsExperience = freezed,Object? photoUrl = freezed,Object? rating = freezed,}) {
  return _then(_BarberProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self._displayName : displayName // ignore: cast_nullable_to_non_nullable
as LocalizedText,bio: freezed == bio ? _self._bio : bio // ignore: cast_nullable_to_non_nullable
as LocalizedText?,specialties: null == specialties ? _self._specialties : specialties // ignore: cast_nullable_to_non_nullable
as List<String>,yearsExperience: freezed == yearsExperience ? _self.yearsExperience : yearsExperience // ignore: cast_nullable_to_non_nullable
as int?,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as BarberRating?,
  ));
}

/// Create a copy of BarberProfile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BarberRatingCopyWith<$Res>? get rating {
    if (_self.rating == null) {
    return null;
  }

  return $BarberRatingCopyWith<$Res>(_self.rating!, (value) {
    return _then(_self.copyWith(rating: value));
  });
}
}


/// @nodoc
mixin _$Slot {

@UtcDateTimeConverter() DateTime get startsAt; String get time; List<String> get barbers;
/// Create a copy of Slot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SlotCopyWith<Slot> get copyWith => _$SlotCopyWithImpl<Slot>(this as Slot, _$identity);

  /// Serializes this Slot to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Slot;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Slot&&(identical(other.startsAt, _this.startsAt) || other.startsAt == _this.startsAt)&&(identical(other.time, _this.time) || other.time == _this.time)&&const DeepCollectionEquality().equals(other.barbers, _this.barbers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Slot;
  return Object.hash(runtimeType,_this.startsAt,_this.time,const DeepCollectionEquality().hash(_this.barbers));
}

@override
String toString() {
  final _this = this as Slot;
  return 'Slot(startsAt: ${_this.startsAt}, time: ${_this.time}, barbers: ${_this.barbers})';
}


}

/// @nodoc
abstract mixin class $SlotCopyWith<$Res>  {
  factory $SlotCopyWith(Slot value, $Res Function(Slot) _then) = _$SlotCopyWithImpl;
@useResult
$Res call({
@UtcDateTimeConverter() DateTime startsAt, String time, List<String> barbers
});




}
/// @nodoc
class _$SlotCopyWithImpl<$Res>
    implements $SlotCopyWith<$Res> {
  _$SlotCopyWithImpl(this._self, this._then);

  final Slot _self;
  final $Res Function(Slot) _then;

/// Create a copy of Slot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? startsAt = null,Object? time = null,Object? barbers = null,}) {
  return _then(Slot(
startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,barbers: null == barbers ? _self.barbers : barbers // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [Slot].
extension SlotPatterns on Slot {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Slot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Slot() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Slot value)  $default,){
final _that = this;
switch (_that) {
case _Slot():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Slot value)?  $default,){
final _that = this;
switch (_that) {
case _Slot() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@UtcDateTimeConverter()  DateTime startsAt,  String time,  List<String> barbers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Slot() when $default != null:
return $default(_that.startsAt,_that.time,_that.barbers);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@UtcDateTimeConverter()  DateTime startsAt,  String time,  List<String> barbers)  $default,) {final _that = this;
switch (_that) {
case _Slot():
return $default(_that.startsAt,_that.time,_that.barbers);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@UtcDateTimeConverter()  DateTime startsAt,  String time,  List<String> barbers)?  $default,) {final _that = this;
switch (_that) {
case _Slot() when $default != null:
return $default(_that.startsAt,_that.time,_that.barbers);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Slot implements Slot {
  const _Slot({@UtcDateTimeConverter() required this.startsAt, required this.time,  List<String> barbers = const []}): _barbers = barbers;
  factory _Slot.fromJson(Map<String, dynamic> json) => _$SlotFromJson(json);

@override@UtcDateTimeConverter() final  DateTime startsAt;
@override final  String time;
 final  List<String> _barbers;
@override@JsonKey() List<String> get barbers {
  if (_barbers is EqualUnmodifiableListView) return _barbers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_barbers);
}


/// Create a copy of Slot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SlotCopyWith<_Slot> get copyWith => __$SlotCopyWithImpl<_Slot>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SlotToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Slot&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.time, time) || other.time == time)&&const DeepCollectionEquality().equals(other.barbers, _barbers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,startsAt,time,const DeepCollectionEquality().hash(_barbers));
}

@override
String toString() {
    return 'Slot(startsAt: $startsAt, time: $time, barbers: $barbers)';
}


}

/// @nodoc
abstract mixin class _$SlotCopyWith<$Res> implements $SlotCopyWith<$Res> {
  factory _$SlotCopyWith(_Slot value, $Res Function(_Slot) _then) = __$SlotCopyWithImpl;
@override @useResult
$Res call({
@UtcDateTimeConverter() DateTime startsAt, String time, List<String> barbers
});




}
/// @nodoc
class __$SlotCopyWithImpl<$Res>
    implements _$SlotCopyWith<$Res> {
  __$SlotCopyWithImpl(this._self, this._then);

  final _Slot _self;
  final $Res Function(_Slot) _then;

/// Create a copy of Slot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? startsAt = null,Object? time = null,Object? barbers = null,}) {
  return _then(_Slot(
startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,barbers: null == barbers ? _self._barbers : barbers // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$SlotDay {

 String get date; String get timezone; List<Slot> get slots;
/// Create a copy of SlotDay
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SlotDayCopyWith<SlotDay> get copyWith => _$SlotDayCopyWithImpl<SlotDay>(this as SlotDay, _$identity);

  /// Serializes this SlotDay to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SlotDay;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SlotDay&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.timezone, _this.timezone) || other.timezone == _this.timezone)&&const DeepCollectionEquality().equals(other.slots, _this.slots));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SlotDay;
  return Object.hash(runtimeType,_this.date,_this.timezone,const DeepCollectionEquality().hash(_this.slots));
}

@override
String toString() {
  final _this = this as SlotDay;
  return 'SlotDay(date: ${_this.date}, timezone: ${_this.timezone}, slots: ${_this.slots})';
}


}

/// @nodoc
abstract mixin class $SlotDayCopyWith<$Res>  {
  factory $SlotDayCopyWith(SlotDay value, $Res Function(SlotDay) _then) = _$SlotDayCopyWithImpl;
@useResult
$Res call({
 String date, String timezone, List<Slot> slots
});




}
/// @nodoc
class _$SlotDayCopyWithImpl<$Res>
    implements $SlotDayCopyWith<$Res> {
  _$SlotDayCopyWithImpl(this._self, this._then);

  final SlotDay _self;
  final $Res Function(SlotDay) _then;

/// Create a copy of SlotDay
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? timezone = null,Object? slots = null,}) {
  return _then(SlotDay(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,slots: null == slots ? _self.slots : slots // ignore: cast_nullable_to_non_nullable
as List<Slot>,
  ));
}

}


/// Adds pattern-matching-related methods to [SlotDay].
extension SlotDayPatterns on SlotDay {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SlotDay value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SlotDay() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SlotDay value)  $default,){
final _that = this;
switch (_that) {
case _SlotDay():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SlotDay value)?  $default,){
final _that = this;
switch (_that) {
case _SlotDay() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String date,  String timezone,  List<Slot> slots)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SlotDay() when $default != null:
return $default(_that.date,_that.timezone,_that.slots);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String date,  String timezone,  List<Slot> slots)  $default,) {final _that = this;
switch (_that) {
case _SlotDay():
return $default(_that.date,_that.timezone,_that.slots);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String date,  String timezone,  List<Slot> slots)?  $default,) {final _that = this;
switch (_that) {
case _SlotDay() when $default != null:
return $default(_that.date,_that.timezone,_that.slots);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SlotDay implements SlotDay {
  const _SlotDay({required this.date, required this.timezone,  List<Slot> slots = const []}): _slots = slots;
  factory _SlotDay.fromJson(Map<String, dynamic> json) => _$SlotDayFromJson(json);

@override final  String date;
@override final  String timezone;
 final  List<Slot> _slots;
@override@JsonKey() List<Slot> get slots {
  if (_slots is EqualUnmodifiableListView) return _slots;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_slots);
}


/// Create a copy of SlotDay
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SlotDayCopyWith<_SlotDay> get copyWith => __$SlotDayCopyWithImpl<_SlotDay>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SlotDayToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SlotDay&&(identical(other.date, date) || other.date == date)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&const DeepCollectionEquality().equals(other.slots, _slots));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,date,timezone,const DeepCollectionEquality().hash(_slots));
}

@override
String toString() {
    return 'SlotDay(date: $date, timezone: $timezone, slots: $slots)';
}


}

/// @nodoc
abstract mixin class _$SlotDayCopyWith<$Res> implements $SlotDayCopyWith<$Res> {
  factory _$SlotDayCopyWith(_SlotDay value, $Res Function(_SlotDay) _then) = __$SlotDayCopyWithImpl;
@override @useResult
$Res call({
 String date, String timezone, List<Slot> slots
});




}
/// @nodoc
class __$SlotDayCopyWithImpl<$Res>
    implements _$SlotDayCopyWith<$Res> {
  __$SlotDayCopyWithImpl(this._self, this._then);

  final _SlotDay _self;
  final $Res Function(_SlotDay) _then;

/// Create a copy of SlotDay
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? timezone = null,Object? slots = null,}) {
  return _then(_SlotDay(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,slots: null == slots ? _self._slots : slots // ignore: cast_nullable_to_non_nullable
as List<Slot>,
  ));
}


}


/// @nodoc
mixin _$QuoteLine {

 String get type;@LocalizedConverter() LocalizedText get name; Money get total; int get durationMinutes;
/// Create a copy of QuoteLine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuoteLineCopyWith<QuoteLine> get copyWith => _$QuoteLineCopyWithImpl<QuoteLine>(this as QuoteLine, _$identity);

  /// Serializes this QuoteLine to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as QuoteLine;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuoteLine&&(identical(other.type, _this.type) || other.type == _this.type)&&const DeepCollectionEquality().equals(other.name, _this.name)&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.durationMinutes, _this.durationMinutes) || other.durationMinutes == _this.durationMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as QuoteLine;
  return Object.hash(runtimeType,_this.type,const DeepCollectionEquality().hash(_this.name),_this.total,_this.durationMinutes);
}

@override
String toString() {
  final _this = this as QuoteLine;
  return 'QuoteLine(type: ${_this.type}, name: ${_this.name}, total: ${_this.total}, durationMinutes: ${_this.durationMinutes})';
}


}

/// @nodoc
abstract mixin class $QuoteLineCopyWith<$Res>  {
  factory $QuoteLineCopyWith(QuoteLine value, $Res Function(QuoteLine) _then) = _$QuoteLineCopyWithImpl;
@useResult
$Res call({
 String type,@LocalizedConverter() LocalizedText name, Money total, int durationMinutes
});


$MoneyCopyWith<$Res> get total;

}
/// @nodoc
class _$QuoteLineCopyWithImpl<$Res>
    implements $QuoteLineCopyWith<$Res> {
  _$QuoteLineCopyWithImpl(this._self, this._then);

  final QuoteLine _self;
  final $Res Function(QuoteLine) _then;

/// Create a copy of QuoteLine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? name = null,Object? total = null,Object? durationMinutes = null,}) {
  return _then(QuoteLine(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as LocalizedText,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as Money,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of QuoteLine
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneyCopyWith<$Res> get total {
  
  return $MoneyCopyWith<$Res>(_self.total, (value) {
    return _then(_self.copyWith(total: value));
  });
}
}


/// Adds pattern-matching-related methods to [QuoteLine].
extension QuoteLinePatterns on QuoteLine {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuoteLine value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuoteLine() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuoteLine value)  $default,){
final _that = this;
switch (_that) {
case _QuoteLine():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuoteLine value)?  $default,){
final _that = this;
switch (_that) {
case _QuoteLine() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type, @LocalizedConverter()  LocalizedText name,  Money total,  int durationMinutes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuoteLine() when $default != null:
return $default(_that.type,_that.name,_that.total,_that.durationMinutes);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type, @LocalizedConverter()  LocalizedText name,  Money total,  int durationMinutes)  $default,) {final _that = this;
switch (_that) {
case _QuoteLine():
return $default(_that.type,_that.name,_that.total,_that.durationMinutes);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type, @LocalizedConverter()  LocalizedText name,  Money total,  int durationMinutes)?  $default,) {final _that = this;
switch (_that) {
case _QuoteLine() when $default != null:
return $default(_that.type,_that.name,_that.total,_that.durationMinutes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuoteLine implements QuoteLine {
  const _QuoteLine({required this.type, @LocalizedConverter() required  LocalizedText name, required this.total, this.durationMinutes = 0}): _name = name;
  factory _QuoteLine.fromJson(Map<String, dynamic> json) => _$QuoteLineFromJson(json);

@override final  String type;
 final  LocalizedText _name;
@override@LocalizedConverter() LocalizedText get name {
  if (_name is EqualUnmodifiableMapView) return _name;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_name);
}

@override final  Money total;
@override@JsonKey() final  int durationMinutes;

/// Create a copy of QuoteLine
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuoteLineCopyWith<_QuoteLine> get copyWith => __$QuoteLineCopyWithImpl<_QuoteLine>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuoteLineToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuoteLine&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.name, _name)&&(identical(other.total, total) || other.total == total)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,type,const DeepCollectionEquality().hash(_name),total,durationMinutes);
}

@override
String toString() {
    return 'QuoteLine(type: $type, name: $name, total: $total, durationMinutes: $durationMinutes)';
}


}

/// @nodoc
abstract mixin class _$QuoteLineCopyWith<$Res> implements $QuoteLineCopyWith<$Res> {
  factory _$QuoteLineCopyWith(_QuoteLine value, $Res Function(_QuoteLine) _then) = __$QuoteLineCopyWithImpl;
@override @useResult
$Res call({
 String type,@LocalizedConverter() LocalizedText name, Money total, int durationMinutes
});


@override $MoneyCopyWith<$Res> get total;

}
/// @nodoc
class __$QuoteLineCopyWithImpl<$Res>
    implements _$QuoteLineCopyWith<$Res> {
  __$QuoteLineCopyWithImpl(this._self, this._then);

  final _QuoteLine _self;
  final $Res Function(_QuoteLine) _then;

/// Create a copy of QuoteLine
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? name = null,Object? total = null,Object? durationMinutes = null,}) {
  return _then(_QuoteLine(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self._name : name // ignore: cast_nullable_to_non_nullable
as LocalizedText,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as Money,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of QuoteLine
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneyCopyWith<$Res> get total {
  
  return $MoneyCopyWith<$Res>(_self.total, (value) {
    return _then(_self.copyWith(total: value));
  });
}
}


/// @nodoc
mixin _$Quote {

 String get currency; Money get subtotal; Money get discount; Money get tax; Money get total; int get durationMinutes; bool get pricesIncludeTax; List<QuoteLine> get lines;
/// Create a copy of Quote
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuoteCopyWith<Quote> get copyWith => _$QuoteCopyWithImpl<Quote>(this as Quote, _$identity);

  /// Serializes this Quote to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Quote;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Quote&&(identical(other.currency, _this.currency) || other.currency == _this.currency)&&(identical(other.subtotal, _this.subtotal) || other.subtotal == _this.subtotal)&&(identical(other.discount, _this.discount) || other.discount == _this.discount)&&(identical(other.tax, _this.tax) || other.tax == _this.tax)&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.durationMinutes, _this.durationMinutes) || other.durationMinutes == _this.durationMinutes)&&(identical(other.pricesIncludeTax, _this.pricesIncludeTax) || other.pricesIncludeTax == _this.pricesIncludeTax)&&const DeepCollectionEquality().equals(other.lines, _this.lines));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Quote;
  return Object.hash(runtimeType,_this.currency,_this.subtotal,_this.discount,_this.tax,_this.total,_this.durationMinutes,_this.pricesIncludeTax,const DeepCollectionEquality().hash(_this.lines));
}

@override
String toString() {
  final _this = this as Quote;
  return 'Quote(currency: ${_this.currency}, subtotal: ${_this.subtotal}, discount: ${_this.discount}, tax: ${_this.tax}, total: ${_this.total}, durationMinutes: ${_this.durationMinutes}, pricesIncludeTax: ${_this.pricesIncludeTax}, lines: ${_this.lines})';
}


}

/// @nodoc
abstract mixin class $QuoteCopyWith<$Res>  {
  factory $QuoteCopyWith(Quote value, $Res Function(Quote) _then) = _$QuoteCopyWithImpl;
@useResult
$Res call({
 String currency, Money subtotal, Money discount, Money tax, Money total, int durationMinutes, bool pricesIncludeTax, List<QuoteLine> lines
});


$MoneyCopyWith<$Res> get subtotal;$MoneyCopyWith<$Res> get discount;$MoneyCopyWith<$Res> get tax;$MoneyCopyWith<$Res> get total;

}
/// @nodoc
class _$QuoteCopyWithImpl<$Res>
    implements $QuoteCopyWith<$Res> {
  _$QuoteCopyWithImpl(this._self, this._then);

  final Quote _self;
  final $Res Function(Quote) _then;

/// Create a copy of Quote
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currency = null,Object? subtotal = null,Object? discount = null,Object? tax = null,Object? total = null,Object? durationMinutes = null,Object? pricesIncludeTax = null,Object? lines = null,}) {
  return _then(Quote(
currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as Money,discount: null == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as Money,tax: null == tax ? _self.tax : tax // ignore: cast_nullable_to_non_nullable
as Money,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as Money,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,pricesIncludeTax: null == pricesIncludeTax ? _self.pricesIncludeTax : pricesIncludeTax // ignore: cast_nullable_to_non_nullable
as bool,lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<QuoteLine>,
  ));
}
/// Create a copy of Quote
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneyCopyWith<$Res> get subtotal {
  
  return $MoneyCopyWith<$Res>(_self.subtotal, (value) {
    return _then(_self.copyWith(subtotal: value));
  });
}/// Create a copy of Quote
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneyCopyWith<$Res> get discount {
  
  return $MoneyCopyWith<$Res>(_self.discount, (value) {
    return _then(_self.copyWith(discount: value));
  });
}/// Create a copy of Quote
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneyCopyWith<$Res> get tax {
  
  return $MoneyCopyWith<$Res>(_self.tax, (value) {
    return _then(_self.copyWith(tax: value));
  });
}/// Create a copy of Quote
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneyCopyWith<$Res> get total {
  
  return $MoneyCopyWith<$Res>(_self.total, (value) {
    return _then(_self.copyWith(total: value));
  });
}
}


/// Adds pattern-matching-related methods to [Quote].
extension QuotePatterns on Quote {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Quote value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Quote() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Quote value)  $default,){
final _that = this;
switch (_that) {
case _Quote():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Quote value)?  $default,){
final _that = this;
switch (_that) {
case _Quote() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String currency,  Money subtotal,  Money discount,  Money tax,  Money total,  int durationMinutes,  bool pricesIncludeTax,  List<QuoteLine> lines)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Quote() when $default != null:
return $default(_that.currency,_that.subtotal,_that.discount,_that.tax,_that.total,_that.durationMinutes,_that.pricesIncludeTax,_that.lines);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String currency,  Money subtotal,  Money discount,  Money tax,  Money total,  int durationMinutes,  bool pricesIncludeTax,  List<QuoteLine> lines)  $default,) {final _that = this;
switch (_that) {
case _Quote():
return $default(_that.currency,_that.subtotal,_that.discount,_that.tax,_that.total,_that.durationMinutes,_that.pricesIncludeTax,_that.lines);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String currency,  Money subtotal,  Money discount,  Money tax,  Money total,  int durationMinutes,  bool pricesIncludeTax,  List<QuoteLine> lines)?  $default,) {final _that = this;
switch (_that) {
case _Quote() when $default != null:
return $default(_that.currency,_that.subtotal,_that.discount,_that.tax,_that.total,_that.durationMinutes,_that.pricesIncludeTax,_that.lines);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Quote implements Quote {
  const _Quote({required this.currency, required this.subtotal, required this.discount, required this.tax, required this.total, required this.durationMinutes, this.pricesIncludeTax = false,  List<QuoteLine> lines = const []}): _lines = lines;
  factory _Quote.fromJson(Map<String, dynamic> json) => _$QuoteFromJson(json);

@override final  String currency;
@override final  Money subtotal;
@override final  Money discount;
@override final  Money tax;
@override final  Money total;
@override final  int durationMinutes;
@override@JsonKey() final  bool pricesIncludeTax;
 final  List<QuoteLine> _lines;
@override@JsonKey() List<QuoteLine> get lines {
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lines);
}


/// Create a copy of Quote
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuoteCopyWith<_Quote> get copyWith => __$QuoteCopyWithImpl<_Quote>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuoteToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Quote&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.discount, discount) || other.discount == discount)&&(identical(other.tax, tax) || other.tax == tax)&&(identical(other.total, total) || other.total == total)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.pricesIncludeTax, pricesIncludeTax) || other.pricesIncludeTax == pricesIncludeTax)&&const DeepCollectionEquality().equals(other.lines, _lines));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,currency,subtotal,discount,tax,total,durationMinutes,pricesIncludeTax,const DeepCollectionEquality().hash(_lines));
}

@override
String toString() {
    return 'Quote(currency: $currency, subtotal: $subtotal, discount: $discount, tax: $tax, total: $total, durationMinutes: $durationMinutes, pricesIncludeTax: $pricesIncludeTax, lines: $lines)';
}


}

/// @nodoc
abstract mixin class _$QuoteCopyWith<$Res> implements $QuoteCopyWith<$Res> {
  factory _$QuoteCopyWith(_Quote value, $Res Function(_Quote) _then) = __$QuoteCopyWithImpl;
@override @useResult
$Res call({
 String currency, Money subtotal, Money discount, Money tax, Money total, int durationMinutes, bool pricesIncludeTax, List<QuoteLine> lines
});


@override $MoneyCopyWith<$Res> get subtotal;@override $MoneyCopyWith<$Res> get discount;@override $MoneyCopyWith<$Res> get tax;@override $MoneyCopyWith<$Res> get total;

}
/// @nodoc
class __$QuoteCopyWithImpl<$Res>
    implements _$QuoteCopyWith<$Res> {
  __$QuoteCopyWithImpl(this._self, this._then);

  final _Quote _self;
  final $Res Function(_Quote) _then;

/// Create a copy of Quote
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currency = null,Object? subtotal = null,Object? discount = null,Object? tax = null,Object? total = null,Object? durationMinutes = null,Object? pricesIncludeTax = null,Object? lines = null,}) {
  return _then(_Quote(
currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as Money,discount: null == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as Money,tax: null == tax ? _self.tax : tax // ignore: cast_nullable_to_non_nullable
as Money,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as Money,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,pricesIncludeTax: null == pricesIncludeTax ? _self.pricesIncludeTax : pricesIncludeTax // ignore: cast_nullable_to_non_nullable
as bool,lines: null == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<QuoteLine>,
  ));
}

/// Create a copy of Quote
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneyCopyWith<$Res> get subtotal {
  
  return $MoneyCopyWith<$Res>(_self.subtotal, (value) {
    return _then(_self.copyWith(subtotal: value));
  });
}/// Create a copy of Quote
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneyCopyWith<$Res> get discount {
  
  return $MoneyCopyWith<$Res>(_self.discount, (value) {
    return _then(_self.copyWith(discount: value));
  });
}/// Create a copy of Quote
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneyCopyWith<$Res> get tax {
  
  return $MoneyCopyWith<$Res>(_self.tax, (value) {
    return _then(_self.copyWith(tax: value));
  });
}/// Create a copy of Quote
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneyCopyWith<$Res> get total {
  
  return $MoneyCopyWith<$Res>(_self.total, (value) {
    return _then(_self.copyWith(total: value));
  });
}
}

// dart format on
