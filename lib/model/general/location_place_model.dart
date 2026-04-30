class LocationPlaceModel {
  LocationPlaceModel({
    List<Places>? places,
    List<ContextualContents>? contextualContents,
    String? searchUri,
    Error? error,
  }) {
    _places = places;
    _contextualContents = contextualContents;
    _searchUri = searchUri;
    _error = error;
  }

  LocationPlaceModel.fromJson(dynamic json) {
    if (json['places'] != null) {
      _places = [];
      json['places'].forEach((v) {
        _places?.add(Places.fromJson(v));
      });
    }
    if (json['contextualContents'] != null) {
      _contextualContents = [];
      json['contextualContents'].forEach((v) {
        _contextualContents?.add(ContextualContents.fromJson(v));
      });
    }
    _searchUri = json['searchUri'];
    _error = json['error'] != null ? Error.fromJson(json['error']) : null;
  }

  List<Places>? _places;
  List<ContextualContents>? _contextualContents;
  String? _searchUri;
  Error? _error;

  List<Places>? get places => _places;

  List<ContextualContents>? get contextualContents => _contextualContents;

  String? get searchUri => _searchUri;

  Error? get error => _error;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_places != null) {
      map['places'] = _places?.map((v) => v.toJson()).toList();
    }
    if (_contextualContents != null) {
      map['contextualContents'] =
          _contextualContents?.map((v) => v.toJson()).toList();
    }
    map['searchUri'] = _searchUri;
    if (_error != null) {
      map['error'] = _error?.toJson();
    }
    return map;
  }
}

class ContextualContents {
  ContextualContents({
    List<Photos>? photos,
  }) {
    _photos = photos;
  }

  ContextualContents.fromJson(dynamic json) {
    if (json['photos'] != null) {
      _photos = [];
      json['photos'].forEach((v) {
        _photos?.add(Photos.fromJson(v));
      });
    }
  }

  List<Photos>? _photos;

  List<Photos>? get photos => _photos;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_photos != null) {
      map['photos'] = _photos?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Photos {
  Photos({
    String? name,
    num? widthPx,
    num? heightPx,
    List<AuthorAttributions>? authorAttributions,
    String? flagContentUri,
    String? googleMapsUri,
  }) {
    _name = name;
    _widthPx = widthPx;
    _heightPx = heightPx;
    _authorAttributions = authorAttributions;
    _flagContentUri = flagContentUri;
    _googleMapsUri = googleMapsUri;
  }

  Photos.fromJson(dynamic json) {
    _name = json['name'];
    _widthPx = json['widthPx'];
    _heightPx = json['heightPx'];
    if (json['authorAttributions'] != null) {
      _authorAttributions = [];
      json['authorAttributions'].forEach((v) {
        _authorAttributions?.add(AuthorAttributions.fromJson(v));
      });
    }
    _flagContentUri = json['flagContentUri'];
    _googleMapsUri = json['googleMapsUri'];
  }

  String? _name;
  num? _widthPx;
  num? _heightPx;
  List<AuthorAttributions>? _authorAttributions;
  String? _flagContentUri;
  String? _googleMapsUri;

  String? get name => _name;

  num? get widthPx => _widthPx;

  num? get heightPx => _heightPx;

  List<AuthorAttributions>? get authorAttributions => _authorAttributions;

  String? get flagContentUri => _flagContentUri;

  String? get googleMapsUri => _googleMapsUri;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['widthPx'] = _widthPx;
    map['heightPx'] = _heightPx;
    if (_authorAttributions != null) {
      map['authorAttributions'] =
          _authorAttributions?.map((v) => v.toJson()).toList();
    }
    map['flagContentUri'] = _flagContentUri;
    map['googleMapsUri'] = _googleMapsUri;
    return map;
  }
}

class AuthorAttributions {
  AuthorAttributions({
    String? displayName,
    String? uri,
    String? photoUri,
  }) {
    _displayName = displayName;
    _uri = uri;
    _photoUri = photoUri;
  }

