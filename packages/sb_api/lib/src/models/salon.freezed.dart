// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'salon.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SalonCard {

 String get id; String get slug;@LocalizedConverter() LocalizedText get name; String get currency; int get branchesCount; String? get logoUrl;@LocalizedOrNullConverter() LocalizedText? get address;@UtcDateTimeOrNullConverter() DateTime? get lastVisitAt;
/// Create a copy of SalonCard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SalonCardCopyWith<SalonCard> get copyWith => _$SalonCardCopyWithImpl<SalonCard>(this as SalonCard, _$identity);

  /// Serializes this SalonCard to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SalonCard;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SalonCard&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.slug, _this.slug) || other.slug == _this.slug)&&const DeepCollectionEquality().equals(other.name, _this.name)&&(identical(other.currency, _this.currency) || other.currency == _this.currency)&&(identical(other.branchesCount, _this.branchesCount) || other.branchesCount == _this.branchesCount)&&(identical(other.logoUrl, _this.logoUrl) || other.logoUrl == _this.logoUrl)&&const DeepCollectionEquality().equals(other.address, _this.address)&&(identical(other.lastVisitAt, _this.lastVisitAt) || other.lastVisitAt == _this.lastVisitAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SalonCard;
  return Object.hash(runtimeType,_this.id,_this.slug,const DeepCollectionEquality().hash(_this.name),_this.currency,_this.branchesCount,_this.logoUrl,const DeepCollectionEquality().hash(_this.address),_this.lastVisitAt);
}

@override
String toString() {
  final _this = this as SalonCard;
  return 'SalonCard(id: ${_this.id}, slug: ${_this.slug}, name: ${_this.name}, currency: ${_this.currency}, branchesCount: ${_this.branchesCount}, logoUrl: ${_this.logoUrl}, address: ${_this.address}, lastVisitAt: ${_this.lastVisitAt})';
}


}

