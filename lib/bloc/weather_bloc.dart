// Importing necessary packages
import 'package:bloc/bloc.dart'; // BLoC package for state management
import 'package:weather/weather.dart'; // Weather package to fetch weather data
import '../data/data.dart'; // Custom data file containing the API key

// Declaring part files which contain event and state definitions
part 'weather_event.dart';
part 'weather_state.dart';

// Definition of the WeatherBloc class which extends Bloc
class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  // Constructor initializes the BLoC with an initial state
  WeatherBloc() : super(WeatherBlocInitial()) {
    // Event handler for FetchWeather event
    on<FetchWeather>((event, emit) async {
      // Emitting loading state
      emit(WeatherBlocLoading());
      try {
        // Creating an instance of WeatherFactory with the API key
        WeatherFactory wf = WeatherFactory(API_KEY, language: Language.ENGLISH);
        // Fetching current weather data for the specified city
        Weather weather = await wf.currentWeatherByCityName(event.cityName);
        // Emitting success state with the fetched weather data
        emit(WeatherBlocSuccess(weather));
      } catch (e) {
        // Emitting failure state with the error message
        emit(WeatherBlocFailure(e.toString()));
      }
    });
  }
}
