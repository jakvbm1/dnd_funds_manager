import 'dart:io';

import 'package:dnd_funds_manager/materials/character.dart';
import 'package:dnd_funds_manager/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';

class CharacterPage extends StatefulWidget
{
  @override
  State<CharacterPage> createState() => _CharacterPageState();
}

class _CharacterPageState extends State<CharacterPage> {
  List<Character> characters = [];

  @override
  void initState()
  {
    load_chars();
    super.initState();
  }

  load_chars() async
  {
        try
    {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/chars.txt');
      if(await file.exists())
      {
        setState(() {
          List<String> names = file.readAsLinesSync();
          for(int i=0; i<names.length; i++)
          {
            characters.add(Character(name: names[i]));
          }
        });        
      }
    }
    catch(e)
    {
      print(e.toString());
    }
  }

  write_chars() async
  {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/chars.txt');
    StringBuffer to_save = StringBuffer();
    for(int i=0; i<characters.length; i++)
    {
      to_save.writeln(characters[i].name);
    }
    await file.writeAsString(to_save.toString());
  }

  ListView character_selection(BuildContext context)
  {
    return ListView.separated
    (
    itemCount: characters.length,
    separatorBuilder: (context, index) => SizedBox(height: 20),
    scrollDirection: Axis.vertical,
    itemBuilder: (context, index) 
    {
      return GestureDetector(
        onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage())),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container
          (
            height: 100,
            child: Text(characters[index].name, textAlign: TextAlign.center,),
            decoration: BoxDecoration
            (
              border: Border.all(color: const Color.fromARGB(255, 68, 68, 68), width: 1),
              borderRadius: BorderRadius.circular(16)
            ),
          ),
        ),
      );
    },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold
    (
      body: character_selection(context)
    );
  }

  Container test_button(BuildContext context) {
    return Container
    (
      alignment: Alignment.center,
      height: 200,
      width: 200,
      decoration: BoxDecoration(color: const Color.fromARGB(255, 224, 202, 135)),
      child: TextButton(
        child: Text("przejdź dalej"),
         onPressed: () 
         {
          characters.add(Character(name: 'Ila'));
          write_chars();
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
      },),
    );
  }
}