// No Flutter imports needed; pure validation utilities

class ValidationUtils {
  // Validation error messages
  static const String requiredField = 'This field is required';
  static const String invalidEmail = 'Please enter a valid email address';
  static const String invalidPassword =
      'Password must be at least 8 characters long';
  static const String passwordMismatch = 'Passwords do not match';
  static const String invalidServiceId =
      'Service ID must be in format: AFP-YYYY-XXX';
  static const String invalidContactNumber =
      'Please enter a valid contact number';
  static const String invalidName =
      'Name can only contain letters, spaces, and hyphens';
  static const String invalidAddress = 'Address is too short';
  static const String invalidSuffix =
      'Suffix can only contain letters, numbers, and common suffixes';

  // Email validation
  static String? validateEmail(String? email) {
    if (email == null || email.trim().isEmpty) {
      return requiredField;
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(email.trim())) {
      return invalidEmail;
    }

    return null;
  }

  // Password validation
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return requiredField;
    }

    if (password.length < 8) {
      return invalidPassword;
    }

    return null;
  }

  // Confirm password validation
  static String? validateConfirmPassword(
    String? confirmPassword,
    String? password,
  ) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return requiredField;
    }

    if (password != confirmPassword) {
      return passwordMismatch;
    }

    return null;
  }

  // Service ID validation
  static String? validateServiceId(String? serviceId) {
    if (serviceId == null || serviceId.trim().isEmpty) {
      return requiredField;
    }

    final serviceIdRegex = RegExp(r'^AFP-\d{4}-\d{3}$');
    if (!serviceIdRegex.hasMatch(serviceId.trim().toUpperCase())) {
      return invalidServiceId;
    }

    return null;
  }

  // Contact number validation
  static String? validateContactNumber(String? contactNumber) {
    if (contactNumber == null || contactNumber.trim().isEmpty) {
      return requiredField;
    }

    final trimmed = contactNumber.trim();
    final digitsOnly = trimmed.replaceAll(RegExp(r'[^\d]'), '');

    // Accept formats:
    // - +63XXXXXXXXXX (country code 63 + 10 digits)
    // - 09XXXXXXXXX (11 digits local format)
    final startsWithPlus63 =
        trimmed.startsWith('+63') || digitsOnly.startsWith('63');
    if (startsWithPlus63) {
      // Must be exactly 12 digits when including 63 prefix
      if (digitsOnly.length == 12 && digitsOnly.startsWith('63')) {
        return null;
      }
      return invalidContactNumber;
    }

    // Allow local 11-digit numbers starting with 09
    if (digitsOnly.length == 11 && digitsOnly.startsWith('09')) {
      return null;
    }

    return invalidContactNumber;
  }

  // Name validation (first name, last name)
  static String? validateName(String? name, String fieldName) {
    if (name == null || name.trim().isEmpty) {
      return '$fieldName is required';
    }

    final nameRegex = RegExp(r'^[a-zA-Z\s\-\.]+$');
    if (!nameRegex.hasMatch(name.trim())) {
      return invalidName;
    }

    if (name.trim().length < 2) {
      return '$fieldName must be at least 2 characters long';
    }

    return null;
  }

  // Address validation
  static String? validateAddress(String? address) {
    if (address == null || address.trim().isEmpty) {
      return requiredField;
    }

    if (address.trim().length < 10) {
      return invalidAddress;
    }

    return null;
  }

  // Suffix validation
  static String? validateSuffix(String? suffix) {
    if (suffix == null || suffix.trim().isEmpty) {
      return null; // Suffix is optional
    }

    final suffixRegex = RegExp(r'^[a-zA-Z0-9\.,\s]+$');
    if (!suffixRegex.hasMatch(suffix.trim())) {
      return invalidSuffix;
    }

    return null;
  }

  // Date of birth validation
  static String? validateDateOfBirth(DateTime? dateOfBirth) {
    if (dateOfBirth == null) {
      return 'Date of birth is required';
    }

    final now = DateTime.now();
    final age = now.year - dateOfBirth.year;

    if (age < 18) {
      return 'You must be at least 18 years old';
    }

    if (age > 100) {
      return 'Please enter a valid date of birth';
    }

    return null;
  }

  // Dropdown validation
  static String? validateDropdown(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }

    return null;
  }

  // Comprehensive signup validation
  static Map<String, String?> validateSignupForm({
    String? firstName,
    String? lastName,
    String? suffix,
    String? serviceId,
    String? email,
    String? password,
    String? confirmPassword,
    String? contactNumber,
    String? address,
    DateTime? dateOfBirth,
    String? branch,
    String? division,
    String? unit,
  }) {
    final errors = <String, String?>{};

    // Validate all fields
    errors['firstName'] = validateName(firstName, 'First name');
    errors['lastName'] = validateName(lastName, 'Last name');
    errors['suffix'] = validateSuffix(suffix);
    errors['serviceId'] = validateServiceId(serviceId);
    errors['email'] = validateEmail(email);
    errors['password'] = validatePassword(password);
    errors['confirmPassword'] = validateConfirmPassword(
      confirmPassword,
      password,
    );
    errors['contactNumber'] = validateContactNumber(contactNumber);
    errors['address'] = validateAddress(address);
    errors['dateOfBirth'] = validateDateOfBirth(dateOfBirth);
    errors['branch'] = validateDropdown(branch, 'Branch of service');
    errors['division'] = validateDropdown(division, 'Division');
    errors['unit'] = validateDropdown(unit, 'Unit');

    return errors;
  }

  // Check if form is valid
  static bool isFormValid(Map<String, String?> errors) {
    return errors.values.every((error) => error == null);
  }

  // Get first error message
  static String? getFirstError(Map<String, String?> errors) {
    for (final error in errors.values) {
      if (error != null) {
        return error;
      }
    }
    return null;
  }

  // Format contact number for display
  static String formatContactNumber(String contactNumber) {
    // Remove all non-digit characters
    final digitsOnly = contactNumber.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.length == 11) {
      // Format: +63 9XX XXX XXXX
      return '+63 ${digitsOnly.substring(1, 4)} ${digitsOnly.substring(4, 7)} ${digitsOnly.substring(7)}';
    } else if (digitsOnly.length == 10) {
      // Format: +63 9XX XXX XXXX (assuming it starts with 9)
      return '+63 ${digitsOnly.substring(0, 3)} ${digitsOnly.substring(3, 6)} ${digitsOnly.substring(6)}';
    }

    return contactNumber; // Return as is if can't format
  }

  // Format service ID for display
  static String formatServiceId(String serviceId) {
    return serviceId.trim().toUpperCase();
  }

  // Sanitize input (remove extra spaces, etc.)
  static String sanitizeInput(String input) {
    return input.trim().replaceAll(RegExp(r'\s+'), ' ');
  }
}
