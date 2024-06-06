import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());
  List<User> myData = [];

 Future<void> getUserData()async   {
    final userId=ConstantVar.auth.currentUser!.uid;
     await ConstantVar.firestore.collection("users").doc(userId)
        .get()
        .then((value) {
      updateUi(value.data()!);
      emit(GetUsersSuccessState());
    })
        .catchError((error){emit(GetUsersFailureState(error.toString()));});
  }

  void updateUserData()   {
    final userId = ConstantVar.auth.currentUser!.uid;
    ConstantVar.firestore.collection("users").doc(userId).update({
      "Name": ConstantVar.nameController.text,
      "phone": ConstantVar.phoneController.text,
      "gmail":ConstantVar.gmailController.text
    }).then((value) {
      toast("Done");
      emit(UpdateUsersSuccessState());})
        .catchError((error){
      emit(UpdateUsersFailureState(error.toString()));
    });

  }
  void updateUi(Map<String, dynamic>map) {
    ConstantVar.nameController.text = map["Name"];
    ConstantVar.phoneController.text = map["phone"];
    ConstantVar.emailController.text = map["email"];
    ConstantVar.gmailController.text = map["gmail"];
  }
}


