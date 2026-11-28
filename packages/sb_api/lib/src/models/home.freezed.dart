// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HomeSalon {

 String get id; String get slug;@LocalizedConverter() LocalizedText get name; String get currency; int get branchesCount; String? get logoUrl; String? get coverUrl; HomeBookingPolicy? get bookingPolicy;
/// Create a copy of HomeSalon
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeSalonCopyWith<HomeSalon> get copyWith => _$HomeSalonCopyWithImpl<HomeSalon>(this as HomeSalon, _$identity);

  /// Serializes this HomeSalon to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as HomeSalon;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeSalon&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.slug, _this.slug) || other.slug == _this.slug)&&const DeepCollectionEquality().equals(other.name, _this.name)&&(identical(other.currency, _this.currency) || other.currency == _this.currency)&&(identical(other.branchesCount, _this.branchesCount) || other.branchesCount == _this.branchesCount)&&(identical(other.logoUrl, _this.logoUrl) || other.logoUrl == _this.logoUrl)&&(identical(other.coverUrl, _this.coverUrl) || other.coverUrl == _this.coverUrl)&&(identical(other.bookingPolicy, _this.bookingPolicy) || other.bookingPolicy == _this.bookingPolicy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as HomeSalon;
  return Object.hash(runtimeType,_this.id,_this.slug,const DeepCollectionEquality().hash(_this.name),_this.currency,_this.branchesCount,_this.logoUrl,_this.coverUrl,_this.bookingPolicy);
}

@override
String toString() {
  final _this = this as HomeSalon;
  return 'HomeSalon(id: ${_this.id}, slug: ${_this.slug}, name: ${_this.name}, currency: ${_this.currency}, branchesCount: ${_this.branchesCount}, logoUrl: ${_this.logoUrl}, coverUrl: ${_this.coverUrl}, bookingPolicy: ${_this.bookingPolicy})';
}


}

/// @nodoc
abstract mixin class $HomeSalonCopyWith<$Res>  {
  factory $HomeSalonCopyWith(HomeSalon value, $Res Function(HomeSalon) _then) = _$HomeSalonCopyWithImpl;
@useResult
$Res call({
 String id, String slug,@LocalizedConverter() LocalizedText name, String currency, int branchesCount, String? logoUrl, String? coverUrl, HomeBookingPolicy? bookingPolicy
});


$HomeBookingPolicyCopyWith<$Res>? get bookingPolicy;

}
/// @nodoc
class _$HomeSalonCopyWithImpl<$Res>
    implements $HomeSalonCopyWith<$Res> {
  _$HomeSalonCopyWithImpl(this._self, this._then);

  final HomeSalon _self;
  final $Res Function(HomeSalon) _then;

/// Create a copy of HomeSalon
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? slug = null,Object? name = null,Object? currency = null,Object? branchesCount = null,Object? logoUrl = freezed,Object? coverUrl = freezed,Object? bookingPolicy = freezed,}) {
  return _then(HomeSalon(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as LocalizedText,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,branchesCount: null == branchesCount ? _self.branchesCount : branchesCount // ignore: cast_nullable_to_non_nullable
as int,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,bookingPolicy: freezed == bookingPolicy ? _self.bookingPolicy : bookingPolicy // ignore: cast_nullable_to_non_nullable
as HomeBookingPolicy?,
  ));
}
/// Create a copy of HomeSalon
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HomeBookingPolicyCopyWith<$Res>? get bookingPolicy {
    if (_self.bookingPolicy == null) {
    return null;
  }

  return $HomeBookingPolicyCopyWith<$Res>(_self.bookingPolicy!, (value) {
    return _then(_self.copyWith(bookingPolicy: value));
  });
}
}


/// Adds pattern-matching-related methods to [HomeSalon].
extension HomeSalonPatterns on HomeSalon {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeSalon value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeSalon() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeSalon value)  $default,){
final _that = this;
switch (_that) {
case _HomeSalon():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeSalon value)?  $default,){
final _that = this;
switch (_that) {
case _HomeSalon() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String slug, @LocalizedConverter()  LocalizedText name,  String currency,  int branchesCount,  String? logoUrl,  String? coverUrl,  HomeBookingPolicy? bookingPolicy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeSalon() when $default != null:
return $default(_that.id,_that.slug,_that.name,_that.currency,_that.branchesCount,_that.logoUrl,_that.coverUrl,_that.bookingPolicy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String slug, @LocalizedConverter()  LocalizedText name,  String currency,  int branchesCount,  String? logoUrl,  String? coverUrl,  HomeBookingPolicy? bookingPolicy)  $default,) {final _that = this;
switch (_that) {
case _HomeSalon():
return $default(_that.id,_that.slug,_that.name,_that.currency,_that.branchesCount,_that.logoUrl,_that.coverUrl,_that.bookingPolicy);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String slug, @LocalizedConverter()  LocalizedText name,  String currency,  int branchesCount,  String? logoUrl,  String? coverUrl,  HomeBookingPolicy? bookingPolicy)?  $default,) {final _that = this;
switch (_that) {
case _HomeSalon() when $default != null:
return $default(_that.id,_that.slug,_that.name,_that.currency,_that.branchesCount,_that.logoUrl,_that.coverUrl,_that.bookingPolicy);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HomeSalon implements HomeSalon {
  const _HomeSalon({required this.id, required this.slug, @LocalizedConverter() required  LocalizedText name, required this.currency, this.branchesCount = 0, this.logoUrl, this.coverUrl, this.bookingPolicy}): _name = name;
  factory _HomeSalon.fromJson(Map<String, dynamic> json) => _$HomeSalonFromJson(json);

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
@override final  String? coverUrl;
@override final  HomeBookingPolicy? bookingPolicy;

/// Create a copy of HomeSalon
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeSalonCopyWith<_HomeSalon> get copyWith => __$HomeSalonCopyWithImpl<_HomeSalon>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HomeSalonToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeSalon&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&const DeepCollectionEquality().equals(other.name, _name)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.branchesCount, branchesCount) || other.branchesCount == branchesCount)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.bookingPolicy, bookingPolicy) || other.bookingPolicy == bookingPolicy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,slug,const DeepCollectionEquality().hash(_name),currency,branchesCount,logoUrl,coverUrl,bookingPolicy);
}

@override
String toString() {
    return 'HomeSalon(id: $id, slug: $slug, name: $name, currency: $currency, branchesCount: $branchesCount, logoUrl: $logoUrl, coverUrl: $coverUrl, bookingPolicy: $bookingPolicy)';
}


}

/// @nodoc
abstract mixin class _$HomeSalonCopyWith<$Res> implements $HomeSalonCopyWith<$Res> {
  factory _$HomeSalonCopyWith(_HomeSalon value, $Res Function(_HomeSalon) _then) = __$HomeSalonCopyWithImpl;
@override @useResult
$Res call({
 String id, String slug,@LocalizedConverter() LocalizedText name, String currency, int branchesCount, String? logoUrl, String? coverUrl, HomeBookingPolicy? bookingPolicy
});


@override $HomeBookingPolicyCopyWith<$Res>? get bookingPolicy;

}
/// @nodoc
class __$HomeSalonCopyWithImpl<$Res>
    implements _$HomeSalonCopyWith<$Res> {
  __$HomeSalonCopyWithImpl(this._self, this._then);

  final _HomeSalon _self;
  final $Res Function(_HomeSalon) _then;

/// Create a copy of HomeSalon
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? slug = null,Object? name = null,Object? currency = null,Object? branchesCount = null,Object? logoUrl = freezed,Object? coverUrl = freezed,Object? bookingPolicy = freezed,}) {
  return _then(_HomeSalon(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self._name : name // ignore: cast_nullable_to_non_nullable
as LocalizedText,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,branchesCount: null == branchesCount ? _self.branchesCount : branchesCount // ignore: cast_nullable_to_non_nullable
as int,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,bookingPolicy: freezed == bookingPolicy ? _self.bookingPolicy : bookingPolicy // ignore: cast_nullable_to_non_nullable
as HomeBookingPolicy?,
  ));
}

