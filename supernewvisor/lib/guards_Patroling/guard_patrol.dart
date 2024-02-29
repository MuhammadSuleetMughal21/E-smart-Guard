import 'package:supervisor/controller/guardListController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GuardPatrolScreenState extends GetView<GuardListController> {
  GuardPatrolScreenState({super.key});

  @override
  final GuardListController controller = Get.put(GuardListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guard Live Patrolling'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                controller.fetchNoti();
              },
              icon: Icon(Icons.refresh))
        ],
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: controller.notiList.length,
          itemBuilder: (context, index) {
            
            final guardKey = controller.notiList[index];
            final guardValue = guardKey['user'];
            // ever(guardKey, (List<dynamic> newList) {
            //   // int lastIndex = newList.length - 1;

            //   // Check if the list is not empty and the last index has changed
            //   // if (newList.isNotEmpty && lastIndex != lastIndex) {
            //     // Update the last index in your controller or wherever you're storing it
            //     // lastIndex = lastIndex;

            //     // RxInt initialLength = newList.length.obs;
            //     // if (newList.length != notiList.length ) {
            //     //   print('im here');
            //     //   int lastValue = newList.length-1;
            //     //   final newValue = newList[lastValue]['user'];
            //     Get.snackbar(
            //       'List Updated',
            //       'The schedule list has been updated. New content: ',
            //       snackPosition: SnackPosition.TOP,
            //       duration: Duration(seconds: 3),
            //     );
            //   // }
            // });
            // // Get.find<GuardListController>();

            return Card(
              color: Colors.lightBlue,
              child: ListTile(
                title: Text(
                  '${guardValue['first_name']} ${guardValue['last_name']}',
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                ),
                subtitle: Text(
                  'Status: ${guardValue['petrolling']}\n Message: ${guardKey['content']}  ',
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                ),
                onTap: () {
                  controller.fetchLocation(
                      guardValue!['_id'], guardValue!['first_name']);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
