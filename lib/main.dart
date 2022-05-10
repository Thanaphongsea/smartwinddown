import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/src/ui/home/home_binding.dart';
import 'package:weather_app/src/ui/home/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';  



final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized;
      const IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true);
      final InitializationSettings initializationSettings = InitializationSettings(iOS: initializationSettingsIOS);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  runApp(App());

}

class App extends StatelessWidget {
  

  String _statusrain = '';
  TextEditingController _controller = TextEditingController();
  final database = FirebaseDatabase.instance.ref();
  final _datarain = FirebaseDatabase.instance.ref();

  Future<void> _shorwNotification1() async{
    const IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails(
      badgeNumber: 1,
      
      subtitle: 'ฝนตกแล้ว',
      
    );

    const NotificationDetails platformChanaelDetails = NotificationDetails(iOS: iosNotificationDetails);

    await flutterLocalNotificationsPlugin.show(0, 'Alert', 'ตอนนี้ฝนตก', platformChanaelDetails);
  }
  Future<void> _shorwNotification2() async{
    const IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails(
      badgeNumber: 1,
      
      subtitle: 'ฝนหยุดแล้ว',
      
    );

    const NotificationDetails platformChanaelDetails = NotificationDetails(iOS: iosNotificationDetails);

    await flutterLocalNotificationsPlugin.show(0, 'Alert', 'ตอนนี้ฝนหยุดแล้ว', platformChanaelDetails);
  }
  
  @override
  Widget build(BuildContext context) {
    final _datarain = database.child('weatherapp/rainstatus').onValue.listen((event) {
      final String rainstatus = event.snapshot.value;
      
        _statusrain = '$rainstatus';
        if(_statusrain == 'rain'){
          return(_shorwNotification1());
        }else{
          return(_shorwNotification2());
        }
        
      
    });
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => HomeScreen(),
          binding: HomeBinding(),
        )
      ],
    );
  }
}