/// Create a copy of HomeSalon
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HomeBookingPolicyCopyWith<$Res>? get bookingPolicy {
    if (_self.bookingPolicy == null) {
    return null;
  }

  return $HomeBookingPolicyCopyWith<$Res>(_self.bookingPolicy!, (value) {
    return _then(_self.copyWith(bookingPolicy: value));
  });
}
}


/// @nodoc
mixin _$HomeBookingPolicy {

 int get leadTimeMinutes; int get maxDaysAhead; int get cancellationWindowMinutes;
/// Create a copy of HomeBookingPolicy
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeBookingPolicyCopyWith<HomeBookingPolicy> get copyWith => _$HomeBookingPolicyCopyWithImpl<HomeBookingPolicy>(this as HomeBookingPolicy, _$identity);

  /// Serializes this HomeBookingPolicy to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as HomeBookingPolicy;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeBookingPolicy&&(identical(other.leadTimeMinutes, _this.leadTimeMinutes) || other.leadTimeMinutes == _this.leadTimeMinutes)&&(identical(other.maxDaysAhead, _this.maxDaysAhead) || other.maxDaysAhead == _this.maxDaysAhead)&&(identical(other.cancellationWindowMinutes, _this.cancellationWindowMinutes) || other.cancellationWindowMinutes == _this.cancellationWindowMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as HomeBookingPolicy;
  return Object.hash(runtimeType,_this.leadTimeMinutes,_this.maxDaysAhead,_this.cancellationWindowMinutes);
}

@override
String toString() {
  final _this = this as HomeBookingPolicy;
  return 'HomeBookingPolicy(leadTimeMinutes: ${_this.leadTimeMinutes}, maxDaysAhead: ${_this.maxDaysAhead}, cancellationWindowMinutes: ${_this.cancellationWindowMinutes})';
}


}

