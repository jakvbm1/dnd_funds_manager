import 'package:dnd_funds_manager/materials/IItem.dart';
import 'package:dnd_funds_manager/materials/enums.dart';
import 'package:dnd_funds_manager/materials/regular_item.dart';

class Weapon extends Item
{
DiceType dice;
String name;
String description;
int nDices = 1;
DamageType dmg = DamageType.Slashing;

Weapon({required this.dice, required this.name, required this.description});

  @override
  String showDescription() {
    String toReturn = description + '\n' + 'Damage type:' + dmg.toString() + '\n';
    return toReturn;
  }

  @override
  // TODO: implement showName
  String get showName => name;
}
