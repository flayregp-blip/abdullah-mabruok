class GiphyModel {
  GiphyModel({
    this.data,
    this.meta,
    this.pagination,
  });

  GiphyModel.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(GiphyData.fromJson(v));
      });
    }
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }

  List<GiphyData>? data;
  Meta? meta;
  Pagination? pagination;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    if (meta != null) {
      map['meta'] = meta?.toJson();
    }
    if (pagination != null) {
      map['pagination'] = pagination?.toJson();
    }
    return map;
  }
}

class Pagination {
  Pagination({
    this.totalCount,
    this.count,
    this.offset,
  });

  Pagination.fromJson(dynamic json) {
    totalCount = json['total_count'];
    count = json['count'];
    offset = json['offset'];
  }

  num? totalCount;
  num? count;
  num? offset;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['total_count'] = totalCount;
    map['count'] = count;
    map['offset'] = offset;
    return map;
  }
}

class Meta {
  Meta({
    this.status,
    this.msg,
    this.responseId,
  });

  Meta.fromJson(dynamic json) {
    status = json['status'];
    msg = json['msg'];
    responseId = json['response_id'];
  }

  num? status;
  String? msg;
  String? responseId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['msg'] = msg;
    map['response_id'] = responseId;
    return map;
  }
}

class GiphyData {
  GiphyData({
    this.type,
    this.id,
    this.url,
    this.slug,
    this.bitlyGifUrl,
    this.bitlyUrl,
    this.embedUrl,
    this.username,
    this.source,
    this.title,
    this.rating,
    this.contentUrl,
    this.sourceTld,
    this.sourcePostUrl,
    this.isSticker,
    this.importDatetime,
    this.trendingDatetime,
    this.images,
    this.user,
    this.analyticsResponsePayload,
    this.analytics,
    this.altText,
  });

  GiphyData.fromJson(dynamic json) {
    type = json['type'];
    id = json['id'];
    url = json['url'];
    slug = json['slug'];
    bitlyGifUrl = json['bitly_gif_url'];
    bitlyUrl = json['bitly_url'];
    embedUrl = json['embed_url'];
    username = json['username'];
    source = json['source'];
    title = json['title'];
    rating = json['rating'];
    contentUrl = json['content_url'];
    sourceTld = json['source_tld'];
    sourcePostUrl = json['source_post_url'];
    isSticker = json['is_sticker'];
    importDatetime = json['import_datetime'];
    trendingDatetime = json['trending_datetime'];
    images =
        json['images'] != null ? GiphyImages.fromJson(json['images']) : null;
    user = json['user'] != null ? GiphyUser.fromJson(json['user']) : null;
    analyticsResponsePayload = json['analytics_response_payload'];
    analytics = json['analytics'] != null
        ? Analytics.fromJson(json['analytics'])
        : null;
    altText = json['alt_text'];
  }

  String? type;
  String? id;
  String? url;
  String? slug;
  String? bitlyGifUrl;
  String? bitlyUrl;
  String? embedUrl;
  String? username;
  String? source;
  String? title;
  String? rating;
  String? contentUrl;
  String? sourceTld;
  String? sourcePostUrl;
  num? isSticker;
  String? importDatetime;
  String? trendingDatetime;
  GiphyImages? images;
  GiphyUser? user;
  String? analyticsResponsePayload;
  Analytics? analytics;
  String? altText;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = type;
    map['id'] = id;
    map['url'] = url;
    map['slug'] = slug;
    map['bitly_gif_url'] = bitlyGifUrl;
    map['bitly_url'] = bitlyUrl;
    map['embed_url'] = embedUrl;
    map['username'] = username;
    map['source'] = source;
    map['title'] = title;
    map['rating'] = rating;
    map['content_url'] = contentUrl;
    map['source_tld'] = sourceTld;
    map['source_post_url'] = sourcePostUrl;
    map['is_sticker'] = isSticker;
    map['import_datetime'] = importDatetime;
    map['trending_datetime'] = trendingDatetime;
    if (images != null) {
      map['images'] = images?.toJson();
    }
    if (user != null) {
      map['user'] = user?.toJson();
    }
    map['analytics_response_payload'] = analyticsResponsePayload;
    if (analytics != null) {
      map['analytics'] = analytics?.toJson();
    }
    map['alt_text'] = altText;
    return map;
  }
}