/// @nodoc
abstract mixin class $HomeBookingPolicyCopyWith<$Res>  {
  factory $HomeBookingPolicyCopyWith(HomeBookingPolicy value, $Res Function(HomeBookingPolicy) _then) = _$HomeBookingPolicyCopyWithImpl;
@useResult
$Res call({
 int leadTimeMinutes, int maxDaysAhead, int cancellationWindowMinutes
});




}
/// @nodoc
class _$HomeBookingPolicyCopyWithImpl<$Res>
    implements $HomeBookingPolicyCopyWith<$Res> {
  _$HomeBookingPolicyCopyWithImpl(this._self, this._then);

  final HomeBookingPolicy _self;
  final $Res Function(HomeBookingPolicy) _then;

/// Create a copy of HomeBookingPolicy
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? leadTimeMinutes = null,Object? maxDaysAhead = null,Object? cancellationWindowMinutes = null,}) {
  return _then(HomeBookingPolicy(
leadTimeMinutes: null == leadTimeMinutes ? _self.leadTimeMinutes : leadTimeMinutes // ignore: cast_nullable_to_non_nullable
as int,maxDaysAhead: null == maxDaysAhead ? _self.maxDaysAhead : maxDaysAhead // ignore: cast_nullable_to_non_nullable
as int,cancellationWindowMinutes: null == cancellationWindowMinutes ? _self.cancellationWindowMinutes : cancellationWindowMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [HomeBookingPolicy].
extension HomeBookingPolicyPatterns on HomeBookingPolicy {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeBookingPolicy value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeBookingPolicy() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeBookingPolicy value)  $default,){
final _that = this;
switch (_that) {
case _HomeBookingPolicy():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeBookingPolicy value)?  $default,){
final _that = this;
switch (_that) {
case _HomeBookingPolicy() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int leadTimeMinutes,  int maxDaysAhead,  int cancellationWindowMinutes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeBookingPolicy() when $default != null:
return $default(_that.leadTimeMinutes,_that.maxDaysAhead,_that.cancellationWindowMinutes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int leadTimeMinutes,  int maxDaysAhead,  int cancellationWindowMinutes)  $default,) {final _that = this;
switch (_that) {
case _HomeBookingPolicy():
return $default(_that.leadTimeMinutes,_that.maxDaysAhead,_that.cancellationWindowMinutes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int leadTimeMinutes,  int maxDaysAhead,  int cancellationWindowMinutes)?  $default,) {final _that = this;
switch (_that) {
case _HomeBookingPolicy() when $default != null:
return $default(_that.leadTimeMinutes,_that.maxDaysAhead,_that.cancellationWindowMinutes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HomeBookingPolicy implements HomeBookingPolicy {
  const _HomeBookingPolicy({this.leadTimeMinutes = 0, this.maxDaysAhead = 30, this.cancellationWindowMinutes = 0});
  factory _HomeBookingPolicy.fromJson(Map<String, dynamic> json) => _$HomeBookingPolicyFromJson(json);

@override@JsonKey() final  int leadTimeMinutes;
@override@JsonKey() final  int maxDaysAhead;
@override@JsonKey() final  int cancellationWindowMinutes;

/// Create a copy of HomeBookingPolicy
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeBookingPolicyCopyWith<_HomeBookingPolicy> get copyWith => __$HomeBookingPolicyCopyWithImpl<_HomeBookingPolicy>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HomeBookingPolicyToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeBookingPolicy&&(identical(other.leadTimeMinutes, leadTimeMinutes) || other.leadTimeMinutes == leadTimeMinutes)&&(identical(other.maxDaysAhead, maxDaysAhead) || other.maxDaysAhead == maxDaysAhead)&&(identical(other.cancellationWindowMinutes, cancellationWindowMinutes) || other.cancellationWindowMinutes == cancellationWindowMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,leadTimeMinutes,maxDaysAhead,cancellationWindowMinutes);
}

@override
String toString() {
    return 'HomeBookingPolicy(leadTimeMinutes: $leadTimeMinutes, maxDaysAhead: $maxDaysAhead, cancellationWindowMinutes: $cancellationWindowMinutes)';
}


}

/// @nodoc
abstract mixin class _$HomeBookingPolicyCopyWith<$Res> implements $HomeBookingPolicyCopyWith<$Res> {
  factory _$HomeBookingPolicyCopyWith(_HomeBookingPolicy value, $Res Function(_HomeBookingPolicy) _then) = __$HomeBookingPolicyCopyWithImpl;
@override @useResult
$Res call({
 int leadTimeMinutes, int maxDaysAhead, int cancellationWindowMinutes
});




}
/// @nodoc
class __$HomeBookingPolicyCopyWithImpl<$Res>
    implements _$HomeBookingPolicyCopyWith<$Res> {
  __$HomeBookingPolicyCopyWithImpl(this._self, this._then);

  final _HomeBookingPolicy _self;
  final $Res Function(_HomeBookingPolicy) _then;

/// Create a copy of HomeBookingPolicy
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? leadTimeMinutes = null,Object? maxDaysAhead = null,Object? cancellationWindowMinutes = null,}) {
  return _then(_HomeBookingPolicy(
leadTimeMinutes: null == leadTimeMinutes ? _self.leadTimeMinutes : leadTimeMinutes // ignore: cast_nullable_to_non_nullable
as int,maxDaysAhead: null == maxDaysAhead ? _self.maxDaysAhead : maxDaysAhead // ignore: cast_nullable_to_non_nullable
as int,cancellationWindowMinutes: null == cancellationWindowMinutes ? _self.cancellationWindowMinutes : cancellationWindowMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$BookAgain {

 String get booking; String get branch;@UtcDateTimeConverter() DateTime get lastVisitAt; BookingBarber? get barber; List<String> get services; List<String> get addons; List<String> get bundles;@LocalizedListConverter() List<LocalizedText> get names;
/// Create a copy of BookAgain
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookAgainCopyWith<BookAgain> get copyWith => _$BookAgainCopyWithImpl<BookAgain>(this as BookAgain, _$identity);

  /// Serializes this BookAgain to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BookAgain;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookAgain&&(identical(other.booking, _this.booking) || other.booking == _this.booking)&&(identical(other.branch, _this.branch) || other.branch == _this.branch)&&(identical(other.lastVisitAt, _this.lastVisitAt) || other.lastVisitAt == _this.lastVisitAt)&&(identical(other.barber, _this.barber) || other.barber == _this.barber)&&const DeepCollectionEquality().equals(other.services, _this.services)&&const DeepCollectionEquality().equals(other.addons, _this.addons)&&const DeepCollectionEquality().equals(other.bundles, _this.bundles)&&const DeepCollectionEquality().equals(other.names, _this.names));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BookAgain;
  return Object.hash(runtimeType,_this.booking,_this.branch,_this.lastVisitAt,_this.barber,const DeepCollectionEquality().hash(_this.services),const DeepCollectionEquality().hash(_this.addons),const DeepCollectionEquality().hash(_this.bundles),const DeepCollectionEquality().hash(_this.names));
}

@override
String toString() {
  final _this = this as BookAgain;
  return 'BookAgain(booking: ${_this.booking}, branch: ${_this.branch}, lastVisitAt: ${_this.lastVisitAt}, barber: ${_this.barber}, services: ${_this.services}, addons: ${_this.addons}, bundles: ${_this.bundles}, names: ${_this.names})';
}


}

/// @nodoc
abstract mixin class $BookAgainCopyWith<$Res>  {
  factory $BookAgainCopyWith(BookAgain value, $Res Function(BookAgain) _then) = _$BookAgainCopyWithImpl;
@useResult
$Res call({
 String booking, String branch,@UtcDateTimeConverter() DateTime lastVisitAt, BookingBarber? barber, List<String> services, List<String> addons, List<String> bundles,@LocalizedListConverter() List<LocalizedText> names
});


$BookingBarberCopyWith<$Res>? get barber;

}
/// @nodoc
class _$BookAgainCopyWithImpl<$Res>
    implements $BookAgainCopyWith<$Res> {
  _$BookAgainCopyWithImpl(this._self, this._then);

  final BookAgain _self;
  final $Res Function(BookAgain) _then;

/// Create a copy of BookAgain
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? booking = null,Object? branch = null,Object? lastVisitAt = null,Object? barber = freezed,Object? services = null,Object? addons = null,Object? bundles = null,Object? names = null,}) {
  return _then(BookAgain(
booking: null == booking ? _self.booking : booking // ignore: cast_nullable_to_non_nullable
as String,branch: null == branch ? _self.branch : branch // ignore: cast_nullable_to_non_nullable
as String,lastVisitAt: null == lastVisitAt ? _self.lastVisitAt : lastVisitAt // ignore: cast_nullable_to_non_nullable
as DateTime,barber: freezed == barber ? _self.barber : barber // ignore: cast_nullable_to_non_nullable
as BookingBarber?,services: null == services ? _self.services : services // ignore: cast_nullable_to_non_nullable
as List<String>,addons: null == addons ? _self.addons : addons // ignore: cast_nullable_to_non_nullable
as List<String>,bundles: null == bundles ? _self.bundles : bundles // ignore: cast_nullable_to_non_nullable
as List<String>,names: null == names ? _self.names : names // ignore: cast_nullable_to_non_nullable
as List<LocalizedText>,
  ));
}
/// Create a copy of BookAgain
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
}
}


/// Adds pattern-matching-related methods to [BookAgain].
extension BookAgainPatterns on BookAgain {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookAgain value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookAgain() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookAgain value)  $default,){
final _that = this;
switch (_that) {
case _BookAgain():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookAgain value)?  $default,){
final _that = this;
switch (_that) {
case _BookAgain() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String booking,  String branch, @UtcDateTimeConverter()  DateTime lastVisitAt,  BookingBarber? barber,  List<String> services,  List<String> addons,  List<String> bundles, @LocalizedListConverter()  List<LocalizedText> names)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookAgain() when $default != null:
return $default(_that.booking,_that.branch,_that.lastVisitAt,_that.barber,_that.services,_that.addons,_that.bundles,_that.names);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String booking,  String branch, @UtcDateTimeConverter()  DateTime lastVisitAt,  BookingBarber? barber,  List<String> services,  List<String> addons,  List<String> bundles, @LocalizedListConverter()  List<LocalizedText> names)  $default,) {final _that = this;
switch (_that) {
case _BookAgain():
return $default(_that.booking,_that.branch,_that.lastVisitAt,_that.barber,_that.services,_that.addons,_that.bundles,_that.names);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String booking,  String branch, @UtcDateTimeConverter()  DateTime lastVisitAt,  BookingBarber? barber,  List<String> services,  List<String> addons,  List<String> bundles, @LocalizedListConverter()  List<LocalizedText> names)?  $default,) {final _that = this;
switch (_that) {
case _BookAgain() when $default != null:
return $default(_that.booking,_that.branch,_that.lastVisitAt,_that.barber,_that.services,_that.addons,_that.bundles,_that.names);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BookAgain implements BookAgain {
  const _BookAgain({required this.booking, required this.branch, @UtcDateTimeConverter() required this.lastVisitAt, this.barber,  List<String> services = const [],  List<String> addons = const [],  List<String> bundles = const [], @LocalizedListConverter()  List<LocalizedText> names = const []}): _services = services,_addons = addons,_bundles = bundles,_names = names;
  factory _BookAgain.fromJson(Map<String, dynamic> json) => _$BookAgainFromJson(json);

@override final  String booking;
@override final  String branch;
@override@UtcDateTimeConverter() final  DateTime lastVisitAt;
@override final  BookingBarber? barber;
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

 final  List<LocalizedText> _names;
@override@JsonKey()@LocalizedListConverter() List<LocalizedText> get names {
  if (_names is EqualUnmodifiableListView) return _names;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_names);
}


/// Create a copy of BookAgain
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookAgainCopyWith<_BookAgain> get copyWith => __$BookAgainCopyWithImpl<_BookAgain>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookAgainToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookAgain&&(identical(other.booking, booking) || other.booking == booking)&&(identical(other.branch, branch) || other.branch == branch)&&(identical(other.lastVisitAt, lastVisitAt) || other.lastVisitAt == lastVisitAt)&&(identical(other.barber, barber) || other.barber == barber)&&const DeepCollectionEquality().equals(other.services, _services)&&const DeepCollectionEquality().equals(other.addons, _addons)&&const DeepCollectionEquality().equals(other.bundles, _bundles)&&const DeepCollectionEquality().equals(other.names, _names));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,booking,branch,lastVisitAt,barber,const DeepCollectionEquality().hash(_services),const DeepCollectionEquality().hash(_addons),const DeepCollectionEquality().hash(_bundles),const DeepCollectionEquality().hash(_names));
}

@override
String toString() {
    return 'BookAgain(booking: $booking, branch: $branch, lastVisitAt: $lastVisitAt, barber: $barber, services: $services, addons: $addons, bundles: $bundles, names: $names)';
}


}