/// @nodoc
abstract mixin class $SalonCardCopyWith<$Res>  {
  factory $SalonCardCopyWith(SalonCard value, $Res Function(SalonCard) _then) = _$SalonCardCopyWithImpl;
@useResult
$Res call({
 String id, String slug,@LocalizedConverter() LocalizedText name, String currency, int branchesCount, String? logoUrl,@LocalizedOrNullConverter() LocalizedText? address,@UtcDateTimeOrNullConverter() DateTime? lastVisitAt
});




}
/// @nodoc
class _$SalonCardCopyWithImpl<$Res>
    implements $SalonCardCopyWith<$Res> {
  _$SalonCardCopyWithImpl(this._self, this._then);

  final SalonCard _self;
  final $Res Function(SalonCard) _then;

/// Create a copy of SalonCard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? slug = null,Object? name = null,Object? currency = null,Object? branchesCount = null,Object? logoUrl = freezed,Object? address = freezed,Object? lastVisitAt = freezed,}) {
  return _then(SalonCard(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as LocalizedText,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,branchesCount: null == branchesCount ? _self.branchesCount : branchesCount // ignore: cast_nullable_to_non_nullable
as int,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as LocalizedText?,lastVisitAt: freezed == lastVisitAt ? _self.lastVisitAt : lastVisitAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [SalonCard].
extension SalonCardPatterns on SalonCard {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SalonCard value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SalonCard() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SalonCard value)  $default,){
final _that = this;
switch (_that) {
case _SalonCard():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SalonCard value)?  $default,){
final _that = this;
switch (_that) {
case _SalonCard() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String slug, @LocalizedConverter()  LocalizedText name,  String currency,  int branchesCount,  String? logoUrl, @LocalizedOrNullConverter()  LocalizedText? address, @UtcDateTimeOrNullConverter()  DateTime? lastVisitAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SalonCard() when $default != null:
return $default(_that.id,_that.slug,_that.name,_that.currency,_that.branchesCount,_that.logoUrl,_that.address,_that.lastVisitAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String slug, @LocalizedConverter()  LocalizedText name,  String currency,  int branchesCount,  String? logoUrl, @LocalizedOrNullConverter()  LocalizedText? address, @UtcDateTimeOrNullConverter()  DateTime? lastVisitAt)  $default,) {final _that = this;
switch (_that) {
case _SalonCard():
return $default(_that.id,_that.slug,_that.name,_that.currency,_that.branchesCount,_that.logoUrl,_that.address,_that.lastVisitAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String slug, @LocalizedConverter()  LocalizedText name,  String currency,  int branchesCount,  String? logoUrl, @LocalizedOrNullConverter()  LocalizedText? address, @UtcDateTimeOrNullConverter()  DateTime? lastVisitAt)?  $default,) {final _that = this;
switch (_that) {
case _SalonCard() when $default != null:
return $default(_that.id,_that.slug,_that.name,_that.currency,_that.branchesCount,_that.logoUrl,_that.address,_that.lastVisitAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SalonCard implements SalonCard {
  const _SalonCard({required this.id, required this.slug, @LocalizedConverter() required  LocalizedText name, required this.currency, this.branchesCount = 0, this.logoUrl, @LocalizedOrNullConverter()  LocalizedText? address, @UtcDateTimeOrNullConverter() this.lastVisitAt}): _name = name,_address = address;
  factory _SalonCard.fromJson(Map<String, dynamic> json) => _$SalonCardFromJson(json);

@override final  String id;
@override final  String slug;
 final  LocalizedText _name;
@override@LocalizedConverter() LocalizedText get name {
  if (_name is EqualUnmodifiableMapView) return _name;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_name);
}

@override final  String currency;
@override@JsonKey() final  int branchesCount;
@override final  String? logoUrl;
 final  LocalizedText? _address;
@override@LocalizedOrNullConverter() LocalizedText? get address {
  final value = _address;
  if (value == null) return null;
  if (_address is EqualUnmodifiableMapView) return _address;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override@UtcDateTimeOrNullConverter() final  DateTime? lastVisitAt;

/// Create a copy of SalonCard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SalonCardCopyWith<_SalonCard> get copyWith => __$SalonCardCopyWithImpl<_SalonCard>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SalonCardToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SalonCard&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&const DeepCollectionEquality().equals(other.name, _name)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.branchesCount, branchesCount) || other.branchesCount == branchesCount)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl)&&const DeepCollectionEquality().equals(other.address, _address)&&(identical(other.lastVisitAt, lastVisitAt) || other.lastVisitAt == lastVisitAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,slug,const DeepCollectionEquality().hash(_name),currency,branchesCount,logoUrl,const DeepCollectionEquality().hash(_address),lastVisitAt);
}

@override
String toString() {
    return 'SalonCard(id: $id, slug: $slug, name: $name, currency: $currency, branchesCount: $branchesCount, logoUrl: $logoUrl, address: $address, lastVisitAt: $lastVisitAt)';
}


}

/// @nodoc
abstract mixin class _$SalonCardCopyWith<$Res> implements $SalonCardCopyWith<$Res> {
  factory _$SalonCardCopyWith(_SalonCard value, $Res Function(_SalonCard) _then) = __$SalonCardCopyWithImpl;
@override @useResult
$Res call({
 String id, String slug,@LocalizedConverter() LocalizedText name, String currency, int branchesCount, String? logoUrl,@LocalizedOrNullConverter() LocalizedText? address,@UtcDateTimeOrNullConverter() DateTime? lastVisitAt
});




}
/// @nodoc
class __$SalonCardCopyWithImpl<$Res>
    implements _$SalonCardCopyWith<$Res> {
  __$SalonCardCopyWithImpl(this._self, this._then);

  final _SalonCard _self;
  final $Res Function(_SalonCard) _then;

/// Create a copy of SalonCard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? slug = null,Object? name = null,Object? currency = null,Object? branchesCount = null,Object? logoUrl = freezed,Object? address = freezed,Object? lastVisitAt = freezed,}) {
  return _then(_SalonCard(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self._name : name // ignore: cast_nullable_to_non_nullable
as LocalizedText,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,branchesCount: null == branchesCount ? _self.branchesCount : branchesCount // ignore: cast_nullable_to_non_nullable
as int,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self._address : address // ignore: cast_nullable_to_non_nullable
as LocalizedText?,lastVisitAt: freezed == lastVisitAt ? _self.lastVisitAt : lastVisitAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$GeoPoint {

 double get lat; double get lng;
/// Create a copy of GeoPoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GeoPointCopyWith<GeoPoint> get copyWith => _$GeoPointCopyWithImpl<GeoPoint>(this as GeoPoint, _$identity);

  /// Serializes this GeoPoint to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as GeoPoint;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GeoPoint&&(identical(other.lat, _this.lat) || other.lat == _this.lat)&&(identical(other.lng, _this.lng) || other.lng == _this.lng));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as GeoPoint;
  return Object.hash(runtimeType,_this.lat,_this.lng);
}

@override
String toString() {
  final _this = this as GeoPoint;
  return 'GeoPoint(lat: ${_this.lat}, lng: ${_this.lng})';
}


}

/// @nodoc
abstract mixin class $GeoPointCopyWith<$Res>  {
  factory $GeoPointCopyWith(GeoPoint value, $Res Function(GeoPoint) _then) = _$GeoPointCopyWithImpl;
@useResult
$Res call({
 double lat, double lng
});




}
/// @nodoc
class _$GeoPointCopyWithImpl<$Res>
    implements $GeoPointCopyWith<$Res> {
  _$GeoPointCopyWithImpl(this._self, this._then);

  final GeoPoint _self;
  final $Res Function(GeoPoint) _then;

/// Create a copy of GeoPoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lat = null,Object? lng = null,}) {
  return _then(GeoPoint(
lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [GeoPoint].
extension GeoPointPatterns on GeoPoint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GeoPoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GeoPoint() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GeoPoint value)  $default,){
final _that = this;
switch (_that) {
case _GeoPoint():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GeoPoint value)?  $default,){
final _that = this;
switch (_that) {
case _GeoPoint() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double lat,  double lng)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GeoPoint() when $default != null:
return $default(_that.lat,_that.lng);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double lat,  double lng)  $default,) {final _that = this;
switch (_that) {
case _GeoPoint():
return $default(_that.lat,_that.lng);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double lat,  double lng)?  $default,) {final _that = this;
switch (_that) {
case _GeoPoint() when $default != null:
return $default(_that.lat,_that.lng);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GeoPoint implements GeoPoint {
  const _GeoPoint({required this.lat, required this.lng});
  factory _GeoPoint.fromJson(Map<String, dynamic> json) => _$GeoPointFromJson(json);

@override final  double lat;
@override final  double lng;

/// Create a copy of GeoPoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GeoPointCopyWith<_GeoPoint> get copyWith => __$GeoPointCopyWithImpl<_GeoPoint>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GeoPointToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GeoPoint&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,lat,lng);
}

@override
String toString() {
    return 'GeoPoint(lat: $lat, lng: $lng)';
}


}

/// @nodoc
abstract mixin class _$GeoPointCopyWith<$Res> implements $GeoPointCopyWith<$Res> {
  factory _$GeoPointCopyWith(_GeoPoint value, $Res Function(_GeoPoint) _then) = __$GeoPointCopyWithImpl;
@override @useResult
$Res call({
 double lat, double lng
});




}
/// @nodoc
class __$GeoPointCopyWithImpl<$Res>
    implements _$GeoPointCopyWith<$Res> {
  __$GeoPointCopyWithImpl(this._self, this._then);

  final _GeoPoint _self;
  final $Res Function(_GeoPoint) _then;

/// Create a copy of GeoPoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lat = null,Object? lng = null,}) {
  return _then(_GeoPoint(
lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$TimeRange {

 String get start; String get end;
/// Create a copy of TimeRange
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimeRangeCopyWith<TimeRange> get copyWith => _$TimeRangeCopyWithImpl<TimeRange>(this as TimeRange, _$identity);

  /// Serializes this TimeRange to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TimeRange;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimeRange&&(identical(other.start, _this.start) || other.start == _this.start)&&(identical(other.end, _this.end) || other.end == _this.end));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TimeRange;
  return Object.hash(runtimeType,_this.start,_this.end);
}

@override
String toString() {
  final _this = this as TimeRange;
  return 'TimeRange(start: ${_this.start}, end: ${_this.end})';
}


}

/// @nodoc
abstract mixin class $TimeRangeCopyWith<$Res>  {
  factory $TimeRangeCopyWith(TimeRange value, $Res Function(TimeRange) _then) = _$TimeRangeCopyWithImpl;
@useResult
$Res call({
 String start, String end
});




}
/// @nodoc
class _$TimeRangeCopyWithImpl<$Res>
    implements $TimeRangeCopyWith<$Res> {
  _$TimeRangeCopyWithImpl(this._self, this._then);

  final TimeRange _self;
  final $Res Function(TimeRange) _then;

/// Create a copy of TimeRange
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? start = null,Object? end = null,}) {
  return _then(TimeRange(
start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as String,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TimeRange].
extension TimeRangePatterns on TimeRange {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TimeRange value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TimeRange() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TimeRange value)  $default,){
final _that = this;
switch (_that) {
case _TimeRange():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TimeRange value)?  $default,){
final _that = this;
switch (_that) {
case _TimeRange() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String start,  String end)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TimeRange() when $default != null:
return $default(_that.start,_that.end);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String start,  String end)  $default,) {final _that = this;
switch (_that) {
case _TimeRange():
return $default(_that.start,_that.end);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String start,  String end)?  $default,) {final _that = this;
switch (_that) {
case _TimeRange() when $default != null:
return $default(_that.start,_that.end);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TimeRange implements TimeRange {
  const _TimeRange({required this.start, required this.end});
  factory _TimeRange.fromJson(Map<String, dynamic> json) => _$TimeRangeFromJson(json);

@override final  String start;
@override final  String end;

/// Create a copy of TimeRange
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimeRangeCopyWith<_TimeRange> get copyWith => __$TimeRangeCopyWithImpl<_TimeRange>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TimeRangeToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimeRange&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,start,end);
}

@override
String toString() {
    return 'TimeRange(start: $start, end: $end)';
}


}

/// @nodoc
abstract mixin class _$TimeRangeCopyWith<$Res> implements $TimeRangeCopyWith<$Res> {
  factory _$TimeRangeCopyWith(_TimeRange value, $Res Function(_TimeRange) _then) = __$TimeRangeCopyWithImpl;
@override @useResult
$Res call({
 String start, String end
});




}
/// @nodoc
class __$TimeRangeCopyWithImpl<$Res>
    implements _$TimeRangeCopyWith<$Res> {
  __$TimeRangeCopyWithImpl(this._self, this._then);

  final _TimeRange _self;
  final $Res Function(_TimeRange) _then;

/// Create a copy of TimeRange
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? start = null,Object? end = null,}) {
  return _then(_TimeRange(
start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as String,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$BranchClosure {

 String get startsOn; String get endsOn;@LocalizedOrNullConverter() LocalizedText? get reason;
/// Create a copy of BranchClosure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BranchClosureCopyWith<BranchClosure> get copyWith => _$BranchClosureCopyWithImpl<BranchClosure>(this as BranchClosure, _$identity);

  /// Serializes this BranchClosure to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BranchClosure;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BranchClosure&&(identical(other.startsOn, _this.startsOn) || other.startsOn == _this.startsOn)&&(identical(other.endsOn, _this.endsOn) || other.endsOn == _this.endsOn)&&const DeepCollectionEquality().equals(other.reason, _this.reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BranchClosure;
  return Object.hash(runtimeType,_this.startsOn,_this.endsOn,const DeepCollectionEquality().hash(_this.reason));
}

@override
String toString() {
  final _this = this as BranchClosure;
  return 'BranchClosure(startsOn: ${_this.startsOn}, endsOn: ${_this.endsOn}, reason: ${_this.reason})';
}


}

/// @nodoc
abstract mixin class $BranchClosureCopyWith<$Res>  {
  factory $BranchClosureCopyWith(BranchClosure value, $Res Function(BranchClosure) _then) = _$BranchClosureCopyWithImpl;
@useResult
$Res call({
 String startsOn, String endsOn,@LocalizedOrNullConverter() LocalizedText? reason
});




}
/// @nodoc
class _$BranchClosureCopyWithImpl<$Res>
    implements $BranchClosureCopyWith<$Res> {
  _$BranchClosureCopyWithImpl(this._self, this._then);

  final BranchClosure _self;
  final $Res Function(BranchClosure) _then;

/// Create a copy of BranchClosure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? startsOn = null,Object? endsOn = null,Object? reason = freezed,}) {
  return _then(BranchClosure(
startsOn: null == startsOn ? _self.startsOn : startsOn // ignore: cast_nullable_to_non_nullable
as String,endsOn: null == endsOn ? _self.endsOn : endsOn // ignore: cast_nullable_to_non_nullable
as String,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as LocalizedText?,
  ));
}

}


/// Adds pattern-matching-related methods to [BranchClosure].
extension BranchClosurePatterns on BranchClosure {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BranchClosure value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BranchClosure() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BranchClosure value)  $default,){
final _that = this;
switch (_that) {
case _BranchClosure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BranchClosure value)?  $default,){
final _that = this;
switch (_that) {
case _BranchClosure() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String startsOn,  String endsOn, @LocalizedOrNullConverter()  LocalizedText? reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BranchClosure() when $default != null:
return $default(_that.startsOn,_that.endsOn,_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String startsOn,  String endsOn, @LocalizedOrNullConverter()  LocalizedText? reason)  $default,) {final _that = this;
switch (_that) {
case _BranchClosure():
return $default(_that.startsOn,_that.endsOn,_that.reason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String startsOn,  String endsOn, @LocalizedOrNullConverter()  LocalizedText? reason)?  $default,) {final _that = this;
switch (_that) {
case _BranchClosure() when $default != null:
return $default(_that.startsOn,_that.endsOn,_that.reason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BranchClosure implements BranchClosure {
  const _BranchClosure({required this.startsOn, required this.endsOn, @LocalizedOrNullConverter()  LocalizedText? reason}): _reason = reason;
  factory _BranchClosure.fromJson(Map<String, dynamic> json) => _$BranchClosureFromJson(json);

@override final  String startsOn;
@override final  String endsOn;
 final  LocalizedText? _reason;
@override@LocalizedOrNullConverter() LocalizedText? get reason {
  final value = _reason;
  if (value == null) return null;
  if (_reason is EqualUnmodifiableMapView) return _reason;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of BranchClosure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BranchClosureCopyWith<_BranchClosure> get copyWith => __$BranchClosureCopyWithImpl<_BranchClosure>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BranchClosureToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BranchClosure&&(identical(other.startsOn, startsOn) || other.startsOn == startsOn)&&(identical(other.endsOn, endsOn) || other.endsOn == endsOn)&&const DeepCollectionEquality().equals(other.reason, _reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,startsOn,endsOn,const DeepCollectionEquality().hash(_reason));
}

@override
String toString() {
    return 'BranchClosure(startsOn: $startsOn, endsOn: $endsOn, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$BranchClosureCopyWith<$Res> implements $BranchClosureCopyWith<$Res> {
  factory _$BranchClosureCopyWith(_BranchClosure value, $Res Function(_BranchClosure) _then) = __$BranchClosureCopyWithImpl;
@override @useResult
$Res call({
 String startsOn, String endsOn,@LocalizedOrNullConverter() LocalizedText? reason
});




}
/// @nodoc
class __$BranchClosureCopyWithImpl<$Res>
    implements _$BranchClosureCopyWith<$Res> {
  __$BranchClosureCopyWithImpl(this._self, this._then);

  final _BranchClosure _self;
  final $Res Function(_BranchClosure) _then;

/// Create a copy of BranchClosure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? startsOn = null,Object? endsOn = null,Object? reason = freezed,}) {
  return _then(_BranchClosure(
startsOn: null == startsOn ? _self.startsOn : startsOn // ignore: cast_nullable_to_non_nullable
as String,endsOn: null == endsOn ? _self.endsOn : endsOn // ignore: cast_nullable_to_non_nullable
as String,reason: freezed == reason ? _self._reason : reason // ignore: cast_nullable_to_non_nullable
as LocalizedText?,
  ));
}


}


/// @nodoc
mixin _$SalonBranch {

 String get id;@LocalizedConverter() LocalizedText get name;@LocalizedConverter() LocalizedText get address; String get timezone; GeoPoint? get location; String? get phone; List<TimeRange> get today;@WeekConverter() List<List<TimeRange>>? get week; List<BranchClosure> get closures;
/// Create a copy of SalonBranch
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SalonBranchCopyWith<SalonBranch> get copyWith => _$SalonBranchCopyWithImpl<SalonBranch>(this as SalonBranch, _$identity);

  /// Serializes this SalonBranch to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SalonBranch;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SalonBranch&&(identical(other.id, _this.id) || other.id == _this.id)&&const DeepCollectionEquality().equals(other.name, _this.name)&&const DeepCollectionEquality().equals(other.address, _this.address)&&(identical(other.timezone, _this.timezone) || other.timezone == _this.timezone)&&(identical(other.location, _this.location) || other.location == _this.location)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&const DeepCollectionEquality().equals(other.today, _this.today)&&const DeepCollectionEquality().equals(other.week, _this.week)&&const DeepCollectionEquality().equals(other.closures, _this.closures));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SalonBranch;
  return Object.hash(runtimeType,_this.id,const DeepCollectionEquality().hash(_this.name),const DeepCollectionEquality().hash(_this.address),_this.timezone,_this.location,_this.phone,const DeepCollectionEquality().hash(_this.today),const DeepCollectionEquality().hash(_this.week),const DeepCollectionEquality().hash(_this.closures));
}

@override
String toString() {
  final _this = this as SalonBranch;
  return 'SalonBranch(id: ${_this.id}, name: ${_this.name}, address: ${_this.address}, timezone: ${_this.timezone}, location: ${_this.location}, phone: ${_this.phone}, today: ${_this.today}, week: ${_this.week}, closures: ${_this.closures})';
}


}

/// @nodoc
abstract mixin class $SalonBranchCopyWith<$Res>  {
  factory $SalonBranchCopyWith(SalonBranch value, $Res Function(SalonBranch) _then) = _$SalonBranchCopyWithImpl;
@useResult
$Res call({
 String id,@LocalizedConverter() LocalizedText name,@LocalizedConverter() LocalizedText address, String timezone, GeoPoint? location, String? phone, List<TimeRange> today,@WeekConverter() List<List<TimeRange>>? week, List<BranchClosure> closures
});


$GeoPointCopyWith<$Res>? get location;

}
/// @nodoc
class _$SalonBranchCopyWithImpl<$Res>
    implements $SalonBranchCopyWith<$Res> {
  _$SalonBranchCopyWithImpl(this._self, this._then);

  final SalonBranch _self;
  final $Res Function(SalonBranch) _then;

/// Create a copy of SalonBranch
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? address = null,Object? timezone = null,Object? location = freezed,Object? phone = freezed,Object? today = null,Object? week = freezed,Object? closures = null,}) {
  return _then(SalonBranch(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as LocalizedText,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as LocalizedText,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as GeoPoint?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,today: null == today ? _self.today : today // ignore: cast_nullable_to_non_nullable
as List<TimeRange>,week: freezed == week ? _self.week : week // ignore: cast_nullable_to_non_nullable
as List<List<TimeRange>>?,closures: null == closures ? _self.closures : closures // ignore: cast_nullable_to_non_nullable
as List<BranchClosure>,
  ));
}
/// Create a copy of SalonBranch
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeoPointCopyWith<$Res>? get location {
    if (_self.location == null) {
    return null;
  }

  return $GeoPointCopyWith<$Res>(_self.location!, (value) {
    return _then(_self.copyWith(location: value));
  });
}
}


/// Adds pattern-matching-related methods to [SalonBranch].
extension SalonBranchPatterns on SalonBranch {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SalonBranch value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SalonBranch() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SalonBranch value)  $default,){
final _that = this;
switch (_that) {
case _SalonBranch():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SalonBranch value)?  $default,){
final _that = this;
switch (_that) {
case _SalonBranch() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @LocalizedConverter()  LocalizedText name, @LocalizedConverter()  LocalizedText address,  String timezone,  GeoPoint? location,  String? phone,  List<TimeRange> today, @WeekConverter()  List<List<TimeRange>>? week,  List<BranchClosure> closures)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SalonBranch() when $default != null:
return $default(_that.id,_that.name,_that.address,_that.timezone,_that.location,_that.phone,_that.today,_that.week,_that.closures);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @LocalizedConverter()  LocalizedText name, @LocalizedConverter()  LocalizedText address,  String timezone,  GeoPoint? location,  String? phone,  List<TimeRange> today, @WeekConverter()  List<List<TimeRange>>? week,  List<BranchClosure> closures)  $default,) {final _that = this;
switch (_that) {
case _SalonBranch():
return $default(_that.id,_that.name,_that.address,_that.timezone,_that.location,_that.phone,_that.today,_that.week,_that.closures);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @LocalizedConverter()  LocalizedText name, @LocalizedConverter()  LocalizedText address,  String timezone,  GeoPoint? location,  String? phone,  List<TimeRange> today, @WeekConverter()  List<List<TimeRange>>? week,  List<BranchClosure> closures)?  $default,) {final _that = this;
switch (_that) {
case _SalonBranch() when $default != null:
return $default(_that.id,_that.name,_that.address,_that.timezone,_that.location,_that.phone,_that.today,_that.week,_that.closures);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SalonBranch implements SalonBranch {
  const _SalonBranch({required this.id, @LocalizedConverter() required  LocalizedText name, @LocalizedConverter() required  LocalizedText address, required this.timezone, this.location, this.phone,  List<TimeRange> today = const [], @WeekConverter()  List<List<TimeRange>>? week,  List<BranchClosure> closures = const []}): _name = name,_address = address,_today = today,_week = week,_closures = closures;
  factory _SalonBranch.fromJson(Map<String, dynamic> json) => _$SalonBranchFromJson(json);

@override final  String id;
 final  LocalizedText _name;
@override@LocalizedConverter() LocalizedText get name {
  if (_name is EqualUnmodifiableMapView) return _name;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_name);
}

 final  LocalizedText _address;
@override@LocalizedConverter() LocalizedText get address {
  if (_address is EqualUnmodifiableMapView) return _address;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_address);
}

@override final  String timezone;
@override final  GeoPoint? location;
@override final  String? phone;
 final  List<TimeRange> _today;
@override@JsonKey() List<TimeRange> get today {
  if (_today is EqualUnmodifiableListView) return _today;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_today);
}

 final  List<List<TimeRange>>? _week;
@override@WeekConverter() List<List<TimeRange>>? get week {
  final value = _week;
  if (value == null) return null;
  if (_week is EqualUnmodifiableListView) return _week;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<BranchClosure> _closures;
@override@JsonKey() List<BranchClosure> get closures {
  if (_closures is EqualUnmodifiableListView) return _closures;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_closures);
}


/// Create a copy of SalonBranch
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SalonBranchCopyWith<_SalonBranch> get copyWith => __$SalonBranchCopyWithImpl<_SalonBranch>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SalonBranchToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SalonBranch&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.name, _name)&&const DeepCollectionEquality().equals(other.address, _address)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.location, location) || other.location == location)&&(identical(other.phone, phone) || other.phone == phone)&&const DeepCollectionEquality().equals(other.today, _today)&&const DeepCollectionEquality().equals(other.week, _week)&&const DeepCollectionEquality().equals(other.closures, _closures));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_name),const DeepCollectionEquality().hash(_address),timezone,location,phone,const DeepCollectionEquality().hash(_today),const DeepCollectionEquality().hash(_week),const DeepCollectionEquality().hash(_closures));
}

@override
String toString() {
    return 'SalonBranch(id: $id, name: $name, address: $address, timezone: $timezone, location: $location, phone: $phone, today: $today, week: $week, closures: $closures)';
}


}

/// @nodoc
abstract mixin class _$SalonBranchCopyWith<$Res> implements $SalonBranchCopyWith<$Res> {
  factory _$SalonBranchCopyWith(_SalonBranch value, $Res Function(_SalonBranch) _then) = __$SalonBranchCopyWithImpl;
@override @useResult
$Res call({
 String id,@LocalizedConverter() LocalizedText name,@LocalizedConverter() LocalizedText address, String timezone, GeoPoint? location, String? phone, List<TimeRange> today,@WeekConverter() List<List<TimeRange>>? week, List<BranchClosure> closures
});


@override $GeoPointCopyWith<$Res>? get location;

}
/// @nodoc
class __$SalonBranchCopyWithImpl<$Res>
    implements _$SalonBranchCopyWith<$Res> {
  __$SalonBranchCopyWithImpl(this._self, this._then);

  final _SalonBranch _self;
  final $Res Function(_SalonBranch) _then;

/// Create a copy of SalonBranch
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? address = null,Object? timezone = null,Object? location = freezed,Object? phone = freezed,Object? today = null,Object? week = freezed,Object? closures = null,}) {
  return _then(_SalonBranch(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self._name : name // ignore: cast_nullable_to_non_nullable
as LocalizedText,address: null == address ? _self._address : address // ignore: cast_nullable_to_non_nullable
as LocalizedText,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as GeoPoint?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,today: null == today ? _self._today : today // ignore: cast_nullable_to_non_nullable
as List<TimeRange>,week: freezed == week ? _self._week : week // ignore: cast_nullable_to_non_nullable
as List<List<TimeRange>>?,closures: null == closures ? _self._closures : closures // ignore: cast_nullable_to_non_nullable
as List<BranchClosure>,
  ));
}

