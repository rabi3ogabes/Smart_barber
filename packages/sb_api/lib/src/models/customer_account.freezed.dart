// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_account.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CustomerAccount {

 String get id; String get phone; String get locale; bool get profileComplete; String? get name; String? get email; String? get avatarUrl;
/// Create a copy of CustomerAccount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerAccountCopyWith<CustomerAccount> get copyWith => _$CustomerAccountCopyWithImpl<CustomerAccount>(this as CustomerAccount, _$identity);

  /// Serializes this CustomerAccount to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CustomerAccount;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerAccount&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.locale, _this.locale) || other.locale == _this.locale)&&(identical(other.profileComplete, _this.profileComplete) || other.profileComplete == _this.profileComplete)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.avatarUrl, _this.avatarUrl) || other.avatarUrl == _this.avatarUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CustomerAccount;
  return Object.hash(runtimeType,_this.id,_this.phone,_this.locale,_this.profileComplete,_this.name,_this.email,_this.avatarUrl);
}

@override
String toString() {
  final _this = this as CustomerAccount;
  return 'CustomerAccount(id: ${_this.id}, phone: ${_this.phone}, locale: ${_this.locale}, profileComplete: ${_this.profileComplete}, name: ${_this.name}, email: ${_this.email}, avatarUrl: ${_this.avatarUrl})';
}


}

