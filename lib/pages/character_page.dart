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

Column selectableOptions()
{
  return Column
  (
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: 
    [
      InkWell
      (
        onTap: () 
        {
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(selected_char: character,)));
        },
        highlightColor: Colors.blue,
        child: Padding
        (
          padding: EdgeInsets.all(8),
          child: Container
          (
            height: 80,
            decoration: BoxDecoration
            (
              border: Border.all(width: 2, color: Colors.black),
              borderRadius: BorderRadius.circular(12)
            ),
            child: Text('Go to funds'),
          )
        )
      ),

      InkWell
      (
        onTap: () 
        {
          
        },
        highlightColor: Colors.blue,
        child: Padding
        (
          padding: EdgeInsets.all(8),
          child: Container
          (
            height: 80,
            decoration: BoxDecoration
            (
              border: Border.all(width: 2, color: Colors.black),
              borderRadius: BorderRadius.circular(12)
            ),
            child: Text('Go to funds'),
          )
        )
      )
    ],
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold
    (
      body: selectableOptions()
    );
  }
}