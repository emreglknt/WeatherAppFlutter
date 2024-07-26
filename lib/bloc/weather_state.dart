part of 'weather_bloc.dart';






sealed class WeatherState extends Equatable{
    const WeatherState();
    @override
  List<Object> get props => [];
}


final class WeatherInitial extends WeatherState {}


final class WeatherLoading extends WeatherState {}


final class WeatherSuccess extends WeatherState {

    final  List<Weather> forecasts;
    const WeatherSuccess(this.forecasts);
    @override
    List<Object> get props => [forecasts];

}



final class WeatherError extends WeatherState {}
