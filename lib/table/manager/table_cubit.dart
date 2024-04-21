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
  List<Schedule> schedules =[];
  List<List<List<String>>> schedulesTable = [];
  void getPeriods() {
    ConstantVar.firestore.collection("periods")
        .get()
        .then((value) {
      periods.clear();
      for(var document in value.docs) {
        final period=Periods.fromMap(document.data());
        periods.add(period);
      }
      emit(Reload());
    }).catchError((error)
    {emit(ReloadFailure(error.toString()));});
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
        emit(Reload());
      }else {
        emit(ReloadFailure('No period found with this id'));
      }
    }catch (e) {
      emit(ReloadFailure(e.toString()));
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
      emit(Reload());
    }).catchError((error){
      emit(ReloadFailure("error"));
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
          emit(Reload());
        });
      }
      else {
        emit(ReloadFailure('No period found with this id'));
      }
    } catch (e) {
      emit(ReloadFailure(e.toString()));
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
      emit(Reload());
    }).catchError((error)
    {emit(ReloadFailure(error.toString()));});
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
        emit(Reload());
      }else {
        emit(ReloadFailure('No room found with this id'));
      }
    }catch (e) {
      emit(ReloadFailure(e.toString()));
    }
  }

  void addRoom()async{
    String name = ConstantVar.roomController.text;
    String id = DateTime.now().microsecondsSinceEpoch.toString();
    int noOfpeople =0;
    final room = Rooms(name, id,noOfpeople);
        //noOfpeople );
    await ConstantVar.firestore
        .collection("rooms")
        .doc(id)
        .set(room.toMap())
        .then((value) {
      rooms.add(room);
      emit(Reload());
    }).catchError((error){
      emit(ReloadFailure("error"));
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
          emit(Reload());
        });
      } else {
        emit(ReloadFailure('No room found with this id'));
      }
    } catch (e) {
      emit(ReloadFailure(e.toString()));
    }
  }


  void getSchedule() {
    int x = 0;
    ConstantVar.firestore.collection("schedule")
        .get()
        .then((value) {
      schedules.clear();
      schedulesTable.clear();
      for(int i = 0 ; i < days.length ; i++){
        for(int j = 0 ; j < periods.length ; j++){
          if(value.docs.isNotEmpty &&
              value.docs.length == days.length*periods.length &&
              value.docs.isNotEmpty &&
              value.docs.length != (days.length*periods.length)){
            schedulesTable[i][j]=schedules[x].rooms  ;
            x++;
          }
          else if (value.docs.isNotEmpty && value.docs.length != (days.length*periods.length)){
            if (schedules[x].index1 == i && schedules[x].index2 == j){
              schedulesTable[i][j]=schedules[x].rooms;
              x++;
            }
            else{
              schedulesTable[i][j][0]= "empty";
              x++;

            }
          }
          else
            if(value.docs.isEmpty){
            schedulesTable[i][j][0]= "empty";
          }
        }
      }
      // for(int e=0;e<schedulesTable.length;e++){
      //   for(int a=0;a<schedulesTable.length;a++){
      //     List<List<List<String>>> sc=[];
      //     print("sc= ${sc[e][a]}");
      //   }
      //}
      emit(Reload());
      // if (value.docs.isNotEmpty) {
      //   for (var document in value.docs) {
      //     final schedules = Schedule.fromMap(document.data());
      //     schedules.add(schedule);
      //   }
      //   for(int i = 0 ; i < 7 ; i++){
      //     for(int j = 0 ; j < periods.length ; j++){
      //       schedulesTable[i][j]=schedules[x].rooms  ;
      //       x++;
      //     }
      //   }
      //   emit(GetScheduleSuccessState());
      // }
      // else if (value.docs.isEmpty){
      //   for(int i = 0 ; i < 7 ; i++){
      //     for(int j = 0 ; j < periods.length ; j++){
      //       schedulesTable[i][j][0]= "empty";
      //       x++;
      //     }
      //   }
      //   emit(GetScheduleSuccessState());
      // }
      // else if (value.docs.length != (7*periods.length)){
      //   for(int i = 0 ; i < 7 ; i++){
      //     for(int j = 0 ; j < periods.length ; j++){
      //       if (schedules[x].index1 == i && schedules[x].index2 == j){
      //         schedules[i][j]=schedules[x].rooms;
      //       }
      //       else{
      //         schedulesTable[i][j][0]= "empty";
      //       }
      //       x++;
      //     }
      //   }
      //   emit(GetScheduleSuccessState());
      // }
    }).catchError((error) {
      if (kDebugMode) {
        print("Error: ${error.toString()}");
      }
      emit(ReloadFailure(error.toString()));});
  }
  Future<void> updateSchedule({required List<List<List<String>>> table}) async {
    List<String> rooms = [];
    String id = "";
    int index1 = 0;
    int index2 = 0;
    var period = Schedule(rooms, index1, index2);
    for(int i = 0 ; i < 7 ; i++){
      for(int j = 0 ; j < periods.length ; j++){
        rooms=table[i][j];
        id = "$i""$j";
        index1 = i;
        index2 = j;
        await ConstantVar.firestore
            .collection("schedule")
            .doc(id)
            .set(period.toMap())
            .then((value) {});
      }
    }
    emit(Reload());
  }




// void updateSchedule(String idPeriod, String updateValue) async {
//   String period = updateValue;
//   try {
//     final QuerySnapshot<Map<String, dynamic>> querySnapshot =
//     await ConstantVar.firestore.collection("periods")
//         .where('id', isEqualTo: idPeriod).get();
//
//     if (querySnapshot.docs.isNotEmpty) {
//       final String documentId = querySnapshot.docs.first.id;
//       await ConstantVar.firestore.collection("periods")
//           .doc(documentId).update({
//         'duration': period,
//       }).then((value) {
//         emit(UpdatePeriodsSuccessState());
//       });
//     } else {
//       emit(UpdatePeriodsFailureState('No period found with this id'));
//     }
//   } catch (e) {
//     emit(UpdatePeriodsFailureState(e.toString()));
//   }
// }


}
