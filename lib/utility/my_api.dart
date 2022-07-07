import 'dart:math';

import 'package:project/model/landmark_model.dart';

class MyApi {
  double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    double distance = 0;

    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lng2 - lng1) * p)) / 2;
    distance = 12742 * asin(sqrt(a));

    return distance;
  }

  // ignore: missing_return
  int calculateTransport(double distance) {
    int transport;
    if (distance <= 1) {
      transport = 35;
    } else {
      transport = 35 + ((distance - 1).round() * 10);
    }
    return transport;
  }

  String difference(String date) {
    int minutes;
    double hours;
    String dayString = '';
    int day;
    double week;
    double month;
    double year;
    DateTime dt = DateTime.parse(date);
    var now = DateTime.now();
    var diff = now.difference(dt);
    day = diff.inDays.toInt();
    minutes = diff.inMinutes.toInt();

    if (minutes < 1) {
      dayString = 'ไม่กี่วินาที';
    } else if (minutes >= 1 && minutes < 60) {
      dayString = '${minutes.toStringAsFixed(0)}นาที';
    } else if (minutes >= 60 && minutes < 1440) {
      hours = minutes / 60;
      dayString = '${hours.toStringAsFixed(0)}ชั่วโมง';
    } else if (minutes >= 1440 && day >= 1 && day < 2) {
      dayString = 'เมื่อวานนี้';
    } else if (day >= 2 && day < 7) {
      dayString = '${day.toStringAsFixed(0)}วัน';
    }else if (day >= 7 && day < 30) {
      week = day / 7;
      dayString = '${week.toStringAsFixed(0)}สัปดาห์';
    } else if (day >= 30 && day < 365) {
      month = day / 30;
      dayString = '${month.toStringAsFixed(0)}เดือน';
    } else if (day >= 365) {
      year = day / 365;
      dayString = '${year.toStringAsFixed(0)}ปี';
    }
    return dayString;
  }

  double calculateTime(double distance) {
    double time;
    if (distance <= 1) {
      time = 15;
    } else if (distance >= 100) {
      time = ((((distance - 1).round() * 1)) / 60);
    } else {
      time = ((((distance - 1).round() * 2)) / 60);
    }
    return time;
  }

  MyApi();
}
