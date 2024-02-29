import 'package:flutter/material.dart';
import 'package:supervisor/controller/guardListController.dart';
import 'package:supervisor/guard_management/total_guards.dart';
import 'package:supervisor/guards_Patroling/chat_guard.dart';
import 'package:supervisor/guards_Patroling/guard_noti.dart';
import 'package:supervisor/guards_Patroling/guard_patrol.dart';


import 'package:get/get.dart';

// ignore: must_be_immutable
class SupHomeScreen extends GetView<GuardListScreenState> {
   SupHomeScreen({super.key});
  GuardListController controller2 = Get.put(GuardListController());

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Supervisor App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/eSmart.png',
              width: 250,
              height: 200,
              alignment: Alignment.topCenter,
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext conntext) {
                  return GuardListScreenState();
                }));
              },
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.only(
                left: 55,
                right: 55,
              )),
              child:
                  const Text('Manage Routes', style: TextStyle(fontSize: 18)),
            ),
            // const SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.push(context,
            //         MaterialPageRoute(builder: (BuildContext conntext) {
            //       return NotiListScreenState();
            //     }));
            //   },
            //   style: ElevatedButton.styleFrom(
            //       padding: const EdgeInsets.only(
            //     left: 55,
            //     right: 55,
            //   )),
            //   child:
            //       const Text('Guard Notifications', style: TextStyle(fontSize: 18)),
            // ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext conntext) {
                  return GuardPatrolScreenState();
                }));
              },
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.only(
                left: 63,
                right: 63,
              )),
              child:
                  const Text('Guard\'s Patrol', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext conntext) {
                  return ChatListScreenState();
                }));
                
              },
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.only(
                left: 56,
                right: 56,
              )),
              child: const Text('Chat With Guard', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 150)
            
          ],
        ),
      ),
    );
  }
}
