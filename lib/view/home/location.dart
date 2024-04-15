import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:food_delivery/view/main_tabview/main_tabview.dart';
import 'package:geolocator/geolocator.dart';
import 'package:food_delivery/view/home/home_view.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationIdentifier extends StatefulWidget {
  const LocationIdentifier({super.key});
  @override
  State<StatefulWidget> createState() => LocationIdentifierState();
}

class LocationIdentifierState extends State<LocationIdentifier> {
  static String KEYNAME = "address";
  List<String> options = ['Options1', 'Options2'];
  _permissionChecker() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      return false;
    }
    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    return true;
  }

  _getLocation(context, currentOption) {
    _permissionChecker().then((value) {
      print(value);
      if (value == false) {
        showModalBottomSheet(
            enableDrag: false,
            context: context,
            builder: (context) {
              return Container(
                height: 180,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Grant Permission to find your location"),
                        ),
                        OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary),
                            onPressed: () async {
                              final permission =
                                  await Permission.location.request();
                              if (permission.isGranted) {
                                Position position =
                                    await Geolocator.getCurrentPosition(
                                        desiredAccuracy: LocationAccuracy.high);
                                print(position);
                                final _pref =
                                    await SharedPreferences.getInstance();
                                _pref.setStringList(KEYNAME, [
                                  position.latitude.toString(),
                                  position.longitude.toString()
                                ]);
                                print("Exit from location");
                              } else {
                                final permission =
                                    await Permission.location.request();
                                Position position =
                                    await Geolocator.getCurrentPosition(
                                        desiredAccuracy: LocationAccuracy.high);
                                print(position);
                                final _pref =
                                    await SharedPreferences.getInstance();
                                _pref.setStringList(KEYNAME, [
                                  position.latitude.toString(),
                                  position.longitude.toString()
                                ]);
                              }
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const MainTabView()));
                            },
                            child: const Text("GRANT")),
                        const Divider(),
                      ],
                    ),
                  ],
                ),
              );
            });
      } else if (value == true) {
        showModalBottomSheet(
            enableDrag: false,
            context: context,
            builder: (context) {
              return Container(
                height: 180,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Select Current Location"),
                    ),
                    OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.inversePrimary),
                        onPressed: () async {
                          Position position =
                              await Geolocator.getCurrentPosition(
                                  desiredAccuracy: LocationAccuracy.high);
                          print(position);
                          final _pref = await SharedPreferences.getInstance();
                          _pref.setStringList(KEYNAME, [
                            position.latitude.toString(),
                            position.longitude.toString()
                          ]);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MainTabView()));
                        },
                        child: const Text("SELECT")),
                  ],
                ),
              );
            });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String currentOption = options[0];
    return Scaffold(
      body: _getLocation(context, currentOption),
    );
  }
}