/// @nodoc
abstract mixin class _$BookAgainCopyWith<$Res> implements $BookAgainCopyWith<$Res> {
  factory _$BookAgainCopyWith(_BookAgain value, $Res Function(_BookAgain) _then) = __$BookAgainCopyWithImpl;
@override @useResult
$Res call({
 String booking, String branch,@UtcDateTimeConverter() DateTime lastVisitAt, BookingBarber? barber, List<String> services, List<String> addons, List<String> bundles,@LocalizedListConverter() List<LocalizedText> names
});


@override $BookingBarberCopyWith<$Res>? get barber;

}
/// @nodoc
class __$BookAgainCopyWithImpl<$Res>
    implements _$BookAgainCopyWith<$Res> {
  __$BookAgainCopyWithImpl(this._self, this._then);

  final _BookAgain _self;
  final $Res Function(_BookAgain) _then;

/// Create a copy of BookAgain
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? booking = null,Object? branch = null,Object? lastVisitAt = null,Object? barber = freezed,Object? services = null,Object? addons = null,Object? bundles = null,Object? names = null,}) {
  return _then(_BookAgain(
booking: null == booking ? _self.booking : booking // ignore: cast_nullable_to_non_nullable
as String,branch: null == branch ? _self.branch : branch // ignore: cast_nullable_to_non_nullable
as String,lastVisitAt: null == lastVisitAt ? _self.lastVisitAt : lastVisitAt // ignore: cast_nullable_to_non_nullable
as DateTime,barber: freezed == barber ? _self.barber : barber // ignore: cast_nullable_to_non_nullable
as BookingBarber?,services: null == services ? _self._services : services // ignore: cast_nullable_to_non_nullable
as List<String>,addons: null == addons ? _self._addons : addons // ignore: cast_nullable_to_non_nullable
as List<String>,bundles: null == bundles ? _self._bundles : bundles // ignore: cast_nullable_to_non_nullable
as List<String>,names: null == names ? _self._names : names // ignore: cast_nullable_to_non_nullable
as List<LocalizedText>,
  ));
}

/// Create a copy of BookAgain
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
}
}


/// @nodoc
mixin _$ReviewPrompt {

 String get booking;@UtcDateTimeConverter() DateTime get startsAt;@LocalizedOrNullConverter() LocalizedText? get barber;
/// Create a copy of ReviewPrompt
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReviewPromptCopyWith<ReviewPrompt> get copyWith => _$ReviewPromptCopyWithImpl<ReviewPrompt>(this as ReviewPrompt, _$identity);

  /// Serializes this ReviewPrompt to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ReviewPrompt;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReviewPrompt&&(identical(other.booking, _this.booking) || other.booking == _this.booking)&&(identical(other.startsAt, _this.startsAt) || other.startsAt == _this.startsAt)&&const DeepCollectionEquality().equals(other.barber, _this.barber));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ReviewPrompt;
  return Object.hash(runtimeType,_this.booking,_this.startsAt,const DeepCollectionEquality().hash(_this.barber));
}

@override
String toString() {
  final _this = this as ReviewPrompt;
  return 'ReviewPrompt(booking: ${_this.booking}, startsAt: ${_this.startsAt}, barber: ${_this.barber})';
}


}

/// @nodoc
abstract mixin class $ReviewPromptCopyWith<$Res>  {
  factory $ReviewPromptCopyWith(ReviewPrompt value, $Res Function(ReviewPrompt) _then) = _$ReviewPromptCopyWithImpl;
@useResult
$Res call({
 String booking,@UtcDateTimeConverter() DateTime startsAt,@LocalizedOrNullConverter() LocalizedText? barber
});




}
/// @nodoc
class _$ReviewPromptCopyWithImpl<$Res>
    implements $ReviewPromptCopyWith<$Res> {
  _$ReviewPromptCopyWithImpl(this._self, this._then);

  final ReviewPrompt _self;
  final $Res Function(ReviewPrompt) _then;

/// Create a copy of ReviewPrompt
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? booking = null,Object? startsAt = null,Object? barber = freezed,}) {
  return _then(ReviewPrompt(
booking: null == booking ? _self.booking : booking // ignore: cast_nullable_to_non_nullable
as String,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,barber: freezed == barber ? _self.barber : barber // ignore: cast_nullable_to_non_nullable
as LocalizedText?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReviewPrompt].
extension ReviewPromptPatterns on ReviewPrompt {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReviewPrompt value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReviewPrompt() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReviewPrompt value)  $default,){
final _that = this;
switch (_that) {
case _ReviewPrompt():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReviewPrompt value)?  $default,){
final _that = this;
switch (_that) {
case _ReviewPrompt() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String booking, @UtcDateTimeConverter()  DateTime startsAt, @LocalizedOrNullConverter()  LocalizedText? barber)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReviewPrompt() when $default != null:
return $default(_that.booking,_that.startsAt,_that.barber);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String booking, @UtcDateTimeConverter()  DateTime startsAt, @LocalizedOrNullConverter()  LocalizedText? barber)  $default,) {final _that = this;
switch (_that) {
case _ReviewPrompt():
return $default(_that.booking,_that.startsAt,_that.barber);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String booking, @UtcDateTimeConverter()  DateTime startsAt, @LocalizedOrNullConverter()  LocalizedText? barber)?  $default,) {final _that = this;
switch (_that) {
case _ReviewPrompt() when $default != null:
return $default(_that.booking,_that.startsAt,_that.barber);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReviewPrompt implements ReviewPrompt {
  const _ReviewPrompt({required this.booking, @UtcDateTimeConverter() required this.startsAt, @LocalizedOrNullConverter()  LocalizedText? barber}): _barber = barber;
  factory _ReviewPrompt.fromJson(Map<String, dynamic> json) => _$ReviewPromptFromJson(json);

@override final  String booking;
@override@UtcDateTimeConverter() final  DateTime startsAt;
 final  LocalizedText? _barber;
@override@LocalizedOrNullConverter() LocalizedText? get barber {
  final value = _barber;
  if (value == null) return null;
  if (_barber is EqualUnmodifiableMapView) return _barber;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of ReviewPrompt
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReviewPromptCopyWith<_ReviewPrompt> get copyWith => __$ReviewPromptCopyWithImpl<_ReviewPrompt>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReviewPromptToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReviewPrompt&&(identical(other.booking, booking) || other.booking == booking)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&const DeepCollectionEquality().equals(other.barber, _barber));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,booking,startsAt,const DeepCollectionEquality().hash(_barber));
}

@override
String toString() {
    return 'ReviewPrompt(booking: $booking, startsAt: $startsAt, barber: $barber)';
}


}

