// import 'package:flutter/material.dart';
// import 'package:my_sqflite_with_todo/cubit/app_cubit.dart';

abstract class AppStates {}

class AppInitialState extends AppStates {}

class AppIndexState extends AppStates {}

class AppFloatingButtonState extends AppStates {}

class AppCreateDatabase extends AppStates {}

class AppReadDatabase extends AppStates {}

class AppGetDatabaseLoadingState extends AppStates {}

class AppInsertToDatabase extends AppStates {}

class AppupdateToDatabase extends AppStates {}

class AppdeleteToDatabase extends AppStates {}
