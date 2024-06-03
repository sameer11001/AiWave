// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:wave_ai/wave_ai.dart';
import 'package:wave_storage/wave_storage.dart';
import '../../../wave_auth.dart';

class User {
  final String uid;
  final String email;
  final String? username;
  final String? imageUrl;
  final int? age;
  final UserRole role;
  final Map<String, dynamic>? data;
  final String createdAt;
  final String? updatedAt;
  User({
    required this.uid,
    required this.email,
    this.username,
    this.imageUrl,
    this.age,
    this.role = UserRole.user,
    this.data,
    required this.createdAt,
    this.updatedAt,
  });

  User copyWith({
    String? uid,
    String? email,
    String? username,
    String? imageUrl,
    int? age,
    UserRole? role,
    Map<String, dynamic>? data,
    String? createdAt,
    String? updatedAt,
  }) {
    return User(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      username: username ?? this.username,
      imageUrl: imageUrl ?? this.imageUrl,
      age: age ?? this.age,
      role: role ?? this.role,
      data: data ?? this.data,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'email': email,
      'username': username,
      'image_url': imageUrl,
      'age': age,
      'role': role.toKey(),
      'data': data,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'] as String,
      email: map['email'] as String,
      username: map['username'],
      imageUrl: map['image_url'] != null ? map['image_url'] as String : null,
      age: map['age'] != null ? map['age'] as int : null,
      role: UserRole.fromKey(map['role'] as String),
      data: map['data'] != null ? map['data'] as Map<String, dynamic> : null,
      createdAt: map['created_at'] as String,
      updatedAt: map['updated_at'] != null ? map['updated_at'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(uid: $uid, email: $email, username: $username, imageUrl: $imageUrl, age: $age, role: $role, data: $data, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.email == email &&
        other.username == username &&
        other.imageUrl == imageUrl &&
        other.age == age &&
        other.role == role &&
        mapEquals(other.data, data) &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        email.hashCode ^
        username.hashCode ^
        imageUrl.hashCode ^
        age.hashCode ^
        role.hashCode ^
        data.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }

  Future<List<AIMedia>> getMedia() async {
    return await WaveAuth.instance.getUserMedia(userUid: uid);
  }

  Future<List<ResearchDocs>> getArchive() async {
    return await WaveAI.instance.researcherWave.getdocs(userUid: uid);
  }

}