/// @nodoc
abstract mixin class _$ReviewPromptCopyWith<$Res> implements $ReviewPromptCopyWith<$Res> {
  factory _$ReviewPromptCopyWith(_ReviewPrompt value, $Res Function(_ReviewPrompt) _then) = __$ReviewPromptCopyWithImpl;
@override @useResult
$Res call({
 String booking,@UtcDateTimeConverter() DateTime startsAt,@LocalizedOrNullConverter() LocalizedText? barber
});




}
/// @nodoc
class __$ReviewPromptCopyWithImpl<$Res>
    implements _$ReviewPromptCopyWith<$Res> {
  __$ReviewPromptCopyWithImpl(this._self, this._then);

  final _ReviewPrompt _self;
  final $Res Function(_ReviewPrompt) _then;

/// Create a copy of ReviewPrompt
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? booking = null,Object? startsAt = null,Object? barber = freezed,}) {
  return _then(_ReviewPrompt(
booking: null == booking ? _self.booking : booking // ignore: cast_nullable_to_non_nullable
as String,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,barber: freezed == barber ? _self._barber : barber // ignore: cast_nullable_to_non_nullable
as LocalizedText?,
  ));
}


}


/// @nodoc
mixin _$PopularService {

 String get id;@LocalizedConverter() LocalizedText get name; int get durationMinutes; Money? get price; String? get imageUrl;
/// Create a copy of PopularService
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PopularServiceCopyWith<PopularService> get copyWith => _$PopularServiceCopyWithImpl<PopularService>(this as PopularService, _$identity);

  /// Serializes this PopularService to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PopularService;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PopularService&&(identical(other.id, _this.id) || other.id == _this.id)&&const DeepCollectionEquality().equals(other.name, _this.name)&&(identical(other.durationMinutes, _this.durationMinutes) || other.durationMinutes == _this.durationMinutes)&&(identical(other.price, _this.price) || other.price == _this.price)&&(identical(other.imageUrl, _this.imageUrl) || other.imageUrl == _this.imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PopularService;
  return Object.hash(runtimeType,_this.id,const DeepCollectionEquality().hash(_this.name),_this.durationMinutes,_this.price,_this.imageUrl);
}

@override
String toString() {
  final _this = this as PopularService;
  return 'PopularService(id: ${_this.id}, name: ${_this.name}, durationMinutes: ${_this.durationMinutes}, price: ${_this.price}, imageUrl: ${_this.imageUrl})';
}


}

