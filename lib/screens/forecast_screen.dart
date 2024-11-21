import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ForecastScreen extends StatelessWidget {
  final String cityName;
  final String unit; // 'metric' for Celsius or 'imperial' for Fahrenheit

  ForecastScreen({required this.cityName, required this.unit});

  /// Fetches the 5-day forecast data from the OpenWeather API
  Future<List<dynamic>> fetchForecast(String cityName, String unit) async {
    final apiKey = "2d1a700dce6365ee95ceb2d631b9920d"; // Replace with your OpenWeather API Key
    final Uri url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=$apiKey&units=$unit");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body)['list'];
    } else {
      throw Exception("Failed to load forecast data. Error: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$cityName - 5-Day Forecast"),
        backgroundColor: Colors.blueGrey,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchForecast(cityName, unit),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error fetching forecast: ${snapshot.error}"),
            );
          } else if (snapshot.hasData) {
            final forecastList = snapshot.data!;

            return ListView.builder(
              itemCount: forecastList.length,
              itemBuilder: (context, index) {
                // Each forecast object
                final forecast = forecastList[index];

                // Convert timestamp to readable date/time
                final dateTime = DateTime.parse(forecast['dt_txt']);
                final temperature = forecast['main']['temp'];
                final description = forecast['weather'][0]['description'];
                final iconCode = forecast['weather'][0]['icon'];

                // Determine the unit symbol
                final unitSymbol = unit == 'metric' ? '°C' : '°F';

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    leading: Image.network(
                      "https://openweathermap.org/img/wn/$iconCode@2x.png",
                      width: 50,
                      height: 50,
                    ),
                    title: Text(
                      "${dateTime.toLocal()}",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Temp: $temperature$unitSymbol, $description",
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text("No forecast data available"),
            );
          }
        },
      ),
    );
  }
}
