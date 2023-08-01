import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as m;
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hijr/api/Api_Services.dart';
import 'package:hijr/bloc/home_cubit.dart';
import 'package:hijr/bloc/states.dart';
import 'package:hijr/second_Screen.dart';
import 'package:hijri/hijri_calendar.dart';

// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../utils.dart';

class TableComplex extends StatefulWidget {
  const TableComplex({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TableComplexState createState() => _TableComplexState();
}

class _TableComplexState extends State<TableComplex> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..changeUnSelected(),
      child: BlocConsumer<HomeCubit, BlocStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = HomeCubit.get(context);
          return Scaffold(
            body: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: Column(
                children: [
                  ValueListenableBuilder<DateTime>(
                    valueListenable: cubit.focusedDay,
                    builder: (context, value, _) {
                      return _CalendarHeader(
                        cubit: cubit,
                        year: cubit.getHijriDateYear(cubit.selectedDay),
                        month: cubit.getHijriDateMonth(cubit.selectedDay),
                        focusedDay: value,
                        onTodayButtonTap: () {
                          cubit.focusedDay.value = DateTime.now();
                        },
                        onLeftArrowTap: () {
                          cubit.pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          );
                        },
                        onRightArrowTap: () {
                          cubit.pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          );
                        },
                      );
                    },
                  ),
                  m.Directionality(
                    textDirection: m.TextDirection.rtl,
                    child: TableCalendar<Event>(
                      onCalendarCreated: (controller) =>
                      cubit.pageController = controller,
                      headerVisible: false,
                      enabledDayPredicate: (DateTime dateTime) {
                        if (cubit.unselectableDays.contains('${dateTime.year}-0${dateTime.month}-${dateTime.day}')) {
                          return false;
                        } else {
                          return true;
                        }
                      },
                      calendarFormat: cubit.calendarFormat,
                      focusedDay: cubit.focusedDay.value,
                      firstDay: kFirstDay,
                      lastDay: kLastDay,
                      startingDayOfWeek: StartingDayOfWeek.saturday,
                      daysOfWeekHeight: 25,
                      selectedDayPredicate: (day) {
                        return isSameDay(cubit.selectedDay, day);
                      },
                      onDaySelected: cubit.onDaySelected,
                      locale: 'ar',
                      onPageChanged: (focusedDay) =>
                      cubit.focusedDay.value = focusedDay,
                      availableGestures: AvailableGestures.horizontalSwipe,
                      headerStyle: const HeaderStyle(
                        formatButtonVisible: true,
                      ),
                      daysOfWeekStyle: const DaysOfWeekStyle(
                        weekendStyle: TextStyle(color: Colors.red),
                      ),
                      calendarBuilders: CalendarBuilders(
                        disabledBuilder: (context, day, _) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 18),
                            decoration: const BoxDecoration(
                              color: Colors.grey,
                              shape: BoxShape.circle,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                day.day.toString(),
                                style: const TextStyle(color: Colors.white),
                                //textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        },
                        selectedBuilder: (BuildContext, day, DateToday) {
                          HijriCalendar hijriDay = HijriCalendar.fromDate(day);
                          String hijriMonth = cubit.getArabicMonthName(
                              HijriCalendar.fromDate(day).hMonth);

                          cubit.changeDate(hijriDay.hDay.toString(), hijriMonth, hijriDay.hYear.toString(),);

                          return Container(
                            margin: const EdgeInsets.only(bottom: 5),
                            padding: const EdgeInsets.all(2),
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              color: Colors.green.shade400,
                              shape: BoxShape.circle,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(day.day.toString(),
                                  style:const TextStyle(
                                      fontSize: 17
                                  ),),
                                Text(
                                  hijriDay.hDay == 1
                                      ? hijriMonth.toString().toString()
                                      : hijriDay.hDay.toString(),
                                  style:  TextStyle(
                                      fontSize:hijriDay.hDay == 1? 8: 11,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          );
                        },
                        todayBuilder: (BuildContext, day, DateToday) {
                          HijriCalendar hijriDay = HijriCalendar.fromDate(day);
                          String hijriMonth = cubit.getArabicMonthName(
                              HijriCalendar.fromDate(day).hMonth);
                          return Container(
                            margin: const EdgeInsets.only(bottom: 2),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Column(
                                children: [
                                  Text(day.day.toString(),
                                    style:const TextStyle(
                                        fontSize: 17
                                    ),),
                                  Text(
                                    hijriDay.hDay == 1
                                        ? hijriMonth.toString()
                                        : hijriDay.hDay.toString(),
                                    style:  TextStyle(
                                        fontSize:hijriDay.hDay == 1? 6: 10, color: Colors.black45),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        defaultBuilder: (BuildContext, day, DateToday) {
                          HijriCalendar hijriDay = HijriCalendar.fromDate(day);
                          String hijriMonth = cubit.getArabicMonthName(
                              HijriCalendar.fromDate(day).hMonth);
                          return Container(
                            margin: const EdgeInsets.only(bottom: 2),
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: Column(
                                children: [
                                  Text(day.day.toString(),
                                    style:const TextStyle(
                                        fontSize: 17
                                    ),
                                  ),
                                  Text(
                                    hijriDay.hDay == 1
                                        ? hijriMonth.toString().toString()
                                        : hijriDay.hDay.toString(),
                                    style:  TextStyle(
                                        fontSize:hijriDay.hDay == 1? 8: 10
                                        , color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // change hijri date
                      cubit.unselectableDays.add(DateTime(
                        cubit.selectedDay.year,
                        cubit.selectedDay.month,
                        cubit.selectedDay.day,
                      ));

                      // post data
                      ApiService().postDataToApi(data: {
                        "hall_id": 600001,
                        "customer_id": 1,
                        "booking_date": DateTime(
                          cubit.selectedDay.year,
                          cubit.selectedDay.month,
                          cubit.selectedDay.day,
                        ).toString(),
                      });

                      // change un available dates
                      cubit.changeUnSelected();

                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const SecondScreen()));
                    },
                    child: Text(
                      'حجز بتاريخ ${cubit.day} ${cubit.month}, ${cubit.year}',
                    ),
                  ),
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
  final HomeCubit cubit;

  const _CalendarHeader({
    Key? key,
    required this.focusedDay,
    required this.onLeftArrowTap,
    required this.onRightArrowTap,
    required this.onTodayButtonTap,
    required this.year,
    required this.month,
    required this.cubit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final headerText = DateFormat.y().format(focusedDay);
    final headerText2 = cubit.getMonthName(focusedDay.month);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const SizedBox(
            width: 8,
          ),
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.calendar_today,
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
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //const SizedBox(width: 8.0),

                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: onLeftArrowTap,
                    ),
                    SizedBox(
                      width: 110.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            headerText,
                            style: TextStyle(
                                fontSize: 14.0, color: Colors.green.shade500),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            headerText2,
                            style: const TextStyle(fontSize: 14.0),
                          )
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: onRightArrowTap,
                    ),
                  ],
                ),
                Text(
                  "$month $year ",
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
