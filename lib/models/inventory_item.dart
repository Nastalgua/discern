class InventoryItem {
  final String name;
  
  int count;

  InventoryItem({
    required this.name,
    required this.count
  });

  static InventoryItem fromJSON(Map<String, dynamic> json) => InventoryItem(
    name: json['name'], 
    count: json['count']
  );

  Map<String, dynamic> toJSON() => {
    'name': this.name,
    'count': this.count
  };

}