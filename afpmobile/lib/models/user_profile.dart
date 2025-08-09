class UserProfile {
  final String id;
  final String name;
  final String rank;
  final String serviceId;
  final String unit;
  final String branch;
  final String currentBase;
  final String email;
  final String phone;
  final String dateEnlisted;
  final String? profilePictureUrl;
  final int completedPrograms;
  final int certificatesEarned;

  UserProfile({
    required this.id,
    required this.name,
    required this.rank,
    required this.serviceId,
    required this.unit,
    required this.branch,
    required this.currentBase,
    required this.email,
    required this.phone,
    required this.dateEnlisted,
    this.profilePictureUrl,
    required this.completedPrograms,
    required this.certificatesEarned,
  });

  // Create a copy of the profile with updated fields
  UserProfile copyWith({
    String? id,
    String? name,
    String? rank,
    String? serviceId,
    String? unit,
    String? branch,
    String? currentBase,
    String? email,
    String? phone,
    String? dateEnlisted,
    String? profilePictureUrl,
    int? completedPrograms,
    int? certificatesEarned,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      rank: rank ?? this.rank,
      serviceId: serviceId ?? this.serviceId,
      unit: unit ?? this.unit,
      branch: branch ?? this.branch,
      currentBase: currentBase ?? this.currentBase,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      dateEnlisted: dateEnlisted ?? this.dateEnlisted,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      completedPrograms: completedPrograms ?? this.completedPrograms,
      certificatesEarned: certificatesEarned ?? this.certificatesEarned,
    );
  }

  // Convert to JSON for storage/API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'rank': rank,
      'serviceId': serviceId,
      'unit': unit,
      'branch': branch,
      'currentBase': currentBase,
      'email': email,
      'phone': phone,
      'dateEnlisted': dateEnlisted,
      'profilePictureUrl': profilePictureUrl,
      'completedPrograms': completedPrograms,
      'certificatesEarned': certificatesEarned,
    };
  }

  // Create from JSON
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      rank: json['rank'] ?? '',
      serviceId: json['serviceId'] ?? '',
      unit: json['unit'] ?? '',
      branch: json['branch'] ?? '',
      currentBase: json['currentBase'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      dateEnlisted: json['dateEnlisted'] ?? '',
      profilePictureUrl: json['profilePictureUrl'],
      completedPrograms: json['completedPrograms'] ?? 0,
      certificatesEarned: json['certificatesEarned'] ?? 0,
    );
  }

  // Sample data for development
  static UserProfile get sampleProfile => UserProfile(
    id: '1',
    name: 'Juan Dela Cruz',
    rank: 'Sergeant (SGT)',
    serviceId: 'AFP - 001234',
    unit: 'Special Forces Regiment',
    branch: 'Philippine Army',
    currentBase: 'Fort Bonifacio, Taguig',
    email: 'j.delacruz@afp.mil.ph',
    phone: '(+63) 912-345-6789',
    dateEnlisted: 'February 15, 2020',
    completedPrograms: 8,
    certificatesEarned: 12,
  );
}
