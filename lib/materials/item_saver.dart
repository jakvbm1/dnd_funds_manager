import 'package:dnd_funds_manager/materials/armor.dart';
import 'package:dnd_funds_manager/materials/character.dart';
import 'package:dnd_funds_manager/materials/regular_item.dart';
import 'package:dnd_funds_manager/materials/weapon.dart';

class ItemSaver
{
  static String weaponString(Weapon weapon)
  {
    String toRet = 'w, ';
    toRet += '${weapon.name}, ${weapon.description}, ${weapon.bonus.toString()}, ${weapon.dice.cln()}, ${weapon.dmg.cln()}, ${weapon.nDices.toString()}, ';
    for(int i=0; i<weapon.attributes.length; i++)
    {
      toRet += weapon.attributes[i].cln();
      if(i < weapon.attributes.length-1)
      {
        toRet += ',';
      }
    }

    return toRet;
  }

  static String armorString(Armor armor)
  {
    String toRet ='a, ';

    toRet += '${armor.name}, ${armor.description}, ${armor.armorClass.toString()}, ${armor.armorType.cln()}, ${armor.bonusStat.cln()}, ${armor.maxBonus.toString()}';

    return toRet;
  }

  static String regularItemString(RegularItem regularItem)
  {
    String toRet ='r, ${regularItem.name}, ${regularItem.description}';
    return toRet;
  }
}