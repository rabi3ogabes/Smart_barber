// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'staff.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StaffUser {

 String get id; String get name; String get locale; bool get twoFactorEnabled; String? get email; String? get phone;
/// Create a copy of StaffUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StaffUserCopyWith<StaffUser> get copyWith => _$StaffUserCopyWithImpl<StaffUser>(this as StaffUser, _$identity);

  /// Serializes this StaffUser to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as StaffUser;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StaffUser&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.locale, _this.locale) || other.locale == _this.locale)&&(identical(other.twoFactorEnabled, _this.twoFactorEnabled) || other.twoFactorEnabled == _this.twoFactorEnabled)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.phone, _this.phone) || other.phone == _this.phone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as StaffUser;
  return Object.hash(runtimeType,_this.id,_this.name,_this.locale,_this.twoFactorEnabled,_this.email,_this.phone);
}

@override
String toString() {
  final _this = this as StaffUser;
  return 'StaffUser(id: ${_this.id}, name: ${_this.name}, locale: ${_this.locale}, twoFactorEnabled: ${_this.twoFactorEnabled}, email: ${_this.email}, phone: ${_this.phone})';
}


}

/// @nodoc
abstract mixin class $StaffUserCopyWith<$Res>  {
  factory $StaffUserCopyWith(StaffUser value, $Res Function(StaffUser) _then) = _$StaffUserCopyWithImpl;
@useResult
$Res call({
 String id, String name, String locale, bool twoFactorEnabled, String? email, String? phone
});




}
/// @nodoc
class _$StaffUserCopyWithImpl<$Res>
    implements $StaffUserCopyWith<$Res> {
  _$StaffUserCopyWithImpl(this._self, this._then);

  final StaffUser _self;
  final $Res Function(StaffUser) _then;

/// Create a copy of StaffUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? locale = null,Object? twoFactorEnabled = null,Object? email = freezed,Object? phone = freezed,}) {
  return _then(StaffUser(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,locale: null == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String,twoFactorEnabled: null == twoFactorEnabled ? _self.twoFactorEnabled : twoFactorEnabled // ignore: cast_nullable_to_non_nullable
as bool,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [StaffUser].
extension StaffUserPatterns on StaffUser {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StaffUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StaffUser() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StaffUser value)  $default,){
final _that = this;
switch (_that) {
case _StaffUser():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StaffUser value)?  $default,){
final _that = this;
switch (_that) {
case _StaffUser() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String locale,  bool twoFactorEnabled,  String? email,  String? phone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StaffUser() when $default != null:
return $default(_that.id,_that.name,_that.locale,_that.twoFactorEnabled,_that.email,_that.phone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String locale,  bool twoFactorEnabled,  String? email,  String? phone)  $default,) {final _that = this;
switch (_that) {
case _StaffUser():
return $default(_that.id,_that.name,_that.locale,_that.twoFactorEnabled,_that.email,_that.phone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String locale,  bool twoFactorEnabled,  String? email,  String? phone)?  $default,) {final _that = this;
switch (_that) {
case _StaffUser() when $default != null:
return $default(_that.id,_that.name,_that.locale,_that.twoFactorEnabled,_that.email,_that.phone);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StaffUser implements StaffUser {
  const _StaffUser({required this.id, required this.name, required this.locale, required this.twoFactorEnabled, this.email, this.phone});
  factory _StaffUser.fromJson(Map<String, dynamic> json) => _$StaffUserFromJson(json);

@override final  String id;
@override final  String name;
@override final  String locale;
@override final  bool twoFactorEnabled;
@override final  String? email;
@override final  String? phone;

/// Create a copy of StaffUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StaffUserCopyWith<_StaffUser> get copyWith => __$StaffUserCopyWithImpl<_StaffUser>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StaffUserToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StaffUser&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.twoFactorEnabled, twoFactorEnabled) || other.twoFactorEnabled == twoFactorEnabled)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,locale,twoFactorEnabled,email,phone);
}

@override
String toString() {
    return 'StaffUser(id: $id, name: $name, locale: $locale, twoFactorEnabled: $twoFactorEnabled, email: $email, phone: $phone)';
}


}

/// @nodoc
abstract mixin class _$StaffUserCopyWith<$Res> implements $StaffUserCopyWith<$Res> {
  factory _$StaffUserCopyWith(_StaffUser value, $Res Function(_StaffUser) _then) = __$StaffUserCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String locale, bool twoFactorEnabled, String? email, String? phone
});




}
/// @nodoc
class __$StaffUserCopyWithImpl<$Res>
    implements _$StaffUserCopyWith<$Res> {
  __$StaffUserCopyWithImpl(this._self, this._then);

  final _StaffUser _self;
  final $Res Function(_StaffUser) _then;

/// Create a copy of StaffUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? locale = null,Object? twoFactorEnabled = null,Object? email = freezed,Object? phone = freezed,}) {
  return _then(_StaffUser(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,locale: null == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String,twoFactorEnabled: null == twoFactorEnabled ? _self.twoFactorEnabled : twoFactorEnabled // ignore: cast_nullable_to_non_nullable
as bool,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$SalonSummary {

 String get id; String get slug;@JsonKey(fromJson: _localized) Map<String, String> get name; String get currency; String get timezone;
/// Create a copy of SalonSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SalonSummaryCopyWith<SalonSummary> get copyWith => _$SalonSummaryCopyWithImpl<SalonSummary>(this as SalonSummary, _$identity);

  /// Serializes this SalonSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SalonSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SalonSummary&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.slug, _this.slug) || other.slug == _this.slug)&&const DeepCollectionEquality().equals(other.name, _this.name)&&(identical(other.currency, _this.currency) || other.currency == _this.currency)&&(identical(other.timezone, _this.timezone) || other.timezone == _this.timezone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SalonSummary;
  return Object.hash(runtimeType,_this.id,_this.slug,const DeepCollectionEquality().hash(_this.name),_this.currency,_this.timezone);
}

@override
String toString() {
  final _this = this as SalonSummary;
  return 'SalonSummary(id: ${_this.id}, slug: ${_this.slug}, name: ${_this.name}, currency: ${_this.currency}, timezone: ${_this.timezone})';
}


}

/// @nodoc
abstract mixin class $SalonSummaryCopyWith<$Res>  {
  factory $SalonSummaryCopyWith(SalonSummary value, $Res Function(SalonSummary) _then) = _$SalonSummaryCopyWithImpl;
@useResult
$Res call({
 String id, String slug,@JsonKey(fromJson: _localized) Map<String, String> name, String currency, String timezone
});




}
/// @nodoc
class _$SalonSummaryCopyWithImpl<$Res>
    implements $SalonSummaryCopyWith<$Res> {
  _$SalonSummaryCopyWithImpl(this._self, this._then);

  final SalonSummary _self;
  final $Res Function(SalonSummary) _then;

/// Create a copy of SalonSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? slug = null,Object? name = null,Object? currency = null,Object? timezone = null,}) {
  return _then(SalonSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as Map<String, String>,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SalonSummary].
extension SalonSummaryPatterns on SalonSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SalonSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SalonSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SalonSummary value)  $default,){
final _that = this;
switch (_that) {
case _SalonSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SalonSummary value)?  $default,){
final _that = this;
switch (_that) {
case _SalonSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String slug, @JsonKey(fromJson: _localized)  Map<String, String> name,  String currency,  String timezone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SalonSummary() when $default != null:
return $default(_that.id,_that.slug,_that.name,_that.currency,_that.timezone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String slug, @JsonKey(fromJson: _localized)  Map<String, String> name,  String currency,  String timezone)  $default,) {final _that = this;
switch (_that) {
case _SalonSummary():
return $default(_that.id,_that.slug,_that.name,_that.currency,_that.timezone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String slug, @JsonKey(fromJson: _localized)  Map<String, String> name,  String currency,  String timezone)?  $default,) {final _that = this;
switch (_that) {
case _SalonSummary() when $default != null:
return $default(_that.id,_that.slug,_that.name,_that.currency,_that.timezone);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SalonSummary implements SalonSummary {
  const _SalonSummary({required this.id, required this.slug, @JsonKey(fromJson: _localized) required  Map<String, String> name, required this.currency, required this.timezone}): _name = name;
  factory _SalonSummary.fromJson(Map<String, dynamic> json) => _$SalonSummaryFromJson(json);

@override final  String id;
@override final  String slug;
 final  Map<String, String> _name;
@override@JsonKey(fromJson: _localized) Map<String, String> get name {
  if (_name is EqualUnmodifiableMapView) return _name;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_name);
}

@override final  String currency;
@override final  String timezone;

/// Create a copy of SalonSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SalonSummaryCopyWith<_SalonSummary> get copyWith => __$SalonSummaryCopyWithImpl<_SalonSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SalonSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SalonSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&const DeepCollectionEquality().equals(other.name, _name)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.timezone, timezone) || other.timezone == timezone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,slug,const DeepCollectionEquality().hash(_name),currency,timezone);
}

@override
String toString() {
    return 'SalonSummary(id: $id, slug: $slug, name: $name, currency: $currency, timezone: $timezone)';
}


}

/// @nodoc
abstract mixin class _$SalonSummaryCopyWith<$Res> implements $SalonSummaryCopyWith<$Res> {
  factory _$SalonSummaryCopyWith(_SalonSummary value, $Res Function(_SalonSummary) _then) = __$SalonSummaryCopyWithImpl;
@override @useResult
$Res call({
 String id, String slug,@JsonKey(fromJson: _localized) Map<String, String> name, String currency, String timezone
});




}
/// @nodoc
class __$SalonSummaryCopyWithImpl<$Res>
    implements _$SalonSummaryCopyWith<$Res> {
  __$SalonSummaryCopyWithImpl(this._self, this._then);

  final _SalonSummary _self;
  final $Res Function(_SalonSummary) _then;

/// Create a copy of SalonSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? slug = null,Object? name = null,Object? currency = null,Object? timezone = null,}) {
  return _then(_SalonSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self._name : name // ignore: cast_nullable_to_non_nullable
as Map<String, String>,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$BranchSummary {

 String get id;@JsonKey(fromJson: _localized) Map<String, String> get name;
/// Create a copy of BranchSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BranchSummaryCopyWith<BranchSummary> get copyWith => _$BranchSummaryCopyWithImpl<BranchSummary>(this as BranchSummary, _$identity);

  /// Serializes this BranchSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BranchSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BranchSummary&&(identical(other.id, _this.id) || other.id == _this.id)&&const DeepCollectionEquality().equals(other.name, _this.name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BranchSummary;
  return Object.hash(runtimeType,_this.id,const DeepCollectionEquality().hash(_this.name));
}

@override
String toString() {
  final _this = this as BranchSummary;
  return 'BranchSummary(id: ${_this.id}, name: ${_this.name})';
}


}

/// @nodoc
abstract mixin class $BranchSummaryCopyWith<$Res>  {
  factory $BranchSummaryCopyWith(BranchSummary value, $Res Function(BranchSummary) _then) = _$BranchSummaryCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(fromJson: _localized) Map<String, String> name
});




}
/// @nodoc
class _$BranchSummaryCopyWithImpl<$Res>
    implements $BranchSummaryCopyWith<$Res> {
  _$BranchSummaryCopyWithImpl(this._self, this._then);

  final BranchSummary _self;
  final $Res Function(BranchSummary) _then;

/// Create a copy of BranchSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(BranchSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

}


/// Adds pattern-matching-related methods to [BranchSummary].
extension BranchSummaryPatterns on BranchSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BranchSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BranchSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BranchSummary value)  $default,){
final _that = this;
switch (_that) {
case _BranchSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BranchSummary value)?  $default,){
final _that = this;
switch (_that) {
case _BranchSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(fromJson: _localized)  Map<String, String> name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BranchSummary() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(fromJson: _localized)  Map<String, String> name)  $default,) {final _that = this;
switch (_that) {
case _BranchSummary():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(fromJson: _localized)  Map<String, String> name)?  $default,) {final _that = this;
switch (_that) {
case _BranchSummary() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BranchSummary implements BranchSummary {
  const _BranchSummary({required this.id, @JsonKey(fromJson: _localized) required  Map<String, String> name}): _name = name;
  factory _BranchSummary.fromJson(Map<String, dynamic> json) => _$BranchSummaryFromJson(json);

@override final  String id;
 final  Map<String, String> _name;
@override@JsonKey(fromJson: _localized) Map<String, String> get name {
  if (_name is EqualUnmodifiableMapView) return _name;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_name);
}


/// Create a copy of BranchSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BranchSummaryCopyWith<_BranchSummary> get copyWith => __$BranchSummaryCopyWithImpl<_BranchSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BranchSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BranchSummary&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.name, _name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_name));
}

@override
String toString() {
    return 'BranchSummary(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$BranchSummaryCopyWith<$Res> implements $BranchSummaryCopyWith<$Res> {
  factory _$BranchSummaryCopyWith(_BranchSummary value, $Res Function(_BranchSummary) _then) = __$BranchSummaryCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(fromJson: _localized) Map<String, String> name
});




}
/// @nodoc
class __$BranchSummaryCopyWithImpl<$Res>
    implements _$BranchSummaryCopyWith<$Res> {
  __$BranchSummaryCopyWithImpl(this._self, this._then);

  final _BranchSummary _self;
  final $Res Function(_BranchSummary) _then;

/// Create a copy of BranchSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(_BranchSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self._name : name // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}


/// @nodoc
mixin _$StaffMe {

 StaffUser get user; List<String> get roles; List<String> get permissions; List<BranchSummary> get branches; List<String> get features; SalonSummary? get salon;
/// Create a copy of StaffMe
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StaffMeCopyWith<StaffMe> get copyWith => _$StaffMeCopyWithImpl<StaffMe>(this as StaffMe, _$identity);

  /// Serializes this StaffMe to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as StaffMe;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StaffMe&&(identical(other.user, _this.user) || other.user == _this.user)&&const DeepCollectionEquality().equals(other.roles, _this.roles)&&const DeepCollectionEquality().equals(other.permissions, _this.permissions)&&const DeepCollectionEquality().equals(other.branches, _this.branches)&&const DeepCollectionEquality().equals(other.features, _this.features)&&(identical(other.salon, _this.salon) || other.salon == _this.salon));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as StaffMe;
  return Object.hash(runtimeType,_this.user,const DeepCollectionEquality().hash(_this.roles),const DeepCollectionEquality().hash(_this.permissions),const DeepCollectionEquality().hash(_this.branches),const DeepCollectionEquality().hash(_this.features),_this.salon);
}

@override
String toString() {
  final _this = this as StaffMe;
  return 'StaffMe(user: ${_this.user}, roles: ${_this.roles}, permissions: ${_this.permissions}, branches: ${_this.branches}, features: ${_this.features}, salon: ${_this.salon})';
}


}

/// @nodoc
abstract mixin class $StaffMeCopyWith<$Res>  {
  factory $StaffMeCopyWith(StaffMe value, $Res Function(StaffMe) _then) = _$StaffMeCopyWithImpl;
@useResult
$Res call({
 StaffUser user, List<String> roles, List<String> permissions, List<BranchSummary> branches, List<String> features, SalonSummary? salon
});


$StaffUserCopyWith<$Res> get user;$SalonSummaryCopyWith<$Res>? get salon;

}
/// @nodoc
class _$StaffMeCopyWithImpl<$Res>
    implements $StaffMeCopyWith<$Res> {
  _$StaffMeCopyWithImpl(this._self, this._then);

  final StaffMe _self;
  final $Res Function(StaffMe) _then;

/// Create a copy of StaffMe
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? user = null,Object? roles = null,Object? permissions = null,Object? branches = null,Object? features = null,Object? salon = freezed,}) {
  return _then(StaffMe(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as StaffUser,roles: null == roles ? _self.roles : roles // ignore: cast_nullable_to_non_nullable
as List<String>,permissions: null == permissions ? _self.permissions : permissions // ignore: cast_nullable_to_non_nullable
as List<String>,branches: null == branches ? _self.branches : branches // ignore: cast_nullable_to_non_nullable
as List<BranchSummary>,features: null == features ? _self.features : features // ignore: cast_nullable_to_non_nullable
as List<String>,salon: freezed == salon ? _self.salon : salon // ignore: cast_nullable_to_non_nullable
as SalonSummary?,
  ));
}
/// Create a copy of StaffMe
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StaffUserCopyWith<$Res> get user {
  
  return $StaffUserCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of StaffMe
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SalonSummaryCopyWith<$Res>? get salon {
    if (_self.salon == null) {
    return null;
  }

  return $SalonSummaryCopyWith<$Res>(_self.salon!, (value) {
    return _then(_self.copyWith(salon: value));
  });
}
}


/// Adds pattern-matching-related methods to [StaffMe].
extension StaffMePatterns on StaffMe {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StaffMe value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StaffMe() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StaffMe value)  $default,){
final _that = this;
switch (_that) {
case _StaffMe():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StaffMe value)?  $default,){
final _that = this;
switch (_that) {
case _StaffMe() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( StaffUser user,  List<String> roles,  List<String> permissions,  List<BranchSummary> branches,  List<String> features,  SalonSummary? salon)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StaffMe() when $default != null:
return $default(_that.user,_that.roles,_that.permissions,_that.branches,_that.features,_that.salon);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( StaffUser user,  List<String> roles,  List<String> permissions,  List<BranchSummary> branches,  List<String> features,  SalonSummary? salon)  $default,) {final _that = this;
switch (_that) {
case _StaffMe():
return $default(_that.user,_that.roles,_that.permissions,_that.branches,_that.features,_that.salon);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( StaffUser user,  List<String> roles,  List<String> permissions,  List<BranchSummary> branches,  List<String> features,  SalonSummary? salon)?  $default,) {final _that = this;
switch (_that) {
case _StaffMe() when $default != null:
return $default(_that.user,_that.roles,_that.permissions,_that.branches,_that.features,_that.salon);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StaffMe extends StaffMe {
  const _StaffMe({required this.user, required  List<String> roles, required  List<String> permissions, required  List<BranchSummary> branches, required  List<String> features, this.salon}): _roles = roles,_permissions = permissions,_branches = branches,_features = features,super._();
  factory _StaffMe.fromJson(Map<String, dynamic> json) => _$StaffMeFromJson(json);

@override final  StaffUser user;
 final  List<String> _roles;
@override List<String> get roles {
  if (_roles is EqualUnmodifiableListView) return _roles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_roles);
}

 final  List<String> _permissions;
@override List<String> get permissions {
  if (_permissions is EqualUnmodifiableListView) return _permissions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_permissions);
}

 final  List<BranchSummary> _branches;
@override List<BranchSummary> get branches {
  if (_branches is EqualUnmodifiableListView) return _branches;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_branches);
}

 final  List<String> _features;
@override List<String> get features {
  if (_features is EqualUnmodifiableListView) return _features;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_features);
}

@override final  SalonSummary? salon;

/// Create a copy of StaffMe
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StaffMeCopyWith<_StaffMe> get copyWith => __$StaffMeCopyWithImpl<_StaffMe>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StaffMeToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StaffMe&&(identical(other.user, user) || other.user == user)&&const DeepCollectionEquality().equals(other.roles, _roles)&&const DeepCollectionEquality().equals(other.permissions, _permissions)&&const DeepCollectionEquality().equals(other.branches, _branches)&&const DeepCollectionEquality().equals(other.features, _features)&&(identical(other.salon, salon) || other.salon == salon));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,user,const DeepCollectionEquality().hash(_roles),const DeepCollectionEquality().hash(_permissions),const DeepCollectionEquality().hash(_branches),const DeepCollectionEquality().hash(_features),salon);
}

