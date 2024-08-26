import 'package:dnd_funds_manager/materials/character.dart';
import 'package:dnd_funds_manager/pages/home.dart';
import 'package:flutter/material.dart';

class CharacterPage extends StatefulWidget
{
  final Character character;

  CharacterPage({super.key, required this.character});

  @override
  State<CharacterPage> createState() => _Character_pageState(character: character);
}

class _Character_pageState extends State<CharacterPage> {
Character character;
_Character_pageState({required this.character});



  @override
  Widget build(BuildContext context) {
    return Scaffold
    (
      backgroundColor: const Color.fromARGB(255, 54, 54, 54),
      appBar: AppBar(title: Text(character.name, style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white, fontSize: 36)), centerTitle: true, backgroundColor:Color.fromARGB(255, 129, 129, 129).withOpacity(0.4) ),
      body: characterInfo()
    );
  }

  Column characterInfo()
  {
    return Column
    (
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,

      children: 
      [
        SizedBox(height: 40),
        Row
        (
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: 
          [
            Container(height: 80, child: Text
            ('class: ' + character.charClass.name,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Colors.white),
            ),),
            Container(height: 80, child: Text
            (
              'experience: ' + character.exp.toString(),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Colors.white),
            ),)
          ],
        )
      ],
    );
  }
}