  AuthorAttributions.fromJson(dynamic json) {
    _displayName = json['displayName'];
    _uri = json['uri'];
    _photoUri = json['photoUri'];
  }

  String? _displayName;
  String? _uri;
  String? _photoUri;

  String? get displayName => _displayName;

  String? get uri => _uri;

  String? get photoUri => _photoUri;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['displayName'] = _displayName;
    map['uri'] = _uri;
    map['photoUri'] = _photoUri;
    return map;
  }
}

class Places {
  Places({
    String? name,
    String? id,
    List<String>? types,
    String? formattedAddress,
    List<AddressComponents>? addressComponents,
    Location? location,
    Viewport? viewport,
    String? googleMapsUri,
    String? websiteUri,
    num? utcOffsetMinutes,
    String? adrFormatAddress,
    String? iconMaskBaseUri,
    String? iconBackgroundColor,
    DisplayName? displayName,
    String? shortFormattedAddress,
    List<Photos>? photos,
    GoogleMapsLinks? googleMapsLinks,
  }) {
    _name = name;
    _id = id;
    _types = types;
    _formattedAddress = formattedAddress;
    _addressComponents = addressComponents;
    _location = location;
    _viewport = viewport;
    _googleMapsUri = googleMapsUri;
    _websiteUri = websiteUri;
    _utcOffsetMinutes = utcOffsetMinutes;
    _adrFormatAddress = adrFormatAddress;
    _iconMaskBaseUri = iconMaskBaseUri;
    _iconBackgroundColor = iconBackgroundColor;
    _displayName = displayName;
    _shortFormattedAddress = shortFormattedAddress;
    _photos = photos;
    _googleMapsLinks = googleMapsLinks;
  }

  Places.fromJson(dynamic json) {
    _name = json['name'];
    _id = json['id'];
    _types = json['types'] != null ? json['types'].cast<String>() : [];
    _formattedAddress = json['formattedAddress'];
    if (json['addressComponents'] != null) {
      _addressComponents = [];
      json['addressComponents'].forEach((v) {
        _addressComponents?.add(AddressComponents.fromJson(v));
      });
    }
    _location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    _viewport =
        json['viewport'] != null ? Viewport.fromJson(json['viewport']) : null;
    _googleMapsUri = json['googleMapsUri'];
    _websiteUri = json['websiteUri'];
    _utcOffsetMinutes = json['utcOffsetMinutes'];
    _adrFormatAddress = json['adrFormatAddress'];
    _iconMaskBaseUri = json['iconMaskBaseUri'];
    _iconBackgroundColor = json['iconBackgroundColor'];
    _displayName = json['displayName'] != null
        ? DisplayName.fromJson(json['displayName'])
        : null;
    _shortFormattedAddress = json['shortFormattedAddress'];
    if (json['photos'] != null) {
      _photos = [];
      json['photos'].forEach((v) {
        _photos?.add(Photos.fromJson(v));
      });
    }
    _googleMapsLinks = json['googleMapsLinks'] != null
        ? GoogleMapsLinks.fromJson(json['googleMapsLinks'])
        : null;
  }

  String? _name;
  String? _id;
  List<String>? _types;
  String? _formattedAddress;
  List<AddressComponents>? _addressComponents;
  Location? _location;
  Viewport? _viewport;
  String? _googleMapsUri;
  String? _websiteUri;
  num? _utcOffsetMinutes;
  String? _adrFormatAddress;
  String? _iconMaskBaseUri;
  String? _iconBackgroundColor;
  DisplayName? _displayName;
  String? _shortFormattedAddress;
  List<Photos>? _photos;
  GoogleMapsLinks? _googleMapsLinks;

  String? get name => _name;

  String? get id => _id;

  List<String>? get types => _types;

  String? get formattedAddress => _formattedAddress;

  List<AddressComponents>? get addressComponents => _addressComponents;

  Location? get location => _location;

  Viewport? get viewport => _viewport;

