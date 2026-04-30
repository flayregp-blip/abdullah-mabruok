class MetadataKeys {
  static const title = 'title';
  static const description = 'description';
  static const image = 'image';
  static const url = 'url';
}

mixin BaseMetadataParser {
  String? title;
  String? description;
  String? image;
  String? url;

  UrlMetadata parse() {
    return UrlMetadata(
      title: title,
      description: description,
      image: image,
      url: url,
    );
  }
}

/// Container class for Metadata
class UrlMetadata {
  String? title;
  String? description;
  String? image;
  String? url;

  UrlMetadata({
    this.title,
    this.description,
    this.image,
    this.url,
  });

  bool get hasAllMetadata {
    return (title != null &&
        description != null &&
        image != null &&
        url != null);
  }

  String? get host {
    if (url != null) {
      final uri = Uri.parse(url!);
      return uri.host.replaceAll('www.', '');
    }
    return null;
  }

  @override
  String toString() {
    return toMap().toString();
  }

  Map<String, String?> toMap() {
    return {
      MetadataKeys.title: title,
      MetadataKeys.description: description,
      MetadataKeys.image: image,
      MetadataKeys.url: url,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  UrlMetadata copyFrom(UrlMetadata other) => copyWith(
        title: other.title,
        description: other.description,
        image: other.image,
        url: other.url,
      );

  UrlMetadata merge(UrlMetadata other) {
    title ??= other.title;
    description ??= other.description;
    image ??= other.image;
    url ??= other.url;
    return this;
  }

  UrlMetadata copyWith({
    String? title,
    String? description,
    String? image,
    String? url,
  }) =>
      UrlMetadata(
        title: title ?? this.title,
        description: description ?? this.description,
        image: image ?? this.image,
        url: url ?? this.url,
      );

  static UrlMetadata fromJson(Map<String, dynamic> json) {
    return UrlMetadata(
      title: json[MetadataKeys.title],
      description: json[MetadataKeys.description],
      image: json[MetadataKeys.image],
      url: json[MetadataKeys.url],
    );
  }
}