class Analytics {
  Analytics({
    this.onload,
    this.onclick,
    this.onsent,
  });

  Analytics.fromJson(dynamic json) {
    onload = json['onload'] != null ? Onload.fromJson(json['onload']) : null;
    onclick =
        json['onclick'] != null ? Onclick.fromJson(json['onclick']) : null;
    onsent = json['onsent'] != null ? Onsent.fromJson(json['onsent']) : null;
  }

  Onload? onload;
  Onclick? onclick;
  Onsent? onsent;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (onload != null) {
      map['onload'] = onload?.toJson();
    }
    if (onclick != null) {
      map['onclick'] = onclick?.toJson();
    }
    if (onsent != null) {
      map['onsent'] = onsent?.toJson();
    }
    return map;
  }
}

class Onsent {
  Onsent({
    this.url,
  });

  Onsent.fromJson(dynamic json) {
    url = json['url'];
  }

  String? url;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['url'] = url;
    return map;
  }
}

class Onclick {
  Onclick({
    this.url,
  });

  Onclick.fromJson(dynamic json) {
    url = json['url'];
  }

  String? url;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['url'] = url;
    return map;
  }
}

class Onload {
  Onload({
    this.url,
  });

  Onload.fromJson(dynamic json) {
    url = json['url'];
  }

  String? url;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['url'] = url;
    return map;
  }
}

class GiphyUser {
  GiphyUser({
    this.avatarUrl,
    this.bannerImage,
    this.bannerUrl,
    this.profileUrl,
    this.username,
    this.displayName,
    this.description,
    this.instagramUrl,
    this.websiteUrl,
    this.isVerified,
  });

  GiphyUser.fromJson(dynamic json) {
    avatarUrl = json['avatar_url'];
    bannerImage = json['banner_image'];
    bannerUrl = json['banner_url'];
    profileUrl = json['profile_url'];
    username = json['username'];
    displayName = json['display_name'];
    description = json['description'];
    instagramUrl = json['instagram_url'];
    websiteUrl = json['website_url'];
    isVerified = json['is_verified'];
  }

  String? avatarUrl;
  String? bannerImage;
  String? bannerUrl;
  String? profileUrl;
  String? username;
  String? displayName;
  String? description;
  String? instagramUrl;
  String? websiteUrl;
  bool? isVerified;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['avatar_url'] = avatarUrl;
    map['banner_image'] = bannerImage;
    map['banner_url'] = bannerUrl;
    map['profile_url'] = profileUrl;
    map['username'] = username;
    map['display_name'] = displayName;
    map['description'] = description;
    map['instagram_url'] = instagramUrl;
    map['website_url'] = websiteUrl;
    map['is_verified'] = isVerified;
    return map;
  }
}

class GiphyImages {
  GiphyImages({
    this.original,
    this.downsizedLarge,
    this.downsizedMedium,
    this.fixedHeight,
    this.fixedHeightDownsampled,
    this.fixedHeightSmall,
    this.fixedWidth,
    this.fixedWidthDownsampled,
    this.fixedWidthSmall,
  });

  GiphyImages.fromJson(dynamic json) {
    original =
        json['original'] != null ? Original.fromJson(json['original']) : null;
    downsizedLarge = json['downsized_large'] != null
        ? DownsizedLarge.fromJson(json['downsized_large'])
        : null;
    downsizedMedium = json['downsized_medium'] != null
        ? DownsizedMedium.fromJson(json['downsized_medium'])
        : null;
    fixedHeight = json['fixed_height'] != null
        ? FixedHeight.fromJson(json['fixed_height'])
        : null;
    fixedHeightDownsampled = json['fixed_height_downsampled'] != null
        ? FixedHeightDownsampled.fromJson(json['fixed_height_downsampled'])
        : null;
    fixedHeightSmall = json['fixed_height_small'] != null
        ? FixedHeightSmall.fromJson(json['fixed_height_small'])
        : null;
    fixedWidth = json['fixed_width'] != null
        ? FixedWidth.fromJson(json['fixed_width'])
        : null;
    fixedWidthDownsampled = json['fixed_width_downsampled'] != null
        ? FixedWidthDownsampled.fromJson(json['fixed_width_downsampled'])
        : null;
    fixedWidthSmall = json['fixed_width_small'] != null
        ? FixedWidthSmall.fromJson(json['fixed_width_small'])
        : null;
  }

