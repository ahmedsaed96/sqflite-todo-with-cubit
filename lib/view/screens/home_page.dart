import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_sqflite_with_todo/cubit/app_cubit.dart';
import 'package:my_sqflite_with_todo/cubit/app_states.dart';

/*
i have to problems first list dont load on app opened
two on dismiss item from new screen to do to done and archived he go and  return again
 */
class HomeLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          final AppCubit appCubit = AppCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: Text(appCubit.titles[appCubit.currentIndex]),
              centerTitle: true,
            ),
            body: Column(
              children: [appCubit.screens[appCubit.currentIndex]],
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: appCubit.currentIndex,
              onTap: (value) {
                appCubit.changeIndex(value);
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.check), label: 'Done'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined), label: 'Archived'),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                appCubit.openBottomSheet(context);
              },
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }
}
