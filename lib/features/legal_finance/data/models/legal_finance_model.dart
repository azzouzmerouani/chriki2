import 'package:equatable/equatable.dart';

class LegalExpert extends Equatable {
  final String id;
  final String name;
  final String specialization;
  final double rating;
  final int reviewCount;
  final String avatarUrl;
  final String bio;
  final double consultationFee;

  const LegalExpert({
    required this.id,
    required this.name,
    required this.specialization,
    required this.rating,
    required this.reviewCount,
    required this.avatarUrl,
    required this.bio,
    required this.consultationFee,
  });

  factory LegalExpert.fromJson(Map<String, dynamic> json) {
    return LegalExpert(
      id: json['id'] as String,
      name: json['name'] as String,
      specialization: json['specialization'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['review_count'] as int,
      avatarUrl: json['avatar_url'] as String,
      bio: json['bio'] as String,
      consultationFee: (json['consultation_fee'] as num).toDouble(),
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
      'consultation_fee': consultationFee,
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
    consultationFee,
  ];
}

class Bank extends Equatable {
  final String id;
  final String name;
  final String logoUrl;
  final String description;
  final double interestRate;
  final List<String> fundingTypes;

  const Bank({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.description,
    required this.interestRate,
    required this.fundingTypes,
  });

  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
      id: json['id'] as String,
      name: json['name'] as String,
      logoUrl: json['logo_url'] as String,
      description: json['description'] as String,
      interestRate: (json['interest_rate'] as num).toDouble(),
      fundingTypes: List<String>.from(json['funding_types'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logo_url': logoUrl,
      'description': description,
      'interest_rate': interestRate,
      'funding_types': fundingTypes,
    };
  }

  @override
  List<Object?> get props => [
    id,
    name,
    logoUrl,
    description,
    interestRate,
    fundingTypes,
  ];
}

enum ApplicationStatus { pending, approved, rejected }

class FundingApplication extends Equatable {
  final String id;
  final String bankName;
  final double amount;
  final String purpose;
  final ApplicationStatus status;
  final DateTime appliedAt;
  final String? notes;

  const FundingApplication({
    required this.id,
    required this.bankName,
    required this.amount,
    required this.purpose,
    required this.status,
    required this.appliedAt,
    this.notes,
  });

  factory FundingApplication.fromJson(Map<String, dynamic> json) {
    return FundingApplication(
      id: json['id'] as String,
      bankName: json['bank_name'] as String,
      amount: (json['amount'] as num).toDouble(),
      purpose: json['purpose'] as String,
      status: ApplicationStatus.values[json['status'] as int],
      appliedAt: DateTime.parse(json['applied_at'] as String),
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bank_name': bankName,
      'amount': amount,
      'purpose': purpose,
      'status': status.index,
      'applied_at': appliedAt.toIso8601String(),
      'notes': notes,
    };
  }

  @override
  List<Object?> get props => [
    id,
    bankName,
    amount,
    purpose,
    status,
    appliedAt,
    notes,
  ];
}
