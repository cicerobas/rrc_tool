import 'item_model.dart';

class Asstec {
  String id;
  String customer;
  String group;
  String nfe;
  String responsibleName;
  String date;

  List<Item> items;

  Asstec(this.id, this.customer, this.group, this.nfe, this.responsibleName,
      this.date, this.items);
}