/// @nodoc
abstract mixin class $PopularServiceCopyWith<$Res>  {
  factory $PopularServiceCopyWith(PopularService value, $Res Function(PopularService) _then) = _$PopularServiceCopyWithImpl;
@useResult
$Res call({
 String id,@LocalizedConverter() LocalizedText name, int durationMinutes, Money? price, String? imageUrl
});


$MoneyCopyWith<$Res>? get price;

}
/// @nodoc
class _$PopularServiceCopyWithImpl<$Res>
    implements $PopularServiceCopyWith<$Res> {
  _$PopularServiceCopyWithImpl(this._self, this._then);

  final PopularService _self;
  final $Res Function(PopularService) _then;

/// Create a copy of PopularService
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? durationMinutes = null,Object? price = freezed,Object? imageUrl = freezed,}) {
  return _then(PopularService(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as LocalizedText,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as Money?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of PopularService
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


/// Adds pattern-matching-related methods to [PopularService].
extension PopularServicePatterns on PopularService {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PopularService value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PopularService() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PopularService value)  $default,){
final _that = this;
switch (_that) {
case _PopularService():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PopularService value)?  $default,){
final _that = this;
switch (_that) {
case _PopularService() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @LocalizedConverter()  LocalizedText name,  int durationMinutes,  Money? price,  String? imageUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PopularService() when $default != null:
return $default(_that.id,_that.name,_that.durationMinutes,_that.price,_that.imageUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @LocalizedConverter()  LocalizedText name,  int durationMinutes,  Money? price,  String? imageUrl)  $default,) {final _that = this;
switch (_that) {
case _PopularService():
return $default(_that.id,_that.name,_that.durationMinutes,_that.price,_that.imageUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @LocalizedConverter()  LocalizedText name,  int durationMinutes,  Money? price,  String? imageUrl)?  $default,) {final _that = this;
switch (_that) {
case _PopularService() when $default != null:
return $default(_that.id,_that.name,_that.durationMinutes,_that.price,_that.imageUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PopularService implements PopularService {
  const _PopularService({required this.id, @LocalizedConverter() required  LocalizedText name, required this.durationMinutes, this.price, this.imageUrl}): _name = name;
  factory _PopularService.fromJson(Map<String, dynamic> json) => _$PopularServiceFromJson(json);

@override final  String id;
 final  LocalizedText _name;
@override@LocalizedConverter() LocalizedText get name {
  if (_name is EqualUnmodifiableMapView) return _name;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_name);
}

@override final  int durationMinutes;
@override final  Money? price;
@override final  String? imageUrl;

/// Create a copy of PopularService
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PopularServiceCopyWith<_PopularService> get copyWith => __$PopularServiceCopyWithImpl<_PopularService>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PopularServiceToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PopularService&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.name, _name)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.price, price) || other.price == price)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_name),durationMinutes,price,imageUrl);
}

@override
String toString() {
    return 'PopularService(id: $id, name: $name, durationMinutes: $durationMinutes, price: $price, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class _$PopularServiceCopyWith<$Res> implements $PopularServiceCopyWith<$Res> {
  factory _$PopularServiceCopyWith(_PopularService value, $Res Function(_PopularService) _then) = __$PopularServiceCopyWithImpl;
@override @useResult
$Res call({
 String id,@LocalizedConverter() LocalizedText name, int durationMinutes, Money? price, String? imageUrl
});


@override $MoneyCopyWith<$Res>? get price;

}
/// @nodoc
class __$PopularServiceCopyWithImpl<$Res>
    implements _$PopularServiceCopyWith<$Res> {
  __$PopularServiceCopyWithImpl(this._self, this._then);

  final _PopularService _self;
  final $Res Function(_PopularService) _then;

/// Create a copy of PopularService
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? durationMinutes = null,Object? price = freezed,Object? imageUrl = freezed,}) {
  return _then(_PopularService(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self._name : name // ignore: cast_nullable_to_non_nullable
as LocalizedText,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as Money?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of PopularService
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
mixin _$HomeFeatures {

 bool get aiStudio; bool get loyalty;
/// Create a copy of HomeFeatures
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeFeaturesCopyWith<HomeFeatures> get copyWith => _$HomeFeaturesCopyWithImpl<HomeFeatures>(this as HomeFeatures, _$identity);

  /// Serializes this HomeFeatures to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as HomeFeatures;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeFeatures&&(identical(other.aiStudio, _this.aiStudio) || other.aiStudio == _this.aiStudio)&&(identical(other.loyalty, _this.loyalty) || other.loyalty == _this.loyalty));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as HomeFeatures;
  return Object.hash(runtimeType,_this.aiStudio,_this.loyalty);
}

@override
String toString() {
  final _this = this as HomeFeatures;
  return 'HomeFeatures(aiStudio: ${_this.aiStudio}, loyalty: ${_this.loyalty})';
}


}

/// @nodoc
abstract mixin class $HomeFeaturesCopyWith<$Res>  {
  factory $HomeFeaturesCopyWith(HomeFeatures value, $Res Function(HomeFeatures) _then) = _$HomeFeaturesCopyWithImpl;
@useResult
$Res call({
 bool aiStudio, bool loyalty
});




}
/// @nodoc
class _$HomeFeaturesCopyWithImpl<$Res>
    implements $HomeFeaturesCopyWith<$Res> {
  _$HomeFeaturesCopyWithImpl(this._self, this._then);

  final HomeFeatures _self;
  final $Res Function(HomeFeatures) _then;

/// Create a copy of HomeFeatures
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? aiStudio = null,Object? loyalty = null,}) {
  return _then(HomeFeatures(
aiStudio: null == aiStudio ? _self.aiStudio : aiStudio // ignore: cast_nullable_to_non_nullable
as bool,loyalty: null == loyalty ? _self.loyalty : loyalty // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [HomeFeatures].
extension HomeFeaturesPatterns on HomeFeatures {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeFeatures value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeFeatures() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeFeatures value)  $default,){
final _that = this;
switch (_that) {
case _HomeFeatures():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeFeatures value)?  $default,){
final _that = this;
switch (_that) {
case _HomeFeatures() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool aiStudio,  bool loyalty)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeFeatures() when $default != null:
return $default(_that.aiStudio,_that.loyalty);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool aiStudio,  bool loyalty)  $default,) {final _that = this;
switch (_that) {
case _HomeFeatures():
return $default(_that.aiStudio,_that.loyalty);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool aiStudio,  bool loyalty)?  $default,) {final _that = this;
switch (_that) {
case _HomeFeatures() when $default != null:
return $default(_that.aiStudio,_that.loyalty);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HomeFeatures implements HomeFeatures {
  const _HomeFeatures({this.aiStudio = false, this.loyalty = false});
  factory _HomeFeatures.fromJson(Map<String, dynamic> json) => _$HomeFeaturesFromJson(json);

@override@JsonKey() final  bool aiStudio;
@override@JsonKey() final  bool loyalty;

/// Create a copy of HomeFeatures
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeFeaturesCopyWith<_HomeFeatures> get copyWith => __$HomeFeaturesCopyWithImpl<_HomeFeatures>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HomeFeaturesToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeFeatures&&(identical(other.aiStudio, aiStudio) || other.aiStudio == aiStudio)&&(identical(other.loyalty, loyalty) || other.loyalty == loyalty));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,aiStudio,loyalty);
}

@override
String toString() {
    return 'HomeFeatures(aiStudio: $aiStudio, loyalty: $loyalty)';
}


}

/// @nodoc
abstract mixin class _$HomeFeaturesCopyWith<$Res> implements $HomeFeaturesCopyWith<$Res> {
  factory _$HomeFeaturesCopyWith(_HomeFeatures value, $Res Function(_HomeFeatures) _then) = __$HomeFeaturesCopyWithImpl;
@override @useResult
$Res call({
 bool aiStudio, bool loyalty
});




}
/// @nodoc
class __$HomeFeaturesCopyWithImpl<$Res>
    implements _$HomeFeaturesCopyWith<$Res> {
  __$HomeFeaturesCopyWithImpl(this._self, this._then);

  final _HomeFeatures _self;
  final $Res Function(_HomeFeatures) _then;

/// Create a copy of HomeFeatures
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? aiStudio = null,Object? loyalty = null,}) {
  return _then(_HomeFeatures(
aiStudio: null == aiStudio ? _self.aiStudio : aiStudio // ignore: cast_nullable_to_non_nullable
as bool,loyalty: null == loyalty ? _self.loyalty : loyalty // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$CustomerHome {

 HomeSalon get salon; String? get branch; CustomerBooking? get nextAppointment; BookAgain? get bookAgain; ReviewPrompt? get reviewPrompt; List<PopularService> get popularServices; HomeFeatures get features;
/// Create a copy of CustomerHome
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerHomeCopyWith<CustomerHome> get copyWith => _$CustomerHomeCopyWithImpl<CustomerHome>(this as CustomerHome, _$identity);

  /// Serializes this CustomerHome to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CustomerHome;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerHome&&(identical(other.salon, _this.salon) || other.salon == _this.salon)&&(identical(other.branch, _this.branch) || other.branch == _this.branch)&&(identical(other.nextAppointment, _this.nextAppointment) || other.nextAppointment == _this.nextAppointment)&&(identical(other.bookAgain, _this.bookAgain) || other.bookAgain == _this.bookAgain)&&(identical(other.reviewPrompt, _this.reviewPrompt) || other.reviewPrompt == _this.reviewPrompt)&&const DeepCollectionEquality().equals(other.popularServices, _this.popularServices)&&(identical(other.features, _this.features) || other.features == _this.features));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CustomerHome;
  return Object.hash(runtimeType,_this.salon,_this.branch,_this.nextAppointment,_this.bookAgain,_this.reviewPrompt,const DeepCollectionEquality().hash(_this.popularServices),_this.features);
}

@override
String toString() {
  final _this = this as CustomerHome;
  return 'CustomerHome(salon: ${_this.salon}, branch: ${_this.branch}, nextAppointment: ${_this.nextAppointment}, bookAgain: ${_this.bookAgain}, reviewPrompt: ${_this.reviewPrompt}, popularServices: ${_this.popularServices}, features: ${_this.features})';
}


}

/// @nodoc
abstract mixin class $CustomerHomeCopyWith<$Res>  {
  factory $CustomerHomeCopyWith(CustomerHome value, $Res Function(CustomerHome) _then) = _$CustomerHomeCopyWithImpl;
@useResult
$Res call({
 HomeSalon salon, String? branch, CustomerBooking? nextAppointment, BookAgain? bookAgain, ReviewPrompt? reviewPrompt, List<PopularService> popularServices, HomeFeatures features
});


$HomeSalonCopyWith<$Res> get salon;$CustomerBookingCopyWith<$Res>? get nextAppointment;$BookAgainCopyWith<$Res>? get bookAgain;$ReviewPromptCopyWith<$Res>? get reviewPrompt;$HomeFeaturesCopyWith<$Res> get features;

}
/// @nodoc
class _$CustomerHomeCopyWithImpl<$Res>
    implements $CustomerHomeCopyWith<$Res> {
  _$CustomerHomeCopyWithImpl(this._self, this._then);

  final CustomerHome _self;
  final $Res Function(CustomerHome) _then;

/// Create a copy of CustomerHome
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? salon = null,Object? branch = freezed,Object? nextAppointment = freezed,Object? bookAgain = freezed,Object? reviewPrompt = freezed,Object? popularServices = null,Object? features = null,}) {
  return _then(CustomerHome(
salon: null == salon ? _self.salon : salon // ignore: cast_nullable_to_non_nullable
as HomeSalon,branch: freezed == branch ? _self.branch : branch // ignore: cast_nullable_to_non_nullable
as String?,nextAppointment: freezed == nextAppointment ? _self.nextAppointment : nextAppointment // ignore: cast_nullable_to_non_nullable
as CustomerBooking?,bookAgain: freezed == bookAgain ? _self.bookAgain : bookAgain // ignore: cast_nullable_to_non_nullable
as BookAgain?,reviewPrompt: freezed == reviewPrompt ? _self.reviewPrompt : reviewPrompt // ignore: cast_nullable_to_non_nullable
as ReviewPrompt?,popularServices: null == popularServices ? _self.popularServices : popularServices // ignore: cast_nullable_to_non_nullable
as List<PopularService>,features: null == features ? _self.features : features // ignore: cast_nullable_to_non_nullable
as HomeFeatures,
  ));
}
/// Create a copy of CustomerHome
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HomeSalonCopyWith<$Res> get salon {
  
  return $HomeSalonCopyWith<$Res>(_self.salon, (value) {
    return _then(_self.copyWith(salon: value));
  });
}/// Create a copy of CustomerHome
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CustomerBookingCopyWith<$Res>? get nextAppointment {
    if (_self.nextAppointment == null) {
    return null;
  }

  return $CustomerBookingCopyWith<$Res>(_self.nextAppointment!, (value) {
    return _then(_self.copyWith(nextAppointment: value));
  });
}/// Create a copy of CustomerHome
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookAgainCopyWith<$Res>? get bookAgain {
    if (_self.bookAgain == null) {
    return null;
  }

  return $BookAgainCopyWith<$Res>(_self.bookAgain!, (value) {
    return _then(_self.copyWith(bookAgain: value));
  });
}/// Create a copy of CustomerHome
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReviewPromptCopyWith<$Res>? get reviewPrompt {
    if (_self.reviewPrompt == null) {
    return null;
  }

  return $ReviewPromptCopyWith<$Res>(_self.reviewPrompt!, (value) {
    return _then(_self.copyWith(reviewPrompt: value));
  });
}/// Create a copy of CustomerHome
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HomeFeaturesCopyWith<$Res> get features {
  
  return $HomeFeaturesCopyWith<$Res>(_self.features, (value) {
    return _then(_self.copyWith(features: value));
  });
}
}


