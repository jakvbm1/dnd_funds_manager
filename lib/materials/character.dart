class Character
{
String name;
int exp = 0;
CharClass charClass = CharClass.none;


Character({required this.name, this.exp = 0, this.charClass=CharClass.none});
}

enum CharClass {none, barbarian, bard, cleric, druid, fighter, monk, paladin, ranger, rogue, sorcerer, warlock, wizard}

extension classname on Enum
{
  String cln()
  {
    return toString().split('.').last;
  }
}