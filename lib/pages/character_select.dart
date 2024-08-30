import 'dart:io';
import 'dart:math';

import 'package:dnd_funds_manager/materials/character.dart';
import 'package:dnd_funds_manager/pages/character_navigation.dart';
import 'package:dnd_funds_manager/pages/character_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';

class SelectCharacterPage extends StatefulWidget
{
  @override
  State<SelectCharacterPage> createState() => _SelectCharacterPageState();
}

class _SelectCharacterPageState extends State<SelectCharacterPage> {
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
      final Directory dir2 = Directory(directory.path + '/characters');

      List<FileSystemEntity> files = await dir2.list().toList();
      final Iterable<File> fl = files.whereType<File>();

      setState(() {
  

      for(int i=0; i<files.length; i++)
      {
        if (files[i] is File)
        {
        String line =  (files[i] as File).readAsStringSync();
        List<String> attributes = line.split(', ');
        characters.add(Character(name: attributes[0], charClass: CharClass.values.byName(attributes[1]), exp: int.parse(attributes[2])));
        }
      }
      });

/*       final File file = File('${directory.path}/chars.txt');
      if(await file.exists())
      {
        setState(() {
          List<String> names = file.readAsLinesSync();
          for(int i=0; i<names.length; i++)
          {
            List<String> attributes = names[i].split(', ');
            if(attributes.length == 1)
            {
            characters.add(Character(name: names[i]));
            }

            else
            {
              characters.add(Character(name: attributes[0], charClass: CharClass.values.byName(attributes[1]), exp: int.parse(attributes[2])));
            }
          }
        });        
      } */
    }
    catch(e)
    {
      print(e.toString());
    }
  }

  write_chars() async
  {
    final Directory directory = await getApplicationDocumentsDirectory();
    final Directory dir2 = await Directory(directory.path + '/characters').create(recursive: true);
    List<File> files = [];
    for(int i=0; i<characters.length; i++)
    {
      files.add(File('${dir2.path}//${characters[i].name}.txt'));
      await files[i].writeAsString(characters[i].name + ', ' + characters[i].charClass.cln() + ', ' + characters[i].exp.toString());
    }
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
      return InkWell(
        highlightColor: Colors.blue,
        onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => CharacterNavigation(char: characters[index]))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container
          (
            height: 100,
            alignment: Alignment.center,
            child: Text
            (
            characters[index].name,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400)),
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
      backgroundColor: const Color.fromARGB(255, 54, 54, 54),
      appBar: bar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          characterSelectionText(),
          Expanded(child: character_selection(context)),
          character_adding()
        ],
      )
    );
  }

  Container characterSelectionText() => 
  Container
  (height: 40,
  alignment: Alignment.center,
   child: Text
   ("Character selection",
  textAlign: TextAlign.center,
  style: TextStyle
  (
    fontWeight: FontWeight.w500,
    fontSize: 18,
    color: Colors.white
  ),
  ),
   );

  InkWell character_adding()
  {
    return InkWell
    (
      highlightColor: Colors.blue,
      onTap: () 
      {
        _displayInputDialog(context);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container
        (
          height: 100,
          alignment: Alignment.center,
          decoration: BoxDecoration
          (
            borderRadius: BorderRadius.circular(16),
            border: Border.all(width: 2, color: const Color.fromARGB(255, 129, 129, 129).withOpacity(0.4)
          ),
        ),
        child: Text('Add character', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),),
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
          title: Text('Input character\'s name'),
          content: TextField
          (
            controller: _textFieldControler,
            decoration: InputDecoration(hintText: "name"),
          ),
          actions: <Widget> [
            TextButton(
              onPressed: (){Navigator.pop(context);},
             child: Text('CANCEL')),

             TextButton(
              onPressed:() {
                setState(() {
                 characters.add(Character(name: _textFieldControler.text));
                 write_chars();
                });
                Navigator.pop(context);
                 
              },
              child: Text('PROCEED')
              )
          ]
        );
       }
    );
    
  }
}