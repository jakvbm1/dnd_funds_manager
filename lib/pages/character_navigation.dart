import 'package:dnd_funds_manager/materials/character.dart';
import 'package:dnd_funds_manager/pages/character_page.dart';
import 'package:dnd_funds_manager/pages/home.dart';
import 'package:dnd_funds_manager/pages/item_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CharacterNavigation extends StatefulWidget
{
final Character char;

CharacterNavigation({super.key, required this.char});
  @override
  State<CharacterNavigation> createState() {
    return _CharacterNavigationState(char: char);
  }
}

class _CharacterNavigationState extends State<CharacterNavigation> 
{
  Character char;
  int currentPageIndex = 0;
  List<Widget> pages = [];


  _CharacterNavigationState({required this.char});

 

  @override
  Widget build(BuildContext context) 
  {
    pages.add(CharacterPage(character: char));
    pages.add(HomePage(selected_char: char));
    pages.add(ItemList(character: char));

    return Scaffold
    (
      bottomNavigationBar: NavigationBar
      (
        onDestinationSelected: (int index) 
        {
          setState(() 
          {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.blue,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>
        [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home', selectedIcon: Icon(Icons.home),),
          NavigationDestination(icon: Icon(Icons.monetization_on_outlined), label: 'Funds', selectedIcon: Icon(Icons.monetization_on),),
          NavigationDestination(icon: Icon(Icons.backpack_outlined), label: 'Equipment', selectedIcon: Icon(Icons.backpack),)
        ],
      ),

     body: pages[currentPageIndex]
    );
  }
  }