# Build a Weather App
This is a simple weather application built using Flutter. The app fetches weather data and displays it to the user. It uses the [weather](https://pub.dev/packages/weather) package to get weather data and the [flutter_bloc](https://pub.dev/packages/flutter_bloc) package to manage the state of the application.

## Table of Contents
- [Dependencies](#dependencies)
- [Getting Started](#getting-started)
- [Download](#download)
- [Screenshot](#screenshot)
- [Usage](#usage)

## Dependencies
This project relies on the following packages:
- `flutter_bloc: ^8.1.3`: A predictable state management library that helps implement the BLoC (Business Logic Component) design pattern.
- `weather: ^3.1.1`: A package to fetch weather data from the OpenWeatherMap API.

## Getting Started
To run this project, follow these steps:
1. **Clone the repository:**
    ```bash
    git clone https://github.com/karthikarjun54/weather_app.git
    ```
    
2. **Navigate to the project directory:**
    ```bash
    cd weather_app
    ```
    
3. **Install the dependencies:**
    ```bash
    flutter pub get
    ```

4. **Run the app:**
    ```bash
    flutter run
    ```

## Download
[Download the APK](https://github.com/karthikarjun54/weather_app/raw/main/app-release.apk)

## Screenshot
<p align="center">
  <img src="https://github.com/karthikarjun54/weather_app/raw/main/location-selection-screen.jpeg" width="200" />
  <img src="https://github.com/karthikarjun54/weather_app/raw/main/progress-indicator-screen.jpeg" width="200" />
  <img src="https://github.com/karthikarjun54/weather_app/raw/main/weather-display-screen.jpeg" width="200" />
</p>

## Usage
### Main Entry Point
The main entry point of the application is in the `main.dart` file:
```dart
import 'package:flutter/material.dart'; // Importing the Flutter Material package for UI components.
import 'package:flutter_bloc/flutter_bloc.dart'; // Importing the Flutter BLoC package for state management.
import 'bloc/weather_bloc.dart'; // Importing the WeatherBloc class.
import 'package:weather_app_task/screens/location_selection_screen.dart'; // Importing the LocationSelectionScreen class.

// The entry point of the Flutter application.
void main() {
  runApp(const MainApp()); // Running the main application widget.
}

// The main application widget that sets up the app.
class MainApp extends StatelessWidget {
  const MainApp({super.key}); // Constructor for the MainApp class.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Disabling the debug banner.
      home: BlocProvider(
        create: (context) =>
            WeatherBloc(), // Creating and providing the WeatherBloc instance.
        child:
            LocationSelectionScreen(), // Setting the home screen of the app to LocationSelectionScreen.
      ),
    );
  }
}
```

## Location Selection Screen
The `LocationSelectionScreen` is where the user can input the city name to fetch the weather data.
```dart
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app_task/screens/weather_display_screen.dart';
import '../bloc/weather_bloc.dart';

class LocationSelectionScreen extends StatefulWidget {
  const LocationSelectionScreen({super.key});

  @override
  State<LocationSelectionScreen> createState() =>
      _LocationSelectionScreenState();
}

class _LocationSelectionScreenState extends State<LocationSelectionScreen> {
  final _formKey =
      GlobalKey<FormState>(); // The form uses a GlobalKey to manage its state.
  final _cityNameController = TextEditingController();

  @override
  void dispose() {
    _cityNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.white,
        ),
      ),
      body: SafeArea(
        // BlocListener listens for state changes and reacts accordingly (e.g., navigating to a new screen or showing a SnackBar).
        child: BlocListener<WeatherBloc, WeatherState>(
          listener: (context, state) {
            if (state is WeatherBlocSuccess) {
              // Navigate to weather display screen on success
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      WeatherDisplayScreen(weather: state.weather)));
              _cityNameController.text = '';
            } else if (state is WeatherBlocFailure) {
              // Show SnackBar on failure
              SnackBar snackBar = SnackBar(
                backgroundColor: Colors.red,
                content: Text(state.message),
                action: SnackBarAction(
                  backgroundColor: Colors.white,
                  textColor: Colors.black,
                  label: 'Close',
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                ),
              );

              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
          child: BlocBuilder<WeatherBloc, WeatherState>(
            // BlocBuilder builds the UI based on the current state (e.g., showing a loading indicator or the form).
            builder: (context, state) {
              if (state is WeatherBlocLoading) {
                // Show Progress Indicator on loading
                return Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Colors.blue),
                      SizedBox(width: 20),
                      Text(
                        'Please wait...',
                        style: TextStyle(fontSize: 16),
                      )
                    ],
                  ),
                );
              } else {
                return OrientationBuilder(
                  // OrientationBuilder is used to detect the screen orientation.
                  builder: (context, orientation) {
                    return SingleChildScrollView(
                      child: Center(
                        child: SizedBox(
                          // Adjust width based on orientation
                          // The width of the main SizedBox container is adjusted based on the orientation: it uses the full screen width in portrait mode and a fixed width of 500 in landscape mode.
                          width: orientation == Orientation.portrait
                              ? double.infinity
                              : 500,
                          height: MediaQuery.of(context).size.height -
                              kToolbarHeight,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Flexible(
                                      child:
                                          Image.asset('assets/location.png')),
                                  SizedBox(height: 10),
                                  // TextFormField includes validation logic to ensure the city name is provided before submission.
                                  TextFormField(
                                    controller: _cityNameController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "City name is required";
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      filled: true,
                                      labelText: 'City name',
                                      fillColor: Colors.transparent,
                                      prefixIcon: Icon(Icons.location_on),
                                      hintText: 'Enter your city name here...',
                                      hintStyle: TextStyle(color: Colors.grey),
                                      errorStyle: TextStyle(fontSize: 14),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  // The ElevatedButton triggers the weather fetching event using the BLoC pattern when the form is valid.
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.black,
                                        foregroundColor: Colors.white,
                                      ),
                                      onPressed: () {
                                        if (_formKey.currentState!.validate() ??
                                            false) {
                                          // Trigger event to fetch weather
                                          BlocProvider.of<WeatherBloc>(context)
                                              .add(FetchWeather(
                                                  _cityNameController.text));
                                        }
                                      },
                                      child: Text("Submit")),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
```

## Weather Display Screen
This widget displays detailed weather information such as temperature, weather conditions, humidity, and wind speed.
```dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weather/weather.dart';

class WeatherDisplayScreen extends StatefulWidget {
  // This class represents the screen that displays weather information.
  const WeatherDisplayScreen({super.key, required this.weather});
  final Weather
      weather; // It takes a Weather object as a parameter to display the weather data.
  @override
  State<WeatherDisplayScreen> createState() => _WeatherDisplayScreenState();
}

class _WeatherDisplayScreenState extends State<WeatherDisplayScreen> {
  // Method to get weather icon based on the weather condition code
  // This method returns an image widget based on the weather condition code.
  Widget getWeatherIcon(int code) {
    // Return appropriate icon based on the weather condition code range
    // It uses a series of switch statements to determine which image to display.
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

  // The weather icon, temperature, and description are displayed at the top.
  // The minimum and maximum temperatures are displayed in a row with icons.
  // Humidity and wind speed are displayed in another row with icons.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        title: Text(
            '${widget.weather.areaName!}'), // The title displays the area name from the Weather object.
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
          statusBarColor: Colors.transparent,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        // This widget detects the screen orientation and adjusts the width of the weather information container accordingly.
        child: OrientationBuilder(
          builder: (context, orientation) {
            return SingleChildScrollView(
              child: Center(
                child: SizedBox(
                  // It uses double.infinity for portrait mode and a fixed width of 500 for landscape mode.
                  width: orientation == Orientation.portrait
                      ? double.infinity
                      : 500,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Display the weather icon based on the condition code
                        getWeatherIcon(widget.weather.weatherConditionCode!),
                        // Display the temperature
                        Text(
                          '${widget.weather.temperature!.celsius!.round()}°C',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 55,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        // Display the weather main description
                        Text(
                          widget.weather.weatherMain!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 30),
                        // Display minimum and maximum temperature
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              Image.asset(
                                'assets/14.png',
                                scale: 8,
                              ),
                              const SizedBox(width: 5),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Temp Min',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    "${widget.weather.tempMin!.celsius!.round()} °C",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              )
                            ]),
                            Row(children: [
                              Image.asset(
                                'assets/13.png',
                                scale: 8,
                              ),
                              const SizedBox(width: 5),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Temp Max',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    "${widget.weather.tempMax!.celsius!.round()} °C",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              )
                            ])
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.0),
                          child: Divider(
                            color: Colors.grey,
                          ),
                        ),
                        // Display humidity and wind speed
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  width: 60,
                                  'assets/humidity.png',
                                  scale: 8,
                                ),
                                const SizedBox(width: 5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Humidity',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      "${widget.weather.humidity!.round()}%",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  'assets/9.png',
                                  scale: 8,
                                ),
                                const SizedBox(width: 5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Wind Speed',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      "${widget.weather.windSpeed!.round()} km/h",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
```
