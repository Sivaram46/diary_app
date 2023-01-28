import 'package:shared_preferences/shared_preferences.dart';

void setLockState(
    Function(bool) setIsLock, Function(bool) setIsLockFirstTime) async {
  final prefs = await SharedPreferences.getInstance();
  final isLock = prefs.getBool("isLock");
  if (isLock == null) {
    setIsLockFirstTime(true);
  } else {
    setIsLock(isLock);
    setIsLockFirstTime(false);
  }
}

Future<bool?> getLock() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool("password");
}

void setLockDisk(bool isLock) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool("isLock", isLock);
}
