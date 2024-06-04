import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  Future<void> login({required String email, required String password}) async {
    String email = ConstantVar.emailController.text;
    String password = ConstantVar.passwordController1.text;
    try{
      QuerySnapshot query = await ConstantVar.firestore
          .collection("users")
          .where("email", isEqualTo: email)
          .get();

      if (query.docs.isNotEmpty) {
        String gmail = query.docs.first.get("gmail");
        ConstantVar.auth
            .signInWithEmailAndPassword(email: gmail, password: password)
            .then((value) {
          emit(LoginSuccessState());
        });
      }
      else {
        emit(LoginFailureState("Email or password is wrong"));
      }
    }
    catch(error){
      emit(LoginFailureState("Error is : ${error.toString()}"));
    }
  }

  void toggleObscureText() {
    emit(LoginState(isObscure: !state.isObscure));
  }
}