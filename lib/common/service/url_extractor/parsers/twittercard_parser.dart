import 'package:html/dom.dart';
import 'package:shortzz/common/service/url_extractor/utils/util.dart';

import 'base_parser.dart';

/// Takes a [http.Document] and parses [UrlMetadata] from [<meta property='twitter:*'>] tags
class TwitterCardParser with BaseMetadataParser {
  final Document? _document;

  TwitterCardParser(this._document);

  /// Get [UrlMetadata.title] from 'twitter:title'
  @override
  String? get title =>
      getProperty(
        _document,
        attribute: 'name',
        property: 'twitter:title',
      ) ??
      getProperty(
        _document,
        property: 'twitter:title',
      );

  /// Get [UrlMetadata.description] from 'twitter:description'
  @override
  String? get description =>
      getProperty(
        _document,
        attribute: 'name',
        property: 'twitter:description',
      ) ??
      getProperty(
        _document,
        property: 'twitter:description',
      );

  /// Get [UrlMetadata.image] from 'twitter:image'
  @override
  String? get image =>
      getProperty(
        _document,
        attribute: 'name',
        property: 'twitter:image',
      ) ??
      getProperty(
        _document,
        property: 'twitter:image',
      );

  /// Get [Document.url]
  @override
  String? get url => _document?.requestUrl;

  @override
  String toString() => parse().toString();
}
