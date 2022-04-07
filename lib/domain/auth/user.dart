import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:notes_ddd/domain/core/value_object.dart';

part 'user.freezed.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required UniqueId id,
  }) = _UserModel;
}
