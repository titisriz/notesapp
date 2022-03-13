import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:notes_ddd/domain/auth/auth_failure.dart';
import 'package:notes_ddd/domain/auth/i_auth_facade.dart';
import 'package:notes_ddd/domain/auth/value_objects.dart';

part 'sign_in_form_event.dart';
part 'sign_in_form_state.dart';
part 'sign_in_form_bloc.freezed.dart';

class SignInFormBloc extends Bloc<SignInFormEvent, SignInFormState> {
  final IAuthFacade _authFacade;

  SignInFormBloc(this._authFacade) : super(SignInFormState.initial()) {
    on<SignInFormEvent>((event, emit) async {
      event.map(
        emailChanged: (e) async {
          emit(state.copyWith(
              emailAddress: EmailAddress(e.emailStr),
              authFailureOrSuccessOpt: none()));
        },
        passwordChanged: (e) async {
          emit(state.copyWith(
            password: Password(e.passwordStr),
            authFailureOrSuccessOpt: none(),
          ));
        },
        registedWithEmailAndPasswordPressed: (e) async {
          _performActionOnAuthFacadeWithEmailAndPassword(
              _authFacade.registerWithEmailAndPassword, emit);
        },
        signInWithEmailAndPasswordPressed: (e) async {
          _performActionOnAuthFacadeWithEmailAndPassword(
              _authFacade.signInWithEmailAndPassword, emit);
        },
        signInWithGooglePressed: (e) async {
          emit(state.copyWith(
            authFailureOrSuccessOpt: none(),
            isSubmitting: true,
          ));
          final failureOrSuccess = await _authFacade.signInWithGoogle();
          emit(state.copyWith(
              authFailureOrSuccessOpt: some(failureOrSuccess),
              isSubmitting: false));
        },
      );
    });
  }
  Future<void> _performActionOnAuthFacadeWithEmailAndPassword(
    Future<Either<AuthFailure, Unit>> Function({
      required EmailAddress emailAddress,
      required Password password,
    })
        forwardedCall,
    Emitter<SignInFormState> emit,
  ) async {
    Either<AuthFailure, Unit>? failureOrSucces;
    var emailValid = state.emailAddress.isValid();
    var passwordValid = state.password.isValid();
    if (emailValid && passwordValid) {
      emit(state.copyWith(
        authFailureOrSuccessOpt: none(),
        isSubmitting: true,
      ));

      failureOrSucces = await forwardedCall(
          emailAddress: state.emailAddress, password: state.password);
    }
    emit(state.copyWith(
      isSubmitting: false,
      showErrorMessages: true,
      authFailureOrSuccessOpt: optionOf(failureOrSucces),
    ));
  }
}
