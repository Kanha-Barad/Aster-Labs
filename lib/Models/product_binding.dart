import 'package:get/get.dart';
import '../Controllers/prod_controller.dart';
import '../Controllers/prod_controller.dart';

class ProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<Product_Controller>(Product_Controller());
  }
}
