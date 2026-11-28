// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BookingBarber {

 String get id;@LocalizedConverter() LocalizedText get name;
/// Create a copy of BookingBarber
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingBarberCopyWith<BookingBarber> get copyWith => _$BookingBarberCopyWithImpl<BookingBarber>(this as BookingBarber, _$identity);

  /// Serializes this BookingBarber to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BookingBarber;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingBarber&&(identical(other.id, _this.id) || other.id == _this.id)&&const DeepCollectionEquality().equals(other.name, _this.name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BookingBarber;
  return Object.hash(runtimeType,_this.id,const DeepCollectionEquality().hash(_this.name));
}

@override
String toString() {
  final _this = this as BookingBarber;
  return 'BookingBarber(id: ${_this.id}, name: ${_this.name})';
}


}

/// @nodoc
abstract mixin class $BookingBarberCopyWith<$Res>  {
  factory $BookingBarberCopyWith(BookingBarber value, $Res Function(BookingBarber) _then) = _$BookingBarberCopyWithImpl;
@useResult
$Res call({
 String id,@LocalizedConverter() LocalizedText name
});




}
/// @nodoc
class _$BookingBarberCopyWithImpl<$Res>
    implements $BookingBarberCopyWith<$Res> {
  _$BookingBarberCopyWithImpl(this._self, this._then);

  final BookingBarber _self;
  final $Res Function(BookingBarber) _then;

/// Create a copy of BookingBarber
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(BookingBarber(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as LocalizedText,
  ));
}

}


/// Adds pattern-matching-related methods to [BookingBarber].
extension BookingBarberPatterns on BookingBarber {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookingBarber value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookingBarber() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookingBarber value)  $default,){
final _that = this;
switch (_that) {
case _BookingBarber():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookingBarber value)?  $default,){
final _that = this;
switch (_that) {
case _BookingBarber() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @LocalizedConverter()  LocalizedText name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookingBarber() when $default != null:
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @LocalizedConverter()  LocalizedText name)  $default,) {final _that = this;
switch (_that) {
case _BookingBarber():
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @LocalizedConverter()  LocalizedText name)?  $default,) {final _that = this;
switch (_that) {
case _BookingBarber() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BookingBarber implements BookingBarber {
  const _BookingBarber({required this.id, @LocalizedConverter() required  LocalizedText name}): _name = name;
  factory _BookingBarber.fromJson(Map<String, dynamic> json) => _$BookingBarberFromJson(json);

@override final  String id;
 final  LocalizedText _name;
@override@LocalizedConverter() LocalizedText get name {
  if (_name is EqualUnmodifiableMapView) return _name;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_name);
}


/// Create a copy of BookingBarber
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingBarberCopyWith<_BookingBarber> get copyWith => __$BookingBarberCopyWithImpl<_BookingBarber>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookingBarberToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingBarber&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.name, _name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_name));
}

@override
String toString() {
    return 'BookingBarber(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$BookingBarberCopyWith<$Res> implements $BookingBarberCopyWith<$Res> {
  factory _$BookingBarberCopyWith(_BookingBarber value, $Res Function(_BookingBarber) _then) = __$BookingBarberCopyWithImpl;
@override @useResult
$Res call({
 String id,@LocalizedConverter() LocalizedText name
});




}
/// @nodoc
class __$BookingBarberCopyWithImpl<$Res>
    implements _$BookingBarberCopyWith<$Res> {
  __$BookingBarberCopyWithImpl(this._self, this._then);

  final _BookingBarber _self;
  final $Res Function(_BookingBarber) _then;

/// Create a copy of BookingBarber
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(_BookingBarber(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self._name : name // ignore: cast_nullable_to_non_nullable
as LocalizedText,
  ));
}


}


/// @nodoc
mixin _$BookingItem {

 String get type;@LocalizedConverter() LocalizedText get name; int get durationMinutes; Money get total; String? get service;
/// Create a copy of BookingItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingItemCopyWith<BookingItem> get copyWith => _$BookingItemCopyWithImpl<BookingItem>(this as BookingItem, _$identity);

  /// Serializes this BookingItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BookingItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingItem&&(identical(other.type, _this.type) || other.type == _this.type)&&const DeepCollectionEquality().equals(other.name, _this.name)&&(identical(other.durationMinutes, _this.durationMinutes) || other.durationMinutes == _this.durationMinutes)&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.service, _this.service) || other.service == _this.service));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BookingItem;
  return Object.hash(runtimeType,_this.type,const DeepCollectionEquality().hash(_this.name),_this.durationMinutes,_this.total,_this.service);
}

@override
String toString() {
  final _this = this as BookingItem;
  return 'BookingItem(type: ${_this.type}, name: ${_this.name}, durationMinutes: ${_this.durationMinutes}, total: ${_this.total}, service: ${_this.service})';
}


}

/// @nodoc
abstract mixin class $BookingItemCopyWith<$Res>  {
  factory $BookingItemCopyWith(BookingItem value, $Res Function(BookingItem) _then) = _$BookingItemCopyWithImpl;
@useResult
$Res call({
 String type,@LocalizedConverter() LocalizedText name, int durationMinutes, Money total, String? service
});


$MoneyCopyWith<$Res> get total;

}
/// @nodoc
class _$BookingItemCopyWithImpl<$Res>
    implements $BookingItemCopyWith<$Res> {
  _$BookingItemCopyWithImpl(this._self, this._then);

  final BookingItem _self;
  final $Res Function(BookingItem) _then;

/// Create a copy of BookingItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? name = null,Object? durationMinutes = null,Object? total = null,Object? service = freezed,}) {
  return _then(BookingItem(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as LocalizedText,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as Money,service: freezed == service ? _self.service : service // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of BookingItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneyCopyWith<$Res> get total {
  
  return $MoneyCopyWith<$Res>(_self.total, (value) {
    return _then(_self.copyWith(total: value));
  });
}
}


/// Adds pattern-matching-related methods to [BookingItem].
extension BookingItemPatterns on BookingItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookingItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookingItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookingItem value)  $default,){
final _that = this;
switch (_that) {
case _BookingItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookingItem value)?  $default,){
final _that = this;
switch (_that) {
case _BookingItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type, @LocalizedConverter()  LocalizedText name,  int durationMinutes,  Money total,  String? service)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookingItem() when $default != null:
return $default(_that.type,_that.name,_that.durationMinutes,_that.total,_that.service);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type, @LocalizedConverter()  LocalizedText name,  int durationMinutes,  Money total,  String? service)  $default,) {final _that = this;
switch (_that) {
case _BookingItem():
return $default(_that.type,_that.name,_that.durationMinutes,_that.total,_that.service);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type, @LocalizedConverter()  LocalizedText name,  int durationMinutes,  Money total,  String? service)?  $default,) {final _that = this;
switch (_that) {
case _BookingItem() when $default != null:
return $default(_that.type,_that.name,_that.durationMinutes,_that.total,_that.service);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BookingItem implements BookingItem {
  const _BookingItem({required this.type, @LocalizedConverter() required  LocalizedText name, required this.durationMinutes, required this.total, this.service}): _name = name;
  factory _BookingItem.fromJson(Map<String, dynamic> json) => _$BookingItemFromJson(json);

@override final  String type;
 final  LocalizedText _name;
@override@LocalizedConverter() LocalizedText get name {
  if (_name is EqualUnmodifiableMapView) return _name;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_name);
}

@override final  int durationMinutes;
@override final  Money total;
@override final  String? service;

/// Create a copy of BookingItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingItemCopyWith<_BookingItem> get copyWith => __$BookingItemCopyWithImpl<_BookingItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookingItemToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingItem&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.name, _name)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.total, total) || other.total == total)&&(identical(other.service, service) || other.service == service));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,type,const DeepCollectionEquality().hash(_name),durationMinutes,total,service);
}

@override
String toString() {
    return 'BookingItem(type: $type, name: $name, durationMinutes: $durationMinutes, total: $total, service: $service)';
}


}

