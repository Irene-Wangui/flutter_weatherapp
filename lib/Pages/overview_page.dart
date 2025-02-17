import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:smokeless_weather/models/tomorrow_io_weather_model.dart';
import 'package:smokeless_weather/utils/get_weather_img_name.dart';
import 'package:smokeless_weather/widgets/daily_view.dart';
import 'package:smokeless_weather/widgets/hourly_view.dart';

class OverviewPage extends StatefulWidget {
  const OverviewPage({super.key});

  @override
  _OverviewPageState createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  late Future<TomorrowIoWeather> futureweather;
  MinutelyHourly? selectedHour;
  Daily? selectedDay;

  String shortName(Location location) {
    List<String> nameparts = location.name.split(',');
    if (nameparts.length < 3) {
      return location.name;
    }

    List<String> newNameList = [nameparts.first, nameparts.last];
    return newNameList.join(',');
  }

  Future<TomorrowIoWeather> fetchWeatherData() async {
    String url = "https://api.tomorrow.io/v4/weather/forecast?location=Nanyuki&apikey=dCb0TVRqI4c8j8BvE68QAehCAMcGSszN";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String, dynamic> rawWeatherData = jsonDecode(response.body) as Map<String, dynamic>;
      final weatherData = TomorrowIoWeather.fromJson(rawWeatherData);
      log(weatherData.toString());
      return weatherData;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  @override
  void initState() {
    super.initState();
    futureweather = fetchWeatherData();
  }

  String displayTime(int hour) {
    if (hour == 0 || hour == 24) {
      return "12AM";
    } else if (hour == 12) {
      return "12PM";
    } else if (hour < 12) {
      return "$hour AM";
    } else {
      int pmTime = hour - 12;
      return "$pmTime PM";
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: futureweather,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final weatherData = snapshot.data!;
            return Scaffold(
              extendBodyBehindAppBar: true,
              backgroundColor: Colors.black87,
              appBar: AppBar(
                title: Text(
                  shortName(weatherData.location),
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                ),
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                centerTitle: true,
              ),
              body: Column(
                children: [
                  // Weather Information Section
                  Flexible(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.lightBlue.shade200,
                              Colors.lightBlue,
                            ],
                          ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(MediaQuery.of(context).size.width / 8),
                            bottomRight: Radius.circular(MediaQuery.of(context).size.width / 8),
                          )),
                      child: selectedDay != null
                          ? DailyView(daily: selectedDay ?? weatherData.timelines.daily.first)
                          : HourlyView(minutelyHourly: selectedHour ?? weatherData.timelines.hourly.first),
                    ),
                  ),

                  Flexible(
                    flex: 1,
                    child: Container(
                      color: Colors.black87,
                      child: ListView(
                        children: [
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Today",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    TextButton(
                                      onPressed: () {},
                                      child: Row(
                                        children: [
                                          Text(
                                            "Next 7 days",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          Icon(Icons.chevron_right_sharp, color: Colors.blue)
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 150,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    ...weatherData.timelines.hourly.map(
                                      (e) => TextButton(
                                        style: TextButton.styleFrom(padding: EdgeInsets.all(2)),
                                        onPressed: () {
                                          log("Pressed hour column at time ${e.time.hour}");
                                          setState(() {
                                            selectedHour = e;
                                            selectedDay = null;
                                          });
                                        },
                                        child: Container(
                                          width: 70,
                                          margin: const EdgeInsets.symmetric(horizontal: 6.0),
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            border: Border.all(color: Colors.grey.shade100, width: 0),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(12),
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                DateFormat.E().format(e.time),
                                              ),
                                              Text(
                                                displayTime(e.time.hour),
                                                style: TextStyle(color: Colors.white),
                                              ),
                                              Image.asset(
                                                "assets/img/weather_icons/${getWeatherImgName(e.minutelyHourlyValues.weatherCode)}.png",
                                                width: MediaQuery.of(context).size.width / 8,
                                              ),
                                              Text(
                                                "${e.minutelyHourlyValues.temperature}\u00B0",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "weekly",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        TextButton(
                                          onPressed: () {},
                                          child: Row(
                                            children: [
                                              Text(
                                                "This week",
                                                style: TextStyle(color: Colors.white),
                                              ),
                                              Icon(Icons.chevron_right_sharp, color: Colors.blue)
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 150,
                                    child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: [
                                        ...weatherData.timelines.daily.map(
                                          (e) => TextButton(
                                            style: TextButton.styleFrom(padding: EdgeInsets.all(2)),
                                            onPressed: () {
                                              log("Pressed hour column at time ${e.time.day}");
                                              setState(() {
                                                selectedDay = e;
                                                selectedHour = null;
                                              });
                                            },
                                            child: Container(
                                              width: 70,
                                              margin: const EdgeInsets.symmetric(horizontal: 6.0),
                                              decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                border: Border.all(color: Colors.grey.shade100, width: 0),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(12),
                                                ),
                                              ),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Text(
                                                    DateFormat.E().format(e.time), // weekday
                                                  ),
                                                  Text(
                                                    DateFormat.MMMd().format(e.time),
                                                    style: TextStyle(color: Colors.white), //displays month and day
                                                  ),
                                                  Image.asset(
                                                    "assets/img/weather_icons/${getWeatherImgName(e.dailyValues.weatherCodeMin)}.png",
                                                    width: MediaQuery.of(context).size.width / 8,
                                                  ),
                                                  Flexible(
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                          "${e.dailyValues.temperatureMax}\u00B0\t/${e.dailyValues.temperatureMin}",
                                                          style: TextStyle(
                                                            color: Colors.white60,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
