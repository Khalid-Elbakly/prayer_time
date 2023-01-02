import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:prayer_time/data/remote/dio_helper.dart';
import 'package:prayer_time/domain/model/prayer_model.dart';
import 'package:prayer_time/presentation/screens/home.dart';

import 'app_states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitState()){
    startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
    selectedDate =DateTime.now();
    endDate = DateTime(DateTime.now().year,
        (DateTime.now().month == 12) ? 1 : DateTime.now().month + 1, 0);
    daysCount = endDate!.day - startDate!.day + 1;
  }

  static AppCubit get(context) => BlocProvider.of(context);

  PrayerModel? prayerModel;

  List<PrayerModel> prayerList = [];
  DateTime? startDate;

  DateTime? selectedDate;

  DateTime? endDate;

  SelectDate(date) {
    selectedDate = date;
    emit(SelectDateState());
  }

  int? daysCount ;

  increaseMonth() async{
    prayerList =[];
    if (selectedDate!.month == 12) {
      selectedDate = DateTime(selectedDate!.year + 1, 1, 1);
      print(selectedDate);
      endDate = DateTime(selectedDate!.year, selectedDate!.month + 1, 0);
    } else {
      selectedDate = DateTime(selectedDate!.year, selectedDate!.month + 1, 1);
      endDate = DateTime(selectedDate!.year, selectedDate!.month + 1, 0);
      print(selectedDate);
    }
    daysCount = endDate!.day -
        startDate!.day +
        1;
    await getPrayerData(
        selectedDate!.day,
        selectedDate!.month,
        selectedDate!.year);
    emit(SelectDateState());
  }

  decreaseMonth() async {
    prayerList = [];
    if (selectedDate!.month == 1) {
      selectedDate = DateTime(selectedDate!.year - 1, 12, 1);
      endDate = DateTime(selectedDate!.year , 1, 0);
    } else {
      selectedDate = DateTime(selectedDate!.year, selectedDate!.month - 1, 1);
      endDate = DateTime(selectedDate!.year, selectedDate!.month , 0);
    }
    daysCount = endDate!.day -
        startDate!.day +
        1;
    await getPrayerData(
    selectedDate!.day,
    selectedDate!.month,
    selectedDate!.year);
    emit(SelectDateState());
  }

  DateTime? date;
  DateTime? _date;

  getDate(index, DateTime date1) {
      startDate = DateTime(date1.year, date1.month, 1);
    _date = startDate!.add(Duration(days: index));
    date = DateTime(_date!.year, _date!.month, _date!.day);
    //  print(date);
  }

  getPrayerData(int day, int month, int year) async {
    emit(InitState());
    await determinePosition();
    List data = await DioHelper.getData(
        latitude: location.latitude,
        longitude: location.longitude,
        month: month,
        year: year);
    print(data);
    data.forEach((element) {
      prayerList.add(PrayerModel(
          asr: element['timings']['Asr'],
          dhuhr: element['timings']['Dhuhr'],
          fajr: element['timings']['Fajr'],
          isha: element['timings']['Isha'],
          date: element['date']['readable'],
          maghrib: element['timings']['Maghrib']));
    });
    emit(PrayerState());
  }

  clearList(){
    prayerList = [];
  }

  late Position location;

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    location = await Geolocator.getCurrentPosition();
    print(location);
    return await Geolocator.getCurrentPosition();
  }
}
