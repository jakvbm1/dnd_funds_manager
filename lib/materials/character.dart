class Character
{
String name;
int exp = 0;
CharClass charClass = CharClass.none;


Character({required this.name});
}

enum CharClass {none, barbarian, bard, cleric, druid, fighter, monk, paladin, ranger, rogue, sorcerer, warlock, wizard}

extension classname on CharClass
{
  String cln()
  {
    return toString().split('.').last;
  }
}