part of 'weather_bloc.dart';

// Sealed class definition for WeatherState
// This serves as a base class for all states of the WeatherBloc
sealed class WeatherState {
  // Constructor for the base state class
  const WeatherState();
}

// Initial state of the WeatherBloc
// This state represents the initial state before any action is taken
final class WeatherBlocInitial extends WeatherState {}

// Loading state of the WeatherBloc
// This state is emitted when a weather fetch operation is in progress
final class WeatherBlocLoading extends WeatherState {}

// Failure state of the WeatherBloc
// This state is emitted when a weather fetch operation fails
final class WeatherBlocFailure extends WeatherState {
  // Error message describing the reason for failure
  final String message;

  // Constructor to initialize the failure state with an error message
  const WeatherBlocFailure(this.message);
}

// Success state of the WeatherBloc
// This state is emitted when a weather fetch operation succeeds
final class WeatherBlocSuccess extends WeatherState {
  // The weather data fetched successfully
  final Weather weather;

  // Constructor to initialize the success state with the fetched weather data
  const WeatherBlocSuccess(this.weather);
}
