import 'package:bloc/bloc.dart';
import '../../models.dart';
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
      emit(LoginFailureState("Email or Password is wrong!"));
    });
  }

  void toggleObscureText() {
    emit(LoginState(isObscure: !state.isObscure));
  }
}
