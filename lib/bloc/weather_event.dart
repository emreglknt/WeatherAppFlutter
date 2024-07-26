part of 'weather_bloc.dart';

@immutable
abstract class WeatherEvent extends Equatable {
 const WeatherEvent();

 @override
 List<Object> get props => [];
}

class FetchWeather extends WeatherEvent {
 final String cityName;

 const FetchWeather(this.cityName);

 @override
 List<Object> get props => [cityName];
}
