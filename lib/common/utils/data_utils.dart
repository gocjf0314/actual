import 'package:actual/common/const/data.dart';

class DataUtils {
  static String pathToUrl(String path) => 'http://${getIPByPlatform()}$path';

  static List<String> listPathsToUrls(List? list) {
    return list?.map((e) => pathToUrl(e)).toList() ?? [];
  }
}
