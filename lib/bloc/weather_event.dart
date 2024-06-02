part of 'weather_bloc.dart';

// Sealed class definition for WeatherEvent
// This serves as a base class for all events related to the WeatherBloc
sealed class WeatherEvent {
  // Constructor for the base event class
  const WeatherEvent();
}

// Event class for fetching weather data
class FetchWeather extends WeatherEvent {
  // The name of the city for which to fetch the weather data
  final String cityName;

  // Constructor to initialize the event with the city name
  const FetchWeather(this.cityName);
}
