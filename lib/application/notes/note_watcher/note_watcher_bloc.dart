import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';
import 'package:notes_ddd/domain/notes/i_notes_repository.dart';
import 'package:notes_ddd/domain/notes/note.dart';
import 'package:notes_ddd/domain/notes/note_failure.dart';

part 'note_watcher_event.dart';
part 'note_watcher_state.dart';
part 'note_watcher_bloc.freezed.dart';

@injectable
class NoteWatcherBloc extends Bloc<NoteWatcherEvent, NoteWatcherState> {
  final INotesRepository _notesRepository;
  StreamSubscription<Either<NoteFailure, KtList<Note>>>?
      _noteStreamSubscription;

  NoteWatcherBloc(this._notesRepository) : super(const _Initial()) {
    on<NoteWatcherEvent>((event, emit) async {
      // TODO: implement event handler
      event.map(watchAllStarted: (value) async {
        emit(const NoteWatcherState.loadInProgress());
        _noteStreamSubscription?.cancel();
        _noteStreamSubscription = _notesRepository.watchAll().listen(
            (failureOrNotes) =>
                add(NoteWatcherEvent.notesReceived(failureOrNotes)));
      }, watchUncompletedStarted: (value) async {
        emit(const NoteWatcherState.loadInProgress());
        _noteStreamSubscription?.cancel();
        _noteStreamSubscription = _notesRepository.watchUncompleted().listen(
            (failureOrNotes) =>
                add(NoteWatcherEvent.notesReceived(failureOrNotes)));
      }, notesReceived: (e) {
        e.failureOrNotes.fold(
          (failure) => NoteWatcherState.loadInFailure(failure),
          (notes) => NoteWatcherState.loadInSuccess(notes),
        );
      });
    });
  }
  @override
  Future<void> close() async {
    // TODO: implement close
    await _noteStreamSubscription?.cancel();
    return super.close();
  }
}