  Original? original;
  DownsizedLarge? downsizedLarge;
  DownsizedMedium? downsizedMedium;
  FixedHeight? fixedHeight;
  FixedHeightDownsampled? fixedHeightDownsampled;
  FixedHeightSmall? fixedHeightSmall;
  FixedWidth? fixedWidth;
  FixedWidthDownsampled? fixedWidthDownsampled;
  FixedWidthSmall? fixedWidthSmall;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (original != null) {
      map['original'] = original?.toJson();
    }
    if (downsizedLarge != null) {
      map['downsized_large'] = downsizedLarge?.toJson();
    }
    if (downsizedMedium != null) {
      map['downsized_medium'] = downsizedMedium?.toJson();
    }
    if (fixedHeight != null) {
      map['fixed_height'] = fixedHeight?.toJson();
    }
    if (fixedHeightDownsampled != null) {
      map['fixed_height_downsampled'] = fixedHeightDownsampled?.toJson();
    }
    if (fixedHeightSmall != null) {
      map['fixed_height_small'] = fixedHeightSmall?.toJson();
    }
    if (fixedWidth != null) {
      map['fixed_width'] = fixedWidth?.toJson();
    }
    if (fixedWidthDownsampled != null) {
      map['fixed_width_downsampled'] = fixedWidthDownsampled?.toJson();
    }
    if (fixedWidthSmall != null) {
      map['fixed_width_small'] = fixedWidthSmall?.toJson();
    }
    return map;
  }
}

class FixedWidthSmall {
  FixedWidthSmall({
    this.height,
    this.width,
    this.size,
    this.url,
    this.mp4Size,
    this.mp4,
    this.webpSize,
    this.webp,
  });

  FixedWidthSmall.fromJson(dynamic json) {
    height = json['height'];
    width = json['width'];
    size = json['size'];
    url = json['url'];
    mp4Size = json['mp4_size'];
    mp4 = json['mp4'];
    webpSize = json['webp_size'];
    webp = json['webp'];
  }

  String? height;
  String? width;
  String? size;
  String? url;
  String? mp4Size;
  String? mp4;
  String? webpSize;
  String? webp;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['height'] = height;
    map['width'] = width;
    map['size'] = size;
    map['url'] = url;
    map['mp4_size'] = mp4Size;
    map['mp4'] = mp4;
    map['webp_size'] = webpSize;
    map['webp'] = webp;
    return map;
  }
}

class FixedWidthDownsampled {
  FixedWidthDownsampled({
    this.height,
    this.width,
    this.size,
    this.url,
    this.webpSize,
    this.webp,
  });

  FixedWidthDownsampled.fromJson(dynamic json) {
    height = json['height'];
    width = json['width'];
    size = json['size'];
    url = json['url'];
    webpSize = json['webp_size'];
    webp = json['webp'];
  }

  String? height;
  String? width;
  String? size;
  String? url;
  String? webpSize;
  String? webp;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['height'] = height;
    map['width'] = width;
    map['size'] = size;
    map['url'] = url;
    map['webp_size'] = webpSize;
    map['webp'] = webp;
    return map;
  }
}

class FixedWidth {
  FixedWidth({
    this.height,
    this.width,
    this.size,
    this.url,
    this.mp4Size,
    this.mp4,
    this.webpSize,
    this.webp,
  });

  FixedWidth.fromJson(dynamic json) {
    height = json['height'];
    width = json['width'];
    size = json['size'];
    url = json['url'];
    mp4Size = json['mp4_size'];
    mp4 = json['mp4'];
    webpSize = json['webp_size'];
    webp = json['webp'];
  }

  String? height;
  String? width;
  String? size;
  String? url;
  String? mp4Size;
  String? mp4;
  String? webpSize;
  String? webp;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['height'] = height;
    map['width'] = width;
    map['size'] = size;
    map['url'] = url;
    map['mp4_size'] = mp4Size;
    map['mp4'] = mp4;
    map['webp_size'] = webpSize;
    map['webp'] = webp;
    return map;
  }
}

class FixedHeightSmall {
  FixedHeightSmall({
    this.height,
    this.width,
    this.size,
    this.url,
    this.mp4Size,
    this.mp4,
    this.webpSize,
    this.webp,
  });

