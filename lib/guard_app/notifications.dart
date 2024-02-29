// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guard/controllers/notificationController.dart';

// ignore: must_be_immutable, use_key_in_widget_constructors
class NotificationsScreenState extends GetView<NotificationController> {
  NotificationController controller2 = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: controller.notifications.length,
          itemBuilder: (context, index) {
            final notification = controller2.notifications[index];
            return Card(
              color: Colors.lightBlue,
              child: ListTile(
                title: Text(
                  notification['content'],
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                ),
                onTap: () {
                  controller.openwhatsapp();
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
