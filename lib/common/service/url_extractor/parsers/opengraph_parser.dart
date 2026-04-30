import 'package:html/dom.dart';
import 'package:shortzz/common/service/url_extractor/utils/util.dart';

import 'base_parser.dart';

/// Takes a [http.Document] and parses [UrlMetadata] from [<meta property='og:*'>] tags
class OpenGraphParser with BaseMetadataParser {
  final Document? _document;

  OpenGraphParser(this._document);

  /// Get [UrlMetadata.title] from 'og:title'
  @override
  String? get title => getProperty(
        _document,
        property: 'og:title',
      );

  /// Get [UrlMetadata.description] from 'og:description'
  @override
  String? get description => getProperty(
        _document,
        property: 'og:description',
      );

  /// Get [UrlMetadata.image] from 'og:image'
  @override
  String? get image => getProperty(
        _document,
        property: 'og:image',
      );

  /// Get [UrlMetadata.url] from 'og:url'
  @override
  String? get url => getProperty(
        _document,
        property: 'og:url',
      );

  @override
  String toString() => parse().toString();
}
