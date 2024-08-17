import 'package:cph_stocks/Screens/home_screen/notes_screen/notes_controller.dart';
import 'package:get/get.dart';

class NotesBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(NotesController());
  }
}
