import 'dart:collection';
import 'dart:io';

import 'package:dnd_funds_manager/materials/IItem.dart';
import 'package:dnd_funds_manager/materials/armor.dart';
import 'package:dnd_funds_manager/materials/character.dart';
import 'package:dnd_funds_manager/materials/enums.dart';
import 'package:dnd_funds_manager/materials/regular_item.dart';
import 'package:dnd_funds_manager/materials/weapon.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';

class ItemList extends StatefulWidget {
  Character character;
  ItemList({super.key, required this.character});

  @override
  State<ItemList> createState() => _ItemListState(character: character);
}

class _ItemListState extends State<ItemList> {
  @override
  void initState() {
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
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 54, 54, 54),
        appBar: AppBar(
            title: Text('${character.name}\' items',
                style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontSize: 36)),
            centerTitle: true,
            backgroundColor:
                const Color.fromARGB(255, 129, 129, 129).withOpacity(0.4)),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [Expanded(child: itemList()), addButton()],
        ));
  }

  ListView itemList() {
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(
        height: 10,
      ),
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8),
          child: SizedBox(
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: () => _displaySubtraction(context, index, false),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                        width: 62,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: const Color.fromARGB(255, 129, 129, 129),
                                width: 3.0)),
                        child: SvgPicture.asset('media/plus.svg')),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onDoubleTap: () => _displayDesc(context, index),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: const Color.fromARGB(255, 129, 129, 129),
                                width: 3.0)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              items.keys.elementAt(index).showName,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text("Amount: ${items.values.elementAt(index)}",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _displaySubtraction(context, index, true),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                        width: 62,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: const Color.fromARGB(255, 129, 129, 129),
                                width: 3.0)),
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

  Padding addButton() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () => setState(() {
            //_displayAddingItem(context);
            _ItemTypeSelection(context);
          }),
          child: Container(
            alignment: Alignment.center,
            height: 100,
            decoration: BoxDecoration(
                border: Border.all(
                    width: 3, color: const Color.fromARGB(255, 129, 129, 129)),
                borderRadius: BorderRadius.circular(12)),
            child: const Text(
              "Add an item to the list",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ));
  }

  Future<void> _displayDesc(BuildContext context, int index) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(items.keys.elementAt(index).showName),
            content: Text(items.keys.elementAt(index).showDescription()),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('RETURN')),
            ],
          );
        });
  }

  Future<void> _displaySubtraction(
      BuildContext context, int index, bool subOrAd) async {
    TextEditingController controller = TextEditingController();

    if (subOrAd && items.values.elementAt(index) == 1) {
      setState(() {
        items.update(items.keys.elementAt(index), (value) => 0);
        items.removeWhere((key, value) => value <= 0);
        write_items();
      });
    } else {
      String nm = '';
      if (subOrAd) {
        nm = 'Input amount to subtract';
      } else {
        nm = 'Input amount to add';
      }
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                title: Text(nm),
                content: TextField(
                  controller: controller,
                  decoration: const InputDecoration(hintText: "amount"),
                ),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('CANCEL')),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          try {
                            int amt = 0;
                            if (subOrAd) {
                              amt = items.values.elementAt(index) -
                                  int.parse(controller.text);
                            } else {
                              amt = items.values.elementAt(index) +
                                  int.parse(controller.text);
                            }

                            items.update(
                                items.keys.elementAt(index), (value) => amt);
                            items.removeWhere((key, value) => value <= 0);
                            write_items();
                          } catch (e) {}
                        });
                        Navigator.pop(context);
                      },
                      child: const Text('PROCEED'))
                ]);
          });
    }
  }

  Future<void> _ItemTypeSelection(BuildContext context) async {
    String? selectedType;

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Select type of Item"),
            content: DropdownButton<String>(
              hint: const Text('Select type'),
              value: selectedType,
              items: <String>['Regular item', 'Weapon', 'Armor']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newVal) {
                setState(() {
                  selectedType = newVal;
                });
              },
            ),
            actions: [
              TextButton(
                onPressed: () {
                  switch (selectedType) {
                    case 'Regular item':
                      _displayAddingItem(context);
                    case 'Weapon':
                      _displayAddingWeapon(context, character);
                    case 'Armor':
                    _displayAddingArmor(context, character);
                  }
                },
                child: const Text('PROCEED'),
              ),
            ],
          );
        });
  }

  Future<void> _displayAddingItem(BuildContext context) async {
    TextEditingController nameController = TextEditingController();
    TextEditingController descController = TextEditingController();

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Item adding'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextField(
                  decoration:
                      const InputDecoration(hintText: "input new item's name"),
                  controller: nameController,
                ),
                TextField(
                  decoration: const InputDecoration(
                      hintText: 'input item\'s description (optional)'),
                  controller: descController,
                )
              ],
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('CANCEL')),
              TextButton(
                child: const Text('PROCEED'),
                onPressed: () {
                  setState(() {
                    if (descController.text.isEmpty) {
                      descController.text = ' ';
                    }

                    items[RegularItem(
                        name: nameController.text,
                        description: descController.text)] = 1;
                    write_items();
                    Navigator.pop(context);
                  });
                },
              )
            ],
          );
        });
  }

  Future<void> _displayAddingWeapon(
      BuildContext context, Character character) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return WeaponAdder(
          character: character,
          listOfItems: items,
        );
      },
    );

    if (result == true) {
      // Update the state of the parent widget if needed
      //_updateCharInfo();
      setState(() {});
    }
  }

  Future<void> _displayAddingArmor(BuildContext context, Character character) async {
    final result = await showDialog<bool>(context: context, builder: (context){return ArmorAdder(character: character, listOfItems: items);});
    if (result==true){setState(() {
      
    });}
  }
  

  write_items() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    File file = File('${directory.path}/${character.name}_items.txt');
    String itemsStringed = '';
    for (int i = 0; i < items.length; i++) {
      itemsStringed +=
          ('${items.keys.elementAt(i).showName}, ${items.keys.elementAt(i).showDescription()}, ${items.values.elementAt(i)}\n');
    }
    await file.writeAsString(itemsStringed);
  }

  load_items() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    File file = File('${directory.path}/${character.name}_items.txt');
    try {
      List<String> itemsStringed = file.readAsLinesSync();
      for (int i = 0; i < itemsStringed.length; i++) {
        List<String> loadedItem = itemsStringed[i].split(', ');
        //print(loadedItem);
        setState(() {
          items[RegularItem(name: loadedItem[0], description: loadedItem[1])] =
              int.parse(loadedItem[2]);
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}

class WeaponAdder extends StatefulWidget {
  final Character character;
  final HashMap<Item, int> listOfItems;

  const WeaponAdder(
      {super.key, required this.character, required this.listOfItems});

  @override
  _WeaponAdderState createState() => _WeaponAdderState();
}

class _WeaponAdderState extends State<WeaponAdder> {
  late TextEditingController nameController;
  late TextEditingController descController;
  late DiceType dice = DiceType.d4;
  late DamageType dmg = DamageType.none;
  late int ndices = 1;
  late int bonus = 0;
  late List<bool> traits = [];
  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    descController = TextEditingController();

    for (int i = 0; i < WeaponType.values.length; i++) {
      traits.add(false);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text('Weapon adding'),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration:
                  const InputDecoration(hintText: "input new weapon's name"),
              controller: nameController,
            ),
            TextField(
              decoration: const InputDecoration(
                  hintText: 'input weapon\'s description (optional)'),
              controller: descController,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Number of dices'),
                DropdownButton<int>(
                    value: ndices,
                    items: <int>[1, 2, 3, 4, 5, 6].map((int selectedValue) {
                      return DropdownMenuItem(
                          value: selectedValue,
                          child: Text(selectedValue.toString()));
                    }).toList(),
                    onChanged: (int? newValue) {
                      setState(() {
                        ndices = newValue!;
                      });
                    }),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Type of dices used'),
                DropdownButton<DiceType>(
                  value: dice,
                  onChanged: (DiceType? newValue) {
                    setState(() {
                      dice = newValue!;
                    });
                  },
                  items: DiceType.values.map((DiceType charClass) {
                    return DropdownMenuItem<DiceType>(
                      value: charClass,
                      child: Text(charClass.cln()),
                    );
                  }).toList(),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Weapon\'s bonus'),
                DropdownButton<int>(
                    value: bonus,
                    items: <int>[0, 1, 2, 3, 4, 5].map((int selectedValue) {
                      return DropdownMenuItem(
                          value: selectedValue,
                          child: Text(selectedValue.toString()));
                    }).toList(),
                    onChanged: (int? newValue) {
                      setState(() {
                        bonus = newValue!;
                      });
                    })
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Type of damage'),
                DropdownButton(
                  value: dmg,
                  onChanged: (DamageType? newValue) {
                    setState(() {
                      dmg = newValue!;
                    });
                  },
                  items: DamageType.values.map((DamageType dmgType) {
                    return DropdownMenuItem<DamageType>(
                        value: dmgType, child: Text(dmgType.cln()));
                  }).toList(),
                )
              ],
            ),
            Container(
              child: Text("Select weapon's traits"),
              height: 20,
            ),
            Container(
              height: 90,
              width: 150,
              child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: WeaponType.values.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Container(
                      alignment: Alignment.center,
                      height: 60,
                      width: 90,
                      decoration: BoxDecoration(
                          border: Border.all(width: 2, color: Colors.black),
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            WeaponType.values[index].cln(),
                            textAlign: TextAlign.center,
                          ),
                          Checkbox(
                            value: traits[index],
                            onChanged: (value) {
                              setState(() {
                                traits[index] = true;
                              });
                            },
                          )
                        ],
                      ),
                    );
                  }),
            )
          ],
        ),
                    actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('CANCEL')),
              TextButton(
                child: const Text('PROCEED'),
                onPressed: () {
                  setState(() {
                    if (descController.text.isEmpty) {
                      descController.text = ' ';
                    }
                    List<WeaponType> wt = [];
                    for(int i=0; i< traits.length; i++)
                    {
                      if(traits[i])
                      {
                        wt.add(WeaponType.values[i]);
                      }
                    } 
                    widget.listOfItems[Weapon(name: nameController.text, description: descController.text, attributes: wt, dice: dice, bonus: bonus, nDices: ndices, dmg: dmg)] = 1;
                    Navigator.pop(context, true);
                    Navigator.pop(context);
                  });
                },
              )
            ],
        );

  }
}

