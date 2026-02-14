/// Base User class that both Student and Landlord will inherit from
abstract class User {
  final String id;
  final String email;
  final String password;
  final String fullName;
  final String phone;

  User({
    required this.id,
    required this.email,
    required this.password,
    required this.fullName,
    required this.phone,
  });
}

/// Student user — extends User with student-specific fields
class Student extends User {
  final String university;
  final String major;
  final int graduationYear;

  Student({
    required String id,
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required this.university,
    required this.major,
    required this.graduationYear,
  }) : super(
    id: id,
    email: email,
    password: password,
    fullName: fullName,
    phone: phone,
  );
}

/// Landlord user — extends User with landlord-specific fields
class Landlord extends User {
  final String companyName;
  final String bankAccount;
  final String taxId;

  Landlord({
    required String id,
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required this.companyName,
    required this.bankAccount,
    required this.taxId,
  }) : super(
    id: id,
    email: email,
    password: password,
    fullName: fullName,
    phone: phone,
  );
}
