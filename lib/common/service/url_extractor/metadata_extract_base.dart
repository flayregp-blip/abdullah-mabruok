import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:html/dom.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;

import 'parsers/base_parser.dart';
import 'parsers/metadata_parser.dart';
import 'utils/util.dart';

/// Fetches a [url], validates it, and returns [UrlMetadata].
Future<UrlMetadata?> extract(String url) async {
  // if (!isURL(url)) {
  //   return null;
  // }

  /// Sane defaults; Always return the Domain name as the [title], and a [description] for a given [url]
  final defaultOutput = UrlMetadata(
    title: getDomain(url),
    description: url,
  );

  try {
    final response = await http.get(Uri.parse(url));
    if (response.headers['content-type']?.startsWith(r'image/') ?? false) {
      defaultOutput.title = '';
      defaultOutput.description = '';
      defaultOutput.image = url;
      return defaultOutput;
    }

    final document = responseToDocument(response);

    if (document == null) {
      return defaultOutput;
    }

    return _extractMetadata(document);
  } on SocketException catch (e) {
    print('SocketException: $e');
  } on TimeoutException catch (e) {
    print('The connection has timed out: $e');
  } on http.ClientException catch (e) {
    print('Client error: $e');
  } catch (e) {
    print('Unexpected error: $e');
  }
  return null;
}

/// Takes an [http.Response] and returns a [html.Document]
Document? responseToDocument(http.Response response) {
  if (response.statusCode != 200) {
    return null;
  }

  Document? document;
  try {
    document = parser.parse(utf8.decode(response.bodyBytes));
    if (response.request != null) {
      document.requestUrl = response.request!.url.toString();
    }
  } catch (err) {
    return document;
  }

  return document;
}

/// Returns instance of [UrlMetadata] with data extracted from the [html.Document]
///
/// Future: Can pass in a strategy i.e: to retrieve only OpenGraph, or OpenGraph and Json+LD only
UrlMetadata _extractMetadata(Document document) {
  return MetadataParser.parse(document);
}
