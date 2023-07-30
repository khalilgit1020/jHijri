import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/home_cubit.dart';
import 'bloc/states.dart';

class SecondScreen extends StatefulWidget {
  const SecondScreen({Key? key}) : super(key: key);

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  @override
  Widget build(BuildContext context) {
    return  BlocProvider(
      create: (context) => HomeCubit()..changeUnSelected(),
      child: BlocConsumer<HomeCubit, BlocStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = HomeCubit.get(context);
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Text('hello'),
            ),
          );
        },
      ),
    );
  }
}
