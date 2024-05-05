import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:centralairconditioning/main.dart';
import 'package:centralairconditioning/table/manager/table_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../models.dart';

class TableCubit extends Cubit<TableState> {
  TableCubit() : super(TableInitial());

  final days = [
    "Saturday",
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday"
  ];
  List<Periods> periods = [];
  List<Rooms> rooms = [];
  bool isLoading = true;
  int x = 0;
  int m = 0;
  Future<void> getPeriods() async{
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

  Future<void> deletePeriod(String duration)async{
    try {
      for (int z = 0 ; z < periods.length ; z++){
        if (periods[z].duration==duration){
          x = m ;
        }
        x++;
      }
      for (var innerList in subjects) {
        innerList.removeAt(m);
      }
      for (int i = 0 ; i < 7 ; i++){
        for (int j = 0 ; j < periods.length ; j++){
          updateSchedule(subjects , i , j);
        }
      }
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await ConstantVar.firestore.collection("periods")
          .where('duration', isEqualTo: duration).get();
      if (querySnapshot.docs.isNotEmpty) {
        await deletePeriodUpdate(m);
        final String documentId = querySnapshot.docs.first.id;
        await ConstantVar.firestore.collection("periods")
            .doc(documentId)
            .delete();
        await getPeriods();
        emit(DeletePeriodsSuccessState());
      }else {
        emit(DeletePeriodsFailureState('No period found with this id'));
      }
    }catch (e) {
      emit(DeletePeriodsFailureState(e.toString()));
    }
  }
  Future<void> deletePeriodUpdate(int place)async{
    for (int i = 0 ; i < periods.length ; i++) {
      if(periods[i].index > place) {
        final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await ConstantVar.firestore.collection("periods")
            .where('index', isEqualTo: i).get();
        if (querySnapshot.docs.isNotEmpty) {
          final String documentId = querySnapshot.docs.first.id;
          await ConstantVar.firestore.collection("periods")
              .doc(documentId).update({
            'index': i - 1,
          });
        }
      }
    }
  }

  Future<void> addPeriod()async{
    // await addPeriodUpdate(place);
    // for (var innerList in subjects) {
    //   innerList.insert(place,["empty"]);
    // }
    // for (int i = 0 ; i < 7 ; i++){
    //   await updateSchedule(subjects , i , place);
    // }
    String duration = ConstantVar.periodController.text;
    String id = DateTime.now().microsecondsSinceEpoch.toString();
    final period = Periods(duration, id);
        //, place);
    await ConstantVar.firestore
        .collection("periods")
        .doc(id)
        .set(period.toMap())
        .then((value) {
          //periods.add(period);
      periods.insert(periods.length+1,period);
      isLoading=true;
      emit(AddPeriodsSuccessState());
    }).catchError((error){
      emit(AddPeriodsFailureState("Error when add"));
    });

  }
  // Future<void> addPeriodUpdate(int place)async{
  //   for (int i = 0 ; i < periods.length ; i++) {
  //     if(periods[i].index >= place) {
  //       final QuerySnapshot<Map<String, dynamic>> querySnapshot =
  //       await ConstantVar.firestore.collection("periods")
  //           .where('index', isEqualTo: i).get();
  //       if (querySnapshot.docs.isNotEmpty) {
  //         final String documentId = querySnapshot.docs.first.id;
  //         await ConstantVar.firestore.collection("periods")
  //             .doc(documentId).update({
  //           'index': i + 1,
  //         });
  //       }
  //     }
  //   }
  // }

  void updatePeriod(String period, String updateValue) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await ConstantVar.firestore.collection("periods")
          .where('duration', isEqualTo: period).get();
      if (querySnapshot.docs.isNotEmpty) {
        final String documentId = querySnapshot.docs.first.id;
        await ConstantVar.firestore.collection("periods")
            .doc(documentId).update({
          'duration': updateValue,
        }).then((value) {
          emit(UpdatePeriodsSuccessState());
        });
      }
      else {
        emit(UpdatePeriodsFailureState('No period found with this id'));
      }
    } catch (e) {
      emit(UpdatePeriodsFailureState(e.toString()));
    }
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

  Future<void> deleteRoom(String name)async{
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
    int noOfPeople =0;
    List<int> color = [0,0,0,0];
    final room = Rooms(name, id,noOfPeople,color,"");
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

  void updateRoom(String room, String updateValue) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await ConstantVar.firestore.collection("rooms")
          .where('name', isEqualTo: room).get();
      if (querySnapshot.docs.isNotEmpty) {
        final String documentId = querySnapshot.docs.first.id;
        await ConstantVar.firestore.collection("rooms")
            .doc(documentId).update({
          'name': updateValue,
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

  Future<void> addSchedule(List<List<String>> table) async {
    for (int i = 0; i < table.length; i++) {
      List<String> rooms = table[i];
      String id = i.toString();
      await ConstantVar.firestore
          .collection("schedule")
          .doc(id)
          .set(Schedule(rooms, i, 0).toMap())
          .then((value) {
            emit(Reload());
      })
          .catchError((error) {
        emit(ReloadFailure('There is no table'));
      });
    }

  }

  Future<void> updateSchedule(List<List<List<String>>> table,int i , int j) async {
        List<String> rooms = table[i][j];
        String id = "$i$j";
        await ConstantVar.firestore
            .collection("schedule")
            .doc(id)
            .set({'rooms': rooms, 'index1': i, 'index2': j})
            .then((_) {
          emit(Reload());
        }).catchError((error) {
          emit(ReloadFailure('There is no table'));
        });


  }

}
