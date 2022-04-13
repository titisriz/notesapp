import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import 'package:kt_dart/kt.dart';
import 'package:notes_ddd/domain/notes/i_notes_repository.dart';
import 'package:notes_ddd/domain/notes/note_failure.dart';
import 'package:notes_ddd/domain/notes/note.dart';
import 'package:notes_ddd/infrastructure/core/firestore_helpers.dart';
import 'package:notes_ddd/infrastructure/notes/note_dtos.dart';
import 'package:rxdart/rxdart.dart';

@LazySingleton(as: INotesRepository)
class NoteRepository implements INotesRepository {
  final FirebaseFirestore _firestore;

  NoteRepository(this._firestore);

  @override
  Stream<Either<NoteFailure, KtList<Note>>> watchAll() async* {
    final userDoc = await _firestore.userDocument();
    yield* userDoc.noteCollection
        .orderBy('serverTimestamp', descending: true)
        .snapshots()
        .map((snapshot) => right<NoteFailure, KtList<Note>>(snapshot.docs
            .map((doc) => NoteDto.fromFireStore(doc).toDomain())
            .toImmutableList()))
        .onErrorReturnWith(
      (error) {
        // log.error(error.toString());
        return left(const NoteFailure.unexpected());
      },
    );
  }

  @override
  Stream<Either<NoteFailure, KtList<Note>>> watchUncompleted() async* {
    final userDoc = await _firestore.userDocument();
    yield* userDoc.noteCollection
        .orderBy('serverTimestamp', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => NoteDto.fromFireStore(doc).toDomain()))
        .map(
          (notes) => right<NoteFailure, KtList<Note>>(notes
              .where(
                  (note) => note.todos.getOrCrash().any((todo) => !todo.done))
              .toImmutableList()),
        )
        .onErrorReturnWith(
      (error) {
        // log.error(error.toString());
        return left(const NoteFailure.unexpected());
      },
    );
  }

  @override
  Future<Either<NoteFailure, Unit>> create(Note note) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<Either<NoteFailure, Unit>> delete(Note note) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Either<NoteFailure, Unit>> update(Note note) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
