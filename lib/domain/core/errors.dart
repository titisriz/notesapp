import 'package:notes_ddd/domain/core/failures.dart';

class UnexpectedValueError extends Error {
  final ValueFailure valueFailure;
  UnexpectedValueError(
    this.valueFailure,
  );

  @override
  String toString() {
    const explanation =
        'Encountered a valuefailure at unrecoverable point, terminating.';
    return Error.safeToString('$explanation, $valueFailure');
  }
}
