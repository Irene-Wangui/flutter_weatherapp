import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smokeless_weather/models/location_result_model.dart';
import 'package:smokeless_weather/utils/location_service.dart';

class LocationResultsPage extends StatefulWidget {
  final String query;
  const LocationResultsPage({super.key, required this.query});

  @override
  _LocationResultsPageState createState() => _LocationResultsPageState();
}

class _LocationResultsPageState extends State<LocationResultsPage> {
  late Future<List<LocationResult>> futureLocations;

  @override
  void initState() {
    super.initState();
    futureLocations = searchLocation(widget.query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: ElevatedButton(
                  onPressed: () {
                    log("Meru clicked");
                    setState(() {
                      futureLocations = searchLocation("Meru");
                    });
                  },
                  child: Text("Meru"),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: ElevatedButton(
                  onPressed: () {
                    log("Embu clicked");
                    setState(() {
                      futureLocations = searchLocation("Embu");
                    });
                  },
                  child: Text("Embu"),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: ElevatedButton(
                  onPressed: () {
                    log("Nyeri clicked");
                    setState(() {
                      futureLocations = searchLocation("Nyeri");
                    });
                  },
                  child: Text("Nyeri"),
                ),
              ),
            ],
          ),
          Expanded(
            child: FutureBuilder<List<LocationResult>>(
              future: futureLocations,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Error fetching location results"));
                }
                final results = snapshot.data;
                if (results == null || results.isEmpty) {
                  return Center(child: Text("No locations found"));
                }

                return ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final location = results[index];
                    return ListTile(
                      leading: CachedNetworkImage(
                        imageUrl: "https://placehold.co/100",
                        placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                      title: Text(location.displayName.split(",")[0]),
                      subtitle: Text(location.displayName),
                      onTap: () {
                        Navigator.of(context).pop(location);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
