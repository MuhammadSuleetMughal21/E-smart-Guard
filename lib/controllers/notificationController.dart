import 'package:get/get.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:guard/information.dart';
import "dart:convert";
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

class NotificationController extends GetxController {
  RxList<dynamic> notifications = <dynamic>[].obs;
  late Position currentPosition;
  //  RxString? notiStatus;
  RxDouble? latitude;
  RxDouble? longitude;

  void onInit() {
    super.onInit();
    fetchNoti();
    getCurrentLocation();

        List<dynamic> previousList = ['ss'];

// Use ever to listen for changes in notiList
ever(
  notifications,
  (List<dynamic> newList) {
    // Check if previousList is not null and the length of newList is greater than previousList
    if (newList.length > previousList.length) {
      // Get the new element added to the list
      int newElement = newList.length-1;
      final newValue = newList[newElement]['content'];
      // final firstName = newList[newElement]['user'];
      print(newValue);

      Get.snackbar('$newValue','', colorText: Colors.white,isDismissible: true);
      
      // Perform actions with the new element
      print('New element added: ');
    }
    
    // Update previousList with the current newList
    previousList = newList.toList();
  });

   Timer.periodic(Duration(seconds: 3), (timer) {
      fetchNoti();
    });


    
    update();


 
  }

  Future<void> getCurrentLocation() async {
    // await Geolocator.openAppSettings();
    // await Geolocator.openLocationSettings();
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);

      currentPosition = position;
      latitude = position.latitude.obs;
      longitude = position.longitude.obs;
      update();
      print('done getting location');
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  Future<void> fetchNoti() async {
    String? userId = await StorageUtil.getUserId();
    String? token = await StorageUtil.getToken();

    final response = await http.get(
      //
      Uri.parse("http://192.168.198.240:8000/api/get-my-notifications/$userId"),
      headers: <String, String>{
        'Content-Type': 'application.json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      // Map<String, dynamic> userData = responseData['data'];
      print(responseData);
      print('success');

      notifications.value = responseData['data'] as List<dynamic>;
      update();
    } else {
      print(userId);
      print(token);
      print('Failed to fetch guard list: ${response.statusCode}');
    }
  }

  Future<void> extendNoti(String status) async {
    String? userId = await StorageUtil.getUserId();
    String? token = await StorageUtil.getToken();

    final url = Uri.parse(
        "http://192.168.198.240:8000/api/extend-or-forget-scan/$userId");
    final response = await http.post(
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
        url,
        body: jsonEncode({
          "extend": status,
        }));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      print(responseData);
      update();
      print('notiSend');
      fetchNoti();

      
    } else {
      // Handle errors here, e.g., show an error message.
      print('Signup failed with status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  
  openwhatsapp() async {
    var whatsapp = notifications[0]['phone_number'];
    var message =
        "Here is my current location:\n https://maps.google.com/?q=$latitude,$longitude";
    var whatsappURl_android =
        "whatsapp://send?phone=" + whatsapp + "&text=$message";

    // android , web
    if (await canLaunch(whatsappURl_android)) {
      await launch(whatsappURl_android);
    } else {
      print('Could not launch WhatsApp. Make sure WhatsApp is installed.');
    }
  }

  

  Future<void> Done() async {
    String? userId1 = await StorageUtil.getUserId();
    String? token1 = await StorageUtil.getToken();

    final url =
        Uri.parse("http://192.168.198.240:8000/api/petrolling-complete/$userId1");
    final response = await http.post(url, headers: {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token1',
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      print(responseData);
      update();
      print('Signup successful');
      // fetchNoti();

      notifications.refresh();
    } else {
      // Handle errors here, e.g., show an error message.
      print('Signup failed with status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }
}
