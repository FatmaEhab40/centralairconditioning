import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../models.dart';
import 'home_state.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  List<Rooms> rooms = [];
  void getRooms() {
    ConstantVar.firestore.collection("rooms")
        .get()
        .then((value) {
      rooms.clear();
      for(var document in value.docs) {
        final room=Rooms.fromMap(document.data());
        rooms.add(room);
      }
      //emit(Reload());
      emit(GetRoomsSuccessState());
    })
        .catchError((error)
    {if (kDebugMode) {
      print("Error Failure: ${error.toString()}");
    }
    emit(GetRoomsFailureState(error.toString()));
     // emit(ReloadFailure(error.toString()));
    });
  }

  void deleteRoom(String name)async{
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await ConstantVar.firestore.collection("rooms")
          .where('name', isEqualTo: name).get();
      if (querySnapshot.docs.isNotEmpty) {
        final String documentId = querySnapshot.docs.first.id;
        await ConstantVar.firestore.collection("rooms")
            .doc(documentId)
            .delete();
        rooms.removeWhere((element) => element.id== name);
        //emit(Reload());
        emit(DeleteRoomsSuccessState());
      }else {
        //emit(ReloadFailure('No room found with this id'));
        emit(DeleteRoomsFailureState('No room found with this id'));
      }
    }catch (e) {
      emit(DeleteRoomsFailureState(e.toString()));
      //emit(ReloadFailure(e.toString()));
    }
  }

  void addRoom()async{
    String name = ConstantVar.roomController.text;
    String id = DateTime.now().microsecondsSinceEpoch.toString();
    int noOfpeople =0;
    final room = Rooms(name, id,noOfpeople);
    await ConstantVar.firestore
        .collection("rooms")
        .doc(id)
        .set(room.toMap())
        .then((value) {
      rooms.add(room);
      emit(AddRoomsSuccessState());
      //emit(Reload());
    }).catchError((error){
      emit(AddRoomsFailureState("Error when add"));
      //emit(ReloadFailure("error"));
    });

  }

  void updateRoom(String idPeriod, String updateValue) async {
    String room = updateValue;
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await ConstantVar.firestore.collection("rooms")
          .where('id', isEqualTo: idPeriod).get();

      if (querySnapshot.docs.isNotEmpty) {
        final String documentId = querySnapshot.docs.first.id;
        await ConstantVar.firestore.collection("rooms")
            .doc(documentId).update({
          'name': room,
        }).then((value) {
          emit(UpdateRoomsSuccessState());
          //emit(Reload());
        });
      } else {
        emit(UpdateRoomsFailureState('No room found with this id'));
       // emit(ReloadFailure('No room found with this id'));
      }
    } catch (e) {
      emit(UpdateRoomsFailureState(e.toString()));
     // emit(ReloadFailure(e.toString()));
    }
  }

  Future<void> fetchData() async {

    final response = await http.get(Uri.parse('http://10.0.2.2:5000/api'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      rooms[0].noOfpeople = data['output'];

      emit(Reload());
    } else {
      emit(ReloadFailure('Failed to load data'));
      throw Exception('Failed to load data');

    }
  }

}
