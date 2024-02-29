// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:flutter/material.dart';
import 'package:guard/controllers/scheduleController.dart';
import 'package:get/get.dart';



// ignore: must_be_immutable
class ScheduleGState extends GetView<ScheduleController> {
 ScheduleController controller = Get.put(ScheduleController());

  ScheduleGState({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule'),
        centerTitle: true,
      ),
      body: Obx(
        ()=> ListView.builder(
          itemCount: controller.scheduleList.length,
          itemBuilder: (context, index) {
            final scheduleS = controller.scheduleList[index];
            return Card(
              color: Colors.lightBlue,
              child: ListTile(
                title: Text('Route No: ${scheduleS['route_name']}',
                  style: const TextStyle(color: Colors.white, fontSize: 25),
                ),
                subtitle: Text('Route No: ${controller.scheduleList[index]['nfc_trackers']} \n No Loops: ${controller.scheduleList[index]['loop']}',
                  style: const TextStyle(color: Colors.white, fontSize: 25),),
              ),
            );
          },
        ),
      ),
    );
  }

  
}
