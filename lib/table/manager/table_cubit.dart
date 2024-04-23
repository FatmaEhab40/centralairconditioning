import 'dart:async';
import 'package:bloc/bloc.dart';
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
  //List<Schedule> schedules =[];
 // List<List<List<String>>> schedulesTable = [];
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
      //emit(Reload());
    }).catchError((error)
    {
      emit(GetPeriodsFailureState(error.toString()));
      //emit(ReloadFailure(error.toString()));
    });
  }

  void deletePeriod(String duration)async{
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await ConstantVar.firestore.collection("periods")
          .where('duration', isEqualTo: duration).get();
      if (querySnapshot.docs.isNotEmpty) {
        final String documentId = querySnapshot.docs.first.id;
        await ConstantVar.firestore.collection("periods")
            .doc(documentId)
            .delete();
        periods.removeWhere((element) => element.id== duration);
        emit(DeletePeriodsSuccessState());
        //emit(Reload());
      }else {
        emit(DeletePeriodsFailureState('No period found with this id'));
        //emit(ReloadFailure('No period found with this id'));
      }
    }catch (e) {
      emit(DeletePeriodsFailureState(e.toString()));
     // emit(ReloadFailure(e.toString()));
    }
  }

  void addPeriod()async{
    String duration = ConstantVar.periodController.text;
    String id = DateTime.now().microsecondsSinceEpoch.toString();
    final period = Periods(duration, id);
    await ConstantVar.firestore
        .collection("periods")
        .doc(id)
        .set(period.toMap())
        .then((value) {
      periods.add(period);
      emit(AddPeriodsSuccessState());
      //emit(Reload());
    }).catchError((error){
      emit(AddPeriodsFailureState("Error when add"));
     // emit(ReloadFailure("error"));
    });

  }

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
          //emit(Reload());
        });
      }
      else {
        emit(UpdatePeriodsFailureState('No period found with this id'));
        //emit(ReloadFailure('No period found with this id'));
      }
    } catch (e) {
      emit(UpdatePeriodsFailureState(e.toString()));
      //emit(ReloadFailure(e.toString()));
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

  // Future<List<List<List<String>>>> getSchedule(List<List<List<String>>> schedulesTable) async {
  //   schedulesTable = List.generate(
  //     7, (i) => List.generate(periods.length, (j) => [],),);
  //   QuerySnapshot snapshot = await ConstantVar.firestore
  //       .collection("schedule")
  //       .get();
  //     for (var doc in snapshot.docs) {
  //       Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
  //       int index1 = data['index1'];
  //       int index2 = data['index2'];
  //       List<String> rooms = List<String>.from(data['rooms']);
  //       schedulesTable[index1][index2] = rooms;
  //       print("Rooms = ${rooms.length}");
  //       print("Schedules = ${schedulesTable.length}");
  //     }
  //     emit(Reload());
  //     return schedulesTable;
  //
  // }
  Future<List<List<List<String>>>> getSchedule(List<List<List<String>>> schedulesTable) async {
  schedulesTable = List.generate(
      7, (i) => List.generate(periods.length, (j) => [],),);
    try {
      QuerySnapshot snapshot = await ConstantVar.firestore
          .collection("schedule")
          .get();
      for (var doc in snapshot.docs) {
        print("2");
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        print("data= $data");
        int index1 = data['index1'];
        print("index1= $index1");
        int index2 = data['index2'];
        print("index2= $index2");
        List<String> rooms = List<String>.from(data['rooms']);
        print("rooms= ${rooms[1]}");
        for(int i=0;i<rooms.length;i++){
          schedulesTable[index1][index2].add(rooms[i]);
        }

        print("Schedules = ${schedulesTable.length}");
      }
      emit(Reload());
      return schedulesTable;
    } catch (e) {
      print("Error when get schedule: $e");
      emit(ReloadFailure(e.toString()));
      return [];
    }
  }

  Future<void> updateSchedule(List<List<List<String>>> table) async {
    for (int i = 0; i < 7; i++) {
      for (int j = 0; j < periods.length; j++) {
        List<String> rooms = table[i][j];
        String id = "$i$j";
        await ConstantVar.firestore
            .collection("schedule")
            .doc(id)
            .update({'rooms': rooms, 'index1': i, 'index2': j})
            .then((_) {
          emit(Reload());
        }).catchError((error) {
          emit(ReloadFailure('There is no table'));
        });
      }
    }

  }




}
