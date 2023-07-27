
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hijr/bloc/states.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../utils.dart';

class HomeCubit extends Cubit<BlocStates> {
  HomeCubit() : super(InitialState());

  static HomeCubit get(context) => BlocProvider.of(context);

  late final ValueNotifier<List<Event>> selectedEvents;
  final ValueNotifier<DateTime> focusedDay = ValueNotifier(DateTime.now());
  DateTime selectedDay = DateTime.now();


  late PageController pageController;
  final CalendarFormat calendarFormat = CalendarFormat.month;

  bool isSameDay( DateTime? b) {
    if (b == null) {
      return false;
    }

    return selectedDay.year == b.year && selectedDay.month == b.month && selectedDay.day == b.day;
  }


  void initState() {
    initializeDateFormatting('ar', null);
    selectedEvents = ValueNotifier(getEventsForDay(focusedDay.value));
    emit(InitState());
  }

  List<Event> getEventsForDay(DateTime day) {
    emit(GetEventsForDayState());
    return kEvents[day] ?? [];

  }

  dispose() {
    focusedDay.dispose();
    emit(DisposeState());
  }

  void onDaySelected(DateTime selectedDa, DateTime focusedDa) {
      selectedDay = selectedDa;
      focusedDay.value = focusedDa;
      print(focusedDay.value);
      print(selectedDay);
      emit(DaySelectedState());

  }


  List<DateTime> unselectableDays = [
    DateTime(2023, 7, 2),
    DateTime(2023, 7, 8),
    // Add more unselectable days as needed
  ];

  void changeUnSelected(List<DateTime> list) {
    unselectableDays  = list;
    emit(UnselectableDaysState());

  }


  String getHijriDateYear(DateTime gregorianDate) {
    final hijriDate = HijriCalendar.fromDate(gregorianDate);
    final formattedDate =
    hijriDate.hYear.toString();
    print(formattedDate);
   // emit(GetHijriDateState());
    return formattedDate;
  }

  String getHijriDateMonth(DateTime gregorianDate) {
    final hijriDate = HijriCalendar.fromDate(gregorianDate);
    final formattedDat =
    hijriDate.hMonth.toString();

    final nameMonth = getArabicMonthName(int.parse(formattedDat));
    print(formattedDat);
    // emit(GetHijriDateState());
    return nameMonth;
  }

  String getArabicMonthName(int monthNumber) {
    List<String> arabicMonthNames = [
      "المحرم",
      "صفر",
      "ربيع الأول",
      "ربيع الآخر",
      "جمادى الأولى",
      "جمادى الآخرة",
      "رجب",
      "شعبان",
      "رمضان",
      "شوال",
      "ذو القعدة",
      "ذو الحجة",
    ];

   // emit(GetArabicMonthNameState());
    return arabicMonthNames[monthNumber - 1];
  }


}