/// @nodoc
abstract mixin class _$BookingItemCopyWith<$Res> implements $BookingItemCopyWith<$Res> {
  factory _$BookingItemCopyWith(_BookingItem value, $Res Function(_BookingItem) _then) = __$BookingItemCopyWithImpl;
@override @useResult
$Res call({
 String type,@LocalizedConverter() LocalizedText name, int durationMinutes, Money total, String? service
});


@override $MoneyCopyWith<$Res> get total;

}
/// @nodoc
class __$BookingItemCopyWithImpl<$Res>
    implements _$BookingItemCopyWith<$Res> {
  __$BookingItemCopyWithImpl(this._self, this._then);

  final _BookingItem _self;
  final $Res Function(_BookingItem) _then;

/// Create a copy of BookingItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? name = null,Object? durationMinutes = null,Object? total = null,Object? service = freezed,}) {
  return _then(_BookingItem(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self._name : name // ignore: cast_nullable_to_non_nullable
as LocalizedText,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as Money,service: freezed == service ? _self.service : service // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of BookingItem
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
mixin _$BookingHistoryEntry {

 String get to;@UtcDateTimeConverter() DateTime get at; String? get from; String? get actor; String? get reason; bool get rescheduled;
/// Create a copy of BookingHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingHistoryEntryCopyWith<BookingHistoryEntry> get copyWith => _$BookingHistoryEntryCopyWithImpl<BookingHistoryEntry>(this as BookingHistoryEntry, _$identity);

  /// Serializes this BookingHistoryEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BookingHistoryEntry;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingHistoryEntry&&(identical(other.to, _this.to) || other.to == _this.to)&&(identical(other.at, _this.at) || other.at == _this.at)&&(identical(other.from, _this.from) || other.from == _this.from)&&(identical(other.actor, _this.actor) || other.actor == _this.actor)&&(identical(other.reason, _this.reason) || other.reason == _this.reason)&&(identical(other.rescheduled, _this.rescheduled) || other.rescheduled == _this.rescheduled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BookingHistoryEntry;
  return Object.hash(runtimeType,_this.to,_this.at,_this.from,_this.actor,_this.reason,_this.rescheduled);
}

@override
String toString() {
  final _this = this as BookingHistoryEntry;
  return 'BookingHistoryEntry(to: ${_this.to}, at: ${_this.at}, from: ${_this.from}, actor: ${_this.actor}, reason: ${_this.reason}, rescheduled: ${_this.rescheduled})';
}


}

/// @nodoc
abstract mixin class $BookingHistoryEntryCopyWith<$Res>  {
  factory $BookingHistoryEntryCopyWith(BookingHistoryEntry value, $Res Function(BookingHistoryEntry) _then) = _$BookingHistoryEntryCopyWithImpl;
@useResult
$Res call({
 String to,@UtcDateTimeConverter() DateTime at, String? from, String? actor, String? reason, bool rescheduled
});




}
/// @nodoc
class _$BookingHistoryEntryCopyWithImpl<$Res>
    implements $BookingHistoryEntryCopyWith<$Res> {
  _$BookingHistoryEntryCopyWithImpl(this._self, this._then);

  final BookingHistoryEntry _self;
  final $Res Function(BookingHistoryEntry) _then;

/// Create a copy of BookingHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? to = null,Object? at = null,Object? from = freezed,Object? actor = freezed,Object? reason = freezed,Object? rescheduled = null,}) {
  return _then(BookingHistoryEntry(
to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as String,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,from: freezed == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as String?,actor: freezed == actor ? _self.actor : actor // ignore: cast_nullable_to_non_nullable
as String?,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,rescheduled: null == rescheduled ? _self.rescheduled : rescheduled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [BookingHistoryEntry].
extension BookingHistoryEntryPatterns on BookingHistoryEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookingHistoryEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookingHistoryEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookingHistoryEntry value)  $default,){
final _that = this;
switch (_that) {
case _BookingHistoryEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookingHistoryEntry value)?  $default,){
final _that = this;
switch (_that) {
case _BookingHistoryEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String to, @UtcDateTimeConverter()  DateTime at,  String? from,  String? actor,  String? reason,  bool rescheduled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookingHistoryEntry() when $default != null:
return $default(_that.to,_that.at,_that.from,_that.actor,_that.reason,_that.rescheduled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String to, @UtcDateTimeConverter()  DateTime at,  String? from,  String? actor,  String? reason,  bool rescheduled)  $default,) {final _that = this;
switch (_that) {
case _BookingHistoryEntry():
return $default(_that.to,_that.at,_that.from,_that.actor,_that.reason,_that.rescheduled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String to, @UtcDateTimeConverter()  DateTime at,  String? from,  String? actor,  String? reason,  bool rescheduled)?  $default,) {final _that = this;
switch (_that) {
case _BookingHistoryEntry() when $default != null:
return $default(_that.to,_that.at,_that.from,_that.actor,_that.reason,_that.rescheduled);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BookingHistoryEntry implements BookingHistoryEntry {
  const _BookingHistoryEntry({required this.to, @UtcDateTimeConverter() required this.at, this.from, this.actor, this.reason, this.rescheduled = false});
  factory _BookingHistoryEntry.fromJson(Map<String, dynamic> json) => _$BookingHistoryEntryFromJson(json);

@override final  String to;
@override@UtcDateTimeConverter() final  DateTime at;
@override final  String? from;
@override final  String? actor;
@override final  String? reason;
@override@JsonKey() final  bool rescheduled;

/// Create a copy of BookingHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingHistoryEntryCopyWith<_BookingHistoryEntry> get copyWith => __$BookingHistoryEntryCopyWithImpl<_BookingHistoryEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookingHistoryEntryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingHistoryEntry&&(identical(other.to, to) || other.to == to)&&(identical(other.at, at) || other.at == at)&&(identical(other.from, from) || other.from == from)&&(identical(other.actor, actor) || other.actor == actor)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.rescheduled, rescheduled) || other.rescheduled == rescheduled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,to,at,from,actor,reason,rescheduled);
}

@override
String toString() {
    return 'BookingHistoryEntry(to: $to, at: $at, from: $from, actor: $actor, reason: $reason, rescheduled: $rescheduled)';
}


}

/// @nodoc
abstract mixin class _$BookingHistoryEntryCopyWith<$Res> implements $BookingHistoryEntryCopyWith<$Res> {
  factory _$BookingHistoryEntryCopyWith(_BookingHistoryEntry value, $Res Function(_BookingHistoryEntry) _then) = __$BookingHistoryEntryCopyWithImpl;
@override @useResult
$Res call({
 String to,@UtcDateTimeConverter() DateTime at, String? from, String? actor, String? reason, bool rescheduled
});




}
/// @nodoc
class __$BookingHistoryEntryCopyWithImpl<$Res>
    implements _$BookingHistoryEntryCopyWith<$Res> {
  __$BookingHistoryEntryCopyWithImpl(this._self, this._then);

  final _BookingHistoryEntry _self;
  final $Res Function(_BookingHistoryEntry) _then;

/// Create a copy of BookingHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? to = null,Object? at = null,Object? from = freezed,Object? actor = freezed,Object? reason = freezed,Object? rescheduled = null,}) {
  return _then(_BookingHistoryEntry(
to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as String,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,from: freezed == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as String?,actor: freezed == actor ? _self.actor : actor // ignore: cast_nullable_to_non_nullable
as String?,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,rescheduled: null == rescheduled ? _self.rescheduled : rescheduled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$BookingBranch {

 String get id;@LocalizedConverter() LocalizedText get name;@LocalizedConverter() LocalizedText get address; String get timezone; GeoPoint? get location; String? get phone;
/// Create a copy of BookingBranch
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingBranchCopyWith<BookingBranch> get copyWith => _$BookingBranchCopyWithImpl<BookingBranch>(this as BookingBranch, _$identity);

  /// Serializes this BookingBranch to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BookingBranch;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingBranch&&(identical(other.id, _this.id) || other.id == _this.id)&&const DeepCollectionEquality().equals(other.name, _this.name)&&const DeepCollectionEquality().equals(other.address, _this.address)&&(identical(other.timezone, _this.timezone) || other.timezone == _this.timezone)&&(identical(other.location, _this.location) || other.location == _this.location)&&(identical(other.phone, _this.phone) || other.phone == _this.phone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BookingBranch;
  return Object.hash(runtimeType,_this.id,const DeepCollectionEquality().hash(_this.name),const DeepCollectionEquality().hash(_this.address),_this.timezone,_this.location,_this.phone);
}

@override
String toString() {
  final _this = this as BookingBranch;
  return 'BookingBranch(id: ${_this.id}, name: ${_this.name}, address: ${_this.address}, timezone: ${_this.timezone}, location: ${_this.location}, phone: ${_this.phone})';
}


}

/// @nodoc
abstract mixin class $BookingBranchCopyWith<$Res>  {
  factory $BookingBranchCopyWith(BookingBranch value, $Res Function(BookingBranch) _then) = _$BookingBranchCopyWithImpl;
@useResult
$Res call({
 String id,@LocalizedConverter() LocalizedText name,@LocalizedConverter() LocalizedText address, String timezone, GeoPoint? location, String? phone
});


$GeoPointCopyWith<$Res>? get location;

}
/// @nodoc
class _$BookingBranchCopyWithImpl<$Res>
    implements $BookingBranchCopyWith<$Res> {
  _$BookingBranchCopyWithImpl(this._self, this._then);

  final BookingBranch _self;
  final $Res Function(BookingBranch) _then;

/// Create a copy of BookingBranch
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? address = null,Object? timezone = null,Object? location = freezed,Object? phone = freezed,}) {
  return _then(BookingBranch(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as LocalizedText,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as LocalizedText,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as GeoPoint?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of BookingBranch
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


/// Adds pattern-matching-related methods to [BookingBranch].
extension BookingBranchPatterns on BookingBranch {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookingBranch value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookingBranch() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookingBranch value)  $default,){
final _that = this;
switch (_that) {
case _BookingBranch():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookingBranch value)?  $default,){
final _that = this;
switch (_that) {
case _BookingBranch() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @LocalizedConverter()  LocalizedText name, @LocalizedConverter()  LocalizedText address,  String timezone,  GeoPoint? location,  String? phone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookingBranch() when $default != null:
return $default(_that.id,_that.name,_that.address,_that.timezone,_that.location,_that.phone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @LocalizedConverter()  LocalizedText name, @LocalizedConverter()  LocalizedText address,  String timezone,  GeoPoint? location,  String? phone)  $default,) {final _that = this;
switch (_that) {
case _BookingBranch():
return $default(_that.id,_that.name,_that.address,_that.timezone,_that.location,_that.phone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @LocalizedConverter()  LocalizedText name, @LocalizedConverter()  LocalizedText address,  String timezone,  GeoPoint? location,  String? phone)?  $default,) {final _that = this;
switch (_that) {
case _BookingBranch() when $default != null:
return $default(_that.id,_that.name,_that.address,_that.timezone,_that.location,_that.phone);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BookingBranch implements BookingBranch {
  const _BookingBranch({required this.id, @LocalizedConverter() required  LocalizedText name, @LocalizedConverter() required  LocalizedText address, required this.timezone, this.location, this.phone}): _name = name,_address = address;
  factory _BookingBranch.fromJson(Map<String, dynamic> json) => _$BookingBranchFromJson(json);

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

/// Create a copy of BookingBranch
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingBranchCopyWith<_BookingBranch> get copyWith => __$BookingBranchCopyWithImpl<_BookingBranch>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookingBranchToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingBranch&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.name, _name)&&const DeepCollectionEquality().equals(other.address, _address)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.location, location) || other.location == location)&&(identical(other.phone, phone) || other.phone == phone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_name),const DeepCollectionEquality().hash(_address),timezone,location,phone);
}

@override
String toString() {
    return 'BookingBranch(id: $id, name: $name, address: $address, timezone: $timezone, location: $location, phone: $phone)';
}


}

/// @nodoc
abstract mixin class _$BookingBranchCopyWith<$Res> implements $BookingBranchCopyWith<$Res> {
  factory _$BookingBranchCopyWith(_BookingBranch value, $Res Function(_BookingBranch) _then) = __$BookingBranchCopyWithImpl;
@override @useResult
$Res call({
 String id,@LocalizedConverter() LocalizedText name,@LocalizedConverter() LocalizedText address, String timezone, GeoPoint? location, String? phone
});


@override $GeoPointCopyWith<$Res>? get location;

}
/// @nodoc
class __$BookingBranchCopyWithImpl<$Res>
    implements _$BookingBranchCopyWith<$Res> {
  __$BookingBranchCopyWithImpl(this._self, this._then);

  final _BookingBranch _self;
  final $Res Function(_BookingBranch) _then;

/// Create a copy of BookingBranch
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? address = null,Object? timezone = null,Object? location = freezed,Object? phone = freezed,}) {
  return _then(_BookingBranch(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self._name : name // ignore: cast_nullable_to_non_nullable
as LocalizedText,address: null == address ? _self._address : address // ignore: cast_nullable_to_non_nullable
as LocalizedText,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as GeoPoint?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of BookingBranch
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
mixin _$BookingSalon {

 String get id; String get slug;@LocalizedConverter() LocalizedText get name;
/// Create a copy of BookingSalon
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingSalonCopyWith<BookingSalon> get copyWith => _$BookingSalonCopyWithImpl<BookingSalon>(this as BookingSalon, _$identity);

  /// Serializes this BookingSalon to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BookingSalon;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingSalon&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.slug, _this.slug) || other.slug == _this.slug)&&const DeepCollectionEquality().equals(other.name, _this.name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BookingSalon;
  return Object.hash(runtimeType,_this.id,_this.slug,const DeepCollectionEquality().hash(_this.name));
}

@override
String toString() {
  final _this = this as BookingSalon;
  return 'BookingSalon(id: ${_this.id}, slug: ${_this.slug}, name: ${_this.name})';
}


}

/// @nodoc
abstract mixin class $BookingSalonCopyWith<$Res>  {
  factory $BookingSalonCopyWith(BookingSalon value, $Res Function(BookingSalon) _then) = _$BookingSalonCopyWithImpl;
@useResult
$Res call({
 String id, String slug,@LocalizedConverter() LocalizedText name
});




}
/// @nodoc
class _$BookingSalonCopyWithImpl<$Res>
    implements $BookingSalonCopyWith<$Res> {
  _$BookingSalonCopyWithImpl(this._self, this._then);

  final BookingSalon _self;
  final $Res Function(BookingSalon) _then;

/// Create a copy of BookingSalon
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? slug = null,Object? name = null,}) {
  return _then(BookingSalon(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as LocalizedText,
  ));
}

}


/// Adds pattern-matching-related methods to [BookingSalon].
extension BookingSalonPatterns on BookingSalon {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookingSalon value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookingSalon() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookingSalon value)  $default,){
final _that = this;
switch (_that) {
case _BookingSalon():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookingSalon value)?  $default,){
final _that = this;
switch (_that) {
case _BookingSalon() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String slug, @LocalizedConverter()  LocalizedText name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookingSalon() when $default != null:
return $default(_that.id,_that.slug,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String slug, @LocalizedConverter()  LocalizedText name)  $default,) {final _that = this;
switch (_that) {
case _BookingSalon():
return $default(_that.id,_that.slug,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String slug, @LocalizedConverter()  LocalizedText name)?  $default,) {final _that = this;
switch (_that) {
case _BookingSalon() when $default != null:
return $default(_that.id,_that.slug,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BookingSalon implements BookingSalon {
  const _BookingSalon({required this.id, required this.slug, @LocalizedConverter() required  LocalizedText name}): _name = name;
  factory _BookingSalon.fromJson(Map<String, dynamic> json) => _$BookingSalonFromJson(json);

@override final  String id;
@override final  String slug;
 final  LocalizedText _name;
@override@LocalizedConverter() LocalizedText get name {
  if (_name is EqualUnmodifiableMapView) return _name;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_name);
}


/// Create a copy of BookingSalon
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingSalonCopyWith<_BookingSalon> get copyWith => __$BookingSalonCopyWithImpl<_BookingSalon>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookingSalonToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingSalon&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&const DeepCollectionEquality().equals(other.name, _name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,slug,const DeepCollectionEquality().hash(_name));
}

@override
String toString() {
    return 'BookingSalon(id: $id, slug: $slug, name: $name)';
}


}

/// @nodoc
abstract mixin class _$BookingSalonCopyWith<$Res> implements $BookingSalonCopyWith<$Res> {
  factory _$BookingSalonCopyWith(_BookingSalon value, $Res Function(_BookingSalon) _then) = __$BookingSalonCopyWithImpl;
@override @useResult
$Res call({
 String id, String slug,@LocalizedConverter() LocalizedText name
});




}
/// @nodoc
class __$BookingSalonCopyWithImpl<$Res>
    implements _$BookingSalonCopyWith<$Res> {
  __$BookingSalonCopyWithImpl(this._self, this._then);

  final _BookingSalon _self;
  final $Res Function(_BookingSalon) _then;

/// Create a copy of BookingSalon
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? slug = null,Object? name = null,}) {
  return _then(_BookingSalon(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self._name : name // ignore: cast_nullable_to_non_nullable
as LocalizedText,
  ));
}


}


/// @nodoc
mixin _$BookingReviewSummary {

 int get rating; String? get comment;
/// Create a copy of BookingReviewSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingReviewSummaryCopyWith<BookingReviewSummary> get copyWith => _$BookingReviewSummaryCopyWithImpl<BookingReviewSummary>(this as BookingReviewSummary, _$identity);

  /// Serializes this BookingReviewSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BookingReviewSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingReviewSummary&&(identical(other.rating, _this.rating) || other.rating == _this.rating)&&(identical(other.comment, _this.comment) || other.comment == _this.comment));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BookingReviewSummary;
  return Object.hash(runtimeType,_this.rating,_this.comment);
}

@override
String toString() {
  final _this = this as BookingReviewSummary;
  return 'BookingReviewSummary(rating: ${_this.rating}, comment: ${_this.comment})';
}


}

/// @nodoc
abstract mixin class $BookingReviewSummaryCopyWith<$Res>  {
  factory $BookingReviewSummaryCopyWith(BookingReviewSummary value, $Res Function(BookingReviewSummary) _then) = _$BookingReviewSummaryCopyWithImpl;
@useResult
$Res call({
 int rating, String? comment
});




}
/// @nodoc
class _$BookingReviewSummaryCopyWithImpl<$Res>
    implements $BookingReviewSummaryCopyWith<$Res> {
  _$BookingReviewSummaryCopyWithImpl(this._self, this._then);

  final BookingReviewSummary _self;
  final $Res Function(BookingReviewSummary) _then;

/// Create a copy of BookingReviewSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rating = null,Object? comment = freezed,}) {
  return _then(BookingReviewSummary(
rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BookingReviewSummary].
extension BookingReviewSummaryPatterns on BookingReviewSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookingReviewSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookingReviewSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookingReviewSummary value)  $default,){
final _that = this;
switch (_that) {
case _BookingReviewSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookingReviewSummary value)?  $default,){
final _that = this;
switch (_that) {
case _BookingReviewSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int rating,  String? comment)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookingReviewSummary() when $default != null:
return $default(_that.rating,_that.comment);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int rating,  String? comment)  $default,) {final _that = this;
switch (_that) {
case _BookingReviewSummary():
return $default(_that.rating,_that.comment);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int rating,  String? comment)?  $default,) {final _that = this;
switch (_that) {
case _BookingReviewSummary() when $default != null:
return $default(_that.rating,_that.comment);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BookingReviewSummary implements BookingReviewSummary {
  const _BookingReviewSummary({required this.rating, this.comment});
  factory _BookingReviewSummary.fromJson(Map<String, dynamic> json) => _$BookingReviewSummaryFromJson(json);

@override final  int rating;
@override final  String? comment;

/// Create a copy of BookingReviewSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingReviewSummaryCopyWith<_BookingReviewSummary> get copyWith => __$BookingReviewSummaryCopyWithImpl<_BookingReviewSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookingReviewSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingReviewSummary&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.comment, comment) || other.comment == comment));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,rating,comment);
}

@override
String toString() {
    return 'BookingReviewSummary(rating: $rating, comment: $comment)';
}


}

/// @nodoc
abstract mixin class _$BookingReviewSummaryCopyWith<$Res> implements $BookingReviewSummaryCopyWith<$Res> {
  factory _$BookingReviewSummaryCopyWith(_BookingReviewSummary value, $Res Function(_BookingReviewSummary) _then) = __$BookingReviewSummaryCopyWithImpl;
@override @useResult
$Res call({
 int rating, String? comment
});




}
/// @nodoc
class __$BookingReviewSummaryCopyWithImpl<$Res>
    implements _$BookingReviewSummaryCopyWith<$Res> {
  __$BookingReviewSummaryCopyWithImpl(this._self, this._then);

  final _BookingReviewSummary _self;
  final $Res Function(_BookingReviewSummary) _then;

/// Create a copy of BookingReviewSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rating = null,Object? comment = freezed,}) {
  return _then(_BookingReviewSummary(
rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$BookingPolicy {

 int get cancellationWindowMinutes;
/// Create a copy of BookingPolicy
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingPolicyCopyWith<BookingPolicy> get copyWith => _$BookingPolicyCopyWithImpl<BookingPolicy>(this as BookingPolicy, _$identity);

  /// Serializes this BookingPolicy to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BookingPolicy;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingPolicy&&(identical(other.cancellationWindowMinutes, _this.cancellationWindowMinutes) || other.cancellationWindowMinutes == _this.cancellationWindowMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BookingPolicy;
  return Object.hash(runtimeType,_this.cancellationWindowMinutes);
}

@override
String toString() {
  final _this = this as BookingPolicy;
  return 'BookingPolicy(cancellationWindowMinutes: ${_this.cancellationWindowMinutes})';
}


}

/// @nodoc
abstract mixin class $BookingPolicyCopyWith<$Res>  {
  factory $BookingPolicyCopyWith(BookingPolicy value, $Res Function(BookingPolicy) _then) = _$BookingPolicyCopyWithImpl;
@useResult
$Res call({
 int cancellationWindowMinutes
});




}
/// @nodoc
class _$BookingPolicyCopyWithImpl<$Res>
    implements $BookingPolicyCopyWith<$Res> {
  _$BookingPolicyCopyWithImpl(this._self, this._then);

  final BookingPolicy _self;
  final $Res Function(BookingPolicy) _then;

/// Create a copy of BookingPolicy
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cancellationWindowMinutes = null,}) {
  return _then(BookingPolicy(
cancellationWindowMinutes: null == cancellationWindowMinutes ? _self.cancellationWindowMinutes : cancellationWindowMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BookingPolicy].
extension BookingPolicyPatterns on BookingPolicy {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookingPolicy value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookingPolicy() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookingPolicy value)  $default,){
final _that = this;
switch (_that) {
case _BookingPolicy():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookingPolicy value)?  $default,){
final _that = this;
switch (_that) {
case _BookingPolicy() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int cancellationWindowMinutes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookingPolicy() when $default != null:
return $default(_that.cancellationWindowMinutes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int cancellationWindowMinutes)  $default,) {final _that = this;
switch (_that) {
case _BookingPolicy():
return $default(_that.cancellationWindowMinutes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int cancellationWindowMinutes)?  $default,) {final _that = this;
switch (_that) {
case _BookingPolicy() when $default != null:
return $default(_that.cancellationWindowMinutes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BookingPolicy implements BookingPolicy {
  const _BookingPolicy({this.cancellationWindowMinutes = 0});
  factory _BookingPolicy.fromJson(Map<String, dynamic> json) => _$BookingPolicyFromJson(json);

@override@JsonKey() final  int cancellationWindowMinutes;

/// Create a copy of BookingPolicy
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingPolicyCopyWith<_BookingPolicy> get copyWith => __$BookingPolicyCopyWithImpl<_BookingPolicy>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookingPolicyToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingPolicy&&(identical(other.cancellationWindowMinutes, cancellationWindowMinutes) || other.cancellationWindowMinutes == cancellationWindowMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,cancellationWindowMinutes);
}

@override
String toString() {
    return 'BookingPolicy(cancellationWindowMinutes: $cancellationWindowMinutes)';
}


}

/// @nodoc
abstract mixin class _$BookingPolicyCopyWith<$Res> implements $BookingPolicyCopyWith<$Res> {
  factory _$BookingPolicyCopyWith(_BookingPolicy value, $Res Function(_BookingPolicy) _then) = __$BookingPolicyCopyWithImpl;
@override @useResult
$Res call({
 int cancellationWindowMinutes
});




}
/// @nodoc
class __$BookingPolicyCopyWithImpl<$Res>
    implements _$BookingPolicyCopyWith<$Res> {
  __$BookingPolicyCopyWithImpl(this._self, this._then);

  final _BookingPolicy _self;
  final $Res Function(_BookingPolicy) _then;

/// Create a copy of BookingPolicy
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cancellationWindowMinutes = null,}) {
  return _then(_BookingPolicy(
cancellationWindowMinutes: null == cancellationWindowMinutes ? _self.cancellationWindowMinutes : cancellationWindowMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$CustomerBooking {

 String get id;@JsonKey(unknownEnumValue: BookingStatus.unknown) BookingStatus get status;@UtcDateTimeConverter() DateTime get startsAt;@UtcDateTimeConverter() DateTime get endsAt; Money get total; BookingBarber? get barber; BookingBranch? get branch; BookingSalon? get salon; List<BookingItem> get items; bool get canChange; bool get canReview; BookingReviewSummary? get review; List<BookingHistoryEntry>? get history; BookingPolicy? get policy; String? get customerNotes; String? get cancelReason;
/// Create a copy of CustomerBooking
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerBookingCopyWith<CustomerBooking> get copyWith => _$CustomerBookingCopyWithImpl<CustomerBooking>(this as CustomerBooking, _$identity);

  /// Serializes this CustomerBooking to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CustomerBooking;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerBooking&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.startsAt, _this.startsAt) || other.startsAt == _this.startsAt)&&(identical(other.endsAt, _this.endsAt) || other.endsAt == _this.endsAt)&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.barber, _this.barber) || other.barber == _this.barber)&&(identical(other.branch, _this.branch) || other.branch == _this.branch)&&(identical(other.salon, _this.salon) || other.salon == _this.salon)&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.canChange, _this.canChange) || other.canChange == _this.canChange)&&(identical(other.canReview, _this.canReview) || other.canReview == _this.canReview)&&(identical(other.review, _this.review) || other.review == _this.review)&&const DeepCollectionEquality().equals(other.history, _this.history)&&(identical(other.policy, _this.policy) || other.policy == _this.policy)&&(identical(other.customerNotes, _this.customerNotes) || other.customerNotes == _this.customerNotes)&&(identical(other.cancelReason, _this.cancelReason) || other.cancelReason == _this.cancelReason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CustomerBooking;
  return Object.hash(runtimeType,_this.id,_this.status,_this.startsAt,_this.endsAt,_this.total,_this.barber,_this.branch,_this.salon,const DeepCollectionEquality().hash(_this.items),_this.canChange,_this.canReview,_this.review,const DeepCollectionEquality().hash(_this.history),_this.policy,_this.customerNotes,_this.cancelReason);
}

@override
String toString() {
  final _this = this as CustomerBooking;
  return 'CustomerBooking(id: ${_this.id}, status: ${_this.status}, startsAt: ${_this.startsAt}, endsAt: ${_this.endsAt}, total: ${_this.total}, barber: ${_this.barber}, branch: ${_this.branch}, salon: ${_this.salon}, items: ${_this.items}, canChange: ${_this.canChange}, canReview: ${_this.canReview}, review: ${_this.review}, history: ${_this.history}, policy: ${_this.policy}, customerNotes: ${_this.customerNotes}, cancelReason: ${_this.cancelReason})';
}


}

/// @nodoc
abstract mixin class $CustomerBookingCopyWith<$Res>  {
  factory $CustomerBookingCopyWith(CustomerBooking value, $Res Function(CustomerBooking) _then) = _$CustomerBookingCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(unknownEnumValue: BookingStatus.unknown) BookingStatus status,@UtcDateTimeConverter() DateTime startsAt,@UtcDateTimeConverter() DateTime endsAt, Money total, BookingBarber? barber, BookingBranch? branch, BookingSalon? salon, List<BookingItem> items, bool canChange, bool canReview, BookingReviewSummary? review, List<BookingHistoryEntry>? history, BookingPolicy? policy, String? customerNotes, String? cancelReason
});


$MoneyCopyWith<$Res> get total;$BookingBarberCopyWith<$Res>? get barber;$BookingBranchCopyWith<$Res>? get branch;$BookingSalonCopyWith<$Res>? get salon;$BookingReviewSummaryCopyWith<$Res>? get review;$BookingPolicyCopyWith<$Res>? get policy;

}
/// @nodoc
class _$CustomerBookingCopyWithImpl<$Res>
    implements $CustomerBookingCopyWith<$Res> {
  _$CustomerBookingCopyWithImpl(this._self, this._then);

  final CustomerBooking _self;
  final $Res Function(CustomerBooking) _then;

/// Create a copy of CustomerBooking
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? status = null,Object? startsAt = null,Object? endsAt = null,Object? total = null,Object? barber = freezed,Object? branch = freezed,Object? salon = freezed,Object? items = null,Object? canChange = null,Object? canReview = null,Object? review = freezed,Object? history = freezed,Object? policy = freezed,Object? customerNotes = freezed,Object? cancelReason = freezed,}) {
  return _then(CustomerBooking(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BookingStatus,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as Money,barber: freezed == barber ? _self.barber : barber // ignore: cast_nullable_to_non_nullable
as BookingBarber?,branch: freezed == branch ? _self.branch : branch // ignore: cast_nullable_to_non_nullable
as BookingBranch?,salon: freezed == salon ? _self.salon : salon // ignore: cast_nullable_to_non_nullable
as BookingSalon?,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<BookingItem>,canChange: null == canChange ? _self.canChange : canChange // ignore: cast_nullable_to_non_nullable
as bool,canReview: null == canReview ? _self.canReview : canReview // ignore: cast_nullable_to_non_nullable
as bool,review: freezed == review ? _self.review : review // ignore: cast_nullable_to_non_nullable
as BookingReviewSummary?,history: freezed == history ? _self.history : history // ignore: cast_nullable_to_non_nullable
as List<BookingHistoryEntry>?,policy: freezed == policy ? _self.policy : policy // ignore: cast_nullable_to_non_nullable
as BookingPolicy?,customerNotes: freezed == customerNotes ? _self.customerNotes : customerNotes // ignore: cast_nullable_to_non_nullable
as String?,cancelReason: freezed == cancelReason ? _self.cancelReason : cancelReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of CustomerBooking
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneyCopyWith<$Res> get total {
  
  return $MoneyCopyWith<$Res>(_self.total, (value) {
    return _then(_self.copyWith(total: value));
  });
}/// Create a copy of CustomerBooking
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingBarberCopyWith<$Res>? get barber {
    if (_self.barber == null) {
    return null;
  }

  return $BookingBarberCopyWith<$Res>(_self.barber!, (value) {
    return _then(_self.copyWith(barber: value));
  });
}/// Create a copy of CustomerBooking
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingBranchCopyWith<$Res>? get branch {
    if (_self.branch == null) {
    return null;
  }

  return $BookingBranchCopyWith<$Res>(_self.branch!, (value) {
    return _then(_self.copyWith(branch: value));
  });
}/// Create a copy of CustomerBooking
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingSalonCopyWith<$Res>? get salon {
    if (_self.salon == null) {
    return null;
  }

  return $BookingSalonCopyWith<$Res>(_self.salon!, (value) {
    return _then(_self.copyWith(salon: value));
  });
}/// Create a copy of CustomerBooking
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingReviewSummaryCopyWith<$Res>? get review {
    if (_self.review == null) {
    return null;
  }

  return $BookingReviewSummaryCopyWith<$Res>(_self.review!, (value) {
    return _then(_self.copyWith(review: value));
  });
}/// Create a copy of CustomerBooking
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingPolicyCopyWith<$Res>? get policy {
    if (_self.policy == null) {
    return null;
  }

  return $BookingPolicyCopyWith<$Res>(_self.policy!, (value) {
    return _then(_self.copyWith(policy: value));
  });
}
}


/// Adds pattern-matching-related methods to [CustomerBooking].
extension CustomerBookingPatterns on CustomerBooking {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomerBooking value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomerBooking() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomerBooking value)  $default,){
final _that = this;
switch (_that) {
case _CustomerBooking():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomerBooking value)?  $default,){
final _that = this;
switch (_that) {
case _CustomerBooking() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(unknownEnumValue: BookingStatus.unknown)  BookingStatus status, @UtcDateTimeConverter()  DateTime startsAt, @UtcDateTimeConverter()  DateTime endsAt,  Money total,  BookingBarber? barber,  BookingBranch? branch,  BookingSalon? salon,  List<BookingItem> items,  bool canChange,  bool canReview,  BookingReviewSummary? review,  List<BookingHistoryEntry>? history,  BookingPolicy? policy,  String? customerNotes,  String? cancelReason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomerBooking() when $default != null:
return $default(_that.id,_that.status,_that.startsAt,_that.endsAt,_that.total,_that.barber,_that.branch,_that.salon,_that.items,_that.canChange,_that.canReview,_that.review,_that.history,_that.policy,_that.customerNotes,_that.cancelReason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(unknownEnumValue: BookingStatus.unknown)  BookingStatus status, @UtcDateTimeConverter()  DateTime startsAt, @UtcDateTimeConverter()  DateTime endsAt,  Money total,  BookingBarber? barber,  BookingBranch? branch,  BookingSalon? salon,  List<BookingItem> items,  bool canChange,  bool canReview,  BookingReviewSummary? review,  List<BookingHistoryEntry>? history,  BookingPolicy? policy,  String? customerNotes,  String? cancelReason)  $default,) {final _that = this;
switch (_that) {
case _CustomerBooking():
return $default(_that.id,_that.status,_that.startsAt,_that.endsAt,_that.total,_that.barber,_that.branch,_that.salon,_that.items,_that.canChange,_that.canReview,_that.review,_that.history,_that.policy,_that.customerNotes,_that.cancelReason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(unknownEnumValue: BookingStatus.unknown)  BookingStatus status, @UtcDateTimeConverter()  DateTime startsAt, @UtcDateTimeConverter()  DateTime endsAt,  Money total,  BookingBarber? barber,  BookingBranch? branch,  BookingSalon? salon,  List<BookingItem> items,  bool canChange,  bool canReview,  BookingReviewSummary? review,  List<BookingHistoryEntry>? history,  BookingPolicy? policy,  String? customerNotes,  String? cancelReason)?  $default,) {final _that = this;
switch (_that) {
case _CustomerBooking() when $default != null:
return $default(_that.id,_that.status,_that.startsAt,_that.endsAt,_that.total,_that.barber,_that.branch,_that.salon,_that.items,_that.canChange,_that.canReview,_that.review,_that.history,_that.policy,_that.customerNotes,_that.cancelReason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CustomerBooking implements CustomerBooking {
  const _CustomerBooking({required this.id, @JsonKey(unknownEnumValue: BookingStatus.unknown) required this.status, @UtcDateTimeConverter() required this.startsAt, @UtcDateTimeConverter() required this.endsAt, required this.total, this.barber, this.branch, this.salon,  List<BookingItem> items = const [], this.canChange = false, this.canReview = false, this.review,  List<BookingHistoryEntry>? history, this.policy, this.customerNotes, this.cancelReason}): _items = items,_history = history;
  factory _CustomerBooking.fromJson(Map<String, dynamic> json) => _$CustomerBookingFromJson(json);

@override final  String id;
@override@JsonKey(unknownEnumValue: BookingStatus.unknown) final  BookingStatus status;
@override@UtcDateTimeConverter() final  DateTime startsAt;
@override@UtcDateTimeConverter() final  DateTime endsAt;
@override final  Money total;
@override final  BookingBarber? barber;
@override final  BookingBranch? branch;
@override final  BookingSalon? salon;
 final  List<BookingItem> _items;
@override@JsonKey() List<BookingItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey() final  bool canChange;
@override@JsonKey() final  bool canReview;
@override final  BookingReviewSummary? review;
 final  List<BookingHistoryEntry>? _history;
@override List<BookingHistoryEntry>? get history {
  final value = _history;
  if (value == null) return null;
  if (_history is EqualUnmodifiableListView) return _history;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  BookingPolicy? policy;
@override final  String? customerNotes;
@override final  String? cancelReason;

/// Create a copy of CustomerBooking
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomerBookingCopyWith<_CustomerBooking> get copyWith => __$CustomerBookingCopyWithImpl<_CustomerBooking>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CustomerBookingToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomerBooking&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.total, total) || other.total == total)&&(identical(other.barber, barber) || other.barber == barber)&&(identical(other.branch, branch) || other.branch == branch)&&(identical(other.salon, salon) || other.salon == salon)&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.canChange, canChange) || other.canChange == canChange)&&(identical(other.canReview, canReview) || other.canReview == canReview)&&(identical(other.review, review) || other.review == review)&&const DeepCollectionEquality().equals(other.history, _history)&&(identical(other.policy, policy) || other.policy == policy)&&(identical(other.customerNotes, customerNotes) || other.customerNotes == customerNotes)&&(identical(other.cancelReason, cancelReason) || other.cancelReason == cancelReason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,status,startsAt,endsAt,total,barber,branch,salon,const DeepCollectionEquality().hash(_items),canChange,canReview,review,const DeepCollectionEquality().hash(_history),policy,customerNotes,cancelReason);
}

@override
String toString() {
    return 'CustomerBooking(id: $id, status: $status, startsAt: $startsAt, endsAt: $endsAt, total: $total, barber: $barber, branch: $branch, salon: $salon, items: $items, canChange: $canChange, canReview: $canReview, review: $review, history: $history, policy: $policy, customerNotes: $customerNotes, cancelReason: $cancelReason)';
}


}

/// @nodoc
abstract mixin class _$CustomerBookingCopyWith<$Res> implements $CustomerBookingCopyWith<$Res> {
  factory _$CustomerBookingCopyWith(_CustomerBooking value, $Res Function(_CustomerBooking) _then) = __$CustomerBookingCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(unknownEnumValue: BookingStatus.unknown) BookingStatus status,@UtcDateTimeConverter() DateTime startsAt,@UtcDateTimeConverter() DateTime endsAt, Money total, BookingBarber? barber, BookingBranch? branch, BookingSalon? salon, List<BookingItem> items, bool canChange, bool canReview, BookingReviewSummary? review, List<BookingHistoryEntry>? history, BookingPolicy? policy, String? customerNotes, String? cancelReason
});


@override $MoneyCopyWith<$Res> get total;@override $BookingBarberCopyWith<$Res>? get barber;@override $BookingBranchCopyWith<$Res>? get branch;@override $BookingSalonCopyWith<$Res>? get salon;@override $BookingReviewSummaryCopyWith<$Res>? get review;@override $BookingPolicyCopyWith<$Res>? get policy;

}
/// @nodoc
class __$CustomerBookingCopyWithImpl<$Res>
    implements _$CustomerBookingCopyWith<$Res> {
  __$CustomerBookingCopyWithImpl(this._self, this._then);

  final _CustomerBooking _self;
  final $Res Function(_CustomerBooking) _then;

/// Create a copy of CustomerBooking
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? status = null,Object? startsAt = null,Object? endsAt = null,Object? total = null,Object? barber = freezed,Object? branch = freezed,Object? salon = freezed,Object? items = null,Object? canChange = null,Object? canReview = null,Object? review = freezed,Object? history = freezed,Object? policy = freezed,Object? customerNotes = freezed,Object? cancelReason = freezed,}) {
  return _then(_CustomerBooking(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BookingStatus,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as Money,barber: freezed == barber ? _self.barber : barber // ignore: cast_nullable_to_non_nullable
as BookingBarber?,branch: freezed == branch ? _self.branch : branch // ignore: cast_nullable_to_non_nullable
as BookingBranch?,salon: freezed == salon ? _self.salon : salon // ignore: cast_nullable_to_non_nullable
as BookingSalon?,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<BookingItem>,canChange: null == canChange ? _self.canChange : canChange // ignore: cast_nullable_to_non_nullable
as bool,canReview: null == canReview ? _self.canReview : canReview // ignore: cast_nullable_to_non_nullable
as bool,review: freezed == review ? _self.review : review // ignore: cast_nullable_to_non_nullable
as BookingReviewSummary?,history: freezed == history ? _self._history : history // ignore: cast_nullable_to_non_nullable
as List<BookingHistoryEntry>?,policy: freezed == policy ? _self.policy : policy // ignore: cast_nullable_to_non_nullable
as BookingPolicy?,customerNotes: freezed == customerNotes ? _self.customerNotes : customerNotes // ignore: cast_nullable_to_non_nullable
as String?,cancelReason: freezed == cancelReason ? _self.cancelReason : cancelReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of CustomerBooking
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneyCopyWith<$Res> get total {
  
  return $MoneyCopyWith<$Res>(_self.total, (value) {
    return _then(_self.copyWith(total: value));
  });
}/// Create a copy of CustomerBooking
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingBarberCopyWith<$Res>? get barber {
    if (_self.barber == null) {
    return null;
  }

  return $BookingBarberCopyWith<$Res>(_self.barber!, (value) {
    return _then(_self.copyWith(barber: value));
  });
}/// Create a copy of CustomerBooking
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingBranchCopyWith<$Res>? get branch {
    if (_self.branch == null) {
    return null;
  }

  return $BookingBranchCopyWith<$Res>(_self.branch!, (value) {
    return _then(_self.copyWith(branch: value));
  });
}/// Create a copy of CustomerBooking
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingSalonCopyWith<$Res>? get salon {
    if (_self.salon == null) {
    return null;
  }

  return $BookingSalonCopyWith<$Res>(_self.salon!, (value) {
    return _then(_self.copyWith(salon: value));
  });
}/// Create a copy of CustomerBooking
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingReviewSummaryCopyWith<$Res>? get review {
    if (_self.review == null) {
    return null;
  }

  return $BookingReviewSummaryCopyWith<$Res>(_self.review!, (value) {
    return _then(_self.copyWith(review: value));
  });
}/// Create a copy of CustomerBooking
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingPolicyCopyWith<$Res>? get policy {
    if (_self.policy == null) {
    return null;
  }

  return $BookingPolicyCopyWith<$Res>(_self.policy!, (value) {
    return _then(_self.copyWith(policy: value));
  });
}
}

/// @nodoc
mixin _$BookingPage {

 List<CustomerBooking> get items; String? get nextCursor;
/// Create a copy of BookingPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingPageCopyWith<BookingPage> get copyWith => _$BookingPageCopyWithImpl<BookingPage>(this as BookingPage, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as BookingPage;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingPage&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.nextCursor, _this.nextCursor) || other.nextCursor == _this.nextCursor));
}


@override
int get hashCode {
  final _this = this as BookingPage;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.items),_this.nextCursor);
}

@override
String toString() {
  final _this = this as BookingPage;
  return 'BookingPage(items: ${_this.items}, nextCursor: ${_this.nextCursor})';
}


}

/// @nodoc
abstract mixin class $BookingPageCopyWith<$Res>  {
  factory $BookingPageCopyWith(BookingPage value, $Res Function(BookingPage) _then) = _$BookingPageCopyWithImpl;
@useResult
$Res call({
 List<CustomerBooking> items, String? nextCursor
});




}
/// @nodoc
class _$BookingPageCopyWithImpl<$Res>
    implements $BookingPageCopyWith<$Res> {
  _$BookingPageCopyWithImpl(this._self, this._then);

  final BookingPage _self;
  final $Res Function(BookingPage) _then;

/// Create a copy of BookingPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? nextCursor = freezed,}) {
  return _then(BookingPage(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<CustomerBooking>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BookingPage].
extension BookingPagePatterns on BookingPage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookingPage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookingPage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookingPage value)  $default,){
final _that = this;
switch (_that) {
case _BookingPage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookingPage value)?  $default,){
final _that = this;
switch (_that) {
case _BookingPage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<CustomerBooking> items,  String? nextCursor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookingPage() when $default != null:
return $default(_that.items,_that.nextCursor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<CustomerBooking> items,  String? nextCursor)  $default,) {final _that = this;
switch (_that) {
case _BookingPage():
return $default(_that.items,_that.nextCursor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<CustomerBooking> items,  String? nextCursor)?  $default,) {final _that = this;
switch (_that) {
case _BookingPage() when $default != null:
return $default(_that.items,_that.nextCursor);case _:
  return null;

}
}

}

/// @nodoc


class _BookingPage implements BookingPage {
  const _BookingPage({required  List<CustomerBooking> items, this.nextCursor}): _items = items;
  

 final  List<CustomerBooking> _items;
@override List<CustomerBooking> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  String? nextCursor;

/// Create a copy of BookingPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingPageCopyWith<_BookingPage> get copyWith => __$BookingPageCopyWithImpl<_BookingPage>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingPage&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),nextCursor);
}

@override
String toString() {
    return 'BookingPage(items: $items, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class _$BookingPageCopyWith<$Res> implements $BookingPageCopyWith<$Res> {
  factory _$BookingPageCopyWith(_BookingPage value, $Res Function(_BookingPage) _then) = __$BookingPageCopyWithImpl;
@override @useResult
$Res call({
 List<CustomerBooking> items, String? nextCursor
});




}
/// @nodoc
class __$BookingPageCopyWithImpl<$Res>
    implements _$BookingPageCopyWith<$Res> {
  __$BookingPageCopyWithImpl(this._self, this._then);

  final _BookingPage _self;
  final $Res Function(_BookingPage) _then;

/// Create a copy of BookingPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? nextCursor = freezed,}) {
  return _then(_BookingPage(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<CustomerBooking>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$BookingSelection {

 String get branch; List<String> get services; List<String> get addons; List<String> get bundles;/// Barber public id, or null for "any available".
 String? get barber;
/// Create a copy of BookingSelection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingSelectionCopyWith<BookingSelection> get copyWith => _$BookingSelectionCopyWithImpl<BookingSelection>(this as BookingSelection, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as BookingSelection;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingSelection&&(identical(other.branch, _this.branch) || other.branch == _this.branch)&&const DeepCollectionEquality().equals(other.services, _this.services)&&const DeepCollectionEquality().equals(other.addons, _this.addons)&&const DeepCollectionEquality().equals(other.bundles, _this.bundles)&&(identical(other.barber, _this.barber) || other.barber == _this.barber));
}


@override
int get hashCode {
  final _this = this as BookingSelection;
  return Object.hash(runtimeType,_this.branch,const DeepCollectionEquality().hash(_this.services),const DeepCollectionEquality().hash(_this.addons),const DeepCollectionEquality().hash(_this.bundles),_this.barber);
}

@override
String toString() {
  final _this = this as BookingSelection;
  return 'BookingSelection(branch: ${_this.branch}, services: ${_this.services}, addons: ${_this.addons}, bundles: ${_this.bundles}, barber: ${_this.barber})';
}


}

/// @nodoc
abstract mixin class $BookingSelectionCopyWith<$Res>  {
  factory $BookingSelectionCopyWith(BookingSelection value, $Res Function(BookingSelection) _then) = _$BookingSelectionCopyWithImpl;
@useResult
$Res call({
 String branch, List<String> services, List<String> addons, List<String> bundles, String? barber
});




}
/// @nodoc
class _$BookingSelectionCopyWithImpl<$Res>
    implements $BookingSelectionCopyWith<$Res> {
  _$BookingSelectionCopyWithImpl(this._self, this._then);

  final BookingSelection _self;
  final $Res Function(BookingSelection) _then;

/// Create a copy of BookingSelection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? branch = null,Object? services = null,Object? addons = null,Object? bundles = null,Object? barber = freezed,}) {
  return _then(BookingSelection(
branch: null == branch ? _self.branch : branch // ignore: cast_nullable_to_non_nullable
as String,services: null == services ? _self.services : services // ignore: cast_nullable_to_non_nullable
as List<String>,addons: null == addons ? _self.addons : addons // ignore: cast_nullable_to_non_nullable
as List<String>,bundles: null == bundles ? _self.bundles : bundles // ignore: cast_nullable_to_non_nullable
as List<String>,barber: freezed == barber ? _self.barber : barber // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BookingSelection].
extension BookingSelectionPatterns on BookingSelection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookingSelection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookingSelection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookingSelection value)  $default,){
final _that = this;
switch (_that) {
case _BookingSelection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookingSelection value)?  $default,){
final _that = this;
switch (_that) {
case _BookingSelection() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String branch,  List<String> services,  List<String> addons,  List<String> bundles,  String? barber)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookingSelection() when $default != null:
return $default(_that.branch,_that.services,_that.addons,_that.bundles,_that.barber);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String branch,  List<String> services,  List<String> addons,  List<String> bundles,  String? barber)  $default,) {final _that = this;
switch (_that) {
case _BookingSelection():
return $default(_that.branch,_that.services,_that.addons,_that.bundles,_that.barber);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String branch,  List<String> services,  List<String> addons,  List<String> bundles,  String? barber)?  $default,) {final _that = this;
switch (_that) {
case _BookingSelection() when $default != null:
return $default(_that.branch,_that.services,_that.addons,_that.bundles,_that.barber);case _:
  return null;

}
}

}

/// @nodoc


class _BookingSelection implements BookingSelection {
  const _BookingSelection({required this.branch,  List<String> services = const [],  List<String> addons = const [],  List<String> bundles = const [], this.barber}): _services = services,_addons = addons,_bundles = bundles;
  

@override final  String branch;
 final  List<String> _services;
@override@JsonKey() List<String> get services {
  if (_services is EqualUnmodifiableListView) return _services;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_services);
}

 final  List<String> _addons;
@override@JsonKey() List<String> get addons {
  if (_addons is EqualUnmodifiableListView) return _addons;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_addons);
}

 final  List<String> _bundles;
@override@JsonKey() List<String> get bundles {
  if (_bundles is EqualUnmodifiableListView) return _bundles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_bundles);
}

/// Barber public id, or null for "any available".
@override final  String? barber;

/// Create a copy of BookingSelection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingSelectionCopyWith<_BookingSelection> get copyWith => __$BookingSelectionCopyWithImpl<_BookingSelection>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingSelection&&(identical(other.branch, branch) || other.branch == branch)&&const DeepCollectionEquality().equals(other.services, _services)&&const DeepCollectionEquality().equals(other.addons, _addons)&&const DeepCollectionEquality().equals(other.bundles, _bundles)&&(identical(other.barber, barber) || other.barber == barber));
}


@override
int get hashCode {
    return Object.hash(runtimeType,branch,const DeepCollectionEquality().hash(_services),const DeepCollectionEquality().hash(_addons),const DeepCollectionEquality().hash(_bundles),barber);
}

@override
String toString() {
    return 'BookingSelection(branch: $branch, services: $services, addons: $addons, bundles: $bundles, barber: $barber)';
}


}

/// @nodoc
abstract mixin class _$BookingSelectionCopyWith<$Res> implements $BookingSelectionCopyWith<$Res> {
  factory _$BookingSelectionCopyWith(_BookingSelection value, $Res Function(_BookingSelection) _then) = __$BookingSelectionCopyWithImpl;
@override @useResult
$Res call({
 String branch, List<String> services, List<String> addons, List<String> bundles, String? barber
});




}
/// @nodoc
class __$BookingSelectionCopyWithImpl<$Res>
    implements _$BookingSelectionCopyWith<$Res> {
  __$BookingSelectionCopyWithImpl(this._self, this._then);

  final _BookingSelection _self;
  final $Res Function(_BookingSelection) _then;

/// Create a copy of BookingSelection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? branch = null,Object? services = null,Object? addons = null,Object? bundles = null,Object? barber = freezed,}) {
  return _then(_BookingSelection(
branch: null == branch ? _self.branch : branch // ignore: cast_nullable_to_non_nullable
as String,services: null == services ? _self._services : services // ignore: cast_nullable_to_non_nullable
as List<String>,addons: null == addons ? _self._addons : addons // ignore: cast_nullable_to_non_nullable
as List<String>,bundles: null == bundles ? _self._bundles : bundles // ignore: cast_nullable_to_non_nullable
as List<String>,barber: freezed == barber ? _self.barber : barber // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
