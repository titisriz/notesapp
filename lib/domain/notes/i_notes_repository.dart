import 'package:dartz/dartz.dart';
import 'package:kt_dart/collection.dart';
import 'package:notes_ddd/domain/notes/note.dart';
import 'package:notes_ddd/domain/notes/note_failure.dart';

abstract class INotesRepository {
  //TODO : watch notes
  Stream<Either<NoteFailure, KtList<Note>>> watchAll();

  //TODO : watch uncompleted notes
  Stream<Either<NoteFailure, KtList<Note>>> watchUncompleted();

  // CUD
  Future<Either<NoteFailure, Unit>> create(Note note);
  Future<Either<NoteFailure, Unit>> update(Note note);
  Future<Either<NoteFailure, Unit>> delete(Note note);
}
