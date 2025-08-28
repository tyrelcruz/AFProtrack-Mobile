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
  final String homeAddress;
  final String? alternateEmail;
  final String? maritalStatus; // Single, Married, etc.
  final String? bloodType; // A+, A-, B+, B-, AB+, AB-, O+, O-
  final String?
  heightMeters; // in meters (stored as string for simplicity/formatting)
  final String?
  weightKg; // in kilograms (stored as string for simplicity/formatting)
  final EmergencyContact? emergencyContact;
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
    required this.homeAddress,
    this.alternateEmail,
    this.maritalStatus,
    this.bloodType,
    this.heightMeters,
    this.weightKg,
    this.emergencyContact,
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
    String? homeAddress,
    String? alternateEmail,
    String? maritalStatus,
    String? bloodType,
    String? heightMeters,
    String? weightKg,
    EmergencyContact? emergencyContact,
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
      homeAddress: homeAddress ?? this.homeAddress,
      alternateEmail: alternateEmail ?? this.alternateEmail,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      bloodType: bloodType ?? this.bloodType,
      heightMeters: heightMeters ?? this.heightMeters,
      weightKg: weightKg ?? this.weightKg,
      emergencyContact: emergencyContact ?? this.emergencyContact,
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
      'homeAddress': homeAddress,
      'alternateEmail': alternateEmail,
      'maritalStatus': maritalStatus,
      'bloodType': bloodType,
      'heightMeters': heightMeters,
      'weightKg': weightKg,
      'emergencyContact': emergencyContact?.toJson(),
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
      homeAddress: json['homeAddress'] ?? '',
      alternateEmail: json['alternateEmail'],
      maritalStatus: json['maritalStatus'],
      bloodType: json['bloodType'],
      heightMeters: json['heightMeters'],
      weightKg: json['weightKg'],
      emergencyContact:
          json['emergencyContact'] != null
              ? EmergencyContact.fromJson(json['emergencyContact'])
              : null,
      profilePictureUrl: json['profilePictureUrl'],
      completedPrograms: json['completedPrograms'] ?? 0,
      certificatesEarned: json['certificatesEarned'] ?? 0,
    );
  }

  // Create from backend API response
  factory UserProfile.fromBackendResponse(Map<String, dynamic> json) {
    // Map backend fields to our UserProfile model
    final fullName =
        '${json['firstName'] ?? ''} ${json['lastName'] ?? ''}'.trim();

    // Format date of birth for display
    String dateEnlisted = '';
    if (json['dateOfBirth'] != null) {
      try {
        final date = DateTime.parse(json['dateOfBirth']);
        final months = [
          'January',
          'February',
          'March',
          'April',
          'May',
          'June',
          'July',
          'August',
          'September',
          'October',
          'November',
          'December',
        ];
        dateEnlisted = '${months[date.month - 1]} ${date.day}, ${date.year}';
      } catch (e) {
        dateEnlisted = json['dateOfBirth'] ?? '';
      }
    }

    return UserProfile(
      id: json['_id'] ?? json['id'] ?? '',
      name: fullName,
      rank: json['rank'] ?? '',
      serviceId: json['serviceId'] ?? '',
      unit: json['unit'] ?? '',
      branch: json['branchOfService'] ?? '',
      currentBase: json['currentBase'] ?? '', // This might not exist in backend
      email: json['email'] ?? '',
      phone: json['contactNumber'] ?? '',
      dateEnlisted: dateEnlisted,
      homeAddress: json['address'] ?? '',
      alternateEmail: json['alternateEmail'],
      maritalStatus: json['maritalStatus'],
      bloodType: json['bloodType'],
      heightMeters: json['heightMeters']?.toString(),
      weightKg: json['weightKg']?.toString(),
      emergencyContact: null, // Backend doesn't have emergency contact yet
      profilePictureUrl: json['profilePictureUrl'],
      completedPrograms: 0, // Will be calculated from training programs
      certificatesEarned: 0, // Will be calculated from training programs
    );
  }

  // Convert to backend API format for updates
  Map<String, dynamic> toBackendFormat() {
    return {
      'firstName': name.split(' ').first,
      'lastName': name.split(' ').skip(1).join(' '),
      'rank': rank,
      'serviceId': serviceId,
      'unit': unit,
      'branchOfService': branch,
      'email': email,
      'contactNumber': phone,
      'address': homeAddress,
      'alternateEmail': alternateEmail,
      'maritalStatus': maritalStatus,
      'bloodType': bloodType,
      'heightMeters':
          heightMeters != null ? double.tryParse(heightMeters!) : null,
      'weightKg': weightKg != null ? double.tryParse(weightKg!) : null,
    };
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
    homeAddress: 'Street 1, Zone 2, Brgy 3, Taguig City, Metro Manila',
    alternateEmail: 'juan.delacruz@example.com',
    maritalStatus: 'Single',
    bloodType: 'O+',
    heightMeters: '1.73',
    weightKg: '70',
    emergencyContact: EmergencyContact(
      fullName: 'Maria Dela Cruz',
      address: 'Street 1, Zone 2, Brgy 3, Taguig City, Metro Manila',
      contactNumber: '(+63) 998-111-2222',
      relationship: 'Mother',
    ),
    completedPrograms: 8,
    certificatesEarned: 12,
  );
}

class EmergencyContact {
  final String fullName;
  final String address;
  final String contactNumber;
  final String relationship; // Father, Mother, Sibling, Husband, Wife, etc.

  EmergencyContact({
    required this.fullName,
    required this.address,
    required this.contactNumber,
    required this.relationship,
  });

  EmergencyContact copyWith({
    String? fullName,
    String? address,
    String? contactNumber,
    String? relationship,
  }) {
    return EmergencyContact(
      fullName: fullName ?? this.fullName,
      address: address ?? this.address,
      contactNumber: contactNumber ?? this.contactNumber,
      relationship: relationship ?? this.relationship,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'address': address,
      'contactNumber': contactNumber,
      'relationship': relationship,
    };
  }

  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      fullName: json['fullName'] ?? '',
      address: json['address'] ?? '',
      contactNumber: json['contactNumber'] ?? '',
      relationship: json['relationship'] ?? '',
    );
  }
}
