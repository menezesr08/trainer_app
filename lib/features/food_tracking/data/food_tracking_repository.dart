import 'package:openfoodfacts/openfoodfacts.dart';

class FoodTrackingRepository {
  FoodTrackingRepository() {
    _initializeConfigurations();
  }

  void _initializeConfigurations() {
    OpenFoodAPIConfiguration.userAgent = UserAgent(name: 'Nutrition App');

    OpenFoodAPIConfiguration.globalLanguages = <OpenFoodFactsLanguage>[
      OpenFoodFactsLanguage.ENGLISH
    ];

    OpenFoodAPIConfiguration.globalCountry = OpenFoodFactsCountry.UNITED_KINGDOM;
  }

  // Add methods to fetch and interact with OpenFoodFacts API here
  Future<Product?> getProduct(String barcode) async {
    final ProductQueryConfiguration configuration = ProductQueryConfiguration(
      barcode,
      language: OpenFoodFactsLanguage.ENGLISH,
      fields: [ProductField.ALL],
      version: ProductQueryVersion.v3,
    );

    final ProductResultV3 result =
        await OpenFoodAPIClient.getProductV3(configuration);

    if (result.status == ProductResultV3.statusSuccess) {
      return result.product;
    } else {
      throw Exception('product not found, please insert data for $barcode');
    }
  }
}