  FixedHeightSmall.fromJson(dynamic json) {
    height = json['height'];
    width = json['width'];
    size = json['size'];
    url = json['url'];
    mp4Size = json['mp4_size'];
    mp4 = json['mp4'];
    webpSize = json['webp_size'];
    webp = json['webp'];
  }

  String? height;
  String? width;
  String? size;
  String? url;
  String? mp4Size;
  String? mp4;
  String? webpSize;
  String? webp;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['height'] = height;
    map['width'] = width;
    map['size'] = size;
    map['url'] = url;
    map['mp4_size'] = mp4Size;
    map['mp4'] = mp4;
    map['webp_size'] = webpSize;
    map['webp'] = webp;
    return map;
  }
}

class FixedHeightDownsampled {
  FixedHeightDownsampled({
    this.height,
    this.width,
    this.size,
    this.url,
    this.webpSize,
    this.webp,
  });

  FixedHeightDownsampled.fromJson(dynamic json) {
    height = json['height'];
    width = json['width'];
    size = json['size'];
    url = json['url'];
    webpSize = json['webp_size'];
    webp = json['webp'];
  }

  String? height;
  String? width;
  String? size;
  String? url;
  String? webpSize;
  String? webp;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['height'] = height;
    map['width'] = width;
    map['size'] = size;
    map['url'] = url;
    map['webp_size'] = webpSize;
    map['webp'] = webp;
    return map;
  }
}

class FixedHeight {
  FixedHeight({
    this.height,
    this.width,
    this.size,
    this.url,
    this.mp4Size,
    this.mp4,
    this.webpSize,
    this.webp,
  });

  FixedHeight.fromJson(dynamic json) {
    height = json['height'];
    width = json['width'];
    size = json['size'];
    url = json['url'];
    mp4Size = json['mp4_size'];
    mp4 = json['mp4'];
    webpSize = json['webp_size'];
    webp = json['webp'];
  }

  String? height;
  String? width;
  String? size;
  String? url;
  String? mp4Size;
  String? mp4;
  String? webpSize;
  String? webp;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['height'] = height;
    map['width'] = width;
    map['size'] = size;
    map['url'] = url;
    map['mp4_size'] = mp4Size;
    map['mp4'] = mp4;
    map['webp_size'] = webpSize;
    map['webp'] = webp;
    return map;
  }
}

class DownsizedMedium {
  DownsizedMedium({
    this.height,
    this.width,
    this.size,
    this.url,
  });

  DownsizedMedium.fromJson(dynamic json) {
    height = json['height'];
    width = json['width'];
    size = json['size'];
    url = json['url'];
  }

  String? height;
  String? width;
  String? size;
  String? url;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['height'] = height;
    map['width'] = width;
    map['size'] = size;
    map['url'] = url;
    return map;
  }
}

class DownsizedLarge {
  DownsizedLarge({
    this.height,
    this.width,
    this.size,
    this.url,
  });

  DownsizedLarge.fromJson(dynamic json) {
    height = json['height'];
    width = json['width'];
    size = json['size'];
    url = json['url'];
  }

  String? height;
  String? width;
  String? size;
  String? url;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['height'] = height;
    map['width'] = width;
    map['size'] = size;
    map['url'] = url;
    return map;
  }
}

class Original {
  Original({
    this.height,
    this.width,
    this.size,
    this.url,
    this.mp4Size,
    this.mp4,
    this.webpSize,
    this.webp,
    this.frames,
    this.hash,
  });

  Original.fromJson(dynamic json) {
    height = json['height'];
    width = json['width'];
    size = json['size'];
    url = json['url'];
    mp4Size = json['mp4_size'];
    mp4 = json['mp4'];
    webpSize = json['webp_size'];
    webp = json['webp'];
    frames = json['frames'];
    hash = json['hash'];
  }

  String? height;
  String? width;
  String? size;
  String? url;
  String? mp4Size;
  String? mp4;
  String? webpSize;
  String? webp;
  String? frames;
  String? hash;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['height'] = height;
    map['width'] = width;
    map['size'] = size;
    map['url'] = url;
    map['mp4_size'] = mp4Size;
    map['mp4'] = mp4;
    map['webp_size'] = webpSize;
    map['webp'] = webp;
    map['frames'] = frames;
    map['hash'] = hash;
    return map;
  }
}
