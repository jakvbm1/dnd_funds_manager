import 'package:dnd_funds_manager/materials/IItem.dart';
import 'package:dnd_funds_manager/materials/character.dart';
import 'package:dnd_funds_manager/materials/enums.dart';

class Armor extends Item
{
int armorClass;
Stat bonusStat = Stat.none;
int maxBonus = 0;
ArmorType armorType = ArmorType.None;
String description;
String name;

Armor({ required this.description, required this.name, this.maxBonus = 0, this.armorType = ArmorType.None, this.armorClass = 0, this.bonusStat = Stat.none});

  @override
  String showDescription() {
    // TODO: implement showDescription
    String toReturn = '$description\nArmor Class$armorClass\nBonus stat:${bonusStat.cln()}(max: ${maxBonus.toString()})\nType: ${armorType.cln()}';
    return toReturn;
  }

  @override
  // TODO: implement showName
  String get showName => name;
}
