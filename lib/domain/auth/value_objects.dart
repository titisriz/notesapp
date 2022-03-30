import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:notes_ddd/domain/core/failures.dart';
import 'package:notes_ddd/domain/core/value_object.dart';
import 'package:notes_ddd/domain/core/value_validators.dart';
import 'package:uuid/uuid.dart';

class EmailAddress extends ValueObject<String> {
  final Either<ValueFailure<String>, String> tess;

  factory EmailAddress(String input) {
    return EmailAddress._(validateEmailAddress(input));
  }

  const EmailAddress._(this.tess);

  @override
  Either<ValueFailure<String>, String> get value => tess;
}

class Password extends ValueObject<String> {
  final Either<ValueFailure<String>, String> tess;

  factory Password(String input) {
    return Password._(validatePassword(input));
  }

  const Password._(this.tess);

  @override
  Either<ValueFailure<String>, String> get value => tess;
}

class UniqueId extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory UniqueId(String uniqueId) {
    return UniqueId._(right(Uuid().v1()));
  }

  factory UniqueId.fromUniqueString(String uniqueId) {
    assert(uniqueId != null);
    return UniqueId._(right(uniqueId));
  }

  const UniqueId._(this.value);
}
