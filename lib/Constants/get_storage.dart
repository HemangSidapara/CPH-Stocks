import 'package:get_storage/get_storage.dart';

final getStorage = GetStorage();

Future<void> setData(String key, dynamic value) async => await getStorage.write(key, value);

int? getInt(String key) => getStorage.read(key);

String? getString(String key) => getStorage.read(key);

bool? getBool(String key) => getStorage.read(key);

double? getDouble(String key) => getStorage.read(key);

dynamic getData(String key) => getStorage.read(key);

List getList(String key) => getStorage.hasData(key)
    ? getStorage.read(key) is List
        ? getStorage.read(key)
        : []
    : [];

Future<void> removeData(String key) async => await getStorage.remove(key);

Future<void> clearData() async => await getStorage.erase();
