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
