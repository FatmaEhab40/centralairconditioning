import 'package:bloc/bloc.dart';
import 'package:firebase_windows/firebase_auth_platform_interface/src/firebase_auth_exception.dart';
import '../../models.dart';
import '../../shared.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  void login({required String email, required String password}) {
    String email = ConstantVar.emailController.text;
    String password = ConstantVar.passwordController1.text;

    ConstantVar.auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      emit(LoginSuccessState());
    }).catchError((error) {
      if (error is FirebaseAuthException) {
        if (error.code == 'user-not-found') {
          emit(LoginFailureState('No user found for that email.'));
        } else if (error.code == 'wrong-password') {
          emit(LoginFailureState('Wrong password provided for that user.'));
        }
      }
      emit(LoginFailureState(error.toString()));
    });
  }

  //Shared Preference
  // void login({required String email, required String password})  {
  //
  //   final checkEmail=  PreferenceUtils.getEmail(PrefKeys.email);
  //   final checkPassword=  PreferenceUtils.getEmail(PrefKeys.password);
  //   if(checkEmail.isNotEmpty && checkPassword.isNotEmpty)
  //   { print("Done");
  //     emit(LoginSuccessState());}
  //
  //   else if(checkEmail.isEmpty && checkPassword.isEmpty)
  //   { print("Email and Password are Wrong.");
  //     emit(LoginFailureState('Email and Password are Wrong.'));}
  //
  //   else if(checkEmail.isEmpty)
  //   { print("Email is Wrong.");
  //     emit(LoginFailureState('Email is Wrong.'));}
  //
  //   else if(checkPassword.isEmpty)
  //   {
  //     print("Password is Wrong.");
  //     emit(LoginFailureState('Password is Wrong.'));}
  // }
  void toggleObscureText() {
    emit(LoginState(isObscure: !state.isObscure));
  }
}
