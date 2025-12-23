import 'dart:convert';
class UserModel {
 final String id;
 final String role;
 final String name;
 final String? email;
 final String? phone;
 final String? password;
 final String? avatar;
 final double rating;
 final String status;
 final DateTime createdAt;
 final DateTime updatedAt;
 const UserModel({required this.id, required this.role, required this.name, this.email, this.phone, this.password, this.avatar, this.rating = 0.0, this.status = 'active', required this.createdAt, required this.updatedAt});
 Map<String, dynamic> toMap() {
  return {'id': id, 'role': role, 'name': name, 'email': email, 'phone': phone, 'password': password, 'avatar': avatar, 'rating': rating, 'status': status, 'createdAt': createdAt.millisecondsSinceEpoch, 'updatedAt': updatedAt.millisecondsSinceEpoch};
 }
 factory UserModel.fromMap(Map<String, dynamic> map) {
  return UserModel(id: map['id']?.toString() ?? '', role: map['role'] as String? ?? 'user', name: map['name'] as String, email: map['email'] as String?, phone: map['phone'] as String?, password: map['password'] as String?, avatar: map['avatar'] as String?, rating: (map['rating'] as num?)?.toDouble() ?? 0.0, status: map['status'] as String? ?? 'active', createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int), updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int));
 }
 String toJson() => json.encode(toMap());
 factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}