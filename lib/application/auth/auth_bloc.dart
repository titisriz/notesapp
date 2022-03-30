import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import 'package:notes_ddd/domain/auth/i_auth_facade.dart';

part 'auth_bloc.freezed.dart';
part 'auth_event.dart';
part 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthFacade _authFacade;

  AuthBloc(
    this._authFacade,
  ) : super(const _Initial()) {
    on<AuthEvent>((event, emit) async {
      event.map(authCheckRequested: (event) async {
        final userOption = await _authFacade.getSignedInUser();
        emit(
          userOption.fold(
            () => const AuthState.unauthenticated(),
            (_) => const AuthState.authenticated(),
          ),
        );
      }, signedOut: (event) async {
        await _authFacade.signOut();
        emit(
          const AuthState.unauthenticated(),
        );
      });
    });
  }
}
