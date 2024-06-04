// ignore_for_file: avoid_print, duplicate_ignore
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models.dart';
import 'forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  ForgetPasswordCubit() : super(ForgetPasswordInitial());

  void isEmailRegistered(String gmail ) async {
    try {

      QuerySnapshot query = await ConstantVar.firestore
          .collection("users")
          .where("gmail", isEqualTo: gmail)
          .get();

      if (query.docs.isNotEmpty) {
        print("true");
        toast("Email is found");
        await ConstantVar.auth
            .sendPasswordResetEmail(
            email: gmail);
        emit(ForgetPasswordSuccessState());
      }
      else {
        emit(ForgetPasswordFailureState("Email is not found"));
      }

    } on FirebaseAuthException catch (e) {
      print (e.toString());
      emit(ForgetPasswordFailureState(e.toString()));
    }
  }


  void toggleObscureText() {
    emit(ForgetPasswordState(isObscure: !state.isObscure));
  }
}
