import 'dart:io';

import 'package:dnd_funds_manager/materials/character.dart';
import 'package:dnd_funds_manager/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

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
        ),
        SizedBox(height: 20),
        InkWell
        (
          onTap: (){
            _displayInfoChanging(context, character);
          (context, character);},
          highlightColor: Colors.blue,
          child: Padding
          (
            padding: EdgeInsets.all(8),
            child: Container
            (
              height: 100,
              decoration: BoxDecoration
              (
              border: Border.all(color: const Color.fromARGB(255, 129, 129, 129).withOpacity(0.4), width: 2),
              borderRadius: BorderRadius.circular(16)
              ),
              alignment: Alignment.center,
              child: Text
              (
                'Modify values',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),)
          ,
        )
      ],
    );
  }

Future<void> _displayInfoChanging(BuildContext context, Character character) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) {
      return CharacterInfoDialog(character: character);
    },
  );

  if (result == true) {
    // Update the state of the parent widget if needed
    _updateCharInfo();
    setState(() {});
  }
}

_updateCharInfo() async
{
  final Directory directory = await getApplicationDocumentsDirectory();
  final Directory dir2 = await Directory(directory.path + '/characters').create(recursive: true);

  File file = File('${dir2.path}/${character.name}.txt');
  await file.writeAsString(character.name + ', ' + character.charClass.cln() +', ' + character.exp.toString());
}
}



class CharacterInfoDialog extends StatefulWidget {
  final Character character;

  CharacterInfoDialog({required this.character});

  @override
  _CharacterInfoDialogState createState() => _CharacterInfoDialogState();
}

class _CharacterInfoDialogState extends State<CharacterInfoDialog> {
  late TextEditingController expController;
  late CharClass startingClass;

  @override
  void initState() {
    super.initState();
    expController = TextEditingController();
    startingClass = widget.character.charClass;
  }

  @override
  void dispose() {
    expController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Character\'s info'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextField(
            decoration: InputDecoration(hintText: "input your character's exp"),
            controller: expController,
          ),
          DropdownButton<CharClass>(
            value: startingClass,
            onChanged: (CharClass? newValue) {
              setState(() {
                startingClass = newValue!;
              });
            },
            items: CharClass.values.map((CharClass charClass) {
              return DropdownMenuItem<CharClass>(
                value: charClass,
                child: Text(charClass.cln()),
              );
            }).toList(),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('CANCEL'),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              try {
                if (expController.text.isNotEmpty) {
                  widget.character.exp = int.parse(expController.text);
                }
                widget.character.charClass = startingClass;
              } catch (e) {}
            });
            Navigator.pop(context, true);
          },
          child: Text('PROCEED'),
        ),
      ],
    );
  }
}