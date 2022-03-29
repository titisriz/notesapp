import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes_ddd/domain/auth/user.dart';
import 'package:notes_ddd/domain/auth/value_objects.dart';

extension FirebaseUserDomainX on User {
  UserModel toDomain() {
    return UserModel(id: UniqueId.fromUniqueString(uid));
  }
}
