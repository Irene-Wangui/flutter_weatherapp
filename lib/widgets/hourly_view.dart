import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smokeless_weather/models/tomorrow_io_weather_model.dart';
import 'package:smokeless_weather/utils/get_weather_conditions.dart';
import 'package:smokeless_weather/utils/get_weather_img_name.dart';

class HourlyView extends StatelessWidget {
  final MinutelyHourly minutelyHourly;
  const HourlyView({super.key, required this.minutelyHourly});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top + 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: (MediaQuery.of(context).size.height / 2 - 120),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment(0, -0.7),
                  child: Column(
                    children: [
                      Text(
                        getWeatherCondition(minutelyHourly.minutelyHourlyValues.weatherCode),
                        style: TextStyle(
                          color: Colors.white54,
                        ),
                      ),
                      Align(
                        alignment: Alignment(0, -0.5),
                        child: Text(
                          "${minutelyHourly.minutelyHourlyValues.temperature}\u00B0",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 60,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Image.asset(
                          "assets/img/weather_icons/${getWeatherImgName(minutelyHourly.minutelyHourlyValues.weatherCode)}@2x.png",
                          width: MediaQuery.of(context).size.width / 3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Icon(
                    MdiIcons.weatherWindy,
                    color: Colors.white70,
                  ),
                  Text(
                    "${minutelyHourly.minutelyHourlyValues.windSpeed}Km/hr",
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    "windy",
                    style: TextStyle(color: Colors.white54),
                  ),
                ],
              ),
              Column(
                children: [
                  Icon(MdiIcons.waterPercent, color: Colors.white70),
                  Text(
                    "${minutelyHourly.minutelyHourlyValues.humidity}",
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
                    "${minutelyHourly.minutelyHourlyValues.humidity}",
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
    ));
  }
}
