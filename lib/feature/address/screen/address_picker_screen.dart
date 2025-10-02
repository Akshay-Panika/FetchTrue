import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:fetchtrue/core/widgets/custom_button.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:geocoding/geocoding.dart' as geoCoding;

import '../address_notifier.dart';

class AddressPickerScreen extends StatefulWidget {
  const AddressPickerScreen({super.key});

  @override
  State<AddressPickerScreen> createState() => _AddressPickerScreenState();
}

class _AddressPickerScreenState extends State<AddressPickerScreen> {
  String? _currentCity;
  String? _currentState;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _getCurrentCityState();
  }

  Future<void> _getCurrentCityState() async {
    if (mounted) {
      setState(() => _isLoading = true);
    }

    bool serviceEnabled;
    geo.LocationPermission permission;

    // 1. Location service check
    serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _updateState(
        city: "Location services are disabled",
        state: null,
        loading: false,
      );
      return;
    }

    // 2. Permission check
    permission = await geo.Geolocator.checkPermission();
    if (permission == geo.LocationPermission.denied) {
      permission = await geo.Geolocator.requestPermission();
      if (permission == geo.LocationPermission.denied) {
        _updateState(
          city: "Location permissions are denied",
          state: null,
          loading: false,
        );
        return;
      }
    }

    if (permission == geo.LocationPermission.deniedForever) {
      _updateState(
        city: "Location permissions are permanently denied",
        state: null,
        loading: false,
      );
      return;
    }

    try {
      // 3. Get current position
      geo.Position position = await geo.Geolocator.getCurrentPosition(
        desiredAccuracy: geo.LocationAccuracy.high,
      );

      // 4. Reverse geocoding to get city & state
      List<geoCoding.Placemark> placemarks =
      await geoCoding.placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      geoCoding.Placemark place = placemarks.first;

      _updateState(
        city: place.locality ?? "Unknown City",
        state: place.administrativeArea ?? "Unknown State",
        loading: false,
      );
    } catch (e) {
      debugPrint("Location Error: $e");
      _updateState(
        city: "Error getting location",
        state: null,
        loading: false,
      );
    }
  }

  void _updateState({String? city, String? state, required bool loading}) {
    if (mounted) {
      setState(() {
        _currentCity = city;
        _currentState = state;
        _isLoading = loading;
      });
    }
  }


  void _confirmAddress() {
    if (_currentCity != null && _currentState != null) {
      Provider.of<AddressNotifier>(context, listen: false).setConfirmedAddress(
        _currentCity!,
        _currentState!,
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please wait for location or refresh.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Address', showBackButton: true,),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Icon(Icons.map, size: 120,color: Colors.green,)),
          50.height,


          CustomContainer(
            border: true,
            width: double.infinity,
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('YOUR LOCATION', style: textStyle12(context, color: Colors.grey.shade600),),
                _isLoading ? Text('Address : Loading...')
                : Text('Address: ${_currentCity != null ? _currentCity:""}, ${_currentState != null ? _currentState : ""}'),
              ],
            ),
          ),


          20.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                  onPressed: _getCurrentCityState,
                  icon: Icon(Icons.refresh, size: 20,),
                  label: Text('Refresh Location', style: textStyle12(context),)),
              20.width,
              
              CustomContainer(
                color: CustomColor.appColor,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Text('Confirm', style: textStyle12(context, color: CustomColor.whiteColor),),
                onTap: _confirmAddress,
              )
            ],
          ),

        ],
      ),
    );
  }
}
