import 'package:bloc/bloc.dart';
import 'package:centralairconditioning/table/manager/table_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models.dart';


class TableCubit extends Cubit<TableState> {
  TableCubit() : super(TableInitial());

  List<Periods> periods = [];
  List<Rooms> rooms = [];

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
    {emit(GetPeriodsFailureState(error.toString()));});
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
      }else {
        emit(DeletePeriodsFailureState('No period found with this id'));
      }
    }catch (e) {
      emit(DeletePeriodsFailureState(e.toString()));
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
    }).catchError((error){
      emit(AddPeriodsFailureState("error"));
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
    }).catchError((error)
    {emit(GetRoomsFailureState(error.toString()));});
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
    final room = Rooms(name, id);
    await ConstantVar.firestore
        .collection("rooms")
        .doc(id)
        .set(room.toMap())
        .then((value) {
      rooms.add(room);
      emit(AddRoomsSuccessState());
    }).catchError((error){
      emit(AddRoomsFailureState("error"));
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

  void updateSelectedRooms(List<Rooms> newRooms) {
    emit(TableUpdated(newRooms: newRooms));
  }

}
