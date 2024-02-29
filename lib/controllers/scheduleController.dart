import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guard/controllers/notificationController.dart';
import 'package:http/http.dart' as http;
import "dart:convert";
import 'package:guard/information.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'dart:async';

class ScheduleController extends GetxController {
  RxList<dynamic> scheduleList = <dynamic>[].obs;
  RxInt scannedTagsCount = 0.obs;
  RxInt maxTagsAllowed = 0.obs;
  RxInt scanCounter = 0.obs;
  RxInt totalLaps = 3.obs;
  RxInt secondsRemaining = 0.obs;
  RxBool isScanning = false.obs;
  Duration initialScanInterval = const Duration(seconds: 15);
  Duration scanInterval = const Duration(seconds: 15);
  Duration extendedDuration = const Duration(seconds: 30);
  NfcManager nfcManager = NfcManager.instance;
  var mounted = false.obs;
  RxBool done = true.obs;
  late Timer _timer;
  late Timer timer;
  RxInt? length;
  RxList<String> ids = <String>[].obs;
  NotificationController controller2 = Get.put(NotificationController());
  @override
  void onInit() {
    super.onInit();
    mounted = true.obs;
    for (int i = 0; i <= 1; i++) {
      fetchDataTrackers();
      update();
      startNfcScan();
      controller2.getCurrentLocation();
    }
    fetchDataTrackers();
    update();
    startNfcScan();

    // timer = Timer.periodic(Duration(seconds: 10), (timer) {
    //   if (mounted.value) {
    //     fetchDataTrackers();
    //     startNfcScan();
    //   } else {
    //     timer.cancel();
    //   }
    // });
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (secondsRemaining > 0) {
          secondsRemaining--;
          update();
          if (!done.value) {
            timer.cancel();
          } else if (isScanning.value && secondsRemaining.value == 0) {
            nfcManager.stopSession();
            controller2.extendNoti('forget');
            showErrorMessage();
            update();
          }
        }
      },
    );
  }

  void startNfcScan() async {
    print('object');
    for (int i = 0; i < scheduleList[0]['loop']!; i++) {
      print('object');
      await _scanOnce();

      isScanning.value = false;

      update();
    }
    isScanning.value = true;
    update();
  }

  Future<void> _scanOnce() async {
    try {
      update();
      await nfcManager.startSession(onDiscovered: (NfcTag tag) async {
        await Future.delayed(const Duration(seconds: 1));
         String tempRecord = "";
        var ndef = Ndef.from(tag);
        if (ndef != null && ndef.cachedMessage != null) {
          for (var record in ndef.cachedMessage!.records) {
            tempRecord =
                "$tempRecord ${String.fromCharCodes(record.payload.sublist(record.payload[0] + 1))}";
          }
          print(tempRecord);
          // ids.add(tempRecord.trim());
        }

        if (ids.contains(tempRecord.trim())) {
            print('not good');
            print(ids);

            // Show popup if ids list contains the same ID as tempRecord
          } else {
            ids.add(tempRecord.trim());
            scannedTagsCount++;
            secondsRemaining.value = initialScanInterval.inSeconds;
            update(); // Reset the timer
          }


        // scannedTagsCount++;
        // update();
        // secondsRemaining.value =
        //     initialScanInterval.inSeconds; // Reset the timer
        print('This is the count $scannedTagsCount');
        update();
        if (scannedTagsCount >= scheduleList[0]['nfc_trackers'].length) {
          scannedTagsCount = 0.obs;
          ids.clear();
          scanCounter++;
          update();
        }

        if (scanCounter >= scheduleList[0]['loop']) {
          await nfcManager.stopSession();
          controller2.Done();
          showDoneMessage();
          done.value = false;
          update();
        }
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  void showDoneMessage() {
    // controller.Done();
    if (isScanning.value) {
      Get.dialog(
        AlertDialog(
          title: const Text('Checkpoints completed'),
          content: const Text('you are all good'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
      update();
    }
  }

  void showErrorMessage() {
    if (isScanning.value) {
      // controller.extendNoti('forget') ;
      Get.dialog(
        AlertDialog(
          title: const Text('Time Ended'),
          content: const Text('Time run out'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
      update();
    }
  }

  void extendTimer() {
    if (isScanning.value && secondsRemaining.value != 0) {
      // controller.extendNoti('extend') ;
      scanInterval = extendedDuration;
      secondsRemaining.value = scanInterval.inSeconds;
      update();
    }
  }

  Future<void> fetchDataTrackers() async {
    update();
    String? userId = await StorageUtil.getUserId();
    String? token = await StorageUtil.getToken();
    final response = await http.get(
      Uri.parse(
          "http://192.168.198.240:8000/api/get-my-accessible-routes/$userId"),
      headers: <String, String>{
        'Content-Type': 'application.json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData1 = jsonDecode(response.body);
      // Map<String, dynamic> userData = responseData['data'];
      print(responseData1);
      print('success3');
      // await Future.delayed(const Duration(seconds: 3));
      scheduleList.value = responseData1['data'] as List<dynamic>;
      print(responseData1);
      startNfcScan();
    } else {
      Map<String, dynamic> responseData1 = jsonDecode(response.body);
      print(responseData1);
      print('Failed to fetch route list: ${response.statusCode}');
    }
  }

  void onClose() {
    _timer.cancel();
    super.onClose();
  }
}