@override
String toString() {
    return 'StaffMe(user: $user, roles: $roles, permissions: $permissions, branches: $branches, features: $features, salon: $salon)';
}


}

/// @nodoc
abstract mixin class _$StaffMeCopyWith<$Res> implements $StaffMeCopyWith<$Res> {
  factory _$StaffMeCopyWith(_StaffMe value, $Res Function(_StaffMe) _then) = __$StaffMeCopyWithImpl;
@override @useResult
$Res call({
 StaffUser user, List<String> roles, List<String> permissions, List<BranchSummary> branches, List<String> features, SalonSummary? salon
});


@override $StaffUserCopyWith<$Res> get user;@override $SalonSummaryCopyWith<$Res>? get salon;

}
/// @nodoc
class __$StaffMeCopyWithImpl<$Res>
    implements _$StaffMeCopyWith<$Res> {
  __$StaffMeCopyWithImpl(this._self, this._then);

  final _StaffMe _self;
  final $Res Function(_StaffMe) _then;

/// Create a copy of StaffMe
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? user = null,Object? roles = null,Object? permissions = null,Object? branches = null,Object? features = null,Object? salon = freezed,}) {
  return _then(_StaffMe(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as StaffUser,roles: null == roles ? _self._roles : roles // ignore: cast_nullable_to_non_nullable
as List<String>,permissions: null == permissions ? _self._permissions : permissions // ignore: cast_nullable_to_non_nullable
as List<String>,branches: null == branches ? _self._branches : branches // ignore: cast_nullable_to_non_nullable
as List<BranchSummary>,features: null == features ? _self._features : features // ignore: cast_nullable_to_non_nullable
as List<String>,salon: freezed == salon ? _self.salon : salon // ignore: cast_nullable_to_non_nullable
as SalonSummary?,
  ));
}

