import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:centralairconditioning/table/manager/table_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models.dart';
import '../../shared.dart';


class TableCubit extends Cubit<TableState> {
  TableCubit() : super(TableInitial());

  List<Periods> periods = [];
  List<Rooms> rooms = [];

  void getPeriods() {
    final userId= ConstantVar.auth.currentUser!.uid;
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
    {emit(GetPeriodsFailureState(error.toString()));});
  }

  void deletePeriod(String idPeriod)async{
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await ConstantVar.firestore.collection("periods")
          .where('id', isEqualTo: idPeriod).get();
      if (querySnapshot.docs.isNotEmpty) {
        final String documentId = querySnapshot.docs.first.id;
        await ConstantVar.firestore.collection("periods")
            .doc(documentId)
            .delete();
        periods.removeWhere((element) => element.id== idPeriod);
        emit(DeletePeriodsSuccessState());
      }else {
        emit(DeletePeriodsFailureState('No period found with this id'));
      }
    }catch (e) {
      emit(DeletePeriodsFailureState(e.toString()));
    }
  }

  void addPeriod({required Periods item}){
    periods.add(item);
    emit(AddPeriodsSuccessState());
  }

  void updatePeriod(String idPeriod, String updateValue) async {
    String period = updateValue;
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await ConstantVar.firestore.collection("periods")
          .where('id', isEqualTo: idPeriod).get();

      if (querySnapshot.docs.isNotEmpty) {
        final String documentId = querySnapshot.docs.first.id;
        await ConstantVar.firestore.collection("periods")
            .doc(documentId).update({
          'duration': period,
        }).then((value) {
          emit(UpdatePeriodsSuccessState());
        });
      } else {
        emit(UpdatePeriodsFailureState('No period found with this id'));
      }
    } catch (e) {
      emit(UpdatePeriodsFailureState(e.toString()));
    }
  }

  void getRooms() {
    final userId= ConstantVar.auth.currentUser!.uid;
    ConstantVar.firestore.collection("rooms")
        .get()
        .then((value) {
      rooms.clear();
      for(var document in value.docs) {
        final room=Rooms.fromMap(document.data());
        rooms.add(room);
      }
      emit(GetRoomsSuccessState());
    }).catchError((error)
    {emit(GetRoomsFailureState(error.toString()));});
  }

  void deleteRoom(String idRoom)async{
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await ConstantVar.firestore.collection("rooms")
          .where('id', isEqualTo: idRoom).get();
      if (querySnapshot.docs.isNotEmpty) {
        final String documentId = querySnapshot.docs.first.id;
        await ConstantVar.firestore.collection("rooms")
            .doc(documentId)
            .delete();
        rooms.removeWhere((element) => element.id== idRoom);
        emit(DeleteRoomsSuccessState());
      }else {
        emit(DeleteRoomsFailureState('No room found with this id'));
      }
    }catch (e) {
      emit(DeleteRoomsFailureState(e.toString()));
    }
  }

  void addRoom({required Rooms item}){
    rooms.add(item);
    emit(AddRoomsSuccessState());
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

  void updateSelectedRooms(List<Rooms> newRooms) {
    emit(TableUpdated(newRooms: newRooms));
  }


//Shared Preference
//   void getPeriods() async {
//     try {
//       await PreferenceUtils.init();
//       List<Periods> periodsList = await PreferenceUtils.getPeriods(PrefKeys.periods) ;
//       periods.clear();
//       periods.addAll(periodsList);
//       emit(GetPeriodsSuccessState());
//     } catch (error) {
//       emit(GetPeriodsFailureState(error.toString()));
//     }
//   }
//   void deletePeriod(String idPeriod) async {
//     try {
//       List<Periods> periodsList = PreferenceUtils.getPeriods(PrefKeys.periods) as List<Periods>;
//       if (periodsList.isNotEmpty) {
//         List<Periods> updatedPeriodsList = periodsList.map((e) => Periods.fromMap(jsonDecode(e as String))).toList();
//         final int index = updatedPeriodsList.indexWhere((element) => element.id == idPeriod);
//         if (index >= 0) {
//           updatedPeriodsList.removeAt(index);
//           List<String> encodedRoomsList = updatedPeriodsList.map((e) => jsonEncode(e.toMap())).toList();
//           PreferenceUtils.setRooms(PrefKeys.rooms, encodedRoomsList.cast<Rooms>());
//           emit(DeletePeriodsSuccessState());
//         } else {
//           emit(DeletePeriodsFailureState('No periods found with this id'));
//         }
//       } else {
//         emit(DeletePeriodsFailureState('No periods found'));
//       }
//     } catch (e) {
//       emit(DeletePeriodsFailureState(e.toString()));
//     }
//   }
//   void addPeriod({required Periods item}) async {
//     try {
//       periods.add(item);
//       List<Periods> periodsStrings = periods;
//       print("periodsStrings: $periodsStrings");
//       await PreferenceUtils.setPeriods(PrefKeys.periods, periodsStrings);
//       emit(AddPeriodsSuccessState());
//     } catch (e) {
//       emit(AddPeriodsFailureState(e.toString()));
//     }
//   }
//   void updatePeriod(String idPeriod, String updateValue) async {
//     try {
//       List<Periods> periodsList = PreferenceUtils.getPeriods(PrefKeys.periods) as List<Periods>;
//
//       if (periodsList.isNotEmpty) {
//         List<Periods> updatedPeriodsList = periodsList.map((e) => Periods.fromMap(jsonDecode(e as String))).toList();
//         final int index = updatedPeriodsList.indexWhere((element) => element.id == idPeriod);
//
//         if (index >= 0) {
//           updatedPeriodsList[index].duration = updateValue;
//           List<String> encodedUpdatedPeriodsList = updatedPeriodsList.map((e) => jsonEncode(e.toMap())).toList();
//           PreferenceUtils.setPeriods(PrefKeys.periods,encodedUpdatedPeriodsList.cast<Periods>());
//           emit(UpdatePeriodsSuccessState());
//         } else {
//           emit(UpdatePeriodsFailureState('No period found with this id'));
//         }
//       } else {
//         emit(UpdatePeriodsFailureState('No periods found'));
//       }
//     } catch (e) {
//       emit(UpdatePeriodsFailureState(e.toString()));
//     }
//   }
//
//   void getRooms() async {
//     try {
//       List<Rooms> roomsList = await PreferenceUtils.getRooms(PrefKeys.rooms);
//       rooms.clear();
//       rooms.addAll(roomsList);
//       emit(GetRoomsSuccessState());
//     } catch (error) {
//       emit(GetRoomsFailureState(error.toString()));
//     }
//   }
//   void deleteRoom(String idRoom) async {
//     try {
//       List<Rooms> roomsList = await PreferenceUtils.getRooms(PrefKeys.rooms);
//       if (roomsList.isNotEmpty) {
//         List<Rooms> updatedRoomsList = roomsList.map((e) => Rooms.fromMap(jsonDecode(e as String))).toList();
//         final int index = updatedRoomsList.indexWhere((element) => element.id == idRoom);
//         if (index >= 0) {
//           updatedRoomsList.removeAt(index);
//           List<String> encodedRoomsList = updatedRoomsList.map((e) => jsonEncode(e.toMap())).toList();
//           PreferenceUtils.setRooms(PrefKeys.rooms, encodedRoomsList.cast<Rooms>());
//           emit(DeleteRoomsSuccessState());
//         } else {
//           emit(DeleteRoomsFailureState('No room found with this id'));
//         }
//       } else {
//         emit(DeleteRoomsFailureState('No rooms found'));
//       }
//     } catch (e) {
//       emit(DeleteRoomsFailureState(e.toString()));
//     }
//   }
//   void addRoom({required Rooms item}) async {
//     try {
//       rooms.add(item);
//       List<String> roomsStrings = rooms.map((e) => json.encode(e.toJson())).toList();
//       await PreferenceUtils.setRooms(PrefKeys.rooms, roomsStrings.cast<Rooms>());
//       emit(AddRoomsSuccessState());
//     } catch (e) {
//       emit(AddRoomsFailureState(e.toString()));
//     }
//   }
//   void updateRoom(String idRoom, String updateValue) async {
//     try {
//       List<Rooms> roomsList = await PreferenceUtils.getRooms(PrefKeys.rooms);
//
//       if (roomsList.isNotEmpty) {
//         List<Rooms> updatedRoomsList =roomsList.map((e) => Rooms.fromMap(jsonDecode(e as String))).toList();
//         final int index = updatedRoomsList.indexWhere((element) => element.id == idRoom);
//
//         if (index >= 0) {
//           updatedRoomsList[index].name = updateValue;
//           List<String> encodedUpdatedRoomsList = updatedRoomsList.map((e) => jsonEncode(e.toMap())).toList();
//           PreferenceUtils.setRooms(PrefKeys.rooms,encodedUpdatedRoomsList.cast<Rooms>());
//           emit(UpdateRoomsSuccessState());
//         } else {
//           emit(UpdateRoomsFailureState('No room found with this id'));
//         }
//       } else {
//         emit(UpdateRoomsFailureState('No rooms found'));
//       }
//     } catch (e) {
//       emit(UpdatePeriodsFailureState(e.toString()));
//     }
//   }
}
