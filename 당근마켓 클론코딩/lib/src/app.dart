import 'package:bamtol_market_app/src/controllers/product_list_controller.dart';
import 'package:bamtol_market_app/src/pages/product_list_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ProductListController());
    
    return const ProductListPage();
  }
}
