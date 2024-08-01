import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app_flutter/bloc/weather_bloc.dart';
import 'package:weather_app_flutter/repo/CityResponse.dart';

import '../utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController cityController = TextEditingController();
  final CityRepository cityRepository = CityRepository();

  String selectedCity = 'Ankara';
  List<String> favoriteCities = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteCities();
    BlocProvider.of<WeatherBloc>(context).add(const FetchWeather("Ankara"));
  }

  void _loadFavoriteCities() async {
    List<String> favorites = await cityRepository.getFavoriteCities();
    setState(() {
      favoriteCities = favorites;
    });
  }

  void _toggleFavoriteCity(String cityName) async {
    if (favoriteCities.contains(cityName)) {
      await cityRepository.removeCityFromFavorites(cityName);
    } else {
      await cityRepository.addCityToFavorites(cityName);
    }
    _loadFavoriteCities(); //reload
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(),
        title: Padding(
          padding: const EdgeInsets.only(top: 20.0, bottom: 15),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: cityController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.34),
                    hintText: 'Enter city name',
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        final cityName = cityController.text;
                        if (cityName.isNotEmpty) {
                          BlocProvider.of<WeatherBloc>(context)
                              .add(FetchWeather(cityName));
                        }
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              DropdownButton<String>(
                value: selectedCity,
                dropdownColor: Colors.transparent.withOpacity(0.4),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCity = newValue!;
                    BlocProvider.of<WeatherBloc>(context)
                        .add(FetchWeather(selectedCity));
                  });
                },
                items:
                favoriteCities.map<DropdownMenuItem<String>>((String city) {
                  return DropdownMenuItem<String>(
                    value: city,
                    child: Text(city, style: TextStyle(color: Colors.white)),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.purple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 20),
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
          BlocBuilder<WeatherBloc, WeatherState>(
            builder: (context, state) {
              if (state is WeatherForecastSuccess) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Center(
                          child: getWeatherIcon(
                              state.forecasts[0].weatherConditionCode!),
                        ),
                        Center(
                          child: Card(
                            color: Colors.white.withOpacity(0.2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Stack(
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        '🌍${state.forecasts[0].areaName}',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 25,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Text(
                                        '${state.forecasts[0].temperature?.celsius?.toStringAsFixed(1)} °C',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 50,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      Text(
                                        '${state.forecasts[0].weatherDescription?.toUpperCase()}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 27,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${state.forecasts[0].date?.day}.${state.forecasts[0].date?.month}.${state.forecasts[0].date?.year}',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                  Positioned(
                                    bottom: -10,
                                    right: -10,
                                    child: IconButton(
                                      icon: Icon(
                                        favoriteCities.contains(
                                                state.forecasts[0].areaName)
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: favoriteCities.contains(
                                                state.forecasts[0].areaName)
                                            ? Colors.red
                                            : Colors.white,
                                      ),
                                      onPressed: () async {
                                        if (favoriteCities.contains(state.forecasts[0].areaName)) {
                                          await cityRepository.removeCityFromFavorites(state.forecasts[0].areaName!);
                                        } else {
                                          await cityRepository.addCityToFavorites(state.forecasts[0].areaName!);
                                        }
                                        _loadFavoriteCities(); // Reload favorite cities
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 22.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: Image.asset('assets/speed.png'),
                                  ),
                                  const SizedBox(width: 5),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Wind',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w300),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        '${state.forecasts[0].windSpeed} km/h',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: Image.asset('assets/humidity.png'),
                                  ),
                                  const SizedBox(width: 5),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Humidity',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w300),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        '${state.forecasts[0].humidity}%',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 2.0),
                          child: Divider(color: Colors.grey),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Next 5 Days',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.keyboard_double_arrow_down_sharp,
                                  size: 25,
                                  color: Colors.white,
                                ),
                                onPressed: _scrollToBottom,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            children:
                                List.generate(state.forecasts.length, (index) {
                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 7),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ListTile(
                                  leading: getWeatherIcon(state
                                      .forecasts[index].weatherConditionCode!),
                                  title: Text(
                                    '${state.forecasts[index].date?.day}' +
                                        '-' +
                                        '${state.forecasts[index].date?.month}' +
                                        '-' +
                                        '${state.forecasts[index].date?.year}' +
                                        '   ' +
                                        '${state.forecasts[index].date?.hour}' +
                                        ':' +
                                        '00',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  trailing: Text(
                                    '${state.forecasts[index].temperature?.celsius?.toStringAsFixed(1)} °C',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else if (state is WeatherLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is WeatherError) {
                return Center(child: Text(state.message));
              } else {
                return const Center(
                  child: Text(
                    'Error!\nPlease enter a valid city to get the weather forecast.',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w400),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget getWeatherIcon(int code) {
    switch (code) {
      case >= 200 && < 300:
        return Image.asset('assets/1.png');
      case >= 300 && < 400:
        return Image.asset('assets/2.png');
      case >= 500 && < 600:
        return Image.asset('assets/3.png');
      case >= 600 && < 700:
        return Image.asset('assets/4.png');
      case >= 700 && < 800:
        return Image.asset('assets/5.png');
      case == 800:
        return Image.asset('assets/6.png');
      case > 800 && <= 804:
        return Image.asset('assets/7.png');
      default:
        return Image.asset('assets/7.png');
    }
  }
}
