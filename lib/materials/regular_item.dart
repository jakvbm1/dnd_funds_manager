import 'package:dnd_funds_manager/materials/IItem.dart';

class RegularItem extends Item {
  @override
  // TODO: implement name
  String get showName => name;

  @override
  String showDescription() {
    return description;
  }

  String name;
String description;
double weight = 0;

RegularItem({required this.name, required this.description});
}



