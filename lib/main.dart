import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'cubit/observer.dart';
import 'view/screens/home_page.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      home: HomeLayout(),
    );
  }
}
