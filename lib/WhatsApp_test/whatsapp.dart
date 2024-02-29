import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class Whatsapp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WhatsappState(); 
  }
}

double latitude = 40.7128; // Replace with the user's actual latitude
double longitude = -74.0060;

  openwhatsapp() async{
  var whatsapp ="+923453448111";
  var message = "Here is my current location:\n https://maps.google.com/?q=$latitude,$longitude";
  var whatsappURl_android = "whatsapp://send?phone="+whatsapp+"&text=$message";

    // android , web
    if( await canLaunch(whatsappURl_android)){
      await launch(whatsappURl_android);
    }else{
      print('Could not launch WhatsApp. Make sure WhatsApp is installed.');
    }
}

class _WhatsappState extends State<Whatsapp> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('location'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              openwhatsapp();
            },
              //sendLocationToWhatsApp(latitude, longitude);
            child: const Text('location'),
          ),
        ],
      ),
    );
  }

}