/// Create a copy of SalonBranch
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeoPointCopyWith<$Res>? get location {
    if (_self.location == null) {
    return null;
  }

  return $GeoPointCopyWith<$Res>(_self.location!, (value) {
    return _then(_self.copyWith(location: value));
  });
}
}


/// @nodoc
mixin _$SalonProfile {

 String get id; String get slug;@LocalizedConverter() LocalizedText get name; String get currency; String? get logoUrl; String? get coverUrl; List<String> get features;
/// Create a copy of SalonProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SalonProfileCopyWith<SalonProfile> get copyWith => _$SalonProfileCopyWithImpl<SalonProfile>(this as SalonProfile, _$identity);

  /// Serializes this SalonProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SalonProfile;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SalonProfile&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.slug, _this.slug) || other.slug == _this.slug)&&const DeepCollectionEquality().equals(other.name, _this.name)&&(identical(other.currency, _this.currency) || other.currency == _this.currency)&&(identical(other.logoUrl, _this.logoUrl) || other.logoUrl == _this.logoUrl)&&(identical(other.coverUrl, _this.coverUrl) || other.coverUrl == _this.coverUrl)&&const DeepCollectionEquality().equals(other.features, _this.features));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SalonProfile;
  return Object.hash(runtimeType,_this.id,_this.slug,const DeepCollectionEquality().hash(_this.name),_this.currency,_this.logoUrl,_this.coverUrl,const DeepCollectionEquality().hash(_this.features));
}

