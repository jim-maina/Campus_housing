/// Base User class that both Student and Landlord will inherit from
abstract class User {
  final String id;
  final String email;
  final String password;
  final String phone;

  User({
    required this.id,
    required this.email,
    required this.password,
    required this.phone,
  });
}

/// Student user — extends User
class Student extends User {
  Student({
    required String id,
    required String email,
    required String password,
    required String phone,
  }) : super(
    id: id,
    email: email,
    password: password,
    phone: phone,
  );
}

/// Landlord user — extends User
class Landlord extends User {
  Landlord({
    required String id,
    required String email,
    required String password,
    required String phone,
  }) : super(
    id: id,
    email: email,
    password: password,
    phone: phone,
  );
}

