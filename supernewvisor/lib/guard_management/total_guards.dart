// import 'package:supervisor/guard_management/routes_assign.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:supervisor/controller/guardListController.dart';


class GuardListScreenState extends GetView<GuardListController> {
  // List<dynamic> guardList = [];
  // List<dynamic> trackerList = [];
  // List<dynamic> routeList = [];
  // List<String> selectedTrackerNames = [];
  // String? selectedGuardId;
  // String? selectedRouteName;
  // int? value;

  



  // Future<void> fetchDataTrackers() async {
  //   final response = await http.get(
  //     Uri.parse("http://192.168.0.115:8000/api/get-all-nfc-tracker"),
  //     headers: <String, String>{
  //       'Content-Type': 'application.json',
  //     },
  //   );
  //   if (response.statusCode == 200) {
  //     Map<String, dynamic> responseData1 = jsonDecode(response.body);
  //     // Map<String, dynamic> userData = responseData['data'];
  //     print(responseData1);
  //     print('success3');
  //     setState(() {
  //       trackerList = responseData1['data'] as List<dynamic>;
  //     });
  //   } else {
  //     Map<String, dynamic> responseData1 = jsonDecode(response.body);
  //     print(responseData1);
  //     print('Failed to fetch route list: ${response.statusCode}');
  //   }
  // }

  // Future<void> fetchDataRoutes() async {
  //   final response = await http.get(
  //     Uri.parse("http://192.168.0.115:8000/api/get-all-routes"),
  //     headers: <String, String>{
  //       'Content-Type': 'application.json',
  //     },
  //   );
  //   if (response.statusCode == 200) {
  //     Map<String, dynamic> responseData2 = jsonDecode(response.body);
  //     // Map<String, dynamic> userData = responseData['data'];
  //     print(responseData2);
  //     print('success2');
  //     setState(() {
  //       routeList = responseData2['data'] as List<dynamic>;
  //     });
  //   } else {
  //     Map<String, dynamic> responseData2 = jsonDecode(response.body);
  //     print(responseData2);
  //     print('Failed to fetch route list: ${response.statusCode}');
  //   }
  // }

  // Future<void> fetchData() async {
  //   String? userId = await StorageUtil.getUserId();
  //   String? token = await StorageUtil.getToken();

  //   final response = await http.get(
  //     Uri.parse("http://192.168.0.115:8000/api/get-all-guard-users/$userId"),
  //     headers: <String, String>{
  //       'Content-Type': 'application.json',
  //       'Authorization': 'Bearer $token',
  //     },
  //   );
  //   if (response.statusCode == 200) {
  //     Map<String, dynamic> responseData3 = jsonDecode(response.body);
  //     // Map<String, dynamic> userData = responseData['data'];
  //     print(responseData3);

  //     // String route = userData['route_name'];

  //     print('success5');
  //     setState(() {
  //       guardList = responseData3['data'] as List<dynamic>;
  //     });
  //   } else {
  //     Map<String, dynamic> responseData3 = jsonDecode(response.body);
  //     // Map<String, dynamic> userData = responseData['data'];
  //     print(responseData3);

  //     // print('Signup failed with status code: ${response.statusCode}');
  //     print('Response body: ${response.body}');
  //     print('Failed to fetch guard list: ${response.statusCode}');
  //   }
  // }

  // Future<void> manageRoute(
  //     String id, String routeName, List<String> trackers, int loops) async {
  //   String? userId = await StorageUtil.getUserId();
  //   String? token = await StorageUtil.getToken();
  //   final url =
  //       Uri.parse("http://10.0.2.2:8000/api/manage-guard-route/$userId");

  //   final response = await http.post(
  //       headers: <String, String>{
  //         'Content-type': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       },
  //       url,
  //       body: jsonEncode({
  //         'userId': id,
  //         'routeName': routeName,
  //         "loop": loops,
  //         "nfcTracker": trackers
  //       }));

  //   if (response.statusCode == 200) {
  //     Map<String, dynamic> responseData = jsonDecode(response.body);

  //     print(responseData['routeName']);
  //     print('Signup successful');
  //     print(responseData);
  //   } else {
  //     print(routeName);
  //     print('register failed with status code: ${response.statusCode}');
  //     print('Response body: ${response.body}');
  //   }
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('Manage Route'),
  //       centerTitle: true,
  //     ),
  //     body: ListView.builder(
  //       itemCount: guardList.length,
  //       itemBuilder: (context, index) {
  //         final guardKey = guardList[index];

