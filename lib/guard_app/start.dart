import 'package:flutter/material.dart';
import 'package:guard/controllers/loginController.dart';
import 'package:guard/controllers/notificationController.dart';
import 'package:guard/controllers/scheduleController.dart';
import 'package:guard/guard_app/notifications.dart';
import 'package:get/get.dart';
import 'package:guard/logging/login.dart';

// ignore: must_be_immutable, camel_case_types
class startGstate extends GetView<ScheduleController> {
  @override
  ScheduleController controller = Get.put(ScheduleController());
  NotificationController controller1 = Get.put(NotificationController());
  LoginController controller3 = Get.put(LoginController());

  startGstate({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_null_comparison
    return controller.scheduleList == null && controller.scheduleList.isEmpty
        ? const CircularProgressIndicator()
        : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text('Guard Patrol'),
            ),
            body: Center(
              child: Obx(
                () => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.schedule,
                      size: 100,
                      color: Colors.white,
                      
                    ),
                    const SizedBox(height: 30),
                    Text(
                      '${controller.scanCounter} / ${controller.scheduleList[0]['loop']} ',
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    if (controller.scanCounter >= controller.scheduleList[0]['loop'])
                      const Text(
                        'Maximum laps done',
                        style: TextStyle(fontSize: 16, color: Colors.red),
                      ),
                    const SizedBox(height: 25),
                    Text(
                      '${controller.scannedTagsCount} out of ${controller.scheduleList[0]['nfc_trackers'].length} checkpoints scanned',
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Next scan in: ${controller.secondsRemaining} seconds',
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),

                    const SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        controller.extendTimer();
                        controller1.extendNoti('extend');
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.only(
                          left: 56,
                          right: 56,
                        ),
                      ),
                      child: const Text('Extend Timer',
                          style: TextStyle(fontSize: 18)),
                    ),
                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: () {
                        controller1.openwhatsapp();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.only(
                          left: 56,
                          right: 56,
                        ),
                      ),
                      child: const Text('Create Incident',
                          style: TextStyle(fontSize: 18)),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        controller3.logOut();
                        // 
                       Get.offAll(() => LoginPageState());
                        
                      },
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 78)),
                      child: const Text('End Patrol',
                          style: TextStyle(fontSize: 18)),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NotificationsScreenState()));
                      },
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 78)),
                      child: const Text('Notifications',
                          style: TextStyle(fontSize: 18)),
                    ),
                    // const SizedBox(
                    //   height: 100,
                    // ),
                  ],
                ),
              ),
            ),
          );
  }
}