  String? get googleMapsUri => _googleMapsUri;

  String? get websiteUri => _websiteUri;

  num? get utcOffsetMinutes => _utcOffsetMinutes;

  String? get adrFormatAddress => _adrFormatAddress;

  String? get iconMaskBaseUri => _iconMaskBaseUri;

  String? get iconBackgroundColor => _iconBackgroundColor;

  DisplayName? get displayName => _displayName;

  String? get shortFormattedAddress => _shortFormattedAddress;

  List<Photos>? get photos => _photos;

  GoogleMapsLinks? get googleMapsLinks => _googleMapsLinks;

  String get city {
    String cityName = '';
    _addressComponents?.forEach((element) {
      if ((element.types ?? []).contains('administrative_area_level_3')) {
        cityName = element.longText ?? '';
      }
    });
    return cityName;
  }

  String get state {
    String _state = '';
    _addressComponents?.forEach((element) {
      if ((element.types ?? []).contains('administrative_area_level_1')) {
        _state = element.longText ?? '';
      }
    });
    return _state;
  }

  String get country {
    String country = '';
    _addressComponents?.forEach((element) {
      if ((element.types ?? []).contains('country')) {
        country = element.longText ?? '';
      }
    });
    return country;
  }

  String get shortCity {
    String cityName = '';
    _addressComponents?.forEach((element) {
      if ((element.types ?? []).contains('administrative_area_level_3')) {
        cityName = element.shortText ?? '';
      }
    });
    return cityName;
  }

  String get shortState {
    String _state = '';
    _addressComponents?.forEach((element) {
      if ((element.types ?? []).contains('administrative_area_level_1')) {
        _state = element.shortText ?? '';
      }
    });
    return _state;
  }

  String get shortCountry {
    String country = '';
    _addressComponents?.forEach((element) {
      if ((element.types ?? []).contains('country')) {
        country = element.shortText ?? '';
      }
    });
    return country;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['id'] = _id;
    map['types'] = _types;
    map['formattedAddress'] = _formattedAddress;
    if (_addressComponents != null) {
      map['addressComponents'] =
          _addressComponents?.map((v) => v.toJson()).toList();
    }
    if (_location != null) {
      map['location'] = _location?.toJson();
    }
    if (_viewport != null) {
      map['viewport'] = _viewport?.toJson();
    }
    map['googleMapsUri'] = _googleMapsUri;
    map['websiteUri'] = _websiteUri;
    map['utcOffsetMinutes'] = _utcOffsetMinutes;
    map['adrFormatAddress'] = _adrFormatAddress;
    map['iconMaskBaseUri'] = _iconMaskBaseUri;
    map['iconBackgroundColor'] = _iconBackgroundColor;
    if (_displayName != null) {
      map['displayName'] = _displayName?.toJson();
    }
    map['shortFormattedAddress'] = _shortFormattedAddress;
    if (_photos != null) {
      map['photos'] = _photos?.map((v) => v.toJson()).toList();
    }
    if (_googleMapsLinks != null) {
      map['googleMapsLinks'] = _googleMapsLinks?.toJson();
    }
    return map;
  }

  String get title => displayName?.text ?? '';

  String get description {
    final parts =
        [city, state, country].where((e) => e.trim().isNotEmpty).toList();
    return parts.join(', ');
  }

  String get placeTitle {
    final items = [title, shortCity, shortState, shortCountry]
        .where((element) => element.trim().isNotEmpty)
        .toList();
    return items.join(', ');
  }
}

class GoogleMapsLinks {
  GoogleMapsLinks({
    String? directionsUri,
    String? placeUri,
    String? photosUri,
  }) {
    _directionsUri = directionsUri;
    _placeUri = placeUri;
    _photosUri = photosUri;
  }

  GoogleMapsLinks.fromJson(dynamic json) {
    _directionsUri = json['directionsUri'];
    _placeUri = json['placeUri'];
    _photosUri = json['photosUri'];
  }

  String? _directionsUri;
  String? _placeUri;
  String? _photosUri;

