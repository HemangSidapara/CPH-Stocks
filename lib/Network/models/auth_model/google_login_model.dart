import 'dart:convert';

GoogleLoginModel googleLoginModelFromJson(String str) => GoogleLoginModel.fromJson(json.decode(str));

String googleLoginModelToJson(GoogleLoginModel data) => json.encode(data.toJson());

class GoogleLoginModel {
  GoogleLoginModel({
    User? user,
  }) {
    _user = user;
  }

  GoogleLoginModel.fromJson(dynamic json) {
    _user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  User? _user;

  GoogleLoginModel copyWith({
    User? user,
  }) =>
      GoogleLoginModel(
        user: user ?? _user,
      );

  User? get user => _user;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user'] = _user;
    return map;
  }
}

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    String? displayName,
    String? email,
    bool? isEmailVerified,
    bool? isAnonymous,
    UserMetadata? metadata,
    String? phoneNumber,
    String? photoURL,
    List<UserInfo>? providerData,
    String? refreshToken,
    String? tenantId,
    String? uid,
  }) {
    _displayName = displayName;
    _email = email;
    _isEmailVerified = isEmailVerified;
    _isAnonymous = isAnonymous;
    _metadata = metadata;
    _phoneNumber = phoneNumber;
    _photoURL = photoURL;
    _providerData = providerData;
    _refreshToken = refreshToken;
    _tenantId = tenantId;
    _uid = uid;
  }

  User.fromJson(dynamic json) {
    _displayName = json['displayName'];
    _email = json['email'];
    _isEmailVerified = json['isEmailVerified'];
    _isAnonymous = json['isAnonymous'];
    _metadata = json['metadata'] != null ? UserMetadata.fromJson(json['metadata']) : null;
    _phoneNumber = json['phoneNumber'];
    _photoURL = json['photoURL'];
    if (json['providerData'] != null) {
      _providerData = [];
      json['providerData'].forEach((v) {
        _providerData?.add(UserInfo.fromJson(v));
      });
    }
    _refreshToken = json['refreshToken'];
    _tenantId = json['tenantId'];
    _uid = json['uid'];
  }

  String? _displayName;
  String? _email;
  bool? _isEmailVerified;
  bool? _isAnonymous;
  UserMetadata? _metadata;
  String? _phoneNumber;
  String? _photoURL;
  List<UserInfo>? _providerData;
  String? _refreshToken;
  String? _tenantId;
  String? _uid;

  User copyWith({
    String? displayName,
    String? email,
    bool? isEmailVerified,
    bool? isAnonymous,
    UserMetadata? metadata,
    String? phoneNumber,
    String? photoURL,
    List<UserInfo>? providerData,
    String? refreshToken,
    String? tenantId,
    String? uid,
  }) =>
      User(
        displayName: displayName ?? _displayName,
        email: email ?? _email,
        isEmailVerified: isEmailVerified ?? _isEmailVerified,
        isAnonymous: isAnonymous ?? _isAnonymous,
        metadata: metadata ?? _metadata,
        phoneNumber: phoneNumber ?? _phoneNumber,
        photoURL: photoURL ?? _photoURL,
        providerData: providerData ?? _providerData,
        refreshToken: refreshToken ?? _refreshToken,
        tenantId: tenantId ?? _tenantId,
        uid: uid ?? _uid,
      );

  String? get displayName => _displayName;

  String? get email => _email;

  bool? get isEmailVerified => _isEmailVerified;

  bool? get isAnonymous => _isAnonymous;

  UserMetadata? get metadata => _metadata;

  String? get phoneNumber => _phoneNumber;

  String? get photoURL => _photoURL;

  List<UserInfo>? get providerData => _providerData;

  String? get refreshToken => _refreshToken;

  String? get tenantId => _tenantId;

  String? get uid => _uid;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['displayName'] = _displayName;
    map['email'] = _email;
    map['isEmailVerified'] = _isEmailVerified;
    map['isAnonymous'] = _isAnonymous;
    if (_metadata != null) {
      map['metadata'] = _metadata?.toJson();
    }
    map['phoneNumber'] = _phoneNumber;
    map['photoURL'] = _photoURL;
    if (_providerData != null) {
      map['providerData'] = _providerData?.map((v) => v.toJson()).toList();
    }
    map['refreshToken'] = _refreshToken;
    map['tenantId'] = _tenantId;
    map['uid'] = _uid;
    return map;
  }
}

UserMetadata userMetadataFromJson(String str) => UserMetadata.fromJson(json.decode(str));

String userMetadataToJson(UserMetadata data) => json.encode(data.toJson());

class UserMetadata {
  UserMetadata({
    String? creationTime,
    String? lastSignInTime,
  }) {
    _creationTime = creationTime;
    _lastSignInTime = lastSignInTime;
  }

  UserMetadata.fromJson(dynamic json) {
    _creationTime = json['creationTime'];
    _lastSignInTime = json['lastSignInTime'];
  }

  String? _creationTime;
  String? _lastSignInTime;

  UserMetadata copyWith({
    String? creationTime,
    String? lastSignInTime,
  }) =>
      UserMetadata(
        creationTime: creationTime ?? _creationTime,
        lastSignInTime: lastSignInTime ?? _lastSignInTime,
      );

  String? get creationTime => _creationTime;

  String? get lastSignInTime => _lastSignInTime;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['creationTime'] = _creationTime;
    map['lastSignInTime'] = _lastSignInTime;
    return map;
  }
}

UserInfo userInfoFromJson(String str) => UserInfo.fromJson(json.decode(str));

String userInfoToJson(UserInfo data) => json.encode(data.toJson());

class UserInfo {
  UserInfo({
    String? displayName,
    String? email,
    String? phoneNumber,
    String? photoURL,
    String? providerId,
    String? uid,
  }) {
    _displayName = displayName;
    _email = email;
    _phoneNumber = phoneNumber;
    _photoURL = photoURL;
    _providerId = providerId;
    _uid = uid;
  }

  UserInfo.fromJson(dynamic json) {
    _displayName = json['displayName'];
    _email = json['email'];
    _phoneNumber = json['phoneNumber'];
    _photoURL = json['photoURL'];
    _providerId = json['providerId'];
    _uid = json['uid'];
  }

  String? _displayName;
  String? _email;
  String? _phoneNumber;
  String? _photoURL;
  String? _providerId;
  String? _uid;

  UserInfo copyWith({
    String? displayName,
    String? email,
    String? phoneNumber,
    String? photoURL,
    String? providerId,
    String? uid,
  }) =>
      UserInfo(
        displayName: displayName ?? _displayName,
        email: email ?? _email,
        phoneNumber: phoneNumber ?? _phoneNumber,
        photoURL: photoURL ?? _photoURL,
        providerId: providerId ?? _providerId,
        uid: uid ?? _uid,
      );

  String? get displayName => _displayName;

  String? get email => _email;

  String? get phoneNumber => _phoneNumber;

  String? get photoURL => _photoURL;

  String? get providerId => _providerId;

  String? get uid => _uid;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['displayName'] = _displayName;
    map['email'] = _email;
    map['phoneNumber'] = _phoneNumber;
    map['photoURL'] = _photoURL;
    map['providerId'] = _providerId;
    map['uid'] = _uid;
    return map;
  }
}
