import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models.dart';
import '../page/profile_screen.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());
  List<User> myData = [];
  String imageUrl = "";


  void getUserData() {
    final userId = ConstantVar.auth.currentUser!.uid;
    ConstantVar.firestore.collection("Users")
        .where('userId', isEqualTo: userId)
        .get()
        .then((value) {
      myData.clear();
      for (var document in value.docs) {
        final user = User.fromMap(document.data());
        myData.add(user);
      }
      emit(GetUsersSuccessState());
    }).catchError((error) {
      emit(GetUsersFailureState(error.toString()));
    });
  }
}


