import 'package:equatable/equatable.dart';

class Investor extends Equatable {
  final String id;
  final String name;
  final String bio;
  final String avatarUrl;
  final List<String> interests; // Tech, Agriculture, Real Estate, etc.
  final double totalInvested;
  final int activeProjects;
  final double rating;
  final String location;

  const Investor({
    required this.id,
    required this.name,
    required this.bio,
    required this.avatarUrl,
    required this.interests,
    required this.totalInvested,
    required this.activeProjects,
    required this.rating,
    required this.location,
  });

  factory Investor.fromJson(Map<String, dynamic> json) {
    return Investor(
      id: json['id'] as String,
      name: json['name'] as String,
      bio: json['bio'] as String,
      avatarUrl: json['avatar_url'] as String,
      interests: List<String>.from(json['interests'] ?? []),
      totalInvested: (json['total_invested'] as num).toDouble(),
      activeProjects: json['active_projects'] as int,
      rating: (json['rating'] as num).toDouble(),
      location: json['location'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'bio': bio,
      'avatar_url': avatarUrl,
      'interests': interests,
      'total_invested': totalInvested,
      'active_projects': activeProjects,
      'rating': rating,
      'location': location,
    };
  }

  @override
  List<Object?> get props => [
    id,
    name,
    bio,
    avatarUrl,
    interests,
    totalInvested,
    activeProjects,
    rating,
    location,
  ];
}

class InvestmentRecord extends Equatable {
  final String id;
  final String projectName;
  final String investorId;
  final double amount;
  final DateTime date;
  final String status; // active, completed, pending

  const InvestmentRecord({
    required this.id,
    required this.projectName,
    required this.investorId,
    required this.amount,
    required this.date,
    required this.status,
  });

  factory InvestmentRecord.fromJson(Map<String, dynamic> json) {
    return InvestmentRecord(
      id: json['id'] as String,
      projectName: json['project_name'] as String,
      investorId: json['investor_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'project_name': projectName,
      'investor_id': investorId,
      'amount': amount,
      'date': date.toIso8601String(),
      'status': status,
    };
  }

  @override
  List<Object?> get props => [
    id,
    projectName,
    investorId,
    amount,
    date,
    status,
  ];
}
