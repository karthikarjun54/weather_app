# Build a Weather App
### Description:
My task is to create a simple weather app using Flutter that fetches weather data from a
public weather API and displays it to the user. The app should have two main screens: a
location selection screen and a weather display screen.
### Screen 1: Location Selection Screen:
- The user should be able to input a city name or select a city from a predefined list.
- Use any public weather API of your choice (e.g., OpenWeatherMap, WeatherAPI) to fetch weather data based on the selected location.
- Display a loading indicator while fetching data.
- Handle errors gracefully and display appropriate messages if the API request fails.
### Screen 2: Weather Display Screen:
- Once the data is fetched successfully, display the following information:
  - City name
  - Current temperature
  - Weather condition (e.g., sunny, cloudy, rainy) with an appropriate weather icon
  - Min and max temperature for the day
  - Humidity and wind speed
# Dependencies
### weather: ^3.1.1
The [weather](https://pub.dev/packages/weather) package is used to fetch weather data from the OpenWeatherMap API. It provides a simple and easy-to-use API to get current weather information, forecasts, and more.
### flutter_bloc: ^8.1.3
The [flutter_bloc](https://pub.dev/packages/flutter_bloc) package is used to manage the state of the application using the BLoC (Business Logic Component) pattern. It helps to separate the business logic from the UI, making the code more maintainable and testable.
# Getting Started
To run this project, follow these steps:
1. Clone the repository:
    ```bash
    git clone https://github.com/karthikarjun54/weather_app.git
    ```
    
2. Navigate to the project directory:
    ```bash
    cd weather_app
    ```
    
3. Install the dependencies:
    ```bash
    flutter pub get
    ```
    
4. Run the app:
    ```bash
    flutter run
    ```
