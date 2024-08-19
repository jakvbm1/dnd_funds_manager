import 'dart:io';
import 'package:dnd_funds_manager/materials/character.dart';
import 'package:flutter/material.dart';
import 'package:dnd_funds_manager/materials/currency.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';

class HomePage extends StatefulWidget
{
  HomePage({super.key, required this.selected_char});
  final Character selected_char;
  @override
  _HomePageState createState() => _HomePageState(selectedChar: selected_char);
  
  
}

class _HomePageState extends State<HomePage>
{
  double funds = 0.0;
  List<Currency> currencies = [];
  Character selectedChar;

  _HomePageState({required this.selectedChar});

  _write() async
  {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/${selectedChar.name}_cash.txt');
    await file.writeAsString(funds.toString());
  }

  _read() async 
  { 
    try
    {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/${selectedChar.name}_cash.txt');
      if(await file.exists())
      {
        setState(() {
          String damn = file.readAsStringSync();
          funds = double.parse(damn);
        });        
      }
    }
    catch(e)
    {
      print(e.toString());
    }
  }

  @override
  void initState()
  {
    currencies = Currency.getCurrencies();
    _read();
    super.initState();
  }
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 54, 54, 54),
      appBar: appbar(),
      body: Column
      (
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: 
        [
          SizedBox(height: 40,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: displayCash(),
          ),
          Expanded(child: coinsSelection())
        ],
      )
    );
  }

    AppBar appbar() {
    return AppBar
    (
      title: Text(selectedChar.name+'\'s funds',
      style: TextStyle
      (
      fontSize: 36,
      fontWeight: FontWeight.w700,
      color: Colors.white
      ),
      ),
      centerTitle: true,
      backgroundColor: const Color.fromARGB(255, 129, 129, 129).withOpacity(0.4),
      
    );
  }

  Container displayCash()
  {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color.fromARGB(255, 129, 129, 129).withOpacity(0.4),
        
      ),
    child: Text
    (
      'Your current funds (in gold): ' + '\n' +funds.toString(),
      textAlign: TextAlign.center,
      style: TextStyle
      (
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: Colors.white
      ),
    ),
    );
  }

  ListView coinsSelection()
  {
    final myController = TextEditingController();
    return ListView.separated
    (separatorBuilder: (context, index) => SizedBox(height: 20,),
     itemCount: currencies.length,
     scrollDirection: Axis.vertical,
     itemBuilder: (context, index)
     {
      return Padding
      (
        padding: const EdgeInsets.all(8),
        child: Container
        (
          height: 80,
          decoration: BoxDecoration
          (
            border: Border.all(color: const Color.fromARGB(255, 129, 129, 129), width: 2.0),
            borderRadius: BorderRadius.circular(12)
          ),
          child: Row
          (
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: 
            [
              GestureDetector(
                onTap: (){sub_money(currencies[index].base_multiplier, myController.text);},
                child: Container(child: SvgPicture.asset('media/minus.svg'),               
                 //color: Colors.transparent,
                 height: 40,
                 width: 80,
                 decoration: BoxDecoration
                 (
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color.fromARGB(255, 129, 129, 129), width: 3.0)
                 ),
                 ),
              ),
              Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.center, children:
               [
                Text(currencies[index].name, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),),
                Container(child: TextField(controller: myController), width: 80, height: 40)
                ],),
              GestureDetector(
                onTap: (){add_money(currencies[index].base_multiplier, myController.text);},
                child: Container(child: SvgPicture.asset('media/plus.svg'),
                 //color: Colors.transparent,
                 height: 40,
                 width: 80,
                 decoration: BoxDecoration
                 (
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color.fromARGB(255, 129, 129, 129), width: 3.0)
                 ),
                   ),
              ),
            ],
          ),
        ),        
      );
     }, 
     );
  }

  void add_money(double multiplier, String value)
  {
    try
    {
    double amount = double.parse(value);
    setState(() {
      funds += multiplier * amount;
    });
    _write();
    }
    catch(e) {print(e.toString());}
  }

  void sub_money(double multiplier, String value)
  {
    try
    {
    double amount = double.parse(value);
    if(funds >= amount*multiplier)
    {
      setState(() 
      {
        funds -= amount*multiplier;
        if(funds < 0.01) {funds = 0;}
      });
      _write();
    }
    }
    catch(e) {print(e.toString());}
  }
}
