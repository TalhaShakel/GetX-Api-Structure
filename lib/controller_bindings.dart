import 'package:get/instance_manager.dart';
import 'package:getx_api_structure/controllers/controller.dart';

class ControllerBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<Controller>(Controller());
  }
}
