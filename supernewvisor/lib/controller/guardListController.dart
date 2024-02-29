import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import 'package:supervisor/information.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class GuardListController extends GetxController {
  RxList<dynamic> guardList = <dynamic>[].obs;
  RxList<dynamic> notiList = <dynamic>[].obs;
  RxList<dynamic> newList = <dynamic>[].obs;
  RxList<dynamic> trackerList = <dynamic>[].obs;
  RxList<dynamic> routeList = <dynamic>[].obs;
  Rx<String?> selectedGuardId = Rx<String?>(null);
  Rx<String?> selectedRouteName = Rx<String?>(null);
  RxList<String> selectedTrackerNames = <String>[].obs;
  RxInt? value = RxInt(0);
  final loopController = TextEditingController();
  late Position currentPosition;
  //  RxString? notiStatus;
  RxDouble? latitude;
  RxDouble? longitude;

  late Timer Time;

  @override
  void onInit() {
    super.onInit();

    List<dynamic> previousList = ['ss'];

// Use ever to listen for changes in notiList
ever(
  notiList,
  (List<dynamic> newList) {
    // Check if previousList is not null and the length of newList is greater than previousList
    if (newList.length > previousList.length) {
      // Get the new element added to the list
      int newElement = newList.length-1;
      final newValue = newList[newElement]['content'];
      final firstName = newList[newElement]['user'];
      print(newValue);

      Get.snackbar('${firstName['first_name']}', '${newValue}', colorText: Colors.white,isDismissible: true);
      
      // Perform actions with the new element
      print('New element added: ');
    }
    
    // Update previousList with the current newList
    previousList = newList.toList();
  });


    getCurrentLocation();
    fetchData();
    fetchDataRoutes();
    fetchDataTrackers();
    fetchNoti();
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

  openwhatsapp(var whatsapp) async {
    // var whatsapp = guardList[0]['phone_number'];
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

  Future<void> fetchDataTrackers() async {
    final response = await http.get(
      Uri.parse("http://192.168.198.240:8000/api/get-all-nfc-tracker"),
      headers: <String, String>{
        'Content-Type': 'application.json',
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData1 = jsonDecode(response.body);
      // Map<String, dynamic> userData = responseData['data'];
      print(responseData1);
      print('success3');
      trackerList.value = responseData1['data'] as List<dynamic>;
    } else {
      Map<String, dynamic> responseData1 = jsonDecode(response.body);
      print(responseData1);
      print('Failed to fetch route list: ${response.statusCode}');
    }
  }

  Future<void> fetchDataRoutes() async {
    final response = await http.get(
      Uri.parse("http://192.168.198.240:8000/api/get-all-routes"),
      headers: <String, String>{
        'Content-Type': 'application.json',
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData2 = jsonDecode(response.body);
      // Map<String, dynamic> userData = responseData['data'];
      print(responseData2);
      print('success2');
      routeList.value = responseData2['data'] as List<dynamic>;
    } else {
      Map<String, dynamic> responseData2 = jsonDecode(response.body);
      print(responseData2);
      print('Failed to fetch route list: ${response.statusCode}');
    }
  }

  Future<void> fetchData() async {
    String? userId = await StorageUtil.getUserId();
    String? token = await StorageUtil.getToken();

    final response = await http.get(
      Uri.parse("http://192.168.198.240:8000/api/get-all-guard-users/$userId"),
      headers: <String, String>{
        'Content-Type': 'application.json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData3 = jsonDecode(response.body);
      // Map<String, dynamic> userData = responseData['data'];
      print(responseData3);

      // String route = userData['route_name'];

      print('success5');

      guardList.value = responseData3['data'] as List<dynamic>;
    } else {
      Map<String, dynamic> responseData3 = jsonDecode(response.body);
      // Map<String, dynamic> userData = responseData['data'];
      print(responseData3);

      // print('Signup failed with status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      print('Failed to fetch guard list: ${response.statusCode}');
    }
  }

  Future<void> fetchNoti() async {
    String? userId = await StorageUtil.getUserId();
    String? token = await StorageUtil.getToken();

    final response = await http.get(
      Uri.parse("http://192.168.198.240:8000/api/get-notifcations/$userId"),
      headers: <String, String>{
        'Content-Type': 'application.json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData3 = jsonDecode(response.body);
      // Map<String, dynamic> userData = responseData['data'];
      print(responseData3);

      // String route = userData['route_name'];

      print('success5');

      notiList.value = responseData3['data'] as List<dynamic>;
       


      update();
      // notiList.refresh();
    } else {
      Map<String, dynamic> responseData3 = jsonDecode(response.body);
      // Map<String, dynamic> userData = responseData['data'];
      print(responseData3);

      // print('Signup failed with status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      print('Failed to fetch guard list: ${response.statusCode}');
    }
    
  }

  Future<void> manageRoute(
      String id, String routeName, List<String> trackers, int loops) async {
    String? userId = await StorageUtil.getUserId();
    String? token = await StorageUtil.getToken();
    final url =
        Uri.parse("http://192.168.198.240:8000/api/manage-guard-route/$userId");

    final response = await http.post(
        headers: <String, String>{
          'Content-type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        url,
        body: jsonEncode({
          'userId': id,
          'routeName': routeName,
          "loop": loops,
          "nfcTracker": trackers
        }));

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);

      print(responseData['routeName']);
      print('Signup successful');
      print(responseData);
    } else {
      print(routeName);
      print('register failed with status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  Future<void> fetchLocation(String id, String name) async {
    String? userId = await StorageUtil.getUserId();
    String? token = await StorageUtil.getToken();

    final url = Uri.parse("http://192.168.198.240:8000/api/get-my-location/$userId");
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "userId": id,
      }),
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      print(responseData);
      print('Success in fetching location');
      var snack = SnackBar(
        content: Text('Your notification has been sent to $name'),
      );
      ScaffoldMessenger.of(Get.context!).showSnackBar(snack);
    } else {
      print('Failed to fetch location: ${response.statusCode}');
    }
  }
}