@override
String toString() {
  final _this = this as SalonProfile;
  return 'SalonProfile(id: ${_this.id}, slug: ${_this.slug}, name: ${_this.name}, currency: ${_this.currency}, logoUrl: ${_this.logoUrl}, coverUrl: ${_this.coverUrl}, features: ${_this.features})';
}


}

/// @nodoc
abstract mixin class $SalonProfileCopyWith<$Res>  {
  factory $SalonProfileCopyWith(SalonProfile value, $Res Function(SalonProfile) _then) = _$SalonProfileCopyWithImpl;
@useResult
$Res call({
 String id, String slug,@LocalizedConverter() LocalizedText name, String currency, String? logoUrl, String? coverUrl, List<String> features
});




}
/// @nodoc
class _$SalonProfileCopyWithImpl<$Res>
    implements $SalonProfileCopyWith<$Res> {
  _$SalonProfileCopyWithImpl(this._self, this._then);

  final SalonProfile _self;
  final $Res Function(SalonProfile) _then;

/// Create a copy of SalonProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? slug = null,Object? name = null,Object? currency = null,Object? logoUrl = freezed,Object? coverUrl = freezed,Object? features = null,}) {
  return _then(SalonProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as LocalizedText,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,features: null == features ? _self.features : features // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [SalonProfile].
extension SalonProfilePatterns on SalonProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SalonProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SalonProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SalonProfile value)  $default,){
final _that = this;
switch (_that) {
case _SalonProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SalonProfile value)?  $default,){
final _that = this;
switch (_that) {
case _SalonProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String slug, @LocalizedConverter()  LocalizedText name,  String currency,  String? logoUrl,  String? coverUrl,  List<String> features)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SalonProfile() when $default != null:
return $default(_that.id,_that.slug,_that.name,_that.currency,_that.logoUrl,_that.coverUrl,_that.features);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String slug, @LocalizedConverter()  LocalizedText name,  String currency,  String? logoUrl,  String? coverUrl,  List<String> features)  $default,) {final _that = this;
switch (_that) {
case _SalonProfile():
return $default(_that.id,_that.slug,_that.name,_that.currency,_that.logoUrl,_that.coverUrl,_that.features);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String slug, @LocalizedConverter()  LocalizedText name,  String currency,  String? logoUrl,  String? coverUrl,  List<String> features)?  $default,) {final _that = this;
switch (_that) {
case _SalonProfile() when $default != null:
return $default(_that.id,_that.slug,_that.name,_that.currency,_that.logoUrl,_that.coverUrl,_that.features);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SalonProfile implements SalonProfile {
  const _SalonProfile({required this.id, required this.slug, @LocalizedConverter() required  LocalizedText name, required this.currency, this.logoUrl, this.coverUrl,  List<String> features = const []}): _name = name,_features = features;
  factory _SalonProfile.fromJson(Map<String, dynamic> json) => _$SalonProfileFromJson(json);

@override final  String id;
@override final  String slug;
 final  LocalizedText _name;
@override@LocalizedConverter() LocalizedText get name {
  if (_name is EqualUnmodifiableMapView) return _name;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_name);
}

@override final  String currency;
@override final  String? logoUrl;
@override final  String? coverUrl;
 final  List<String> _features;
@override@JsonKey() List<String> get features {
  if (_features is EqualUnmodifiableListView) return _features;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_features);
}


/// Create a copy of SalonProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SalonProfileCopyWith<_SalonProfile> get copyWith => __$SalonProfileCopyWithImpl<_SalonProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SalonProfileToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SalonProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&const DeepCollectionEquality().equals(other.name, _name)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&const DeepCollectionEquality().equals(other.features, _features));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,slug,const DeepCollectionEquality().hash(_name),currency,logoUrl,coverUrl,const DeepCollectionEquality().hash(_features));
}

