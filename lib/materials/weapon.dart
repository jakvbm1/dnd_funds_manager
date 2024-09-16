import 'package:dnd_funds_manager/materials/IItem.dart';
import 'package:dnd_funds_manager/materials/character.dart';
import 'package:dnd_funds_manager/materials/enums.dart';

class Weapon extends Item
{
DiceType dice;
String name;
String description;
int nDices = 1;
int bonus = 0;
DamageType dmg = DamageType.Slashing;
List<WeaponType> attributes = [];

Weapon({required this.dice, required this.name, required this.description});

  @override
  String showDescription() {

    String atrString = '';
    for(int i=0; i<attributes.length; i++)
    {
      atrString += attributes[i].cln();
      if(i != attributes.length-1)
      {
        atrString += ', ';
      }
    }

    String toReturn = '$description\nDamage type: $dmg\nDices: amount $nDices type: ${dice.cln()} \n$atrString';
    return toReturn;
  }

  @override
  // TODO: implement showName
  String get showName => name;
}