/// Create a copy of StaffMe
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StaffUserCopyWith<$Res> get user {
  
  return $StaffUserCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of StaffMe
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SalonSummaryCopyWith<$Res>? get salon {
    if (_self.salon == null) {
    return null;
  }

  return $SalonSummaryCopyWith<$Res>(_self.salon!, (value) {
    return _then(_self.copyWith(salon: value));
  });
}
}


/// @nodoc
mixin _$MembershipOption {

 String get salon; String get slug;@JsonKey(fromJson: _localized) Map<String, String> get name;
/// Create a copy of MembershipOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MembershipOptionCopyWith<MembershipOption> get copyWith => _$MembershipOptionCopyWithImpl<MembershipOption>(this as MembershipOption, _$identity);

  /// Serializes this MembershipOption to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MembershipOption;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MembershipOption&&(identical(other.salon, _this.salon) || other.salon == _this.salon)&&(identical(other.slug, _this.slug) || other.slug == _this.slug)&&const DeepCollectionEquality().equals(other.name, _this.name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MembershipOption;
  return Object.hash(runtimeType,_this.salon,_this.slug,const DeepCollectionEquality().hash(_this.name));
}

@override
String toString() {
  final _this = this as MembershipOption;
  return 'MembershipOption(salon: ${_this.salon}, slug: ${_this.slug}, name: ${_this.name})';
}


}

