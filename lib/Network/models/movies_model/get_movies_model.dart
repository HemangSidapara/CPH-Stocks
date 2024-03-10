import 'dart:convert';

/// data : [{"logoPortrait":"https://images.jojoapp.in/assetimages/3_EKKA_RECENTLY_ADDED_THUMBNAILS-1706240343252.png","releaseDate":"2023-08-25","playbackURL":"https://content.uplynk.com/ext/86c4eb5dab6149acb3be20b5d21bd68e/7154.m3u8?tc=1&exp=1708403403869&rn=8386292595&ct=a&oid=86c4eb5dab6149acb3be20b5d21bd68e&eid=7154&euid=7154&sig=d5b7a71d249d54a662023a702f56c51b82b141cc0c993a84c92e6018042b1968","logoBanner":"https://images.jojoapp.in/assetimages/MV_3EKKA_1920x1080-1706193118401.jpg","movieName":"3 Ekka"}]

GetMoviesModel getMoviesModelFromJson(String str) => GetMoviesModel.fromJson(json.decode(str));

String getMoviesModelToJson(GetMoviesModel data) => json.encode(data.toJson());

class GetMoviesModel {
  GetMoviesModel({
    List<Data>? data,
  }) {
    _data = data;
  }

  GetMoviesModel.fromJson(dynamic json) {
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
  }

  List<Data>? _data;

  GetMoviesModel copyWith({
    List<Data>? data,
  }) =>
      GetMoviesModel(
        data: data ?? _data,
      );

  List<Data>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// logoPortrait : "https://images.jojoapp.in/assetimages/3_EKKA_RECENTLY_ADDED_THUMBNAILS-1706240343252.png"
/// releaseDate : "2023-08-25"
/// playbackURL : "https://content.uplynk.com/ext/86c4eb5dab6149acb3be20b5d21bd68e/7154.m3u8?tc=1&exp=1708403403869&rn=8386292595&ct=a&oid=86c4eb5dab6149acb3be20b5d21bd68e&eid=7154&euid=7154&sig=d5b7a71d249d54a662023a702f56c51b82b141cc0c993a84c92e6018042b1968"
/// logoBanner : "https://images.jojoapp.in/assetimages/MV_3EKKA_1920x1080-1706193118401.jpg"
/// movieName : "3 Ekka"
/// provider : "JOJO"

Data dataFromJson(String str) => Data.fromJson(json.decode(str));

String dataToJson(Data data) => json.encode(data.toJson());

class Data {
  Data({
    String? logoPortrait,
    String? releaseDate,
    String? playbackURL,
    String? logoBanner,
    String? movieName,
    String? provider,
    String? providerLogo,
    String? description,
    Map<String, String>? keys,
  }) {
    _logoPortrait = logoPortrait;
    _releaseDate = releaseDate;
    _playbackURL = playbackURL;
    _logoBanner = logoBanner;
    _movieName = movieName;
    _provider = providerLogo;
    _description = description;
    _keys = keys;
  }

  Data.fromJson(dynamic json) {
    _logoPortrait = json['logoPortrait'];
    _releaseDate = json['releaseDate'];
    _playbackURL = json['playbackURL'];
    _logoBanner = json['logoBanner'];
    _movieName = json['movieName'];
    _provider = json['provider'];
    _providerLogo = json['providerLogo'];
    _description = json['description'];
    _keys = (json['keys'] as Map<String, dynamic>?)?.map((key, value) => MapEntry<String, String>(key, value.toString()));
  }

  String? _logoPortrait;
  String? _releaseDate;
  String? _playbackURL;
  String? _logoBanner;
  String? _movieName;
  String? _provider;
  String? _providerLogo;
  String? _description;
  Map<String, String>? _keys;

  Data copyWith({
    String? logoPortrait,
    String? releaseDate,
    String? playbackURL,
    String? logoBanner,
    String? movieName,
    String? provider,
    String? providerLogo,
    String? description,
    Map<String, String>? keys,
  }) =>
      Data(
        logoPortrait: logoPortrait ?? _logoPortrait,
        releaseDate: releaseDate ?? _releaseDate,
        playbackURL: playbackURL ?? _playbackURL,
        logoBanner: logoBanner ?? _logoBanner,
        movieName: movieName ?? _movieName,
        provider: provider ?? _provider,
        providerLogo: providerLogo ?? _providerLogo,
        description: description ?? _description,
        keys: keys ?? _keys,
      );

  String? get logoPortrait => _logoPortrait;

  String? get releaseDate => _releaseDate;

  String? get playbackURL => _playbackURL;

  String? get logoBanner => _logoBanner;

  String? get movieName => _movieName;

  String? get provider => _provider;

  String? get providerLogo => _providerLogo;

  String? get description => _description;

  Map<String, String>? get keys => _keys;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['logoPortrait'] = _logoPortrait;
    map['releaseDate'] = _releaseDate;
    map['playbackURL'] = _playbackURL;
    map['logoBanner'] = _logoBanner;
    map['movieName'] = _movieName;
    map['provider'] = _provider;
    map['providerLogo'] = _providerLogo;
    map['description'] = _description;
    map['keys'] = _keys;
    return map;
  }
}
