import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:discern/models/inventory_item.dart';
import 'package:discern/providers/auth_provider.dart';

Future<void> updateInventory(String itemType, int changeAmount) async {
  final userRef = FirebaseFirestore.instance
      .collection('users')
      .doc(AuthProvider.getUser().uid);
  
  final snapshot = await userRef.get();
  
  List<dynamic> inventory = (snapshot.data()!)['inventory'];
  final items = inventory.map(
    (e) => InventoryItem.fromJSON(e)
  ).toList();

  int count = 0;
  for (final item in items) {
    if (item.name == itemType) {
      count = item.count;
      break;
    }
  }

  InventoryItem item = new InventoryItem(name: itemType, count: count);

  bool containsItem = false;
  items.forEach((element) {
    if (element.name == item.name) {
      containsItem = true;
    }
  });

  var itemsJSON = items.map(
    (e) {
      if (item.name != e.name) return e.toJSON();
      
      e.count = e.count + changeAmount;
      return e.toJSON();
    }
  ).toList();

  if (!containsItem) itemsJSON.add(item.toJSON());

  await userRef.update({ 'inventory' : itemsJSON });
}
