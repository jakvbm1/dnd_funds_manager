import 'package:dnd_funds_manager/materials/IItem.dart';
import 'package:dnd_funds_manager/materials/character.dart';
import 'package:dnd_funds_manager/materials/enums.dart';
import 'package:dnd_funds_manager/materials/regular_item.dart';

class Armor extends Item
{
int armorClass;
Stat bonusStat = Stat.none;
int maxBonus = 0;
ArmorType armorType = ArmorType.None;
String description;
String name;

Armor({required this.armorClass, required this.description, required this.name});

  @override
  String showDescription() {
    // TODO: implement showDescription
    String toReturn = description + '\n' + 'Armor Class' + armorClass.toString() + '\n' + 'Bonus stat:' + bonusStat.cln() + '(max: ${maxBonus.toString()})' + '\n' + 
    'Type: ${armorType.cln()}';
    return toReturn;
  }

  @override
  // TODO: implement showName
  String get showName => name;
}