  //         return Card(
  //           color: Colors.lightBlue,
  //           child: ListTile(
  //             title: Text('${guardKey['first_name']} ${guardKey['last_name']}', style:const TextStyle(
  //               color: Colors.white,fontSize: 24
  //             ),),
  //             subtitle: Text('Email: ${guardKey['email']}', style:const TextStyle(
  //               color: Colors.white,fontSize: 24
  //             ),),
  //             onTap: () {
  //               String guardId = guardKey['_id'];

  //               Navigator.pushReplacement(
  //                 context,
  //                 MaterialPageRoute(
  //                     builder: (context) => routeListScreen(
  //                           id: guardId,
  //                         )),
  //               );
  //             },
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }
  @override
  final GuardListController controller = Get.put(GuardListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Route'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Obx(
          ()=> Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButton<String>(
                        hint: Text('Select Guard'),
                        value: controller.selectedGuardId.value,
                        onChanged: (String? newValue) {
                          
                            controller.selectedGuardId.value = newValue;
                          
                        },
                        items: controller.guardList.map<DropdownMenuItem<String>>((guard) {
                          return DropdownMenuItem<String>(
                            value: guard['_id'],
                            child: Text(
                              '${guard['first_name']} ${guard['last_name']}',
                              style: TextStyle(fontSize: 20),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 55, bottom: 15),
                      child: DropdownButton<String>(
                        hint: Text('Select Route'),
                        value: controller.selectedRouteName.value,
                        onChanged: (String? newValue) {
                          
                            controller.selectedRouteName.value = newValue;
                          
                        },
                        items: controller.routeList.map<DropdownMenuItem<String>>((route) {
                          return DropdownMenuItem<String>(
                            value: route['name'],
                            child: Text(
                              route['name'],
                              style: TextStyle(fontSize: 20),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Wrap(
                spacing: 15,
                children: [
                  Container(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, bottom: 28),
                        child: MultiSelectDialogField<String>(
                          items: controller.trackerList
                              .map((tracker) => MultiSelectItem<String>(
                                  tracker['name'], tracker['name']))
                              .toList(),
                          initialValue: controller.selectedTrackerNames,
                          onConfirm: (List<String> values) {
                            
                              controller.selectedTrackerNames.value = values;
                            
                          },
                          title: Text('Select Trackers'),
                          buttonText: Text('Select Trackers'),
                          // chipDisplay: MultiSelectChipDisplay(
                          //   onTap: (value) {
                          //     setState(() {
                          //       selectedTrackerNames.remove(value);
                          //     });
                          //   },
                          // ),
                          // validator: (values) {
                          //   if (values == null || values.isEmpty) {
                          //     return 'Please select at least one tracker';
                          //   }
                          //   return null;
                          // },
                        ),
                      ),
                    ),
                  ),
        
                  const SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    width: 330,
                    child: TextField(
                      controller: controller.loopController,
                      keyboardType: TextInputType.number,
                      // controller: loopController,
                      decoration: const InputDecoration(
                        hintText: 'Number of loops',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        hintStyle: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              SingleChildScrollView(
                child: Container(
                  height: 430, // Set the desired height here
                  child: ListView.builder(
                    itemCount: controller.guardList.length,
                    itemBuilder: (context, index) {
                      final guardKey = controller.guardList[index];
                      final guardValues = guardKey['accessibleRoutes'];
                      // final guardValues = guardKey['accessibleRoutes'];
                      return Card(
                        color: Colors.lightBlue,
                        child: ListTile(
                          title: Text(
                            'Guard Name: ${guardKey['first_name']} ${guardKey['last_name']}',
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          ),
                          subtitle: 
                          Text(
                            'Assigned Route: ${guardValues}  ',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(
                onPressed: () {
                  
                    controller.value!.value = int.tryParse(controller.loopController.text) ?? 0;
                  
                  controller.manageRoute(controller.selectedGuardId.value!, controller.selectedRouteName.value!,
                      controller.selectedTrackerNames, controller.value!.value);
                },
                child: const Text('Assign',style: TextStyle( fontSize: 24)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
