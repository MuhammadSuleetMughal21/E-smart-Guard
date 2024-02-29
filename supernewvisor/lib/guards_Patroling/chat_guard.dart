import 'package:supervisor/controller/guardListController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatListScreenState extends GetView<GuardListController> {
  ChatListScreenState({super.key});

  
  final GuardListController controller2 = Get.put(GuardListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat With Guard'),
        centerTitle: true,
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: controller2.guardList.length,
          itemBuilder: (context, index) {
            final guardKey = controller2.guardList[index];
            // final guardValues = guardKey['user'];

            return Card(
              color: Colors.lightBlue,
              child: ListTile(
                title: Text(
                  '${guardKey['first_name']} ${guardKey['last_name']}',
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                ),
                onTap: () {
                  controller2.openwhatsapp(guardKey['phone_number']);
                },
                // subtitle: Text('${guardKey['petrolling']}',style: const TextStyle(color: Colors.white, fontSize: 24),),
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
