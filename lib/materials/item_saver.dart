import 'package:dnd_funds_manager/materials/armor.dart';
import 'package:dnd_funds_manager/materials/character.dart';
import 'package:dnd_funds_manager/materials/enums.dart';
import 'package:dnd_funds_manager/materials/regular_item.dart';
import 'package:dnd_funds_manager/materials/weapon.dart';

class ItemSaver
{
  static String weaponString(Weapon weapon, int amount)
  {
    String toRet = 'w, ${amount.toString()}, ';
    toRet += '${weapon.name}, ${weapon.description}, ${weapon.bonus.toString()}, ${weapon.dice.cln()}, ${weapon.dmg.cln()}, ${weapon.nDices.toString()}, ';
    for(int i=0; i<weapon.attributes.length; i++)
    {
      toRet += weapon.attributes[i].cln();
      if(i < weapon.attributes.length-1)
      {
        toRet += ', ';
      }
    }

    return toRet;
  }

  static String armorString(Armor armor, int amount)
  {
    String toRet ='a, ${amount.toString()}, ';

    toRet += '${armor.name}, ${armor.description}, ${armor.armorClass.toString()}, ${armor.armorType.cln()}, ${armor.bonusStat.cln()}, ${armor.maxBonus.toString()}';

    return toRet;
  }

  static String regularItemString(RegularItem regularItem, int amount)
  {
    String toRet ='r, ${amount.toString()}, ${regularItem.name}, ${regularItem.description}';
    return toRet;
  }

  static (Weapon, int) stringToWeapon(String string)
  {
    List<String> atts = string.split(', ');
    List<WeaponType> weaponAtt = [];
    if(atts.length > 8)
    {
      for(int i = 8; i < atts.length; i++)
      {
        weaponAtt.add(WeaponType.values.byName(atts[i]));
      }
    }

    return (Weapon(dice: DiceType.values.byName(atts[5]), name: atts[2], description: atts[3], bonus: int.parse(atts[4]), dmg: DamageType.values.byName(atts[6]), nDices: int.parse(atts[7]), attributes: weaponAtt), int.parse(atts[1]));
  }

  static (Armor, int) stringToArmor(String string)
  {
    List<String> atts = string.split(', ');
    return (Armor(name: atts[2], description: atts[3], armorType: ArmorType.values.byName(atts[5]),armorClass: int.parse(atts[4]), bonusStat: Stat.values.byName(atts[6]), maxBonus: int.parse(atts[7])), int.parse(atts[1]));
  }

  static (RegularItem, int) stringToRegularItem(String string)
  {
    List<String> atts = string.split(', ');
    return (RegularItem(name: atts[2], description: atts[3]), int.parse(atts[1]));
  }
}