/// @nodoc
abstract mixin class $CustomerAccountCopyWith<$Res>  {
  factory $CustomerAccountCopyWith(CustomerAccount value, $Res Function(CustomerAccount) _then) = _$CustomerAccountCopyWithImpl;
@useResult
$Res call({
 String id, String phone, String locale, bool profileComplete, String? name, String? email, String? avatarUrl
});




}
/// @nodoc
class _$CustomerAccountCopyWithImpl<$Res>
    implements $CustomerAccountCopyWith<$Res> {
  _$CustomerAccountCopyWithImpl(this._self, this._then);

  final CustomerAccount _self;
  final $Res Function(CustomerAccount) _then;

/// Create a copy of CustomerAccount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? phone = null,Object? locale = null,Object? profileComplete = null,Object? name = freezed,Object? email = freezed,Object? avatarUrl = freezed,}) {
  return _then(CustomerAccount(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,locale: null == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String,profileComplete: null == profileComplete ? _self.profileComplete : profileComplete // ignore: cast_nullable_to_non_nullable
as bool,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CustomerAccount].
extension CustomerAccountPatterns on CustomerAccount {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomerAccount value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomerAccount() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomerAccount value)  $default,){
final _that = this;
switch (_that) {
case _CustomerAccount():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomerAccount value)?  $default,){
final _that = this;
switch (_that) {
case _CustomerAccount() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String phone,  String locale,  bool profileComplete,  String? name,  String? email,  String? avatarUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomerAccount() when $default != null:
return $default(_that.id,_that.phone,_that.locale,_that.profileComplete,_that.name,_that.email,_that.avatarUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String phone,  String locale,  bool profileComplete,  String? name,  String? email,  String? avatarUrl)  $default,) {final _that = this;
switch (_that) {
case _CustomerAccount():
return $default(_that.id,_that.phone,_that.locale,_that.profileComplete,_that.name,_that.email,_that.avatarUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String phone,  String locale,  bool profileComplete,  String? name,  String? email,  String? avatarUrl)?  $default,) {final _that = this;
switch (_that) {
case _CustomerAccount() when $default != null:
return $default(_that.id,_that.phone,_that.locale,_that.profileComplete,_that.name,_that.email,_that.avatarUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CustomerAccount implements CustomerAccount {
  const _CustomerAccount({required this.id, required this.phone, required this.locale, required this.profileComplete, this.name, this.email, this.avatarUrl});
  factory _CustomerAccount.fromJson(Map<String, dynamic> json) => _$CustomerAccountFromJson(json);

@override final  String id;
@override final  String phone;
@override final  String locale;
@override final  bool profileComplete;
@override final  String? name;
@override final  String? email;
@override final  String? avatarUrl;

/// Create a copy of CustomerAccount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomerAccountCopyWith<_CustomerAccount> get copyWith => __$CustomerAccountCopyWithImpl<_CustomerAccount>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CustomerAccountToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomerAccount&&(identical(other.id, id) || other.id == id)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.profileComplete, profileComplete) || other.profileComplete == profileComplete)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,phone,locale,profileComplete,name,email,avatarUrl);
}

@override
String toString() {
    return 'CustomerAccount(id: $id, phone: $phone, locale: $locale, profileComplete: $profileComplete, name: $name, email: $email, avatarUrl: $avatarUrl)';
}


}

/// @nodoc
abstract mixin class _$CustomerAccountCopyWith<$Res> implements $CustomerAccountCopyWith<$Res> {
  factory _$CustomerAccountCopyWith(_CustomerAccount value, $Res Function(_CustomerAccount) _then) = __$CustomerAccountCopyWithImpl;
@override @useResult
$Res call({
 String id, String phone, String locale, bool profileComplete, String? name, String? email, String? avatarUrl
});




}
/// @nodoc
class __$CustomerAccountCopyWithImpl<$Res>
    implements _$CustomerAccountCopyWith<$Res> {
  __$CustomerAccountCopyWithImpl(this._self, this._then);

  final _CustomerAccount _self;
  final $Res Function(_CustomerAccount) _then;

/// Create a copy of CustomerAccount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? phone = null,Object? locale = null,Object? profileComplete = null,Object? name = freezed,Object? email = freezed,Object? avatarUrl = freezed,}) {
  return _then(_CustomerAccount(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,locale: null == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String,profileComplete: null == profileComplete ? _self.profileComplete : profileComplete // ignore: cast_nullable_to_non_nullable
as bool,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$OtpSent {

 int get expiresIn; int get retryAfter;
/// Create a copy of OtpSent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OtpSentCopyWith<OtpSent> get copyWith => _$OtpSentCopyWithImpl<OtpSent>(this as OtpSent, _$identity);

  /// Serializes this OtpSent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as OtpSent;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OtpSent&&(identical(other.expiresIn, _this.expiresIn) || other.expiresIn == _this.expiresIn)&&(identical(other.retryAfter, _this.retryAfter) || other.retryAfter == _this.retryAfter));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as OtpSent;
  return Object.hash(runtimeType,_this.expiresIn,_this.retryAfter);
}

@override
String toString() {
  final _this = this as OtpSent;
  return 'OtpSent(expiresIn: ${_this.expiresIn}, retryAfter: ${_this.retryAfter})';
}


}

/// @nodoc
abstract mixin class $OtpSentCopyWith<$Res>  {
  factory $OtpSentCopyWith(OtpSent value, $Res Function(OtpSent) _then) = _$OtpSentCopyWithImpl;
@useResult
$Res call({
 int expiresIn, int retryAfter
});




}
/// @nodoc
class _$OtpSentCopyWithImpl<$Res>
    implements $OtpSentCopyWith<$Res> {
  _$OtpSentCopyWithImpl(this._self, this._then);

  final OtpSent _self;
  final $Res Function(OtpSent) _then;

/// Create a copy of OtpSent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? expiresIn = null,Object? retryAfter = null,}) {
  return _then(OtpSent(
expiresIn: null == expiresIn ? _self.expiresIn : expiresIn // ignore: cast_nullable_to_non_nullable
as int,retryAfter: null == retryAfter ? _self.retryAfter : retryAfter // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [OtpSent].
extension OtpSentPatterns on OtpSent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OtpSent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OtpSent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OtpSent value)  $default,){
final _that = this;
switch (_that) {
case _OtpSent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OtpSent value)?  $default,){
final _that = this;
switch (_that) {
case _OtpSent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int expiresIn,  int retryAfter)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OtpSent() when $default != null:
return $default(_that.expiresIn,_that.retryAfter);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int expiresIn,  int retryAfter)  $default,) {final _that = this;
switch (_that) {
case _OtpSent():
return $default(_that.expiresIn,_that.retryAfter);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int expiresIn,  int retryAfter)?  $default,) {final _that = this;
switch (_that) {
case _OtpSent() when $default != null:
return $default(_that.expiresIn,_that.retryAfter);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OtpSent implements OtpSent {
  const _OtpSent({required this.expiresIn, required this.retryAfter});
  factory _OtpSent.fromJson(Map<String, dynamic> json) => _$OtpSentFromJson(json);

@override final  int expiresIn;
@override final  int retryAfter;

/// Create a copy of OtpSent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OtpSentCopyWith<_OtpSent> get copyWith => __$OtpSentCopyWithImpl<_OtpSent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OtpSentToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OtpSent&&(identical(other.expiresIn, expiresIn) || other.expiresIn == expiresIn)&&(identical(other.retryAfter, retryAfter) || other.retryAfter == retryAfter));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,expiresIn,retryAfter);
}

@override
String toString() {
    return 'OtpSent(expiresIn: $expiresIn, retryAfter: $retryAfter)';
}


}

/// @nodoc
abstract mixin class _$OtpSentCopyWith<$Res> implements $OtpSentCopyWith<$Res> {
  factory _$OtpSentCopyWith(_OtpSent value, $Res Function(_OtpSent) _then) = __$OtpSentCopyWithImpl;
@override @useResult
$Res call({
 int expiresIn, int retryAfter
});




}
/// @nodoc
class __$OtpSentCopyWithImpl<$Res>
    implements _$OtpSentCopyWith<$Res> {
  __$OtpSentCopyWithImpl(this._self, this._then);

  final _OtpSent _self;
  final $Res Function(_OtpSent) _then;

/// Create a copy of OtpSent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? expiresIn = null,Object? retryAfter = null,}) {
  return _then(_OtpSent(
expiresIn: null == expiresIn ? _self.expiresIn : expiresIn // ignore: cast_nullable_to_non_nullable
as int,retryAfter: null == retryAfter ? _self.retryAfter : retryAfter // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
