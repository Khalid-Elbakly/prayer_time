import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:prayer_time/core/controller/cubit/app_cubit.dart';
import 'package:prayer_time/core/controller/cubit/app_states.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

ItemScrollController controller = ItemScrollController();

class _HomeState extends State<Home> {
  late AppCubit cubit;
  @override
  void initState() {
    cubit =AppCubit.get(context);
    cubit.getPrayerData(DateTime.now().day,DateTime.now().month,DateTime.now().year);



    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context,state){
        if(state is PrayerState){
          Future.delayed(Duration(seconds: 1),(){controller.scrollTo(index: cubit.selectedDate!.day-1, duration: Duration(seconds: 1));});
        }
      },
      builder: (context, state) => Scaffold(
        backgroundColor: Colors.blue.shade200,
        body: state is! InitState
            ? SafeArea(
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: DaysList(
                          index: cubit.daysCount!,
                          controller: controller,
                          selectedDate: cubit.selectedDate!,
                        ),
                      ),
                      //          CalendarDatePicker(firstDate: DateTime.now(),initialDate: DateTime.now(),lastDate: DateTime(2055),onDateChanged: (s){},),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 3),
                        child: Row(
                          children: [
                            Text(formatDate(AppCubit.get(context).selectedDate!,
                                ['MM', ' ', 'yyyy'])),
                            const Spacer(),
                            IconButton(
                                onPressed: () {
                                  AppCubit.get(context).decreaseMonth();
                                  // print(index);
                                  DaysList(
                                    index: cubit.daysCount!,
                                    controller: controller,
                                    selectedDate: cubit.selectedDate!,
                                  );
                                  //   controller.scrollTo(index: 0, duration: Duration(seconds: 1));
                                },
                                icon: const Icon(Icons.arrow_back_ios)),
                            IconButton(
                                onPressed: () {
                                  cubit.increaseMonth();
                                  DaysList(
                                    index: cubit.daysCount!,
                                    controller: controller,
                                    selectedDate: cubit.selectedDate!,
                                  );
                                  // controller.scrollTo(index: 0, duration: Duration(seconds: 1));
                                },
                                icon: const Icon(Icons.arrow_forward_ios)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20)),
                              color: Colors.white),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: [
                                  const Text('Fajr',style: TextStyle(fontSize: 16),),
                                  const Spacer(),
                                  Text(AppCubit.get(context)
                                      .prayerList[cubit.selectedDate!.day-1]
                                      .fajr,style: const TextStyle(fontSize: 16),)
                                ],
                              ),
                              Container(color: Colors.grey,width: double.infinity,height: 2,),
                              Row(
                                children: [
                                  const Text('Dhuhr',style: TextStyle(fontSize: 16),),
                                  const Spacer(),
                                  Text(AppCubit.get(context)
                                      .prayerList[cubit.selectedDate!.day-1]
                                      .dhuhr,style: const TextStyle(fontSize: 16),)
                                ],
                              ),
                              Container(color: Colors.grey,width: double.infinity,height: 2,),
                              Row(
                                children: [
                                  const Text('Asr',style: TextStyle(fontSize: 16),),
                                  const Spacer(),
                                  Text(AppCubit.get(context)
                                      .prayerList[cubit.selectedDate!.day-1]
                                      .asr,style: const TextStyle(fontSize: 16),)
                                ],
                              ),
                              Container(color: Colors.grey,width: double.infinity,height: 2,),
                              Row(
                                children: [
                                  const Text('Maghrib',style: TextStyle(fontSize: 16),),
                                  const Spacer(),
                                  Text(AppCubit.get(context)
                                      .prayerList[cubit.selectedDate!.day-1]
                                      .maghrib,style: const TextStyle(fontSize: 16),)
                                ],
                              ),
                              Container(color: Colors.grey,width: double.infinity,height: 2,),
                              Row(
                                children: [
                                  const Text('Isha',style: TextStyle(fontSize: 16),),
                                  const Spacer(),
                                  Text(AppCubit.get(context)
                                      .prayerList[cubit.selectedDate!.day-1]
                                      .isha,style: const TextStyle(fontSize: 16),)
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}

class DaysList extends StatelessWidget {
  DaysList(
      {Key? key,
      required this.controller,
      required this.selectedDate,
      required this.index})
      : super(key: key);

  ItemScrollController controller;
  DateTime selectedDate;
  int index;

  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
    return SizedBox(
        height: 81,
        child:
            // get the date object based on the index position
            // if widget.startDate is null then use the initialDateValue
            ScrollablePositionedList.builder(
                itemScrollController: controller,
                scrollDirection: Axis.horizontal,
                itemCount: index,
                itemBuilder: (context, index) {
                  AppCubit.get(context).getDate(index, selectedDate);
                  var date = AppCubit.get(context).date;
                  return InkWell(
                    onTap: () {
                      AppCubit.get(context).SelectDate(date);
                    },
                    child: Container(
                      width: 50,
                      margin: const EdgeInsets.all(3.0),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              DateFormat(
                                "E",
                              )
                                  .format(AppCubit.get(context).date!)
                                  .toUpperCase(), // WeekDay
                            ),
                            CircleAvatar(
                              backgroundColor:
                                  AppCubit.get(context).selectedDate!.day ==
                                          date!.day
                                      ? Colors.green
                                      : Colors.white,
                              child: Text(
                                AppCubit.get(context)
                                    .date!
                                    .day
                                    .toString(), // Date
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }));
  }
}