import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:discern/models/inventory_item.dart';
import 'package:discern/providers/auth_provider.dart';

Future<void> updateInventory(String itemType, int changeAmount) async {
  final userRef = FirebaseFirestore.instance
      .collection('users')
      .doc(AuthProvider.getUser().uid);
  
  final snapshot = await userRef.get();
  
  List<dynamic> inventory = (snapshot.data()!)['inventory'];
  List<InventoryItem> items = inventory.map(
    (e) => InventoryItem.fromJSON(e)
  ).toList();

  int count = -1;
  for (final item in items) {
    if (item.name == itemType) {
      count = item.count;
      break;
    }
  }

  if (count == -1) {
    count = 1;
  }

  InventoryItem item = new InventoryItem(name: itemType, count: count);

  bool containsItem = false;
  items.forEach((e) {
    if (e.name == item.name) {
      containsItem = true;
      e.count = e.count + changeAmount;
    }
  });

  items = items.where((element) => element.count > 0).toList();

  var itemsJSON = items.map(
    (e) => e.toJSON()
  ).toList();

  if (!containsItem) itemsJSON.add(item.toJSON());

  await userRef.update({ 'inventory' : itemsJSON });
}
