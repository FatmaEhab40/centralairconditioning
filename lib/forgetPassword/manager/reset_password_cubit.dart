import 'package:bloc/bloc.dart';
import 'package:centralairconditioning/forgetPassword/manager/reset_password_state.dart';
import 'package:firebase_windows/firebase_auth_platform_interface/src/firebase_auth_exception.dart';
import '../../models.dart';


class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit() : super(ResetPasswordInitial());
  void resetPassword() async {
    try {
      await ConstantVar.auth
          .sendPasswordResetEmail(
          email: ConstantVar.emailController.text.trim());
      emit(ResetPasswordSuccessState());
      toast("Success");
    }

    on FirebaseAuthException catch (e) {
      emit(ResetPasswordFailureState(e.toString()));
      toast("Failure");
    }
  }

  void toggleObscureText() {
    emit(ResetPasswordState(isObscure1: !state.isObscure1,isObscure2: !state.isObscure2));
  }
}
