import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models.dart';
import '../../shared.dart';
import '../page/profile_screen.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());
  List<User> myData =[];
  String imageUrl="";


  void getUsersFromFirestore() {
    final userId= ConstantVar.auth.currentUser!.uid;
    ConstantVar.firestore.collection("Users")
        .where('userId',isEqualTo:userId)
        .get()
        .then((value) {
      myData.clear();
      for(var document in value.docs) {
        final user=User.fromMap(document.data());
        myData.add(user);
      }
      emit(GetUsersSuccessState());
    }).catchError((error)
    {emit(GetUsersFailureState(error.toString()));});
  }

  //Shared Preference
  // void getUsers() async {
  //   try {
  //     final userDataJson = await PreferenceUtils.getUsers();
  //     final userData = (jsonDecode(userDataJson as String))
  //         .map((e) => User.fromMap(e))
  //         .toList();
  //     myData.clear();
  //     myData.addAll(userData);
  //     emit(GetUsersSuccessState());
  //       } catch (e) {
  //     emit(GetUsersFailureState('Failed to parse user data: $e'));
  //   }
  // }
  //
  //
  // Future<void> updateCurrentUser(int index, User item) async {
  //   try {
  //     List<User> userDataJsonList = await PreferenceUtils.getUsers();
  //
  //     if (userDataJsonList.isNotEmpty) {
  //       myData = (jsonDecode(userDataJsonList.join(',')) as List<dynamic>)
  //           .map((e) => User.fromMap(e))
  //           .toList();
  //
  //       myData[index] = item;
  //
  //       final updatedUserDataJsonList = (myData.map((e) => jsonEncode(e.toMap()))).toList();
  //       await PreferenceUtils.setUsers(updatedUserDataJsonList);
  //
  //       emit(UpdateUsersSuccessState());
  //     } else {
  //       emit(UpdateUsersFailureState('No user data found'));
  //     }
  //   } catch (e) {
  //     emit(UpdateUsersFailureState('Failed to update user data: $e'));
  //   }
  // }


}
