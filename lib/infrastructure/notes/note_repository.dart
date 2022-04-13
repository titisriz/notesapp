import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
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
        if (error is PlatformException &&
            error.message!.contains('PERMISSION_DENIED')) {
          return left(const NoteFailure.insufficientPermission());
        }
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
        if (error is PlatformException &&
            error.message!.contains('PERMISSION_DENIED')) {
          return left(const NoteFailure.insufficientPermission());
        }
        return left(const NoteFailure.unexpected());
      },
    );
  }

  @override
  Future<Either<NoteFailure, Unit>> create(Note note) async {
    try {
      final userDoc = await _firestore.userDocument();
      final noteDto = NoteDto.fromDomain(note);
      // userDoc.noteCollection.add(noteDto.toJson());
      await userDoc.noteCollection.doc(noteDto.id).set(noteDto.toJson());
      return right(unit);
    } on PlatformException catch (e) {
      if (e.message!.contains('PERMISSION_DENIED')) {
        return left(const NoteFailure.insufficientPermission());
      }
      return left(const NoteFailure.unexpected());
    }
  }

  @override
  Future<Either<NoteFailure, Unit>> update(Note note) async {
    try {
      final userDoc = await _firestore.userDocument();
      final noteDto = NoteDto.fromDomain(note);
      // userDoc.noteCollection.add(noteDto.toJson());
      await userDoc.noteCollection.doc(noteDto.id).update(noteDto.toJson());
      return right(unit);
    } on PlatformException catch (e) {
      if (e.message!.contains('PERMISSION_DENIED')) {
        return left(const NoteFailure.insufficientPermission());
      } else if (e.message!.contains('NOT_FOUND')) {
        return left(const NoteFailure.unableToUpdate());
      }
      return left(const NoteFailure.unexpected());
    }
  }

  @override
  Future<Either<NoteFailure, Unit>> delete(Note note) async {
    try {
      final userDoc = await _firestore.userDocument();
      final noteDto = note.id.getOrCrash();
      // userDoc.noteCollection.add(noteDto.toJson());
      await userDoc.noteCollection.doc(noteDto).delete();
      return right(unit);
    } on PlatformException catch (e) {
      if (e.message!.contains('PERMISSION_DENIED')) {
        return left(const NoteFailure.insufficientPermission());
      } else if (e.message!.contains('NOT_FOUND')) {
        return left(const NoteFailure.unableToUpdate());
      }
      return left(const NoteFailure.unexpected());
    }
  }
}
