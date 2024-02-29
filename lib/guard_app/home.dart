import 'package:flutter/material.dart';
import 'package:guard/controllers/notificationController.dart';
import 'package:guard/controllers/scheduleController.dart';
import 'package:guard/guard_app/scheduleG.dart';
import 'package:guard/guard_app/start.dart';
import 'package:get/get.dart';

class home extends StatelessWidget {
   home({super.key});
NotificationController controller = Get.put(NotificationController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Guard Home',
          textAlign: TextAlign.center,
        ),
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/eSmart.png',
                width: 250,
                //height: 150,
                alignment: Alignment.topCenter,
              ),
              const SizedBox(
                height: 60,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> startGstate()));
                },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.only(
                      left: 55,
                      right: 55,
                    )),
                child:
                    const Text('Start Patrol', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  controller.openwhatsapp();
                },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.only(
                      left: 40,
                      right: 40,
                    )),
                child: const Text('Create Incident',
                    style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                   Navigator.push(context, MaterialPageRoute(builder: (context)=>  ScheduleGState()));
                },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.only(
                      left: 38,
                      right: 38,
                    )),
                child: const Text('Check Schedule',
                    style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(
                height: 150,
              )
            ],
          ),
        ),
    );
  }
}
