import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import '../../models.dart';
import '../../table/page/table_screen.dart';
import '../manager/table_cubit.dart';
import '../manager/table_state.dart';

List<DropDownValueModel> dropDownListPeriods = cubitTable.periods
    .map(
        (period) => DropDownValueModel(name: period.duration, value: period.id))
    .toList();

List<DropDownValueModel> dropDownListRooms = cubitTable.rooms
    .map((room) => DropDownValueModel(name: room.name, value: room.id))
    .toList();

class DeleteScreen extends StatefulWidget {
  const DeleteScreen({super.key});

  @override
  State<DeleteScreen> createState() => _DeleteScreenState();
}

class _DeleteScreenState extends State<DeleteScreen> {
  final periodController = SingleValueDropDownController();
  final roomController = SingleValueDropDownController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubitTable,
      child: BlocBuilder<TableCubit, TableState>(
        buildWhen: (previous, current) {
          return current is Reload||
              current is DeletePeriodsSuccessState||
              current is DeleteRoomsSuccessState;
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: ConstantVar.backgroundPage,
              centerTitle: true,
              iconTheme: const IconThemeData(color: ConstantVar.backgroundPage),
              title: GradientText(
                'Delete',
                style: GoogleFonts.eagleLake(fontSize: 20.sp),
                gradientType: GradientType.linear,
                colors: ConstantVar.gradientList,
              ),
            ),
            body: Container(
              margin: EdgeInsets.all(20.sp),
              padding: EdgeInsets.all(10.sp),
              child: Column(
                children: [
                  DropDownTextField(
                    controller: periodController,
                    enableSearch: true,
                    searchDecoration: InputDecoration(
                      labelText: "Search Here",
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: const Color(0xFF3E2723), width: 5.sp)),
                      labelStyle: const TextStyle(
                          color: Colors.brown, fontWeight: FontWeight.bold),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: const Color(0xFF3E2723), width: 5.sp),
                      ),
                    ),
                    textFieldDecoration: InputDecoration(
                      labelText: "Period",
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: const Color(0xFF3E2723), width: 5.sp)),
                      labelStyle: const TextStyle(
                          color: Colors.brown, fontWeight: FontWeight.bold),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: const Color(0xFF3E2723), width: 5.sp),
                      ),
                      prefixIcon: const Icon(Icons.access_time_filled,
                          color: Colors.brown),
                    ),
                    listTextStyle: TextStyle(fontSize: 20.sp),
                    textStyle: TextStyle(fontSize: 20.sp),
                    dropDownItemCount: cubitTable.periods.length,
                    dropDownList: dropDownListPeriods,
                    onChanged: (value) {},
                  ),
                  SizedBox(height: 20.sp),
                  DropDownTextField(
                    controller: roomController,
                    enableSearch: true,
                    searchDecoration: InputDecoration(
                      labelText: "Search Here",
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: const Color(0xFF3E2723), width: 5.sp)),
                      labelStyle: const TextStyle(
                          color: Colors.brown, fontWeight: FontWeight.bold),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: const Color(0xFF3E2723), width: 5.sp),
                      ),
                    ),
                    textFieldDecoration: InputDecoration(
                      labelText: "Room",
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: const Color(0xFF3E2723), width: 5.sp)),
                      labelStyle: const TextStyle(
                          color: Colors.brown, fontWeight: FontWeight.bold),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: const Color(0xFF3E2723), width: 5.sp),
                      ),
                      prefixIcon: const Icon(Icons.room, color: Colors.brown),
                    ),
                    listTextStyle: TextStyle(fontSize: 20.sp),
                    textStyle: TextStyle(fontSize: 20.sp),
                    dropDownItemCount: cubitTable.rooms.length,
                    dropDownList: dropDownListRooms,
                    onChanged: (value) {},
                  ),
                  SizedBox(height: 5.sp),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if(roomController.dropDownValue != null &&
                            roomController.dropDownValue!.name.isNotEmpty&&
                            periodController.dropDownValue != null &&
                            periodController.dropDownValue!.name.isNotEmpty){
                          String selectedValue1 =
                              roomController.dropDownValue!.name,
                              selectedValue2 =
                                  periodController.dropDownValue!.name;
                          await showLoadingIndicatorS(context, (s) async {
                            await cubitTable.deleteRoom(selectedValue1);
                            await cubitTable.deletePeriod(selectedValue2);
                          });
                          ConstantVar.periodController.clear();
                          ConstantVar.roomController.clear();
                        }
                        else if (roomController.dropDownValue != null &&
                            roomController.dropDownValue!.name.isNotEmpty) {
                          String selectedValue =
                              roomController.dropDownValue!.name;
                          await showLoadingIndicatorS(context, (s) async {
                            await cubitTable.deleteRoom(selectedValue);
                          });
                          ConstantVar.roomController.clear();
                        }
                        else if (periodController.dropDownValue != null &&
                            periodController.dropDownValue!.name.isNotEmpty) {
                          String selectedValue =
                              periodController.dropDownValue!.name;
                          await showLoadingIndicatorS(context, (s) async {
                            await cubitTable.deletePeriod(selectedValue);
                          });
                          ConstantVar.periodController.clear();
                        }

                        ConstantVar.periodController.clear();
                        ConstantVar.roomController.clear();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.0.sp, vertical: 5.0.sp),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0.sp)),
                      ),
                      child: Text(
                        "Delete",
                        style: TextStyle(color: Colors.white, fontSize: 20.sp),
                      ),
                    ),
                  ),
                  SizedBox(height: 5.sp),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TableScreen(),
                            ));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.0.sp, vertical: 5.0.sp),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0.sp)),
                      ),
                      child: Text(
                        "Schedule",
                        style: TextStyle(color: Colors.white, fontSize: 20.sp),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
