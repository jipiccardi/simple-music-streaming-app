class AppUser {
  final String id;
  final String email;

  AppUser({
    required this.id,
    required this.email,
  });

  factory AppUser.fromFirestore(Map<String, dynamic> data, String id) {
    return AppUser(
      id: id,
      email: data['email'],
    );
  }
}