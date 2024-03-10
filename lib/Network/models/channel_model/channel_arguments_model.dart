import 'dart:convert';

ChannelArgumentsModel channelArgumentsModelFromJson(String str) => ChannelArgumentsModel.fromJson(json.decode(str));

String channelArgumentsModelToJson(ChannelArgumentsModel data) => json.encode(data.toJson());

class ChannelArgumentsModel {
  ChannelArgumentsModel({
    String? channelName,
    String? dashWidewinePlayUrl,
    String? logo,
    num? id,
    String? dashWidewineLicenseUrl,
    List<String>? audio,
    List<String>? genre,
    bool? hd,
    String? provider,
    String? bid,
    List<String>? entitlements,
    String? keyid,
    String? key,
  }) {
    _channelName = channelName;
    _dashWidewinePlayUrl = dashWidewinePlayUrl;
    _logo = logo;
    _id = id;
    _dashWidewineLicenseUrl = dashWidewineLicenseUrl;
    _audio = audio;
    _genre = genre;
    _hd = hd;
    _provider = provider;
    _bid = bid;
    _entitlements = entitlements;
    _keyid = keyid;
    _key = key;
  }

  ChannelArgumentsModel.fromJson(dynamic json) {
    _channelName = json['channelName'];
    _dashWidewinePlayUrl = json['dashWidewinePlayUrl'];
    _logo = json['logo'];
    _id = json['id'];
    _dashWidewineLicenseUrl = json['dashWidewineLicenseUrl'];
    _audio = json['audio'] != null ? json['audio'].cast<String>() : [];
    _genre = json['genre'] != null ? json['genre'].cast<String>() : [];
    _hd = json['HD'];
    _provider = json['provider'];
    _bid = json['bid'];
    _entitlements = json['entitlements'] != null ? json['entitlements'].cast<String>() : [];
    _keyid = json['keyid'];
    _key = json['key'];
  }

  String? _channelName;
  String? _dashWidewinePlayUrl;
  String? _logo;
  num? _id;
  String? _dashWidewineLicenseUrl;
  List<String>? _audio;
  List<String>? _genre;
  bool? _hd;
  String? _provider;
  String? _bid;
  List<String>? _entitlements;
  String? _keyid;
  String? _key;

  ChannelArgumentsModel copyWith({
    String? channelName,
    String? dashWidewinePlayUrl,
    String? logo,
    num? id,
    String? dashWidewineLicenseUrl,
    List<String>? audio,
    List<String>? genre,
    bool? hd,
    String? provider,
    String? bid,
    List<String>? entitlements,
    String? keyid,
    String? key,
  }) =>
      ChannelArgumentsModel(
        channelName: channelName ?? _channelName,
        dashWidewinePlayUrl: dashWidewinePlayUrl ?? _dashWidewinePlayUrl,
        logo: logo ?? _logo,
        id: id ?? _id,
        dashWidewineLicenseUrl: dashWidewineLicenseUrl ?? _dashWidewineLicenseUrl,
        audio: audio ?? _audio,
        genre: genre ?? _genre,
        hd: hd ?? _hd,
        provider: provider ?? _provider,
        bid: bid ?? _bid,
        entitlements: entitlements ?? _entitlements,
        keyid: keyid ?? _keyid,
        key: key ?? _key,
      );

  String? get channelName => _channelName;

  String? get dashWidewinePlayUrl => _dashWidewinePlayUrl;

  String? get logo => _logo;

  num? get id => _id;

  String? get dashWidewineLicenseUrl => _dashWidewineLicenseUrl;

  List<String>? get audio => _audio;

  List<String>? get genre => _genre;

  bool? get hd => _hd;

  String? get provider => _provider;

  String? get bid => _bid;

  List<String>? get entitlements => _entitlements;

  String? get keyid => _keyid;

  String? get key => _key;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['channelName'] = _channelName;
    map['dashWidewinePlayUrl'] = _dashWidewinePlayUrl;
    map['logo'] = _logo;
    map['id'] = _id;
    map['dashWidewineLicenseUrl'] = _dashWidewineLicenseUrl;
    map['audio'] = _audio;
    map['genre'] = _genre;
    map['HD'] = _hd;
    map['provider'] = _provider;
    map['bid'] = _bid;
    map['entitlements'] = _entitlements;
    map['keyid'] = _keyid;
    map['key'] = _key;
    return map;
  }
}
