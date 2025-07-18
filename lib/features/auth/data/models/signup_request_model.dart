class SignupRequestModel {
  final String username;
  final String email;
  final String phoneNumber;
  final String publicKey;

  SignupRequestModel({
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.publicKey,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'phoneNumber': phoneNumber,
      'publicKey': publicKey,
    };
  }
}
