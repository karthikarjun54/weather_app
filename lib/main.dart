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
