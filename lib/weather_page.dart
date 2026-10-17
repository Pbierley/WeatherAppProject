import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const apikey = 'f74cd0558084f85ba83aecab3fb282d3';

// PAGE 2: WEATHER PAGE

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});


  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  bool isLoading = true;

  String cityName = '';
  String weatherDescription = '';
  double temp = 0.0;
  int humidity = 0;

  @override
  void initState() {
    super.initState();
    loadWeatherData();
  }
  loadWeatherData() async {
    await Future.delayed(Duration(seconds: 3),);
    http.Response response = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/weather?lat=39.029425&lon=-84.465003&appid=$apikey&units=imperial'));
    print(response.statusCode);
    print(response.body);
    String data = response.body;
    var longitude = jsonDecode(data) ['coord'] ['lon'];
    var latitude = jsonDecode(data) ['coord'] ['lat'];
    print(longitude);
    print(latitude);
    weatherDescription = jsonDecode(data) ['weather'] [0] ['description'];
    temp = jsonDecode(data) ['main'] ['temp'];
    humidity = jsonDecode(data) ['main'] ['humidity'];
    cityName = jsonDecode(data) ['name'];
    setState(() {
      isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Current Weather')),
      ),
      body: isLoading
          ? Center(child: SpinKitSpinningLines(color: Colors.black))
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.wb_cloudy,
              size: 80,
              color: Colors.lightBlue,
            ),
            SizedBox(height: 20),
            Text(
              cityName, // 3. The variable is now accessible here
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              // Note: OpenWeather returns Kelvin by default unless you append &units=imperial to your API URL.
              // I left this hardcoded like your original snippet, but you can swap it for $temp!
              '$temp°F', // Dynamically showing temperature
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              weatherDescription, // Dynamically showing description
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              'Humidity: $humidity%', // Dynamically showing humidity
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                print('back button pressed');
                Navigator.pop(context);
              },
              child: Text('Back to Home'),
            ),
          ],
        ),
      ),

    );
  }
}

