// ignore_for_file: avoid_print

import 'package:bloc/bloc.dart';
import 'package:firebase_windows/firebase_auth_platform_interface/src/firebase_auth_exception.dart';
import '../../models.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());


  void createAccount(
      {required String email,
        required String password,
        required String phone,
        required String name}
      )async {
    try {
      await ConstantVar.auth.createUserWithEmailAndPassword(
          email: email,
          password: password);
      await saveUserData(email: email,phone: phone,name:name);
      emit(RegisterSuccessState());

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(RegisterFailureState("Error=> The password provided is too weak."));
      }
      else if (e.code == 'email-already-in-use') {
        emit(RegisterFailureState("Error=> The account already exists for that email."));
      }
    } catch (e) {
      emit(RegisterFailureState("Error=> $e"));
    }
  }

  Future<void>  saveUserData({
    required String name,
    required String phone,
    required String email,
  })async {
    final userId=ConstantVar.auth.currentUser!.uid;
    await ConstantVar.firestore.collection("users").doc(userId).set({
      "Name":name,
      "email":email,
      "phone":phone,
      "userId":userId,
      "image":"",

    }).onError((e, _) => print("Error writing document: $e"));
  }

  void toggleObscureText() {
    emit(RegisterState(isObscure: !state.isObscure));
  }
}
