import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:weather_app_flutter/utils.dart';

class CityRepository {

  Future<void> addCityToFavorites(String cityName) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favoriteCities = prefs.getStringList('favorite_cities') ?? [];

    if (!favoriteCities.contains(cityName)) {
      favoriteCities.add(cityName);
      await prefs.setStringList('favorite_cities', favoriteCities);
      Fluttertoast.showToast(
          msg: "$cityName added to favorites",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0
      );
    } else {
      Fluttertoast.showToast(
          msg: "$cityName is already in favorites",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize:  16.0
      );
    }
  }

  Future<List<String>> getFavoriteCities() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('favorite_cities') ?? [];
  }



  Future<void> removeCityFromFavorites(String cityName) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favoriteCities = prefs.getStringList('favorite_cities') ?? [];

    if (favoriteCities.contains(cityName)) {
      favoriteCities.remove(cityName);
      await prefs.setStringList('favorite_cities', favoriteCities);
      Fluttertoast.showToast(
          msg: "$cityName removed from favorites",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.orange,
          textColor: Colors.white,
          fontSize: 16.0
      );
    } else {
      Fluttertoast.showToast(
          msg: "$cityName is not in favorites",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }



}