/// @nodoc
abstract mixin class $MembershipOptionCopyWith<$Res>  {
  factory $MembershipOptionCopyWith(MembershipOption value, $Res Function(MembershipOption) _then) = _$MembershipOptionCopyWithImpl;
@useResult
$Res call({
 String salon, String slug,@JsonKey(fromJson: _localized) Map<String, String> name
});




}
/// @nodoc
class _$MembershipOptionCopyWithImpl<$Res>
    implements $MembershipOptionCopyWith<$Res> {
  _$MembershipOptionCopyWithImpl(this._self, this._then);

  final MembershipOption _self;
  final $Res Function(MembershipOption) _then;

/// Create a copy of MembershipOption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? salon = null,Object? slug = null,Object? name = null,}) {
  return _then(MembershipOption(
salon: null == salon ? _self.salon : salon // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

}


/// Adds pattern-matching-related methods to [MembershipOption].
extension MembershipOptionPatterns on MembershipOption {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MembershipOption value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MembershipOption() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MembershipOption value)  $default,){
final _that = this;
switch (_that) {
case _MembershipOption():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MembershipOption value)?  $default,){
final _that = this;
switch (_that) {
case _MembershipOption() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String salon,  String slug, @JsonKey(fromJson: _localized)  Map<String, String> name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MembershipOption() when $default != null:
return $default(_that.salon,_that.slug,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String salon,  String slug, @JsonKey(fromJson: _localized)  Map<String, String> name)  $default,) {final _that = this;
switch (_that) {
case _MembershipOption():
return $default(_that.salon,_that.slug,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String salon,  String slug, @JsonKey(fromJson: _localized)  Map<String, String> name)?  $default,) {final _that = this;
switch (_that) {
case _MembershipOption() when $default != null:
return $default(_that.salon,_that.slug,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MembershipOption implements MembershipOption {
  const _MembershipOption({required this.salon, required this.slug, @JsonKey(fromJson: _localized) required  Map<String, String> name}): _name = name;
  factory _MembershipOption.fromJson(Map<String, dynamic> json) => _$MembershipOptionFromJson(json);

@override final  String salon;
@override final  String slug;
 final  Map<String, String> _name;
@override@JsonKey(fromJson: _localized) Map<String, String> get name {
  if (_name is EqualUnmodifiableMapView) return _name;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_name);
}


/// Create a copy of MembershipOption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MembershipOptionCopyWith<_MembershipOption> get copyWith => __$MembershipOptionCopyWithImpl<_MembershipOption>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MembershipOptionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MembershipOption&&(identical(other.salon, salon) || other.salon == salon)&&(identical(other.slug, slug) || other.slug == slug)&&const DeepCollectionEquality().equals(other.name, _name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,salon,slug,const DeepCollectionEquality().hash(_name));
}

@override
String toString() {
    return 'MembershipOption(salon: $salon, slug: $slug, name: $name)';
}


}

/// @nodoc
abstract mixin class _$MembershipOptionCopyWith<$Res> implements $MembershipOptionCopyWith<$Res> {
  factory _$MembershipOptionCopyWith(_MembershipOption value, $Res Function(_MembershipOption) _then) = __$MembershipOptionCopyWithImpl;
@override @useResult
$Res call({
 String salon, String slug,@JsonKey(fromJson: _localized) Map<String, String> name
});




}
/// @nodoc
class __$MembershipOptionCopyWithImpl<$Res>
    implements _$MembershipOptionCopyWith<$Res> {
  __$MembershipOptionCopyWithImpl(this._self, this._then);

  final _MembershipOption _self;
  final $Res Function(_MembershipOption) _then;

/// Create a copy of MembershipOption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? salon = null,Object? slug = null,Object? name = null,}) {
  return _then(_MembershipOption(
salon: null == salon ? _self.salon : salon // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self._name : name // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}

// dart format on
