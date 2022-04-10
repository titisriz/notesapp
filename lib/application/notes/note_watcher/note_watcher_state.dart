part of 'note_watcher_bloc.dart';

@freezed
class NoteWatcherState with _$NoteWatcherState {
  const factory NoteWatcherState.initial() = _Initial;
  const factory NoteWatcherState.loadInProgress() = _LoadInProgress;
  const factory NoteWatcherState.loadInSuccess(KtList<Note> notes) =
      _LoadInSuccess;
  const factory NoteWatcherState.loadInFailure(NoteFailure noteFailure) =
      _LoadInFailure;
}
