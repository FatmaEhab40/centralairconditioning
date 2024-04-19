// ignore_for_file: unrelated_type_equality_checks
import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multiselect/multiselect.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import '../../models.dart';
import '../manager/table_cubit.dart';
import '../manager/table_state.dart';
import 'add_screen.dart';
import 'delete_screen.dart';
import 'edit_screen.dart';

final cubit = TableCubit();

class TableScreen extends StatefulWidget {
  const TableScreen({super.key});

  @override
  State<TableScreen> createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {
  String dropDownValue = 'example value';
  String checker(int i, int j) {
    if (subjects[i][j][0] == const GrpcError.outOfRange()) {
      return "empty";
    } else {
      return subjects[i][j][0];
    }
  }

  final containerHeight = 40.sp;
  final containerWidth = 50.sp;
  final days = [
    "Saturday",
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday"
  ];
  List<List<List<String>>> subjects = [
    [
      ["6006", "6106"],
      ["empty"],
      ["empty"],
      ["empty"],
      ["empty"],
      ["empty"],
      ["empty"],
      ["empty"],
      ["empty"],
    ],
    [
      ["empty"],
      ["empty"],
      ["empty"],
      ["empty"],
      ["empty"],
      ["empty"],
      ["empty"],
      ["empty"],
      ["empty"],
    ],
    [
      ["empty"],
      ["empty"],
      ["empty"],
      ["empty"],
      ["empty"],
      ["empty"],
      ["empty"],
      ["empty"],
      ["empty"],
    ],
    [
      ["empty"],
      ["empty"],
      ["empty"],
      ["empty"],
      ["empty"],
      ["empty"],
      ["empty"],
      ["empty"],
      ["empty"],
    ],
    [
      ["empty"],
      ["empty"],
      ["empty"],
      ["empty"],
      ["empty"],
      ["empty"],
      ["empty"],
      ["empty"],
      ["empty"],
    ],
    [
      ["empty"],
      ["empty"],
      ["empty"],
      ["empty"],
      ["empty"],
      ["empty"],
      ["empty"],
      ["empty"],
      ["empty"],
    ],
    [
      ["empty"],
      ["empty"],
      ["empty"],
      ["empty"],
      ["empty"],
      ["empty"],
      ["empty"],
      ["empty"],
      ["empty"],
    ],
  ];
  final periodController = TextEditingController();
  final roomController = TextEditingController();
  List<String> selectedRooms = [];
  
  @override
  void initState() {
    super.initState();
    cubit.getPeriods();
    cubit.getRooms();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: BlocBuilder<TableCubit, TableState>(
        buildWhen: (previous, current) {
          return current is GetRoomsSuccessState ||
              current is DeleteRoomsSuccessState ||
              current is AddRoomsSuccessState ||
              current is UpdateRoomsSuccessState ||
              current is GetPeriodsSuccessState ||
              current is DeletePeriodsSuccessState ||
              current is AddPeriodsSuccessState ||
              current is UpdatePeriodsSuccessState;
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: ConstantVar.backgroundPage,
              centerTitle: true,
              iconTheme: const IconThemeData(
                color: Colors.brown,
              ),
              title: GradientText(
                'Schedule',
                style: GoogleFonts.eagleLake(fontSize: 20.sp),
                gradientType: GradientType.linear,
                colors: ConstantVar.gradientList,
              ),
              actions: [
                PopupMenuButton(
                    icon: const Icon(Icons.menu, color: Colors.brown),
                    color: ConstantVar.backgroundPage,
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem<int>(
                          value: 0,
                          child: GradientText(
                            'Add',
                            colors: ConstantVar.gradientList,
                            style: TextStyle(fontSize: 20.sp),
                          ),
                        ),
                        PopupMenuItem<int>(
                          value: 1,
                          child: GradientText(
                            'Edit',
                            colors: ConstantVar.gradientList,
                            style: TextStyle(fontSize: 20.sp),
                          ),
                        ),
                        PopupMenuItem<int>(
                          value: 2,
                          child: GradientText(
                            'Delete',
                            colors: ConstantVar.gradientList,
                            style: TextStyle(fontSize: 20.sp),
                          ),
                        ),
                      ];
                    },
                    onSelected: (value) {
                      if (value == 0) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider.value(
                                  value: cubit, child: const AddScreen()),
                            )).then((value) => (value) {
                              cubit.getPeriods();
                              cubit.getRooms();
                            });
                      } else if (value == 1) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EditScreen(),
                            )).then((value) => (value) {
                              cubit.getPeriods();
                              cubit.getRooms();
                            });
                      } else if (value == 2) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DeleteScreen(),
                            )).then((value) => (value) {
                              cubit.getPeriods();
                              cubit.getRooms();
                            });
                      }
                    }),
              ],
            ),
            body: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                  height: (containerHeight*(days.length+1))+(10.sp*(days.length+2)),
                  width: (containerWidth*(cubit.periods.length+1))+(12.sp*(cubit.periods.length+2)),
                  padding: EdgeInsets.all(10.sp),
                  child: PageView(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                // Top header View
                                SizedBox(
                                  height: containerHeight,
                                  width: containerWidth,
                                  child: CustomPaint(
                                    painter: RectanglePainter(),
                                    child: Stack(
                                      children: [
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: Padding(
                                            padding: EdgeInsets.all(4.0.sp),
                                            child: Text("Period",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20.sp)),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Padding(
                                            padding: EdgeInsets.all(4.0.sp),
                                            child: Text("Day",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20.sp)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                //periods
                                Expanded(
                                  child: Container(
                                    height: containerHeight,
                                    margin: EdgeInsets.all(5.sp),
                                    // child: SingleChildScrollView(
                                    //   scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: List<Widget>.generate(
                                        cubit.periods.length,
                                        (index) => Container(
                                          height: containerHeight,
                                          width: containerWidth,
                                          margin: EdgeInsets.all(5.sp),
                                          decoration: const BoxDecoration(
                                            color:
                                                ConstantVar.backgroundContainer,
                                            shape: BoxShape.rectangle,
                                          ),
                                          child: Center(
                                            child: Text(
                                              //"period ''${index}",
                                              cubit.periods[index].duration,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 19.sp),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              // Added fixed size to scroll listView horizontal
                              height: 500.sp,
                              child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: days.length,
                                itemBuilder: (context, index1) => SizedBox(
                                  height: containerHeight,
                                  width: containerWidth,
                                  child: Row(
                                    children: [
                                      //day
                                      Container(
                                        height: containerHeight,
                                        width: containerWidth,
                                        margin: EdgeInsets.all(5.sp),
                                        decoration: const BoxDecoration(
                                          color:
                                              ConstantVar.backgroundContainer,
                                          shape: BoxShape.rectangle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            days[index1],
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20.sp),
                                          ),
                                        ),
                                      ),
                                      //rooms
                                      Expanded(
                                        child: SizedBox(
                                          height: containerHeight,
                                          child: Row(
                                            children: List<Widget>.generate(
                                              cubit.periods.length,
                                              (index2) => Container(
                                                color: Colors.white,
                                                child: Container(
                                                  height: containerHeight,
                                                  width: containerWidth,
                                                  color: ConstantVar
                                                      .backgroundPage,
                                                  margin: EdgeInsets.all(5.sp),
                                                  child: Center(
                                                      child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 4.sp),
                                                    child:DropdownButton<String>(
                                                      value: dropDownValue=subjects[index1][index2][0],
                                                      onChanged: (String? newValue){
                                                        setState(() {
                                                          dropDownValue = newValue!;
                                                        });
                                                      },
                                                      items: List.generate(subjects[index1][index2].length, (int index) {
                                                        return DropdownMenuItem(
                                                          value: subjects[index1][index2][index],
                                                          child: Text(subjects[index1][index2][index]),
                                                        );
                                                      })..add(DropdownMenuItem(
                                                        value: "add",
                                                        child: ElevatedButton(
                                                          onPressed: () {
                                                            showDialog(
                                                              context: context,
                                                              builder: (BuildContext context) {
                                                                return AlertDialog(
                                                                  title: const Text("Hall list"),
                                                                  content: DropDownMultiSelect<String>(
                                                                    selectedValues: selectedRooms,
                                                                    selected_values_style:
                                                                    const TextStyle(
                                                                        color: Colors.brown),
                                                                    onChanged: (List<String> newValue2){
                                                                      selectedRooms = newValue2;
                                                                    },
                                                                    options: existenceChecker(index1, index2),
                                                                    decoration: InputDecoration(
                                                                      iconColor: Colors.brown,
                                                                      label: const Text(
                                                                        'Select Rooms',
                                                                        textAlign: TextAlign.start,
                                                                        style: TextStyle(
                                                                            color: Colors.brown),
                                                                      ),
                                                                      focusedBorder:
                                                                      OutlineInputBorder(
                                                                          borderSide: BorderSide(
                                                                              color: const Color(
                                                                                  0xFF3E2723),
                                                                              width: 5.sp)),
                                                                      labelStyle: TextStyle(
                                                                          fontSize: 15.sp,
                                                                          color: Colors.brown,
                                                                          fontWeight:
                                                                          FontWeight.bold),
                                                                      enabledBorder:
                                                                      OutlineInputBorder(
                                                                        borderSide: BorderSide(
                                                                            color: const Color(
                                                                                0xFF3E2723),
                                                                            width: 5.sp),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  actions: <Widget>[
                                                                    ElevatedButton(
                                                                        onPressed: (){
                                                                          for(int i = 0 ; i < selectedRooms.length; i++){
                                                                            if (selectedRooms[i].endsWith(" exist")) {
                                                                              selectedRooms[i] = selectedRooms[i].substring(0, selectedRooms[i].length - " exist".length);
                                                                            }
                                                                          }
                                                                          for(int i = 0 ; i < selectedRooms.length ; i++){
                                                                            for(int j = 0 ; j < subjects[index1][index2].length ; j++){
                                                                              if(subjects[index1][index2][j]==selectedRooms[i]){
                                                                                subjects[index1][index2].removeAt(j);
                                                                              }
                                                                            }
                                                                          }
                                                                          if(subjects[index1][index2].isEmpty){
                                                                            subjects[index1][index2].add("empty");
                                                                          }
                                                                          selectedRooms.clear();
                                                                          setState(() {});
                                                                          Navigator.of(context).pop();
                                                                        },
                                                                        child: const Text("Delete")
                                                                    ),
                                                                    ElevatedButton(
                                                                      onPressed: () async {
                                                                        for(int i = 0 ; i < selectedRooms.length; i++){
                                                                          if (selectedRooms[i].endsWith(" exist")) {
                                                                            selectedRooms[i] = selectedRooms[i].substring(0, selectedRooms[i].length - " exist".length);
                                                                        }
                                                                        }
                                                                        if(subjects[index1][index2][0]=="empty"){
                                                                          for (int i = 0; i < selectedRooms.length; i++) {
                                                                            subjects[index1][index2].add(selectedRooms[i]);
                                                                          }
                                                                          subjects[index1][index2].removeAt(0);
                                                                        }
                                                                        else {
                                                                          for(int i = 0 ; i < selectedRooms.length ; i++){
                                                                            for(int j = 0 ; j < subjects[index1][index2].length ; j++){
                                                                              if(subjects[index1][index2][j]==selectedRooms[i]){
                                                                                selectedRooms.removeAt(i);
                                                                              }
                                                                            }
                                                                          }
                                                                          if(selectedRooms.isNotEmpty){
                                                                          for (int i = 0; i < selectedRooms.length; i++) {
                                                                            subjects[index1][index2].add(selectedRooms[i]);
                                                                          }
                                                                          }
                                                                        }
                                                                        selectedRooms.clear();
                                                                        setState(() {});
                                                                        Navigator.of(context).pop();
                                                                      },

                                                                      // onPressed: () {
                                                                      //   if(subjects[index1][index2][0]=="empty"){
                                                                      //     for (int i = 0; i < selectedRooms.length; i++) {
                                                                      //       subjects[index1][index2].add(selectedRooms[i]);
                                                                      //     }
                                                                      //     subjects[index1][index2].removeAt(0);
                                                                      //   }
                                                                      //   else{
                                                                      //     for (int i = 0; i < selectedRooms.length; i++) {
                                                                      //       subjects[index1][index2].add(selectedRooms[i]);
                                                                      //     }}
                                                                      //   selectedRooms.clear();
                                                                      //   setState(() {});
                                                                      //   Navigator.of(context).pop();
                                                                      // },
                                                                      child: const Text("Add"),
                                                                    ),
                                                                    TextButton(
                                                                      onPressed: () {
                                                                        selectedRooms.clear();
                                                                        Navigator.of(context).pop(); // Close the pop-up
                                                                      },
                                                                      child: const Text("Close"),
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            );
                                                          },

                                                          child: Text("$index1""$index2"),
                                                        ),
                                                      )

                                                      ),
                                                    ),
                                                  )),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
          );
        },
      ),
    );
  }
  // static Future<bool> dubChecker(List<String> l1, List<String> l2) async {
  //   for (int i = 0; i < l2.length; i++) {
  //     for (int j = 0; j < l1.length; j++) {
  //       if (l1[j] != l2[i]) {
  //         return true;
  //       } else {
  //         return false;
  //       }
  //     }
  //   }
  //   return false; // Add a return statement outside the loops
  // }
  List<String> existenceChecker(int i, int j) {
    List<String> roomNames = cubit.rooms.map((room) => room.name).toList();

    for (int y = 0; y < roomNames.length; y++) {
      for (int z = 0; z < subjects[i][j].length; z++) {
        if (subjects[i][j][z] == roomNames[y]) {
          roomNames[y] = "${roomNames[y]} exist";
        }
      }
    }
    return roomNames;
  }
}

class RectanglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()
      ..color = ConstantVar.backgroundContainer
      ..strokeWidth = 2.sp
      ..strokeCap = StrokeCap.round;

    final crossLine = Paint()
      ..color = Colors.white
      ..strokeWidth = 5.sp
      ..strokeCap = StrokeCap.round;

    // Draw the rectangle
    canvas.drawRect(Offset.zero & size, backgroundPaint);

    // Draw the cross line
    canvas.drawLine(Offset.zero, Offset(size.width, size.height), crossLine);
    //canvas.drawLine(Offset(0, size.height), Offset(size.width, 0), crossLine);
  }

  @override
  bool shouldRepaint(RectanglePainter oldDelegate) => false;
}


Future<void> dialogAddRoomBuilder(BuildContext context) {
  List<Rooms> selectedValues = [];
  return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ConstantVar.backgroundPage,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30))),
          content: DropDownMultiSelect(
            options: cubit.rooms,
            selectedValues: selectedValues,
            onChanged: (p0) {},
          ),
          actions: [
            Center(
                child: Column(
              children: [
                SizedBox(
                  width: 50.sp,
                  child: ElevatedButton(
                    onPressed: () {
                      cubit.rooms.addAll(selectedValues);
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


Future<void> dialogDelRoomBuilder(BuildContext context) {
  List<Rooms> selectedValues = [];
  return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ConstantVar.backgroundPage,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30))),
          content: DropDownMultiSelect(
            options: cubit.rooms,
            selectedValues: selectedValues,
            onChanged: (p0) {},
          ),
          actions: [
            Center(
                child: Column(
              children: [
                SizedBox(
                  width: 50.sp,
                  child: ElevatedButton(
                    onPressed: () {
                      cubit.rooms
                          .removeWhere((room) => selectedValues.contains(room));
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
