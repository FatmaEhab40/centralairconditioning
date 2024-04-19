import 'dart:async' show Future;
import 'dart:convert';
import 'package:centralairconditioning/profile/page/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models.dart';

enum PrefKeys{
  email,
  password,
  periods,
  rooms,
  name,
  phone,
  imageProfile,
  userId
}

class PreferenceUtils {

  static Future<SharedPreferences> get _instance async {
    return _prefsInstance ??= await SharedPreferences.getInstance();
  }
  static SharedPreferences? _prefsInstance;

  static Future<SharedPreferences> init() async {
    _prefsInstance = await _instance;
    return _prefsInstance!;
  }

  static Future<bool> setEmail(PrefKeys key,String value) async {
    var prefs = await _instance;
    return prefs.setString(key.name, value) ;
  }
  static String getEmail(PrefKeys key,[String defValue='']) {
    return _prefsInstance!.getString(key.name) ?? defValue ;
  }

  static Future<bool> setPassword(PrefKeys key,String value) async {
    var prefs = await _instance;
    return prefs.setString(key.name, value) ;
  }
  static String getPassword(PrefKeys key,[String defValue='']) {
    return _prefsInstance!.getString(key.name) ?? defValue ;
  }

  static Future<bool> setName(PrefKeys key,String value) async {
    var prefs = await _instance;
    return prefs.setString(key.name, value) ;
  }
  static String getName(PrefKeys key,[String defValue='']) {
    return _prefsInstance!.getString(key.name) ?? defValue ;
  }

  static Future<bool> setPhone(PrefKeys key,String value) async {
    var prefs = await _instance;
    return prefs.setString(key.name, value) ;
  }
  static String getPhone(PrefKeys key,[String defValue='']) {
    return _prefsInstance!.getString(key.name) ?? defValue ;
  }

  static Future<bool> setUserId(PrefKeys key,String value) async {
    var prefs = await _instance;
    return prefs.setString(key.name, value) ;
  }
  static String getUserId(PrefKeys key,[String defValue='']) {
    return _prefsInstance!.getString(key.name) ?? defValue ;
  }

  static Future<bool> setImageProfile(PrefKeys key,String userId) async {
    var prefs = await _instance;
    return prefs.setString(key.name, userId) ;
  }
  static String getImageProfile(PrefKeys key,[String defValue='']) {
    return _prefsInstance!.getString(key.name) ?? defValue ;
  }

  static Future<List<User>> getUsers() async {
    final prefs = await _instance;
    List<String> userDataJsonList = prefs.getStringList('users') ?? [];
    return userDataJsonList.map((e) => User.fromMap(json.decode(e))).toList();
  }
  static Future<void> setUsers(List<String> users) async {
    var prefs = await _instance;
    prefs.setStringList('users', users);
  }

  static Future<bool> setPeriods(PrefKeys key, List<Periods> values) async {
    var prefs = await _instance;
    List<String> periodsStrings = values.map((p) => json.encode(p.toJson())).toList();

    return prefs.setStringList(key.name, periodsStrings);
  }
  static Future<List<Periods>> getPeriods(PrefKeys key, [List<Periods> defValue = const []]) async {
    final prefs = _prefsInstance;

    if (prefs == null) {
      return defValue;
    }
    String? periodsString = prefs.getString(key.name);
    //print(periodsString);
    List<String> periodsStrings = periodsString?.split(',') ?? defValue.map((p) => json.encode(p.toJson())).toList();
   // print(periodsStrings);
    List<Periods> periodsList = periodsStrings.map((p) => Periods.fromMap(json.decode(p))).toList();
    return periodsList;
  }

  static Future<bool> setRooms(PrefKeys key,List<Rooms> values) async {
    var prefs = await _instance;
    List<String> roomsStrings = values.map((p) => json.encode(p.toJson())).toList();
    return prefs.setStringList(key.name, roomsStrings);
  }
  static Future<List<Rooms>> getRooms(PrefKeys key) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(key.name);
    if (data == null) return [];
    final List<dynamic> decodedData = jsonDecode(data.join(','));
    return decodedData.map((e) => Rooms.fromMap(e)).toList();
  }


}
