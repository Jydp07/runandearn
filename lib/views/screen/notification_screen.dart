import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:runandearn/views/common/text.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TitleText(title: "Notifications"),
        backgroundColor: Colors.black12,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        },icon: const FaIcon(FontAwesomeIcons.arrowLeft,color: Colors.white,),),
      ),
      
      backgroundColor: const Color.fromARGB(255, 60, 48, 48),
      body: const Center(
        child: NormText(title: "You don't have any notifications",),
        //TODO:Notification Screen
      ),
    );
  }
}