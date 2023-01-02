class PrayerModel{
  String fajr;
  String dhuhr;
  String asr;
  String maghrib;
  String isha;
  String date;

  PrayerModel({
    required this.date,
    required this.asr,required this.dhuhr,required this.fajr,required this.isha,required this.maghrib
});
  @override
  String toString() {
    return [fajr,dhuhr,asr,maghrib,isha].toString();
  }
}