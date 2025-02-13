import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smokeless_weather/models/tomorrow_io_weather_model.dart';
import 'package:smokeless_weather/utils/get_weather_img_name.dart';

class OverviewPage extends StatefulWidget {
  const OverviewPage({super.key});

  @override
  _OverviewPageState createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  late Future<TomorrowIoWeather> futureweather;
  Future<TomorrowIoWeather> fetchWeatherData() async {
    String url =
        "https://api.tomorrow.io/v4/weather/forecast?location=Nanyuki&apikey=dCb0TVRqI4c8j8BvE68QAehCAMcGSszN";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String, dynamic> rawWeatherData =
          jsonDecode(response.body) as Map<String, dynamic>;
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
                title: const Text(
                  'Nanyuki',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
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
                            bottomLeft: Radius.circular(
                                MediaQuery.of(context).size.width / 8),
                            bottomRight: Radius.circular(
                                MediaQuery.of(context).size.width / 8),
                          )),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              // height: 400,
                              child: Stack(
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        "mostly sunny",
                                        style: TextStyle(
                                          color: Colors.white54,
                                        ),
                                      ),
                                      Text(
                                        "24\u00B0",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 70,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SvgPicture.asset(
                                    "assets/svg/weather_icons/partly-cloudy-day.svg",
                                    semanticsLabel: "weather icon",
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/svg/weather_icons/wind-beaufort-0.svg",
                                      semanticsLabel: "Wind icon",
                                      width: MediaQuery.of(context).size.width /
                                          10,
                                    ),
                                    Text(
                                      "9km/h",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      "wind",
                                      style: TextStyle(color: Colors.white54),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/svg/weather_icons/raindrop.svg",
                                      semanticsLabel: "weather icon",
                                      width: MediaQuery.of(context).size.width /
                                          10,
                                    ),
                                    Text(
                                      "25%",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      "Humidity",
                                      style: TextStyle(color: Colors.white54),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Icon(
                                      Icons.visibility,
                                      color: Colors.white54,
                                    ),
                                    Text(
                                      "1.7km",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      "Visibility",
                                      style: TextStyle(color: Colors.white54),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Flexible(
                    flex: 1,
                    child: Container(
                      color: Colors.black87,
                      child: Column(
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
                                      Icon(Icons.chevron_right_sharp,
                                          color: Colors.blue)
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 120,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                ...weatherData.timelines.hourly.map(
                                  (e) => TextButton(
                                    style: TextButton.styleFrom(
                                        padding: EdgeInsets.all(2)),
                                    onPressed: () {
                                      log("Pressed hour column at time ${e.time.hour}");
                                    },
                                    child: Container(
                                      width: 70,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 6.0),
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        border: Border.all(
                                            color: Colors.grey.shade100,
                                            width: 0),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(12),
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            displayTime(e.time.hour),
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          SvgPicture.asset(
                                            "assets/svg/weather_icons/${getWeatherImgName(e.minutelyHourlyValues.weatherCode)}.png",
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                8,
                                          ),
                                          Text(
                                              "${e.minutelyHourlyValues.temperature}\u00B0",
                                              style: TextStyle(
                                                  color: Colors.white)),
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
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Text("snapshot.error");
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
