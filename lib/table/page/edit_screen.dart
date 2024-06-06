import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import '../../table/page/table_screen.dart';
import '../../models.dart';
import '../manager/table_cubit.dart';
import '../manager/table_state.dart';

List<DropDownValueModel> dropDownListPeriods = cubitTable.periods
    .map(
        (period) => DropDownValueModel(name: period.duration, value: period.id))
    .toList();

List<DropDownValueModel> dropDownListRooms = cubitTable.rooms
    .map((room) => DropDownValueModel(name: room.name, value: room.id))
    .toList();

class EditScreen extends StatefulWidget {
  const EditScreen({super.key});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final periodController = SingleValueDropDownController();
  final roomController = SingleValueDropDownController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubitTable,
      child: BlocBuilder<TableCubit, TableState>(
        buildWhen: (previous, current) {
          return current is Reload||
              current is UpdatePeriodsSuccessState||
              current is UpdateRoomsSuccessState;
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: ConstantVar.backgroundPage,
              centerTitle: true,
              iconTheme: const IconThemeData(color: ConstantVar.backgroundPage),
              title: GradientText(
                'Edit',
                style: GoogleFonts.eagleLake(fontSize: 20.sp),
                gradientType: GradientType.linear,
                colors: ConstantVar.gradientList,
              ),
            ),
            body: Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(10),
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
                      onPressed: () {
                        if (periodController.dropDownValue != null &&
                            periodController.dropDownValue!.name.isNotEmpty) {
                          String selectedValue =
                              periodController.dropDownValue!.name;
                          ConstantVar.periodController.clear();
                          dialogPeriodBuilder(context, selectedValue);

                        }
                        if (roomController.dropDownValue != null &&
                            roomController.dropDownValue!.name.isNotEmpty) {
                          String selectedValue =
                              roomController.dropDownValue!.name;
                          ConstantVar.roomController.clear();
                          dialogRoomBuilder(context, selectedValue);

                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.0.sp, vertical: 5.0.sp),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0.sp)),
                      ),
                      child: Text(
                        "Edit",
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

  Future<void> dialogPeriodBuilder(BuildContext context, String selectedValue) {
    ConstantVar.periodController.text = selectedValue;
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: ConstantVar.backgroundPage,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30))),
            title: GradientText(
              'Edit Period',
              style: GoogleFonts.eagleLake(fontSize: 20.sp),
              gradientType: GradientType.linear,
              colors: ConstantVar.gradientList,
              textAlign: TextAlign.center,
            ),
            content: TextFormField(
              controller: ConstantVar.periodController,
              decoration: InputDecoration(
                labelText: "Period",
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: const Color(0xFF3E2723), width: 5.sp)),
                labelStyle: const TextStyle(
                    color: Colors.brown, fontWeight: FontWeight.bold),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                  BorderSide(color: const Color(0xFF3E2723), width: 5.sp),
                ),
              ),
              cursorColor: const Color(0xFF3E2723),
            ),
            actions: [
              Center(
                  child: Column(
                    children: [
                      SizedBox(
                        width: 50.sp,
                        child: ElevatedButton(
                          onPressed: () async {
                            String period = ConstantVar.periodController.text;
                            await showLoadingIndicatorS(context, (s) async {
                              cubitTable.updatePeriod(selectedValue, period);
                            });
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.brown,
                            padding: EdgeInsets.symmetric(
                                horizontal: 5.0.sp, vertical: 5.0.sp),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0.sp)),
                          ),
                          child: Text(
                            "Save",
                            style: TextStyle(color: Colors.white, fontSize: 15.sp),
                          ),
                        ),
                      ),
                      SizedBox(height: 5.sp),
                      SizedBox(
                        width: 50.sp,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.brown,
                            padding: EdgeInsets.symmetric(
                                horizontal: 5.0.sp, vertical: 5.0.sp),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0.sp)),
                          ),
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: Colors.white, fontSize: 15.sp),
                          ),
                        ),
                      ),
                    ],
                  )),
            ],
          );
        });
  }

  Future<void> dialogRoomBuilder(BuildContext context, String selectedValue) {
    ConstantVar.roomController.text = selectedValue;
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: ConstantVar.backgroundPage,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30))),
            title: GradientText(
              'Edit Room',
              style: GoogleFonts.eagleLake(fontSize: 20.sp),
              gradientType: GradientType.linear,
              colors: ConstantVar.gradientList,
              textAlign: TextAlign.center,
            ),
            content: TextFormField(
              controller: ConstantVar.roomController,
              decoration: InputDecoration(
                labelText: "Room",
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: const Color(0xFF3E2723), width: 5.sp)),
                labelStyle: const TextStyle(
                    color: Colors.brown, fontWeight: FontWeight.bold),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                  BorderSide(color: const Color(0xFF3E2723), width: 5.sp),
                ),
              ),
              cursorColor: const Color(0xFF3E2723),
            ),
            actions: [
              Center(
                  child: Column(
                    children: [
                      SizedBox(
                        width: 50.sp,
                        child: ElevatedButton(
                          onPressed: () async {
                            String room = ConstantVar.roomController.text;
                            await showLoadingIndicatorS(context, (s) async {
                              cubitTable.updateRoom(selectedValue, room);
                            });
                            ConstantVar.roomController.clear();
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.brown,
                            padding: EdgeInsets.symmetric(
                                horizontal: 5.0.sp, vertical: 5.0.sp),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0.sp)),
                          ),
                          child: Text(
                            "Save",
                            style: TextStyle(color: Colors.white, fontSize: 15.sp),
                          ),
                        ),
                      ),
                      SizedBox(height: 5.sp),
                      SizedBox(
                        width: 50.sp,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.brown,
                            padding: EdgeInsets.symmetric(
                                horizontal: 5.0.sp, vertical: 5.0.sp),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0.sp)),
                          ),
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: Colors.white, fontSize: 15.sp),
                          ),
                        ),
                      ),
                    ],
                  )),
            ],
          );
        });
  }
}


