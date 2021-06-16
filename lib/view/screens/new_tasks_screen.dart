import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_sqflite_with_todo/constant.dart';
import 'package:my_sqflite_with_todo/cubit/app_cubit.dart';
import 'package:my_sqflite_with_todo/cubit/app_states.dart';

class NewTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          final tasks = AppCubit.get(context).tasks;
          // state != AppCreateDatabase
          return tasks!.isNotEmpty
              ? ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  itemCount: tasks.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      buildCustomDivider(context),
                  itemBuilder: (BuildContext context, int index) {
                    return buildDismissible(context, index, tasks);
                  },
                )
              : Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.menu, size: 50.0, color: Colors.grey[600]),
                    Text(
                      'No tasks yet..add one!!',
                      style: TextStyle(color: Colors.grey[600], fontSize: 20.0),
                    ),
                  ],
                ));
        },
      ),
    );
  }

  Dismissible buildDismissible(
      BuildContext context, int index, List<Map<dynamic, dynamic>> tasks) {
    return Dismissible(
      background: Container(
        color: Colors.blue[400],
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 40.0),
              child: const Icon(Icons.check_box, size: 30.0),
            )
          ],
        ),
      ),
      secondaryBackground: Container(
        color: Colors.black45,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 40.0),
              child: const Icon(Icons.archive_outlined, size: 30.0),
            ),
          ],
        ),
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          AppCubit.get(context).updateDatabase(
              index: index,
              id: int.parse(
                  AppCubit.get(context).tasks![index]['id'].toString()),
              status: 'archived');
        } else if (direction == DismissDirection.startToEnd) {
          AppCubit.get(context).updateDatabase(
              index: index,
              id: int.parse(
                  AppCubit.get(context).tasks![index]['id'].toString()),
              status: 'done');
        }
      },
      key: UniqueKey(),
      // key: Key(tasks[index]['id'].toString()),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          children: [
            buildCircleContainer(context, index),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Stack(children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${tasks[index]['title']}',
                    ),
                    const SizedBox(height: 10.0),
                    Text('${tasks[index]['date']}'),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 170.0, top: 10.0),
                  child: IconButton(
                    onPressed: () {
                      AppCubit.get(context).deleteFromDatabase(int.parse(
                          AppCubit.get(context)
                              .tasks![index]['id']
                              .toString()));
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.black54,
                      size: 30.0,
                    ),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Container buildCircleContainer(BuildContext context, int index) {
    return Container(
      height: 75.0,
      width: 75.0,
      decoration: const BoxDecoration(
        color: Colors.lightBlueAccent,
        shape: BoxShape.circle,
      ),
      child:
          Center(child: Text('${AppCubit.get(context).tasks![index]['time']}')),
    );
  }

  Container buildCustomDivider(BuildContext context) {
    return Container(
      height: 1.0,
      width: size(context).width,
      color: Colors.grey,
    );
  }
}
