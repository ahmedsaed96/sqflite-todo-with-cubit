import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_sqflite_with_todo/constant.dart';
import 'package:my_sqflite_with_todo/cubit/app_cubit.dart';
import 'package:my_sqflite_with_todo/cubit/app_states.dart';

class DoneScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return AppCubit.get(context).donetasks!.isNotEmpty
              ? ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  itemCount: AppCubit.get(context).donetasks!.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      buildCustomDivider(context),
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        children: [
                          buildCircleContainer(context, index),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${AppCubit.get(context).donetasks![index]['title']}',
                                ),
                                const SizedBox(height: 10.0),
                                Text(
                                    '${AppCubit.get(context).donetasks![index]['date']}'),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                )
              : Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.menu, size: 50.0, color: Colors.grey[600]),
                    Text(
                      'No done tasks!!',
                      style: TextStyle(color: Colors.grey[600], fontSize: 20.0),
                    ),
                  ],
                ));
        },
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
      child: Center(
          child: Text('${AppCubit.get(context).donetasks![index]['time']}')),
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