  String? get directionsUri => _directionsUri;

  String? get placeUri => _placeUri;

  String? get photosUri => _photosUri;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['directionsUri'] = _directionsUri;
    map['placeUri'] = _placeUri;
    map['photosUri'] = _photosUri;
    return map;
  }
}

class DisplayName {
  DisplayName({
    String? text,
    String? languageCode,
  }) {
    _text = text;
    _languageCode = languageCode;
  }

  DisplayName.fromJson(dynamic json) {
    _text = json['text'];
    _languageCode = json['languageCode'];
  }

  String? _text;
  String? _languageCode;

  String? get text => _text;

  String? get languageCode => _languageCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['text'] = _text;
    map['languageCode'] = _languageCode;
    return map;
  }
}

class Viewport {
  Viewport({
    Low? low,
    High? high,
  }) {
    _low = low;
    _high = high;
  }

  Viewport.fromJson(dynamic json) {
    _low = json['low'] != null ? Low.fromJson(json['low']) : null;
    _high = json['high'] != null ? High.fromJson(json['high']) : null;
  }

  Low? _low;
  High? _high;

  Low? get low => _low;

  High? get high => _high;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_low != null) {
      map['low'] = _low?.toJson();
    }
    if (_high != null) {
      map['high'] = _high?.toJson();
    }
    return map;
  }
}

class High {
  High({
    num? latitude,
    num? longitude,
  }) {
    _latitude = latitude;
    _longitude = longitude;
  }

  High.fromJson(dynamic json) {
    _latitude = json['latitude'];
    _longitude = json['longitude'];
  }

  num? _latitude;
  num? _longitude;

  num? get latitude => _latitude;

  num? get longitude => _longitude;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['latitude'] = _latitude;
    map['longitude'] = _longitude;
    return map;
  }
}

class Low {
  Low({
    num? latitude,
    num? longitude,
  }) {
    _latitude = latitude;
    _longitude = longitude;
  }

  Low.fromJson(dynamic json) {
    _latitude = json['latitude'];
    _longitude = json['longitude'];
  }

  num? _latitude;
  num? _longitude;

  num? get latitude => _latitude;

  num? get longitude => _longitude;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['latitude'] = _latitude;
    map['longitude'] = _longitude;
    return map;
  }
}

class Location {
  Location({
    num? latitude,
    num? longitude,
  }) {
    _latitude = latitude;
    _longitude = longitude;
  }

  Location.fromJson(dynamic json) {
    _latitude = json['latitude'];
    _longitude = json['longitude'];
  }

  num? _latitude;
  num? _longitude;

  num? get latitude => _latitude;

  num? get longitude => _longitude;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['latitude'] = _latitude;
    map['longitude'] = _longitude;
    return map;
  }
}

class AddressComponents {
  AddressComponents({
    String? longText,
    String? shortText,
    List<String>? types,
    String? languageCode,
  }) {
    _longText = longText;
    _shortText = shortText;
    _types = types;
    _languageCode = languageCode;
  }

  AddressComponents.fromJson(dynamic json) {
    _longText = json['longText'];
    _shortText = json['shortText'];
    _types = json['types'] != null ? json['types'].cast<String>() : [];
    _languageCode = json['languageCode'];
  }

  String? _longText;
  String? _shortText;
  List<String>? _types;
  String? _languageCode;

  String? get longText => _longText;

  String? get shortText => _shortText;

  List<String>? get types => _types;

  String? get languageCode => _languageCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['longText'] = _longText;
    map['shortText'] = _shortText;
    map['types'] = _types;
    map['languageCode'] = _languageCode;
    return map;
  }
}

class Error {
  Error({
    this.code,
    this.message,
    this.status,
  });

  Error.fromJson(dynamic json) {
    code = json['code'];
    message = json['message'];
    status = json['status'];
  }

  num? code;
  String? message;
  String? status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = code;
    map['message'] = message;
    map['status'] = status;
    return map;
  }
}
