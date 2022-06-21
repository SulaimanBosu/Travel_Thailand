import 'dart:math';


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



    double calculateTime(double distance) {
    double time;
    if (distance <= 1) {
      time = 15;
    }else if(distance >= 100){
      time = ((((distance - 1).round() * 1)) / 60);
    }
     else {
    time = ((((distance - 1).round() * 2)) / 60);
    }
    return time;
  }
  MyApi();
}