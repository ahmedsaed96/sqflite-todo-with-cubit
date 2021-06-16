import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_sqflite_with_todo/constant.dart';

import 'package:my_sqflite_with_todo/view/widgets/custom_text_filed.dart';
import 'package:sqflite/sqflite.dart';
import '../cubit/app_states.dart';
import '../view/screens/archived_screen.dart';
import '../view/screens/done_screen.dart';
import '../view/screens/new_tasks_screen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());
  static AppCubit get(BuildContext context) => BlocProvider.of(context);
  TextEditingController? taskTitleController = TextEditingController();
  TextEditingController? taskTimeController = TextEditingController();
  TextEditingController? taskDateController = TextEditingController();
  int currentIndex = 0;

  Database? database;
  GlobalKey<FormState> fomrKey = GlobalKey<FormState>();
  List<Map>? tasks = [];
  List<Map>? donetasks = [];
  List<Map>? archivedtasks = [];
  List<String> titles = [
    'Home',
    'Done',
    'Archived',
  ];
  List<Widget> screens = [
    NewTasksScreen(),
    DoneScreen(),
    ArchivedScreen(),
  ];
  void changeIndex(int index) {
    currentIndex = index;
    emit(AppIndexState());
  }

  void openBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Form(
              key: fomrKey,
              child: buildBottomSheetColumn(context),
            ),
          );
        });
    emit(AppFloatingButtonState());
  }

  Future createDatabase() async {
    database = await openDatabase(
      'database1.db',
      version: 1,
      onCreate: (db, version) async {
        await db
            .execute(
                'CREATE TABLE tasks(id INTEGER PRIMARY KEY,title TEXT,time TEXT,date TEXT,state TEXT)')
            .then((value) {
          debugPrint('table created');
        }).catchError((e) {
          debugPrint('error on crate table $e');
        });
      },
      onOpen: (db) {
        debugPrint('database opened');
        readDatabase();
      },
    );

    emit(AppCreateDatabase());
  }

  Future<List<Map>?> readDatabase({int? index}) async {
    emit(AppGetDatabaseLoadingState());
    tasks = [];
    donetasks = [];
    archivedtasks = [];
    await database?.rawQuery('SELECT * FROM tasks').then((value) {
      tasks = value;
      for (final task in tasks!) {
        if (task['state'] == 'new') {
          tasks!.add(task);
        } else if (task['state'] == 'done') {
          donetasks!.add(task);
          tasks!.removeAt(int.parse(task[index].toString()));
        } else if (task['state'] == 'archived') {
          archivedtasks!.add(task);
          tasks!.removeAt(int.parse(task[index].toString()));
        }
      }
    });
    emit(AppReadDatabase());
    debugPrint("tasks is = $tasks");
  }

  Future insertToDatabase({
    String? title,
    String? date,
    String? time,
  }) async {
    await database?.transaction((txn) async {
      debugPrint('txn opend');
      txn
          .rawInsert(
              'INSERT INTO tasks(title, date, time, state) VALUES("$title", "$date", "$time", "New")')
          //'INSERT INTO Test(name, value, num) VALUES("some name", 1234, 456.789)')
          .then((value) {
        readDatabase();
        debugPrint('insert successfully!!');
      }).catchError((e) {
        debugPrint('error when inser opend =$e ');
      });
    });
    emit(AppInsertToDatabase());
  }

  Future updateDatabase({String? status, int? id, int? index}) async {
    await database?.rawUpdate(
      'UPDATE tasks SET state = ? WHERE id = ?',
      // ignore: unnecessary_string_interpolations
      ["$status", "$id"],
    ).then((value) {
      readDatabase(index: index);
    });
    emit(AppupdateToDatabase());
  }

  void deleteFromDatabase(int? id) {
    database!.rawDelete('DELETE FROM tasks WHERE id = ?', ['$id']).then(
        (value) => readDatabase());
    emit(AppdeleteToDatabase());
  }

  SizedBox buildBottomSheetColumn(BuildContext context) {
    return SizedBox(
      height: size(context).height / 1.9,
      child: Column(
        children: [
          const SizedBox(height: 15.0),
          customTextField(
            onTap: () {}, //to avoid null error in consol
            hintText: 'Task Title',
            icon: Icons.text_fields,
            val: taskTitleController!.text,
            field: 'Title',
            textEditingController: taskTitleController,
          ),
          const SizedBox(height: 15.0),
          //Task Time
          customTextField(
              onTap: () => showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  ).then((value) {
                    return taskTimeController!.text =
                        value!.format(context).toString();
                  }),
              disableKeyBoard: true,
              hintText: 'Task Time',
              icon: Icons.watch_later_outlined,
              val: taskTimeController!.text,
              field: 'Time',
              textEditingController: taskTimeController),
          const SizedBox(height: 15.0),
          //Task Date
          customTextField(
              onTap: () => showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2023, 10, 10),
                  ).then((value) {
                    return taskDateController!.text =
                        DateFormat.yMMMd().format(value!);
                  }),
              disableKeyBoard: true,
              hintText: 'Task Date',
              icon: Icons.calendar_today,
              val: taskDateController!.text,
              field: 'Date',
              textEditingController: taskDateController),
          const SizedBox(height: 10.0),
          ElevatedButton(
            onPressed: () {
              if (fomrKey.currentState!.validate()) {
                insertToDatabase(
                        title: taskTitleController?.text,
                        date: taskDateController?.text,
                        time: taskTimeController?.text)
                    .then((value) {
                  taskTitleController!.clear();
                  taskDateController!.clear();
                  taskTimeController!.clear();
                  Navigator.pop(context);
                });
              } else {
                return;
              }
            },
            child: const Text('ADD'),
          )
        ],
      ),
    );
  }
}
