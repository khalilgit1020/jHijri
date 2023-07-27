import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hijr/bloc/home_cubit.dart';
import 'package:hijr/bloc/states.dart';
import 'package:hijri/hijri_calendar.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/date_symbol_data_local.dart';

import '../utils.dart';

class TableComplexExample extends StatefulWidget {
  const TableComplexExample({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TableComplexExampleState createState() => _TableComplexExampleState();
}

class _TableComplexExampleState extends State<TableComplexExample> {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(),
      child: BlocConsumer<HomeCubit, BlocStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = HomeCubit.get(context);
          return Scaffold(
            body: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ValueListenableBuilder<DateTime>(
                    valueListenable: cubit.focusedDay,
                    builder: (context, value, _) {
                      return _CalendarHeader(
                        year: cubit.getHijriDateYear(cubit.selectedDay),
                        month: cubit.getHijriDateMonth(cubit.selectedDay),
                        focusedDay: value,
                        onTodayButtonTap: () {
                          cubit.focusedDay.value = DateTime.now();
                        },
                        onLeftArrowTap: () {
                          cubit.pageController.previousPage(
                            duration:const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          );
                        },
                        onRightArrowTap: () {
                          cubit.pageController.nextPage(
                            duration:const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          );
                        },

                      );
                    },
                  ),
                  TableCalendar<Event>(
                    onCalendarCreated: (controller) => cubit.pageController = controller,
                    headerVisible: false,

                    enabledDayPredicate: (DateTime dateTime){
                      if (cubit.unselectableDays.contains(DateTime(dateTime.year,dateTime.month,dateTime.day))) {
                        return false;
                      }else{
                        return true;
                      }
                    },
                    calendarFormat: cubit.calendarFormat,
                    focusedDay: cubit.focusedDay.value,
                    firstDay: kFirstDay,
                    lastDay: kLastDay,
                    daysOfWeekHeight: 25,
                    selectedDayPredicate: (day) {
                      return cubit.isSameDay(day);
                    },

                    onDaySelected: cubit.onDaySelected,
                    locale: 'ar',
                    onPageChanged: (focusedDay) => cubit.focusedDay.value = focusedDay,
                    availableGestures: AvailableGestures.horizontalSwipe,
                    headerStyle:const HeaderStyle(
                      formatButtonVisible: true,
                    ),
                    daysOfWeekStyle:const DaysOfWeekStyle(
                      weekendStyle: TextStyle(color: Colors.red),
                    ),
                    calendarBuilders: CalendarBuilders(
                      disabledBuilder: (context, day, _) {
                        return Center(
                          child: Text(
                            day.day.toString(),
                            style:const TextStyle(color: Colors.grey,fontSize: 12),
                          ),

                        );
                      },
                      selectedBuilder: (BuildContext, day, DateToday) {
                        HijriCalendar hijriDay = HijriCalendar.fromDate(day);
                        String hijriMonth =
                        cubit.getArabicMonthName(HijriCalendar.fromDate(day).hMonth);
                        return Container(
                          margin:const EdgeInsets.only(bottom: 2),
                          decoration:const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                Text(day.day.toString()),
                                Text(
                                  hijriDay.hDay == 1
                                      ? hijriMonth.toString().toString()
                                      : hijriDay.hDay.toString(),
                                  style:const TextStyle(fontSize: 8, color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      todayBuilder: (BuildContext, day, DateToday) {
                        HijriCalendar hijriDay = HijriCalendar.fromDate(day);
                        String hijriMonth =
                        cubit.getArabicMonthName(HijriCalendar.fromDate(day).hMonth);
                        return Container(
                          margin:const EdgeInsets.only(bottom: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(7.0),
                            child: Column(
                              children: [
                                Text(day.day.toString()),
                                Text(
                                  hijriDay.hDay == 1
                                      ? hijriMonth.toString().toString()
                                      : hijriDay.hDay.toString(),
                                  style:
                                  const TextStyle(fontSize: 8, color: Colors.black45),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      defaultBuilder: (BuildContext, day, DateToday) {
                        HijriCalendar hijriDay = HijriCalendar.fromDate(day);
                        String hijriMonth =
                        cubit.getArabicMonthName(HijriCalendar.fromDate(day).hMonth);
                        return Container(
                          margin:const EdgeInsets.only(bottom: 2),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Text(day.day.toString()),
                                Text(
                                  hijriDay.hDay == 1
                                      ? hijriMonth.toString().toString()
                                      : hijriDay.hDay.toString(),
                                  style:const TextStyle(fontSize: 7, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  ElevatedButton(onPressed:(){
                    print(cubit.selectedDay);
                  },
                    child:const Text('send'),
                  ),
                  /*Center(
                    child: Column(
                      children: [
                        Text(
                          ' Date: ${cubit.selectedDay.toLocal()}',
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Selected Hijri Date: ${cubit.getHijriDateYear(cubit.selectedDay)}',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  )*/
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CalendarHeader extends StatelessWidget {
  final DateTime focusedDay;
  final VoidCallback onLeftArrowTap;
  final VoidCallback onRightArrowTap;
  final VoidCallback onTodayButtonTap;
final String year;
  final String month;
  const _CalendarHeader({
    Key? key,
    required this.focusedDay,
    required this.onLeftArrowTap,
    required this.onRightArrowTap,
    required this.onTodayButtonTap,
    required this.year, required this.month,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final headerText = DateFormat.yMMM().format(focusedDay);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const SizedBox(width: 8,),
          Column(
            children: [
              IconButton(
                icon:const Icon(Icons.calendar_today,
                    size: 24.0, color: Colors.grey),
                visualDensity: VisualDensity.compact,
                onPressed: onTodayButtonTap,
              ),
              const Text(
                "اليوم",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    const SizedBox(width: 8.0),

                    IconButton(
                      icon:const Icon(Icons.chevron_left),
                      onPressed: onLeftArrowTap,
                    ),
                    SizedBox(
                      width: 100.0,
                      child: Text(
                        headerText,
                        style:const TextStyle(fontSize: 22.0),
                      ),
                    ),
                    IconButton(
                      icon:const Icon(Icons.chevron_right),
                      onPressed: onRightArrowTap,
                    ),
                  ],
                ),
                Text(
                  "$month $year ",
                  style:const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
