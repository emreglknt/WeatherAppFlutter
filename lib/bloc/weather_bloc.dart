import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:meta/meta.dart';
import 'package:weather/weather.dart';

import '../utils.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc() : super(WeatherInitial()) {



    on<FetchWeather>((event, emit) async{
      emit(WeatherLoading());
      try {

        bool isConnected = await checkInternetConnection();
        if(!isConnected){
          emit(WeatherError(message: 'No Internet Connection'));
          return;
        }


        WeatherFactory wf = WeatherFactory(API_KEY,language: Language.ENGLISH);
        List<Weather> forecasts = (await wf.fiveDayForecastByCityName(event.cityName));
        emit(WeatherForecastSuccess(forecasts));
      }catch (error) {
        emit(WeatherError(message: 'An error occurred'));
      }
    });







  }
}
