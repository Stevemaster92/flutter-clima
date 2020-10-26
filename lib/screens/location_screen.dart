import 'package:clima/screens/city_screen.dart';
import 'package:clima/services/weather.dart';
import 'package:clima/utilities/constants.dart';
import 'package:flutter/material.dart';

class LocationScreen extends StatefulWidget {
  final locationWeather;

  LocationScreen({this.locationWeather});

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  int temp;
  String city, weatherIcon, message, description;
  WeatherModel model = WeatherModel();

  @override
  void initState() {
    super.initState();
    updateUI(widget.locationWeather);
  }

  void updateUI(dynamic data) {
    setState(() {
      if (data == null) {
        temp = 0;
        weatherIcon = "Error";
        message = "Unable to get weather data";
        city = "";
        return;
      }

      int condition = data["weather"][0]["id"];
      description = data["weather"][0]["description"];
      temp = (data["main"]["temp"] as double).floor();
      city = data["name"];

      weatherIcon = model.getWeatherIcon(condition);
      message = model.getMessage(temp);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/location_background.jpg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.5),
                BlendMode.dstATop,
              )),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    onPressed: () async {
                      var data = await model.getLocationWeather();
                      updateUI(data);
                    },
                    child: Icon(Icons.near_me, size: 50.0),
                  ),
                  FlatButton(
                    onPressed: () async {
                      var typedCity = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CityScreen()),
                      );

                      if (typedCity != null) {
                        var data = await model.getCityWeather(typedCity);
                        updateUI(data);
                      }
                    },
                    child: Icon(Icons.location_city, size: 50.0),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(weatherIcon, style: kConditionTextStyle),
                  Row(
                    children: [
                      Text(temp.toString(), style: kTempValueTextStyle),
                      SizedBox(width: 10.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: kTempUnitBoxDecoration,
                            child: Text("O", style: kTempUnitTextStyle),
                          ),
                          Text("now", style: kTempSubTextStyle),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      "$message",
                      textAlign: TextAlign.right,
                      style: kMessageTextStyle,
                    ),
                    SizedBox(height: 10.0),
                    Text.rich(
                      TextSpan(
                          text: "There's $description in ",
                          style: kDescriptionTextStyle,
                          children: [
                            TextSpan(
                                text: "$city",
                                style: TextStyle(fontStyle: FontStyle.italic))
                          ]),
                      textAlign: TextAlign.right,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
