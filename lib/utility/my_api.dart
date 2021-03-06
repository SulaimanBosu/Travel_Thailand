import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:project/model/landmark_model.dart';
import 'package:project/utility/myConstant.dart';
import 'package:project/utility/my_style.dart';
import 'package:project/widgets/card_view.dart';

typedef StringVoidFunc = void Function(String);
typedef BoolVoidFunc = void Function(bool);

class MyApi {
  double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    double distance = 0;

    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lng2 - lng1) * p)) / 2;
    distance = 12742 * asin(sqrt(a));
    if (distance >= 600) {
      distance = distance + 100;
      return distance;
    } else if (distance >= 300) {
      distance = distance + 50;
      return distance;
    } else {
      return distance;
    }

    // return distance;
  }
  // external double cos(num radians);
  // external double sin(num radians);

  double calculateDistance2(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    double theta = lon1 - lon2;
    double dist = sin(deg2rad(lat1)) * sin(deg2rad(lat2)) +
        cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * cos(deg2rad(theta));
    dist = acos(dist);
    dist = rad2deg(dist);
    dist = dist * 60 * 1.1515;
    dist = dist * 1.609344;
    return (dist);
  }

  double deg2rad(double deg) {
    return (deg * pi / 180.0);
  }

  double rad2deg(double rad) {
    return (rad * 180 / pi);
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
      dayString = '????????????????????????????????????';
    } else if (minutes >= 1 && minutes < 60) {
      dayString = '${minutes.toStringAsFixed(0)}????????????';
    } else if (minutes >= 60 && minutes < 1440) {
      hours = minutes / 60;
      dayString = '${hours.toStringAsFixed(0)}?????????????????????';
    } else if (minutes >= 1440 && day >= 1 && day < 2) {
      dayString = '?????????????????????????????????';
    } else if (day >= 2 && day < 7) {
      dayString = '${day.toStringAsFixed(0)}?????????';
    } else if (day >= 7 && day < 30) {
      week = day / 7;
      dayString = '${week.toStringAsFixed(0)}?????????????????????';
    } else if (day >= 30 && day < 365) {
      month = day / 30;
      dayString = '${month.toStringAsFixed(0)}???????????????';
    } else if (day >= 365) {
      year = day / 365;
      dayString = '${year.toStringAsFixed(0)}??????';
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
