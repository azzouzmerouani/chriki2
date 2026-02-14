import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';

/// Model representing an Unsplash photo result.
class UnsplashPhoto {
  final String id;
  final String description;
  final UnsplashPhotoUrls urls;
  final UnsplashUser user;

  const UnsplashPhoto({
    required this.id,
    required this.description,
    required this.urls,
    required this.user,
  });

  factory UnsplashPhoto.fromJson(Map<String, dynamic> json) {
    return UnsplashPhoto(
      id: json['id'] as String? ?? '',
      description:
          json['description'] as String? ??
          json['alt_description'] as String? ??
          '',
      urls: UnsplashPhotoUrls.fromJson(
        json['urls'] as Map<String, dynamic>? ?? {},
      ),
      user: UnsplashUser.fromJson(json['user'] as Map<String, dynamic>? ?? {}),
    );
  }
}

/// URLs for different image sizes returned by Unsplash.
class UnsplashPhotoUrls {
  final String raw;
  final String full;
  final String regular;
  final String small;
  final String thumb;

  const UnsplashPhotoUrls({
    required this.raw,
    required this.full,
    required this.regular,
    required this.small,
    required this.thumb,
  });

  factory UnsplashPhotoUrls.fromJson(Map<String, dynamic> json) {
    return UnsplashPhotoUrls(
      raw: json['raw'] as String? ?? '',
      full: json['full'] as String? ?? '',
      regular: json['regular'] as String? ?? '',
      small: json['small'] as String? ?? '',
      thumb: json['thumb'] as String? ?? '',
    );
  }
}

/// Photographer attribution from Unsplash.
class UnsplashUser {
  final String name;
  final String username;

  const UnsplashUser({required this.name, required this.username});

  factory UnsplashUser.fromJson(Map<String, dynamic> json) {
    return UnsplashUser(
      name: json['name'] as String? ?? '',
      username: json['username'] as String? ?? '',
    );
  }

  /// Attribution link as required by Unsplash guidelines.
  String get profileUrl => 'https://unsplash.com/@$username';
}

/// Service for searching photos on Unsplash.
///
/// Uses the Unsplash Search Photos API (`GET /search/photos`)
/// with public `client_id` authentication.
class UnsplashService {
  UnsplashService._();

  static final UnsplashService instance = UnsplashService._();

  final http.Client _client = http.Client();

  /// In-memory cache to avoid repeated API calls for the same query.
  final Map<String, List<UnsplashPhoto>> _cache = {};

  /// Search photos by [query] keyword.
  ///
  /// Returns a list of [UnsplashPhoto] results.
  /// Results are cached per query to minimize API calls.
  Future<List<UnsplashPhoto>> searchPhotos(
    String query, {
    int perPage = 10,
    String orientation = 'landscape',
  }) async {
    final cacheKey = '${query}_${perPage}_$orientation';
    if (_cache.containsKey(cacheKey)) {
      return _cache[cacheKey]!;
    }

    try {
      final uri =
          Uri.parse(
            '${ApiConstants.unsplashBaseUrl}${ApiConstants.unsplashSearchPhotos}',
          ).replace(
            queryParameters: {
              'query': query,
              'per_page': perPage.toString(),
              'orientation': orientation,
              'client_id': ApiConstants.unsplashAccessKey,
            },
          );

      final response = await _client.get(
        uri,
        headers: {'Accept-Version': 'v1'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final results =
            (data['results'] as List<dynamic>?)
                ?.map((e) => UnsplashPhoto.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [];
        _cache[cacheKey] = results;
        return results;
      }
    } catch (_) {
      // Silently fail and return empty list – UI will show a placeholder.
    }

    return [];
  }

  /// Get a single photo URL for a given [query].
  ///
  /// Returns the `small` size URL for card usage, or an empty string
  /// if no results are found.
  Future<String> getPhotoUrl(
    String query, {
    String size = 'small',
    int index = 0,
  }) async {
    final photos = await searchPhotos(query);
    if (photos.isEmpty || index >= photos.length) return '';
    final urls = photos[index].urls;
    switch (size) {
      case 'raw':
        return urls.raw;
      case 'full':
        return urls.full;
      case 'regular':
        return urls.regular;
      case 'thumb':
        return urls.thumb;
      case 'small':
      default:
        return urls.small;
    }
  }

  /// Clears the in-memory cache.
  void clearCache() => _cache.clear();
}
