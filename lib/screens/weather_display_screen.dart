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
