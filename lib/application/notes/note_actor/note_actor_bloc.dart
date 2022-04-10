import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:notes_ddd/domain/notes/i_notes_repository.dart';
import 'package:notes_ddd/domain/notes/note.dart';
import 'package:notes_ddd/domain/notes/note_failure.dart';

part 'note_actor_event.dart';
part 'note_actor_state.dart';
part 'note_actor_bloc.freezed.dart';

class NoteActorBloc extends Bloc<NoteActorEvent, NoteActorState> {
  final INotesRepository _notesRepository;
  NoteActorBloc(this._notesRepository) : super(const _Initial()) {
    on<NoteActorEvent>((event, emit) async {
      event.map(
        deleted: (e) async {
          emit(const NoteActorState.actionInProgress());
          final possibleFailure = await _notesRepository.delete(event.note);
          emit(possibleFailure.fold(
              (failure) => NoteActorState.deleteFailure(failure),
              (_) => const NoteActorState.deleteSuccess()));
        },
      );
    });
  }
}
