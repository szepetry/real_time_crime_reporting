import 'package:workmanager/workmanager.dart';
import 'dart:async';
import 'dart:io';

const simpleTaskKey = 'simpleTask';
const simpleDelayedTask = 'simpleDelayedTask';
const simplePeriodicTask = 'simplePeriodicTask';
const simplePeriodic1HourTask = 'simplePeriodic1HourTask';

class BackgroundServices {
  
  void callbackDispatcher() {
    print('Callback dispatcher');
    Workmanager.executeTask((taskName, inputData) {
      Timer.periodic(Duration(seconds: 15), (Timer timer) {
        print('message each 15secs');
      });
      print("Native called background task: pusher");
      return Future.value(true);
    });
  }


}
