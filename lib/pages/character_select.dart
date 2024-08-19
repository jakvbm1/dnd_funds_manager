import 'dart:io';

import 'package:dnd_funds_manager/materials/character.dart';
import 'package:dnd_funds_manager/pages/home.dart';
import 'package:flutter/cupertino.dart';
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
        onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(selected_char: characters[index],))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container
          (
            height: 100,
            child: Text(characters[index].name, textAlign: TextAlign.center,),
            decoration: BoxDecoration
            (
              border: Border.all(color: const Color.fromARGB(255, 129, 129, 129).withOpacity(0.4), width: 2),
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
      appBar: bar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          
          Expanded(child: character_selection(context)),
          character_adding()
        ],
      )
    );
  }

  GestureDetector character_adding()
  {
    return GestureDetector
    (
      onTap: () 
      {
        _displayInputDialog(context);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container
        (
          height: 100,
          decoration: BoxDecoration
          (
            borderRadius: BorderRadius.circular(16),
            border: Border.all(width: 2, color: const Color.fromARGB(255, 129, 129, 129).withOpacity(0.4)
          ),
        ),
        child: Text('Dodaj postać', textAlign: TextAlign.center,),
      ),
    )
    );
  }

  AppBar bar()
  {
    return AppBar
    (
      title: Text('DND funds manager',
      style: TextStyle
      (
      fontSize: 36,
      fontWeight: FontWeight.w700,
      color: Colors.white
      ),
      ),
      centerTitle: true,
      backgroundColor: const Color.fromARGB(255, 129, 129, 129).withOpacity(0.4),
      
    );
  }

  Future<void> _displayInputDialog(BuildContext context) async
  {
    TextEditingController _textFieldControler = TextEditingController();

    return showDialog(
      context: context,
       builder: (context) 
       {
        return AlertDialog(
          title: Text('Podaj imię postaci'),
          content: TextField
          (
            controller: _textFieldControler,
            decoration: InputDecoration(hintText: "imię"),
          ),
          actions: <Widget> [
            TextButton(
              onPressed: (){Navigator.pop(context);},
             child: Text('ANULUJ')),

             TextButton(
              onPressed:() {
                setState(() {
                 characters.add(Character(name: _textFieldControler.text));
                 write_chars();
                });
                Navigator.pop(context);
                 
              },
              child: Text('DODAJ')
              )
          ]
        );
       }
    );
    
  }
}