/// Adds pattern-matching-related methods to [CustomerHome].
extension CustomerHomePatterns on CustomerHome {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomerHome value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomerHome() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomerHome value)  $default,){
final _that = this;
switch (_that) {
case _CustomerHome():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomerHome value)?  $default,){
final _that = this;
switch (_that) {
case _CustomerHome() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( HomeSalon salon,  String? branch,  CustomerBooking? nextAppointment,  BookAgain? bookAgain,  ReviewPrompt? reviewPrompt,  List<PopularService> popularServices,  HomeFeatures features)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomerHome() when $default != null:
return $default(_that.salon,_that.branch,_that.nextAppointment,_that.bookAgain,_that.reviewPrompt,_that.popularServices,_that.features);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( HomeSalon salon,  String? branch,  CustomerBooking? nextAppointment,  BookAgain? bookAgain,  ReviewPrompt? reviewPrompt,  List<PopularService> popularServices,  HomeFeatures features)  $default,) {final _that = this;
switch (_that) {
case _CustomerHome():
return $default(_that.salon,_that.branch,_that.nextAppointment,_that.bookAgain,_that.reviewPrompt,_that.popularServices,_that.features);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( HomeSalon salon,  String? branch,  CustomerBooking? nextAppointment,  BookAgain? bookAgain,  ReviewPrompt? reviewPrompt,  List<PopularService> popularServices,  HomeFeatures features)?  $default,) {final _that = this;
switch (_that) {
case _CustomerHome() when $default != null:
return $default(_that.salon,_that.branch,_that.nextAppointment,_that.bookAgain,_that.reviewPrompt,_that.popularServices,_that.features);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CustomerHome implements CustomerHome {
  const _CustomerHome({required this.salon, this.branch, this.nextAppointment, this.bookAgain, this.reviewPrompt,  List<PopularService> popularServices = const [], this.features = const HomeFeatures()}): _popularServices = popularServices;
  factory _CustomerHome.fromJson(Map<String, dynamic> json) => _$CustomerHomeFromJson(json);

@override final  HomeSalon salon;
@override final  String? branch;
@override final  CustomerBooking? nextAppointment;
@override final  BookAgain? bookAgain;
@override final  ReviewPrompt? reviewPrompt;
 final  List<PopularService> _popularServices;
@override@JsonKey() List<PopularService> get popularServices {
  if (_popularServices is EqualUnmodifiableListView) return _popularServices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_popularServices);
}

@override@JsonKey() final  HomeFeatures features;

/// Create a copy of CustomerHome
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomerHomeCopyWith<_CustomerHome> get copyWith => __$CustomerHomeCopyWithImpl<_CustomerHome>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CustomerHomeToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomerHome&&(identical(other.salon, salon) || other.salon == salon)&&(identical(other.branch, branch) || other.branch == branch)&&(identical(other.nextAppointment, nextAppointment) || other.nextAppointment == nextAppointment)&&(identical(other.bookAgain, bookAgain) || other.bookAgain == bookAgain)&&(identical(other.reviewPrompt, reviewPrompt) || other.reviewPrompt == reviewPrompt)&&const DeepCollectionEquality().equals(other.popularServices, _popularServices)&&(identical(other.features, features) || other.features == features));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,salon,branch,nextAppointment,bookAgain,reviewPrompt,const DeepCollectionEquality().hash(_popularServices),features);
}

@override
String toString() {
    return 'CustomerHome(salon: $salon, branch: $branch, nextAppointment: $nextAppointment, bookAgain: $bookAgain, reviewPrompt: $reviewPrompt, popularServices: $popularServices, features: $features)';
}


}

/// @nodoc
abstract mixin class _$CustomerHomeCopyWith<$Res> implements $CustomerHomeCopyWith<$Res> {
  factory _$CustomerHomeCopyWith(_CustomerHome value, $Res Function(_CustomerHome) _then) = __$CustomerHomeCopyWithImpl;
@override @useResult
$Res call({
 HomeSalon salon, String? branch, CustomerBooking? nextAppointment, BookAgain? bookAgain, ReviewPrompt? reviewPrompt, List<PopularService> popularServices, HomeFeatures features
});


@override $HomeSalonCopyWith<$Res> get salon;@override $CustomerBookingCopyWith<$Res>? get nextAppointment;@override $BookAgainCopyWith<$Res>? get bookAgain;@override $ReviewPromptCopyWith<$Res>? get reviewPrompt;@override $HomeFeaturesCopyWith<$Res> get features;

}
/// @nodoc
class __$CustomerHomeCopyWithImpl<$Res>
    implements _$CustomerHomeCopyWith<$Res> {
  __$CustomerHomeCopyWithImpl(this._self, this._then);

  final _CustomerHome _self;
  final $Res Function(_CustomerHome) _then;

/// Create a copy of CustomerHome
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? salon = null,Object? branch = freezed,Object? nextAppointment = freezed,Object? bookAgain = freezed,Object? reviewPrompt = freezed,Object? popularServices = null,Object? features = null,}) {
  return _then(_CustomerHome(
salon: null == salon ? _self.salon : salon // ignore: cast_nullable_to_non_nullable
as HomeSalon,branch: freezed == branch ? _self.branch : branch // ignore: cast_nullable_to_non_nullable
as String?,nextAppointment: freezed == nextAppointment ? _self.nextAppointment : nextAppointment // ignore: cast_nullable_to_non_nullable
as CustomerBooking?,bookAgain: freezed == bookAgain ? _self.bookAgain : bookAgain // ignore: cast_nullable_to_non_nullable
as BookAgain?,reviewPrompt: freezed == reviewPrompt ? _self.reviewPrompt : reviewPrompt // ignore: cast_nullable_to_non_nullable
as ReviewPrompt?,popularServices: null == popularServices ? _self._popularServices : popularServices // ignore: cast_nullable_to_non_nullable
as List<PopularService>,features: null == features ? _self.features : features // ignore: cast_nullable_to_non_nullable
as HomeFeatures,
  ));
}

