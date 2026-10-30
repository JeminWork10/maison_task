class ProductReview {
  final double rating;
  final String comment;
  final String date;
  final String reviewerName;
  final String reviewerEmail;

  const ProductReview({
    required this.rating,
    required this.comment,
    required this.date,
    required this.reviewerName,
    required this.reviewerEmail,
  });

  factory ProductReview.fromJson(Map<String, dynamic> json) {
    return ProductReview(
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      comment: json['comment'] as String? ?? '',
      date: json['date'] as String? ?? '',
      reviewerName: json['reviewerName'] as String? ?? 'Anonymous',
      reviewerEmail: json['reviewerEmail'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rating': rating,
      'comment': comment,
      'date': date,
      'reviewerName': reviewerName,
      'reviewerEmail': reviewerEmail,
    };
  }
}

class ProductModel {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final List<String> tags;
  final String? brand;
  final String? sku;
  final String? warrantyInformation;
  final String? shippingInformation;
  final String? availabilityStatus;
  final List<ProductReview> reviews;
  final String? returnPolicy;
  final int? minimumOrderQuantity;
  final List<String> images;
  final String thumbnail;

  const ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    this.tags = const [],
    this.brand,
    this.sku,
    this.warrantyInformation,
    this.shippingInformation,
    this.availabilityStatus,
    this.reviews = const [],
    this.returnPolicy,
    this.minimumOrderQuantity,
    this.images = const [],
    required this.thumbnail,
  });

  bool get isInStock => stock > 0;

  double get originalPrice {
    if (discountPercentage <= 0) return price;
    return price / (1 - (discountPercentage / 100));
  }

  String get displayBrand =>
      (brand != null && brand!.isNotEmpty) ? brand! : 'Generic';

  String get primaryImage {
    if (thumbnail.isNotEmpty) return thumbnail;
    if (images.isNotEmpty) return images.first;
    return '';
  }

  Map<String, dynamic> toRouteArgs() => {'id': id, 'title': title};

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final rawImages = json['images'];
    final rawTags = json['tags'];
    final rawReviews = json['reviews'];

    return ProductModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? 'Untitled',
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? 'General',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      discountPercentage: (json['discountPercentage'] as num?)?.toDouble() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      tags: rawTags is List
          ? rawTags.map((e) => e.toString()).toList()
          : const [],
      brand: json['brand'] as String?,
      sku: json['sku'] as String?,
      warrantyInformation: json['warrantyInformation'] as String?,
      shippingInformation: json['shippingInformation'] as String?,
      availabilityStatus: json['availabilityStatus'] as String?,
      reviews: rawReviews is List
          ? rawReviews
                .whereType<Map>()
                .map(
                  (e) => ProductReview.fromJson(Map<String, dynamic>.from(e)),
                )
                .toList()
          : const [],
      returnPolicy: json['returnPolicy'] as String?,
      minimumOrderQuantity: (json['minimumOrderQuantity'] as num?)?.toInt(),
      images: rawImages is List
          ? rawImages.map((e) => e.toString()).toList()
          : const [],
      thumbnail: json['thumbnail'] as String? ?? '',
    );
  }
}
