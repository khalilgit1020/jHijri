import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hijr/bloc/states.dart';
import 'package:hijr/test.dart';

import 'bloc/bloc_observer.dart';
import 'bloc/home_cubit.dart';

void main() {

  BlocOverrides.runZoned(
        () {
      // Use cubits...
      runApp(MyApp());
    },
    blocObserver: SimpleBlocObserver(),
  );

}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  BlocProvider(
      create: (context) => HomeCubit()..initState(),
      child: BlocConsumer<HomeCubit, BlocStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'hijri',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home:const TableComplexExample(),
          );
        },
      ),
    );;
  }
}