/// Create a copy of CustomerHome
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HomeSalonCopyWith<$Res> get salon {
  
  return $HomeSalonCopyWith<$Res>(_self.salon, (value) {
    return _then(_self.copyWith(salon: value));
  });
}/// Create a copy of CustomerHome
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CustomerBookingCopyWith<$Res>? get nextAppointment {
    if (_self.nextAppointment == null) {
    return null;
  }

  return $CustomerBookingCopyWith<$Res>(_self.nextAppointment!, (value) {
    return _then(_self.copyWith(nextAppointment: value));
  });
}/// Create a copy of CustomerHome
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookAgainCopyWith<$Res>? get bookAgain {
    if (_self.bookAgain == null) {
    return null;
  }

  return $BookAgainCopyWith<$Res>(_self.bookAgain!, (value) {
    return _then(_self.copyWith(bookAgain: value));
  });
}/// Create a copy of CustomerHome
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReviewPromptCopyWith<$Res>? get reviewPrompt {
    if (_self.reviewPrompt == null) {
    return null;
  }

  return $ReviewPromptCopyWith<$Res>(_self.reviewPrompt!, (value) {
    return _then(_self.copyWith(reviewPrompt: value));
  });
}/// Create a copy of CustomerHome
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HomeFeaturesCopyWith<$Res> get features {
  
  return $HomeFeaturesCopyWith<$Res>(_self.features, (value) {
    return _then(_self.copyWith(features: value));
  });
}
}


/// @nodoc
mixin _$NotificationPreferences {

 bool get bookingUpdates; bool get reminders; bool get offers;
/// Create a copy of NotificationPreferences
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationPreferencesCopyWith<NotificationPreferences> get copyWith => _$NotificationPreferencesCopyWithImpl<NotificationPreferences>(this as NotificationPreferences, _$identity);

  /// Serializes this NotificationPreferences to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as NotificationPreferences;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationPreferences&&(identical(other.bookingUpdates, _this.bookingUpdates) || other.bookingUpdates == _this.bookingUpdates)&&(identical(other.reminders, _this.reminders) || other.reminders == _this.reminders)&&(identical(other.offers, _this.offers) || other.offers == _this.offers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as NotificationPreferences;
  return Object.hash(runtimeType,_this.bookingUpdates,_this.reminders,_this.offers);
}

@override
String toString() {
  final _this = this as NotificationPreferences;
  return 'NotificationPreferences(bookingUpdates: ${_this.bookingUpdates}, reminders: ${_this.reminders}, offers: ${_this.offers})';
}


}

/// @nodoc
abstract mixin class $NotificationPreferencesCopyWith<$Res>  {
  factory $NotificationPreferencesCopyWith(NotificationPreferences value, $Res Function(NotificationPreferences) _then) = _$NotificationPreferencesCopyWithImpl;
@useResult
$Res call({
 bool bookingUpdates, bool reminders, bool offers
});




}
/// @nodoc
class _$NotificationPreferencesCopyWithImpl<$Res>
    implements $NotificationPreferencesCopyWith<$Res> {
  _$NotificationPreferencesCopyWithImpl(this._self, this._then);

  final NotificationPreferences _self;
  final $Res Function(NotificationPreferences) _then;

/// Create a copy of NotificationPreferences
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bookingUpdates = null,Object? reminders = null,Object? offers = null,}) {
  return _then(NotificationPreferences(
bookingUpdates: null == bookingUpdates ? _self.bookingUpdates : bookingUpdates // ignore: cast_nullable_to_non_nullable
as bool,reminders: null == reminders ? _self.reminders : reminders // ignore: cast_nullable_to_non_nullable
as bool,offers: null == offers ? _self.offers : offers // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationPreferences].
extension NotificationPreferencesPatterns on NotificationPreferences {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationPreferences value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationPreferences() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationPreferences value)  $default,){
final _that = this;
switch (_that) {
case _NotificationPreferences():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationPreferences value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationPreferences() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool bookingUpdates,  bool reminders,  bool offers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationPreferences() when $default != null:
return $default(_that.bookingUpdates,_that.reminders,_that.offers);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool bookingUpdates,  bool reminders,  bool offers)  $default,) {final _that = this;
switch (_that) {
case _NotificationPreferences():
return $default(_that.bookingUpdates,_that.reminders,_that.offers);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool bookingUpdates,  bool reminders,  bool offers)?  $default,) {final _that = this;
switch (_that) {
case _NotificationPreferences() when $default != null:
return $default(_that.bookingUpdates,_that.reminders,_that.offers);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationPreferences implements NotificationPreferences {
  const _NotificationPreferences({this.bookingUpdates = true, this.reminders = true, this.offers = false});
  factory _NotificationPreferences.fromJson(Map<String, dynamic> json) => _$NotificationPreferencesFromJson(json);

@override@JsonKey() final  bool bookingUpdates;
@override@JsonKey() final  bool reminders;
@override@JsonKey() final  bool offers;

/// Create a copy of NotificationPreferences
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationPreferencesCopyWith<_NotificationPreferences> get copyWith => __$NotificationPreferencesCopyWithImpl<_NotificationPreferences>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationPreferencesToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationPreferences&&(identical(other.bookingUpdates, bookingUpdates) || other.bookingUpdates == bookingUpdates)&&(identical(other.reminders, reminders) || other.reminders == reminders)&&(identical(other.offers, offers) || other.offers == offers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,bookingUpdates,reminders,offers);
}

@override
String toString() {
    return 'NotificationPreferences(bookingUpdates: $bookingUpdates, reminders: $reminders, offers: $offers)';
}


}

/// @nodoc
abstract mixin class _$NotificationPreferencesCopyWith<$Res> implements $NotificationPreferencesCopyWith<$Res> {
  factory _$NotificationPreferencesCopyWith(_NotificationPreferences value, $Res Function(_NotificationPreferences) _then) = __$NotificationPreferencesCopyWithImpl;
@override @useResult
$Res call({
 bool bookingUpdates, bool reminders, bool offers
});




}
/// @nodoc
class __$NotificationPreferencesCopyWithImpl<$Res>
    implements _$NotificationPreferencesCopyWith<$Res> {
  __$NotificationPreferencesCopyWithImpl(this._self, this._then);

  final _NotificationPreferences _self;
  final $Res Function(_NotificationPreferences) _then;

/// Create a copy of NotificationPreferences
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bookingUpdates = null,Object? reminders = null,Object? offers = null,}) {
  return _then(_NotificationPreferences(
bookingUpdates: null == bookingUpdates ? _self.bookingUpdates : bookingUpdates // ignore: cast_nullable_to_non_nullable
as bool,reminders: null == reminders ? _self.reminders : reminders // ignore: cast_nullable_to_non_nullable
as bool,offers: null == offers ? _self.offers : offers // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