@override
String toString() {
    return 'SalonProfile(id: $id, slug: $slug, name: $name, currency: $currency, logoUrl: $logoUrl, coverUrl: $coverUrl, features: $features)';
}


}

/// @nodoc
abstract mixin class _$SalonProfileCopyWith<$Res> implements $SalonProfileCopyWith<$Res> {
  factory _$SalonProfileCopyWith(_SalonProfile value, $Res Function(_SalonProfile) _then) = __$SalonProfileCopyWithImpl;
@override @useResult
$Res call({
 String id, String slug,@LocalizedConverter() LocalizedText name, String currency, String? logoUrl, String? coverUrl, List<String> features
});




}
/// @nodoc
class __$SalonProfileCopyWithImpl<$Res>
    implements _$SalonProfileCopyWith<$Res> {
  __$SalonProfileCopyWithImpl(this._self, this._then);

  final _SalonProfile _self;
  final $Res Function(_SalonProfile) _then;

/// Create a copy of SalonProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? slug = null,Object? name = null,Object? currency = null,Object? logoUrl = freezed,Object? coverUrl = freezed,Object? features = null,}) {
  return _then(_SalonProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self._name : name // ignore: cast_nullable_to_non_nullable
as LocalizedText,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,features: null == features ? _self._features : features // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
