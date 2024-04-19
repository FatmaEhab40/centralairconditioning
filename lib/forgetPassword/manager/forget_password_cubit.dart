// ignore_for_file: avoid_print, duplicate_ignore
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_windows/firebase_auth_platform_interface/src/firebase_auth_exception.dart';
import '../../models.dart';
import 'forget_password_state.dart';
class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  ForgetPasswordCubit() : super(ForgetPasswordInitial());

  void isEmailRegistered(String email) async {
    try {
      QuerySnapshot query = await ConstantVar.firestore
          .collection("users")
          .where("email", isEqualTo: email)
          .get();
      if (query.docs.isNotEmpty) {
        print("Email is found");

        emit(ForgetPasswordSuccessState());
      } else {
        // ignore: avoid_print
        print("Email is not found");
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
