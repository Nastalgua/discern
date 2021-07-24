import 'package:discern/ui/inventory.dart';
import 'package:flutter/material.dart';
import 'package:discern/constants/route_constants.dart';

import 'package:discern/main.dart';
import 'package:discern/ui/home.dart';
import 'package:discern/ui/product_details.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case HomeViewRoute:
        return MaterialPageRoute(builder: (_) => Home(cameras: cameras));
      case ProductDetailsViewRoute:
        return MaterialPageRoute(
          builder: (_) => ProductDetails(itemType: (args as String))
        );
      case InventoryViewRoute:
        return MaterialPageRoute(builder: (_) => Inventory());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: Text('error'),
          ),
          body: Center(
            child: Text('error'),
          ),
        );
      }
    );
  }
}
