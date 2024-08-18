import 'package:dnd_funds_manager/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CharacterPage extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return Scaffold
    (
      body: Container
      (
        alignment: Alignment.center,
        height: 200,
        width: 200,
        decoration: BoxDecoration(color: const Color.fromARGB(255, 224, 202, 135)),
        child: TextButton(
          child: Text("przejdź dalej"),
           onPressed: () 
           {
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
        },),
      )
    );
  }
  
}