class ArmorAdder extends StatefulWidget
{
  final Character character;
  final HashMap<Item, int> listOfItems;

  const ArmorAdder(
      {super.key, required this.character, required this.listOfItems});

  @override
  _ArmorAdderState createState() => _ArmorAdderState();
}

class _ArmorAdderState extends State<ArmorAdder>
{
  late TextEditingController nameController;
  late TextEditingController descController;
  late int maxBonus;
  late Stat bonusStat;
  late int armorClass;
  late ArmorType armorType;
  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    descController = TextEditingController();
    maxBonus = 0;
    bonusStat = Stat.none;
    armorClass = 10;
    armorType = ArmorType.None;
  }

  @override
  void dispose() {
    nameController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context)
  {
    return AlertDialog
    (
      title: const Text('Armor adding'),
      content: Column
      (
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: 
        [
          TextField(
              decoration:
                  const InputDecoration(hintText: "input new armor's name"),
              controller: nameController,
            ),

            TextField(
              decoration: const InputDecoration(
                  hintText: 'input armor\'s description (optional)'),
              controller: descController,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Armor class'),
                DropdownButton<int>(
                    value: armorClass,
                    items: <int>[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20].map((int selectedValue) {
                      return DropdownMenuItem(
                          value: selectedValue,
                          child: Text(selectedValue.toString()));
                    }).toList(),
                    onChanged: (int? newValue) {
                      setState(() {
                        armorClass = newValue!;
                      });
                    })
              ],),

              Row
              (
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: 
                [
                  Text("Statistic for bonus"),
                  DropdownButton<Stat>
                  (
                    value: bonusStat,
                    items: Stat.values.map((Stat selectedStat)
                    {
                      return DropdownMenuItem(child: Text(selectedStat.cln()), value: selectedStat);
                    }).toList(),
                    onChanged: (Stat? newValue)
                    {
                      setState(() {
                          bonusStat = newValue!;
                      });
                    },
                  )
                ],
              ),

              Row
              (
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Max stat bonus'),
                DropdownButton<int>(
                    value: maxBonus,
                    items: <int>[0, 1, 2, 3, 4, 5].map((int selectedValue) {
                      return DropdownMenuItem(
                          value: selectedValue,
                          child: Text(selectedValue.toString()));
                    }).toList(),
                    onChanged: (int? newValue) {
                      setState(() {
                        maxBonus = newValue!;
                      });
                    })
              ],
              ),

              Row
              (
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: 
                [
                  Text('Type of armor'),
                  DropdownButton<ArmorType>
                  (
                    value: armorType,
                    items: ArmorType.values.map((ArmorType selectedType) {
                      return DropdownMenuItem(value: selectedType, child: Text(selectedType.cln()));
                    }).toList(),
                    onChanged: (ArmorType? newValue){
                      setState(() {
                        armorType = newValue!;
                      });
                    },
                  )
                ],
              )
        ],     
      ),

                         actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('CANCEL')),
              TextButton(
                child: const Text('PROCEED'),
                onPressed: () {
                  setState(() {
                    if (descController.text.isEmpty) {
                      descController.text = ' ';
                    }                     
                    widget.listOfItems[Armor(name: nameController.text, description: descController.text, maxBonus: maxBonus, armorClass: armorClass, bonusStat: bonusStat, armorType: armorType)] = 1;
                    Navigator.pop(context, true);
                    Navigator.pop(context);
                  });
                },
              )
            ],
    );
  }
}