import 'package:dnd_funds_manager/materials/armor.dart';
import 'package:dnd_funds_manager/materials/character.dart';
import 'package:dnd_funds_manager/materials/enums.dart';
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

  static Weapon stringToWeapon(String string)
  {
    List<String> atts = string.split(', ');
    List<WeaponType> weaponAtt = [];
    if(atts.length > 7)
    {
      for(int i = 7; i < atts.length; i++)
      {
        weaponAtt.add(WeaponType.values.byName(atts[i]));
      }
    }

    return Weapon(dice: DiceType.values.byName(atts[6]), name: atts[1], description: atts[2], bonus: int.parse(atts[3]), dmg: DamageType.values.byName(atts[4]), nDices: int.parse(atts[5]), attributes: weaponAtt);
  }

  static Armor stringToArmor(String string)
  {
    List<String> atts = string.split(', ');
    return Armor(name: atts[1], description: atts[2], armorType: ArmorType.values.byName(atts[3]), bonusStat: Stat.values.byName(atts[4]), maxBonus: int.parse(atts[5]));
  }

  static RegularItem stringToRegularItem(String string)
  {
    List<String> atts = string.split(', ');
    return RegularItem(name: atts[1], description: atts[2]);
  }
}