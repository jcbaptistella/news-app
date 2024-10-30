class UserResponse {
  final String username;
  final String name;
  final String phoneNumber;

  UserResponse({required this.username, required this.name, required this.phoneNumber});

  // Método para converter JSON em um objeto UserResponse
  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      username: json['username'] ?? 'Desconhecido',
      phoneNumber: json['phoneNumber'] ?? 'Desconhecido',
      name: json['name'] ?? 'Desconhecido'
    );
  }

  // Método para converter um objeto UserResponse em JSON
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'name': name,
      'phoneNumber': phoneNumber,
    };
  }
}
