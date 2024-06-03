enum UserRole {
  user,
  admin;

  // Convert enum value to a string key
  String toKey() => name.toString();

  // Create an enum value from a string key
  static UserRole fromKey(String? key) {
    return UserRole.values.firstWhere(
      (type) => type.toKey() == key,
      orElse: () => UserRole.user,
    );
  }
}
