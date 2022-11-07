import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Global Secure Manager
/// Storage Sensational Data In
/// Local & Client

const ACCESS_TOKEN_KEY = 'ACCESS_TOKEN';
const REFRESH_TOKEN_KEY = 'REFRESH_TOKEN';

final secureStorage = FlutterSecureStorage();

/// Simulator IP is equals to PC
/// PC IP is different from emulator IP
/// when emulator OS is android
///
/// emulator localhost:port_number
/// OS: android
///
/// simulator localhost(PC localhost):port_number
/// OS: IOS
///
const emulatorIP = '10.0.2.2:3000';

const simulatorIP = '127.0.0.1:3000';

String getIPByPlatform() {
  final String ip = Platform.isIOS ? simulatorIP : emulatorIP;

  return ip;
}

