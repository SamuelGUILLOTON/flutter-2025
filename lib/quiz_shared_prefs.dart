import 'package:shared_preferences/shared_preferences.dart';


storeLastAPICall(int date) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('last_call', date);
}

Future<int> getLastAPICall() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt('last_call') ?? 0;
}