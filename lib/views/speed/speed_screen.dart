import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:speedometer_mobile/res/dimens.dart';

class SpeedScreen extends StatefulWidget {
  const SpeedScreen({super.key});

  @override
  State<SpeedScreen> createState() => _SpeedScreenState();
}

class _SpeedScreenState extends State<SpeedScreen> {
  StreamSubscription<Position>? _positionStreamSubscription;
  double _currentSpeed = 0.0; // Speed in m/s

  bool _isLoading = true;
  String? _errorMessage;
  bool _isServiceDisabled = false;
  bool _isPermissionDeniedForever = false;

  @override
  void initState() {
    super.initState();
    _checkPermissionsAndInit();
  }

  Future<void> _checkPermissionsAndInit() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _isServiceDisabled = false;
      _isPermissionDeniedForever = false;
    });

    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _isServiceDisabled = true;
        _errorMessage = 'Location services are disabled.\nPlease enable them to track speed.';
        _isLoading = false;
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _errorMessage = 'Location permissions are denied.\nCannot track speed.';
          _isLoading = false;
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _isPermissionDeniedForever = true;
        _errorMessage =
            'Location permissions are permanently denied.\nPlease enable them in app settings.';
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = false;
    });

    _startTracking();
  }

  void _startTracking() {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 0,
    );

    _positionStreamSubscription = Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen(
          (Position position) {
            if (mounted) {
              setState(() {
                // position.speed is in m/s
                _currentSpeed = position.speed < 0 ? 0 : position.speed;
              });
            }
          },
          onError: (error) {
            if (mounted) {
              setState(() {
                _errorMessage = 'Failed to get location stream:\n$error';
              });
            }
          },
        );
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  double get _speedKmH => _currentSpeed * 3.6;

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: AppDimens.paddingAll(2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_off, size: 64, color: Theme.of(context).colorScheme.error),
            AppDimens.gap(2),
            Text(
              _errorMessage ?? 'Unknown error occurred.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: AppDimens.baseSize * 1.5),
            ),
            AppDimens.gap(3),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _checkPermissionsAndInit,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
                if (_isServiceDisabled || _isPermissionDeniedForever) ...[
                  AppDimens.gap(2),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (_isServiceDisabled) {
                        Geolocator.openLocationSettings();
                      } else if (_isPermissionDeniedForever) {
                        Geolocator.openAppSettings();
                      }
                    },
                    icon: const Icon(Icons.settings),
                    label: const Text('Open Settings'),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            AppDimens.gap(2),
            Text('Checking location services...'),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return _buildErrorState();
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Prędkość',
            style: TextStyle(
              fontSize: AppDimens.baseSize * 3,
              fontWeight: FontWeight.bold,
            ),
          ),
          AppDimens.gap(),
          Text(
            _speedKmH.toStringAsFixed(1),
            style: TextStyle(
              fontSize: 80,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          Text(
            'km/h',
            style: TextStyle(
              fontSize: 24,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          AppDimens.gap(),
          Text(
            '(${_currentSpeed.toStringAsFixed(1)} m/s)',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }
}
