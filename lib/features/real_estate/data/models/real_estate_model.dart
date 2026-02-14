import 'package:equatable/equatable.dart';

enum RealEstateType { residential, commercial, land, renovation }

class RealEstateProject extends Equatable {
  final String id;
  final String title;
  final String description;
  final RealEstateType type;
  final double latitude;
  final double longitude;
  final String address;
  final List<String> galleryUrls;
  final double totalFunding;
  final double currentFunding;
  final int investorsCount;
  final double minInvestment;
  final bool isCrowdfunding;
  final String? bmcData; // Business Model Canvas
  final DateTime createdAt;

  const RealEstateProject({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.address,
    this.galleryUrls = const [],
    required this.totalFunding,
    required this.currentFunding,
    required this.investorsCount,
    required this.minInvestment,
    this.isCrowdfunding = false,
    this.bmcData,
    required this.createdAt,
  });

  double get fundingPercentage =>
      totalFunding > 0 ? (currentFunding / totalFunding * 100) : 0;

  double get remainingFunding => totalFunding - currentFunding;

  factory RealEstateProject.fromJson(Map<String, dynamic> json) {
    return RealEstateProject(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: RealEstateType.values[json['type'] as int],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'] as String,
      galleryUrls: List<String>.from(json['gallery_urls'] ?? []),
      totalFunding: (json['total_funding'] as num).toDouble(),
      currentFunding: (json['current_funding'] as num).toDouble(),
      investorsCount: json['investors_count'] as int,
      minInvestment: (json['min_investment'] as num).toDouble(),
      isCrowdfunding: json['is_crowdfunding'] as bool? ?? false,
      bmcData: json['bmc_data'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.index,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'gallery_urls': galleryUrls,
      'total_funding': totalFunding,
      'current_funding': currentFunding,
      'investors_count': investorsCount,
      'min_investment': minInvestment,
      'is_crowdfunding': isCrowdfunding,
      'bmc_data': bmcData,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    type,
    latitude,
    longitude,
    address,
    galleryUrls,
    totalFunding,
    currentFunding,
    investorsCount,
    minInvestment,
    isCrowdfunding,
    bmcData,
    createdAt,
  ];
}

class RealEstateExpert extends Equatable {
  final String id;
  final String name;
  final String specialization;
  final double rating;
  final int reviewCount;
  final String avatarUrl;
  final String bio;

  const RealEstateExpert({
    required this.id,
    required this.name,
    required this.specialization,
    required this.rating,
    required this.reviewCount,
    required this.avatarUrl,
    required this.bio,
  });

  factory RealEstateExpert.fromJson(Map<String, dynamic> json) {
    return RealEstateExpert(
      id: json['id'] as String,
      name: json['name'] as String,
      specialization: json['specialization'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['review_count'] as int,
      avatarUrl: json['avatar_url'] as String,
      bio: json['bio'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialization': specialization,
      'rating': rating,
      'review_count': reviewCount,
      'avatar_url': avatarUrl,
      'bio': bio,
    };
  }

  @override
  List<Object?> get props => [
    id,
    name,
    specialization,
    rating,
    reviewCount,
    avatarUrl,
    bio,
  ];
}
