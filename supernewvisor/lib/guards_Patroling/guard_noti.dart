import 'package:supervisor/controller/guardListController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotiListScreenState extends GetView<GuardListController> {
  NotiListScreenState({super.key});

  
  final GuardListController controller1 = Get.put(GuardListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guard '),
        centerTitle: true,
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: controller1.guardList.length,
          itemBuilder: (context, index) {
            final guardKey = controller1.guardList[index];

            return Card(
              color: Colors.lightBlue,
              child: ListTile(
                title: Text(
                  '${guardKey['first_name']} ${guardKey['last_name']}',
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                ),
                subtitle: Text('${guardKey['petrolling']}',style: const TextStyle(color: Colors.white, fontSize: 24),),
                // subtitle: Text(
                //   'Status: ${guardKey['petrolling']}\n ',
                //   style: const TextStyle(color: Colors.white, fontSize: 24),
                // ),
               
              ),
            );
          },
        ),
        
      ),
    );
  }
}
