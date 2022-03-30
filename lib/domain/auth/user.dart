import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:notes_ddd/domain/auth/value_objects.dart';

part 'user.freezed.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required UniqueId id,
  }) = _UserModel;
}
