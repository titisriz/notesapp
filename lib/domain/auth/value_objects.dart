import 'package:dartz/dartz.dart';
import 'package:notes_ddd/domain/core/failures.dart';
import 'package:notes_ddd/domain/core/value_object.dart';
import 'package:notes_ddd/domain/core/value_validators.dart';

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
