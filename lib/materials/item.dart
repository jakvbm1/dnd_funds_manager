class Item
{
String name;
String description;
double weight = 0;

Item({required this.name, required this.description});
}

class Weapon extends Item
{
DiceType dice;
int nDices = 1;
DamageType dmg = DamageType.slashing;

Weapon({required this.dice, required super.name, required super.description});
}

class Armor extends Item
{
int armorClass;
Stat bonusStat = Stat.none;
int maxBonus = 0;

Armor({required this.armorClass, required super.description, required super.name});
}

enum DamageType {piercing, slashing}
enum DiceType {d4, d6, d8, d10, d12, d20}
enum Stat {none, strenght, dexterity, charisma, intelligence, wisdom, constitution}