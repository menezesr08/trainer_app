import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:trainer_app/providers/food_tracking_providers.dart';

class FoodTrackingUI extends ConsumerStatefulWidget {
  const FoodTrackingUI({super.key});

  @override
  ConsumerState<FoodTrackingUI> createState() => _ConsumerFoodTrackingUIState();
}

class _ConsumerFoodTrackingUIState extends ConsumerState<FoodTrackingUI> {
  String? barcode;
  String? foodName;

  Future<void> scanBarcode() async {
    try {
      final foodtrackingRepo = ref.read(foodTrackingRepositoryProvider);
      final result = await BarcodeScanner.scan();
      final product = await foodtrackingRepo.getProduct(result.rawContent);
      final productName =
          product?.getProductNameBrand(OpenFoodFactsLanguage.ENGLISH, '');
      setState(() {
        barcode = result.rawContent;
        foodName = productName;
      });
    } catch (e) {
      setState(() {
        barcode = 'Failed to get barcode: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Track your foood'),
      ),
      body: Column(children: [
        Text('Scan result: $barcode\n', style: TextStyle(fontSize: 20)),
        ElevatedButton(
          onPressed: scanBarcode,
          child: Text('Start Barcode Scan'),
        ),
        SizedBox(
          height: 20,
        ),
        Text(foodName ?? '')
      ]),
    );
  }
}
