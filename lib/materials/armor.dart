import 'package:dnd_funds_manager/materials/enums.dart';
import 'package:dnd_funds_manager/materials/regular_item.dart';

class Armor extends RegularItem
{
int armorClass;
Stat bonusStat = Stat.none;
int maxBonus = 0;

Armor({required this.armorClass, required super.description, required super.name});
}
