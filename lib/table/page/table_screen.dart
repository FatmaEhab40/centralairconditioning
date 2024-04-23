// ignore_for_file: unrelated_type_equality_checks
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

final cubitTable = TableCubit();
List<List<List<String>>> subjects = [];
class TableScreen extends StatefulWidget {
  const TableScreen({super.key});

  @override
  State<TableScreen> createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {
  final containerHeight = 40.sp;
  final containerWidth = 50.sp;

  final periodController = TextEditingController();
  final roomController = TextEditingController();
  List<String> selectedRooms = [];
  // List<List<List<String>>> subjects = [
  //   [
  //     ["6006", "6106"],
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //   ],
  //   [
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //   ],
  //   [
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //   ],
  //   [
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //   ],
  //   [
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //   ],
  //   [
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //   ],
  //   [
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //   ],
  //   [
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //   ],
  //   [
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //     ["empty"],
  //   ],
  // ];
  
  @override
  void initState() {
    super.initState();
    cubitTable.getPeriods();
    cubitTable.getRooms();
    cubitTable.getSchedule(subjects);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubitTable,
      child: BlocBuilder<TableCubit, TableState>(
        buildWhen: (previous, current) {
          return current is Reload||
              current is GetPeriodsSuccessState||
              current is GetRoomsSuccessState||
              current is AddPeriodsSuccessState||
              current is AddRoomsSuccessState||
              current is UpdatePeriodsSuccessState||
              current is UpdateRoomsSuccessState||
              current is DeletePeriodsSuccessState||
              current is DeleteRoomsSuccessState;
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
                                  value: cubitTable, child: const AddScreen()),
                            )).then((value) => (value) {
                              cubitTable.getPeriods();
                              cubitTable.getRooms();
                            });
                      } else if (value == 1) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EditScreen(),
                            )).then((value) => (value) {
                              cubitTable.getPeriods();
                              cubitTable.getRooms();
                            });
                      } else if (value == 2) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DeleteScreen(),
                            )).then((value) => (value) {
                              cubitTable.getPeriods();
                              cubitTable.getRooms();
                            });
                      }
                    }),
              ],
            ),
            body: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                  height: (containerHeight*(cubitTable.days.length+1))+(10.sp+(8.sp*(cubitTable.days.length+2))),
                  width: (containerWidth*(cubitTable.periods.length+1))+(10.sp+(8.sp*(cubitTable.periods.length+2))),
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
                                        cubitTable.periods.length,
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
                                              cubitTable.periods[index].duration,
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
                                itemCount: cubitTable.days.length,
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
                                            cubitTable.days[index1],
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
                                              cubitTable.periods.length,
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
                                                      value: subjects[index1][index2][0],
                                                      onChanged: (String? newValue){
                                                      },
                                                      items: List.generate(subjects[index1][index2].length,
                                                              (int index) {
                                                        return DropdownMenuItem(
                                                          value: subjects[index1][index2][index],
                                                          child: Text(subjects[index1][index2][index]

                                                          ),
                                                        );
                                                      })..add(DropdownMenuItem(
                                                        value: "add",
                                                        child: TextButton(
                                                          onPressed: () {
                                                            Navigator.of(context).pop();
                                                            showDialog(
                                                              context: context,
                                                              builder: (BuildContext context) {
                                                                return AlertDialog(
                                                                  backgroundColor: ConstantVar.backgroundPage,
                                                                  shape: const RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.all(Radius.circular(30))),
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
                                                                  actions: [
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      children: <Widget>[
                                                                        TextButton(
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
                                                                              if(selectedRooms.isNotEmpty){
                                                                                selectedRooms.clear();
                                                                                cubitTable.updateSchedule(subjects);
                                                                                // setState(() {});
                                                                                Navigator.of(context).pop();
                                                                              }
                                                                              cubitTable.updateSchedule(subjects);
                                                                            },
                                                                            child: const Text("Delete",style: TextStyle(color: Colors.brown),),
                                                                        ),
                                                                        TextButton(
                                                                          onPressed: () async {
                                                                            for(int i = 0 ; i < selectedRooms.length; i++){
                                                                              if (selectedRooms[i].endsWith(" exist")) {
                                                                                selectedRooms[i] = selectedRooms[i].substring(0, selectedRooms[i].length - " exist".length);
                                                                            }
                                                                            }
                                                                            if(subjects[index1][index2][0]=="empty"&&selectedRooms.isNotEmpty){
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
                                                                            if(selectedRooms.isNotEmpty){
                                                                            selectedRooms.clear();
                                                                            cubitTable.updateSchedule(subjects);
                                                                            Navigator.of(context).pop();
                                                                            }
                                                                            cubitTable.updateSchedule(subjects);
                                                                          },
                                                                          child: const Text("Add",style: TextStyle(color: Colors.brown)),
                                                                        ),
                                                                        TextButton(
                                                                          onPressed: () {
                                                                            selectedRooms.clear();
                                                                            Navigator.of(context).pop(); // Close the pop-up
                                                                          },
                                                                          child: const Text("Close",style: TextStyle(color: Colors.brown),),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            );
                                                          },
                                                          child: const Text("Edit",style: TextStyle(color: Colors.black))),
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
  List<String> existenceChecker(int i, int j) {
    List<String> roomNames = cubitTable.rooms.map((room) => room.name).toList();

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

