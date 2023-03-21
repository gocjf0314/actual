import 'package:actual/common/const/data.dart';

class DataUtils {

  static pathToUrl(String path) => 'http://${getIPByPlatform()}$path';

}