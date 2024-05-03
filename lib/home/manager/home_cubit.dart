import 'package:bloc/bloc.dart';
import 'package:centralairconditioning/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../models.dart';
import 'home_state.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
List<Rooms> rooms = [];
List<Periods> periods = [];

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  void getPeriods() {
    ConstantVar.firestore.collection("periods")
        .get()
        .then((value) {
      periods.clear();
      for(var document in value.docs) {
        final period=Periods.fromMap(document.data());
        periods.add(period);
      }
      emit(GetPeriodsSuccessState());
    }).catchError((error)
    {
      emit(GetPeriodsFailureState(error.toString()));
    });
  }

  void getRooms() {
    ConstantVar.firestore.collection("rooms")
        .get()
        .then((value) {
      rooms.clear();
      for(var document in value.docs) {
        final room=Rooms.fromMap(document.data());
        rooms.add(room);
      }
      emit(GetRoomsSuccessState());
    })
        .catchError((error)
    {if (kDebugMode) {
      print("Error Failure: ${error.toString()}");
    }
    emit(GetRoomsFailureState(error.toString()));
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

        emit(DeleteRoomsSuccessState());
      }else {
        emit(DeleteRoomsFailureState('No room found with this id'));
      }
    }catch (e) {
      emit(DeleteRoomsFailureState(e.toString()));
    }
  }

  void addRoom()async{
    String name = ConstantVar.roomController.text;
    String id = DateTime.now().microsecondsSinceEpoch.toString();
    int noOfpeople =0;
    List<int> color = [0,0,0,0];
    final room = Rooms(name, id,noOfpeople,color);
    await ConstantVar.firestore
        .collection("rooms")
        .doc(id)
        .set(room.toMap())
        .then((value) {
      rooms.add(room);
      emit(AddRoomsSuccessState());
    }).catchError((error){
      emit(AddRoomsFailureState("Error when add"));
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
        });
      } else {
        emit(UpdateRoomsFailureState('No room found with this id'));
      }
    } catch (e) {
      emit(UpdateRoomsFailureState(e.toString()));
    }
  }


  Future<void> fetchData(int index) async {
    bool c = await there(index);
    final response = await http.get(Uri.parse('http://10.0.2.2:5000/api'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      rooms[0].noOfpeople = data['output'];
      if(rooms[0].noOfpeople!=0&&c){
        rooms[index].color = [90,194,37,1];
        if(rooms[0].noOfpeople==1){
          rooms[index].temp = 26;
        }
        else if(rooms[0].noOfpeople==2){
          rooms[index].temp = 25;
        }
        else if(rooms[0].noOfpeople==3){
          rooms[index].temp = 24;
        }
        else if(rooms[0].noOfpeople==4){
          rooms[index].temp = 23;
        }
        else if(rooms[0].noOfpeople==5){
          rooms[index].temp = 22;
        }
      }
      else if (rooms[0].noOfpeople!=0&&!c){
        rooms[index].color = [90,194,37,1];
        if(rooms[0].noOfpeople==1){
          rooms[index].temp = 26;
        }
        else if(rooms[0].noOfpeople==2){
          rooms[index].temp = 25;
        }
        else if(rooms[0].noOfpeople==3){
          rooms[index].temp = 24;
        }
        else if(rooms[0].noOfpeople==4){
          rooms[index].temp = 23;
        }
        else if(rooms[0].noOfpeople==5){
          rooms[index].temp = 22;
        }
      }
      else if (rooms[0].noOfpeople==0&&c){
        rooms[index].color = [255,216,0,1];
        rooms[index].temp = 0;
      }
      else if (rooms[0].noOfpeople==0&&!c){//16:00-8:00
        rooms[index].color = [171,0,0,1];
        rooms[index].temp = 0;
      }

      emit(Reload());
      Future.delayed(const Duration(seconds: 5), () {
        fetchData(index);
      });
    }
    else {
      emit(ReloadFailure('Failed to load data'));
      throw Exception('Failed to load data');
    }
  }

  Future<bool> there(int index) async {
    bool inSchedule = false;
    if (currentPeriod() != 'null') {
      for (int i = 0;
      i < subjects[getCurrentDayOfWeek()][int.parse(currentPeriod())].length;
      i++) {
        if (subjects[getCurrentDayOfWeek()][int.parse(currentPeriod())][i]
            == rooms[index].name) {
          inSchedule = true;
          return true;
        }
      }
    }
    rooms[index].inSchedule = inSchedule.toString();
    return false;
  }
  //         return true;
  //       }
  //     }
  //     return false;
  //   }
  //
  //   else {
  //     return false;
  //   }
  //
  // }

  int getCurrentDayOfWeek() {
    List<int> daysOfWeek = [2, 3, 4, 5, 6, 0, 1];
    DateTime currentTime = DateTime.now();
    int dayOfWeek = daysOfWeek[currentTime.weekday - 1];
    return dayOfWeek;
  }

  String currentPeriod(){
    DateTime currentTime = DateTime.now();
    int startHour = 0;
    int startMinute = 0;
    int endHour = 0;
    int endMinute = 0;
    List<String> parts = [] , pop1 = [] , pop2=[];

    for(int i = 0 ; i < periods.length ; i++){

      parts = periods[i].duration.split('-');
      pop1 = parts[0].split(':');
      pop2 = parts[1].split(':');
      startHour = int.parse(pop1[0]);
      startMinute = int.parse(pop1[1]);
      endHour = int.parse(pop2[0]);
      endMinute = int.parse(pop2[1]);

      if (((currentTime.hour == startHour &&
        currentTime.minute >= startMinute )||
        currentTime.hour > startHour)&&
        ((currentTime.hour == endHour &&
        currentTime.minute <= endMinute)||
            currentTime.hour < endHour)){

      return '$i';
    }
    parts.clear();
    pop1.clear();
    pop2.clear();

    }
    return 'null';

  }


  // void storeFetchedDataInFirebase(int index, rooms) {
  //   String name = ConstantVar.roomController.text;
  //   String id = "1709135121528823";
  //   int noOfpeople =0;
  //   List<int> color = [0,0,0,0];
  //   final room = Rooms(name, id,noOfpeople,color);
  //   await ConstantVar.firestore
  //       .collection("rooms")
  //       .doc(id)
  //       .set(room.toMap())
  //
  //
  //   // Prepare the data to be stored
  //   Map<String, dynamic> roomData = {
  //     'noOfpeople': rooms[0].noOfpeople,
  //     'color': rooms[index].color,
  //     'temp': rooms[index].temp,
  //   };
  //
  //   // Add the data to the first document
  //   firstRoomDocument.set(roomData).then((value) {
  //     print('Fetched data stored in the first document in the "rooms" collection');
  //   }).catchError((error) {
  //     print('Error storing fetched data: $error');
  //   });
  // }
}
