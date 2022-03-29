import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notes_ddd/application/auth/sign_in_form/bloc/sign_in_form_bloc.dart';
import 'package:notes_ddd/injection.dart';
import 'package:notes_ddd/presentation/sign_in/widgets/sign_in_form.dart';

import '../../domain/auth/i_auth_facade.dart';
import '../../infrastructure/auth/firebase_auth_facade.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseAuthFacade tes =
        FirebaseAuthFacade(FirebaseAuth.instance, GoogleSignIn());
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: BlocProvider<SignInFormBloc>(
        create: (context) => getIt<SignInFormBloc>(),
        child: SignInForm(tes),
      ),
    );
  }
}
