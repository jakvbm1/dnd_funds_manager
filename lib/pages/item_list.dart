import 'dart:collection';
import 'dart:io';

import 'package:dnd_funds_manager/materials/character.dart';
import 'package:dnd_funds_manager/materials/item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';

class ItemList extends StatefulWidget { 
  Character character;
  ItemList({required this.character});

   @override
  State<ItemList> createState() => _ItemListState(character: character);
}

class _ItemListState extends State<ItemList> {


    @override
  void initState()
  {
    load_items();
    //items[Item(name: 'miecz', description: 'gęsty')] = 1;
    //items[Item(name: 'łuk', description: 'długi')] = 3;
    //items[Item(name: 'tarcza', description: 'szmato')] = 1;
  }
  HashMap<Item, int> items = HashMap();
  //List<Item> items = [];
  Character character;

  _ItemListState({required this.character});

  @override
  Widget build(BuildContext context) {
    return Scaffold
    (
      backgroundColor: const Color.fromARGB(255, 54, 54, 54),
      appBar: AppBar(title: Text('${character.name}\' items', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white, fontSize: 36)), centerTitle: true, backgroundColor:Color.fromARGB(255, 129, 129, 129).withOpacity(0.4) ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: itemList()),
          addButton()
        ],
      )
    );
  }
  
  ListView itemList()
  {
    return ListView.separated
    (
      itemCount: items.length,
      separatorBuilder:(context, index) => SizedBox(height: 10,),
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) 
      {
        return Padding
        (
          padding: EdgeInsets.all(8),
          child: Container
          (
            height: 70,
            child: Row
            (
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.stretch,

              children: 
              [
              GestureDetector
              (
                onTap: () => _displaySubtraction(context, index, false),

                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container
                    (width: 62,
                    decoration: BoxDecoration
                  (
                   borderRadius: BorderRadius.circular(8),
                   border: Border.all(color: const Color.fromARGB(255, 129, 129, 129), width: 3.0)
                  ),
                  child: SvgPicture.asset('media/plus.svg')),
                ),
              ),
              Expanded(
                child: GestureDetector
                (
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container
                    (
                    decoration: BoxDecoration
                    (
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color.fromARGB(255, 129, 129, 129), width: 3.0)
                    ),
                      child: Column
                      (
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: 
                        [
                          Text(items.keys.elementAt(index).name, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),),
                          Text("Amount: "+ items.values.elementAt(index).toString(),style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector
              (
                onTap: () => _displaySubtraction(context, index, true),

                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container
                  (width: 62,
                  decoration: BoxDecoration
                 (
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color.fromARGB(255, 129, 129, 129), width: 3.0)
                 ),
                  child: SvgPicture.asset('media/minus.svg')),
                ),
              )
              ],
            ),
          ),
        );
      },
      
    );
  }

Padding addButton()
 {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: GestureDetector
    ( 
    onTap: ()=>setState(() {
      _displayAddingItem(context);
    }),

    child: Container
    (
      alignment: Alignment.center,
      height: 100,
      child: Text("Add an item to the list", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white), textAlign: TextAlign.center,),
      decoration: BoxDecoration
      (
        border: Border.all(width: 3, color: const Color.fromARGB(255, 129, 129, 129)),
        borderRadius: BorderRadius.circular(12)
      ),
    ),
    )
  );
 }

  Future<void> _displaySubtraction(BuildContext context, int index, bool subOrAd) async
  {
    TextEditingController controller = TextEditingController();

    if(subOrAd && items.values.elementAt(index) == 1)
    {
      setState(() {
      items.update(items.keys.elementAt(index), (value) => 0);
      items.removeWhere((key, value) => value <= 0 );
      write_items();
      });
    }

    else
    {
      String nm = '';
      if(subOrAd) {nm = 'Input amount to subtract';}
      else {nm = 'Input amount to add';}
    return showDialog(
      context: context,
       builder: (context) 
       {
        return AlertDialog(
          title: Text(nm),
          content: TextField
          (
            controller: controller,
            decoration: InputDecoration(hintText: "amount"),
          ),
          actions: <Widget> [
            TextButton(
              onPressed: (){Navigator.pop(context);},
             child: Text('CANCEL')),

             TextButton(
              onPressed:() {
                setState(() {


                  try
                  {
                  int amt = 0;
                  if(subOrAd)
                  {
                    amt = items.values.elementAt(index) - int.parse(controller.text);
                  }

                  else
                  {
                    amt = items.values.elementAt(index) + int.parse(controller.text);
                  }
  
                  items.update(items.keys.elementAt(index), (value) => amt);
                  items.removeWhere((key, value) => value <= 0 );
                  write_items();
                  }

                  catch(e)
                  {

                  }
                  

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

Future<void> _displayAddingItem(BuildContext context) async
{
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();

  return showDialog
  (context: context, 
  builder: (context)
  {
    return AlertDialog
    (
      title: Text('Item adding'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextField(
            decoration: InputDecoration(hintText: "input new item's name"),
            controller: nameController,
          ),
          TextField
          (
            decoration: InputDecoration(hintText: 'input item\'s description (optional)'),
            controller: descController,
          )
        ],
      ),
      actions: <Widget>
      [
        TextButton(
          onPressed: (){Navigator.pop(context);},
          child: Text('CANCEL')
        ),

        TextButton
        (
          child: Text('PROCEED'),
          onPressed: ()
          {
            setState(() 
            {
              if(descController.text.isEmpty) {descController.text=' ';}

              items[Item(name: nameController.text, description:  descController.text)] = 1;
              write_items();
              Navigator.pop(context);
            });
          },
        )
      ],
    );
  }
  );
}
  
write_items() async
  {
    final Directory directory = await getApplicationDocumentsDirectory();
    File file = File('${directory.path}/${character.name}_items.txt');
    String itemsStringed = '';
    for(int i=0; i<items.length; i++)
    {
      itemsStringed += (items.keys.elementAt(i).name + ', ' + items.keys.elementAt(i).description + ', ' + items.values.elementAt(i).toString() + '\n');
    }
    await file.writeAsString(itemsStringed);
  }

  load_items() async
  {
    final Directory directory = await getApplicationDocumentsDirectory();
    File file = File('${directory.path}/${character.name}_items.txt');
    try
    {
      List<String> itemsStringed = file.readAsLinesSync();
      for(int i=0; i<itemsStringed.length; i++)
      {
        List<String> loadedItem = itemsStringed[i].split(', ');
        //print(loadedItem);
        setState(() 
        {
          items[Item(name: loadedItem[0], description: loadedItem[1])] = int.parse(loadedItem[2]);
        });
      }
    }
    catch(e)
    {
      print(e.toString());
    }
  }
  
  }
