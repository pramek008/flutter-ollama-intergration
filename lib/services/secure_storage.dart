import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class SecureStorage {
  Future<void> write(String key, String value);

  Future<String?> read(String key);

  Future<void> delete(String key);

  Future<Map<String, String>> readAll();

  Future<void> deleteAll();

  Future<bool> containsKey(String key);
}

class SecureStorageImpl implements SecureStorage {
  SecureStorageImpl(this._secureStorage);

  final FlutterSecureStorage _secureStorage;

  String userKey = 'UserKey';
  String baseUrlKey = 'BaseUrlKey';
  String portKey = 'PortKey';
  String customPathKey = 'CustomPathKey';
  String customModelKey = 'CustomModelKey';

  @override
  Future<void> write(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  @override
  Future<String?> read(String key) async {
    return await _secureStorage.read(key: key);
  }

  @override
  Future<void> delete(String key) async {
    await _secureStorage.delete(key: key);
  }

  @override
  Future<Map<String, String>> readAll() async {
    return await _secureStorage.readAll();
  }

  @override
  Future<void> deleteAll() async {
    await _secureStorage.deleteAll();
  }

  @override
  Future<bool> containsKey(String key) async {
    return await _secureStorage.containsKey(key: key);
  }
}

extension AuthSecureStorage on SecureStorage {
  // DEFAULT
  static String defaultUrl = 'localhost';
  static int defaultPort = 11434;
  static String defaultPath = '/api/generate';
  static String defaultModel = 'gemma:2b';

  Future<void> writeUser(String value) async {
    await write('UserKey', value);
  }

  Future<String?> readUser() async {
    return await read('UserKey');
  }

  Future<void> deleteUser() async {
    await delete('UserKey');
  }

  Future<void> writeBaseUrl(String value) async {
    await write('BaseUrlKey', value);
  }

  Future<String> readBaseUrl() async {
    final baseUrl = await read('BaseUrlKey');
    if (baseUrl != null && baseUrl.isNotEmpty) {
      return baseUrl;
    } else {
      if (Platform.isAndroid) {
        return "10.0.2.2";
      } else if (Platform.isIOS) {
        return "127.0.0.1";
      } else {
        return defaultUrl;
      }
    }
    // return await read('BaseUrlKey');
  }

  Future<void> deleteBaseUrl() async {
    await delete('BaseUrlKey');
  }

  Future<void> writePort(String value) async {
    await write('PortKey', value);
  }

  Future<String> readPort() async {
    final port = await read('PortKey');
    if (port != null && port.isNotEmpty) {
      return port;
    } else {
      return defaultPort.toString();
    }
  }

  Future<void> deletePort() async {
    await delete('PortKey');
  }

  Future<void> writeCustomPath(String value) async {
    await write('CustomPathKey', value);
  }

  Future<String> readCustomPath() async {
    final customPath = await read('CustomPathKey');
    if (customPath != null && customPath.isNotEmpty) {
      return customPath;
    } else {
      return defaultPath;
    }
  }

  Future<void> deleteCustomPath() async {
    await delete('CustomPathKey');
  }

  Future<void> writeCustomModel(String value) async {
    await write('CustomModelKey', value);
  }

  Future<String> readCustomModel() async {
    final customModel = await read('CustomModelKey');
    if (customModel != null && customModel.isNotEmpty) {
      return customModel;
    } else {
      return defaultModel;
    }
  }

  Future<void> deleteCustomModel() async {
    await delete('CustomModelKey');
  }
}
