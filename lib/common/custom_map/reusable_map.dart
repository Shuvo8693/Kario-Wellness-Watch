import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// Reusable Map Widget
class ReusableMap extends StatefulWidget {
  final LatLng initialPosition;
  final double initialZoom;
  final Set<Marker>? markers;
  final Set<Polyline>? polylines;
  final Set<Circle>? circles;
  final bool showMyLocation;
  final bool showMyLocationButton;
  final MapType mapType;
  final Function(GoogleMapController)? onMapCreated;
  final Function(LatLng)? onTap;
  final Function(LatLng)? onLongPress;
  final bool darkMode;
  final Widget? customFloatingButton;
  final FloatingActionButtonLocation? floatingButtonLocation;

  const ReusableMap({
    super.key,
    required this.initialPosition,
    this.initialZoom = 15.0,
    this.markers,
    this.polylines,
    this.circles,
    this.showMyLocation = true,
    this.showMyLocationButton = false,
    this.mapType = MapType.normal,
    this.onMapCreated,
    this.onTap,
    this.onLongPress,
    this.darkMode = true,
    this.customFloatingButton,
    this.floatingButtonLocation,
  });

  @override
  State<ReusableMap> createState() => ReusableMapState();
}

class ReusableMapState extends State<ReusableMap> {
  GoogleMapController? _controller;

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        GoogleMap(
          onMapCreated: (GoogleMapController controller) {
            _controller = controller;
            if (widget.darkMode) {
              _setDarkMapStyle();
            }
            widget.onMapCreated?.call(controller);
          },
          initialCameraPosition: CameraPosition(
            target: widget.initialPosition,
            zoom: widget.initialZoom,
          ),
          markers: widget.markers ?? {},
          polylines: widget.polylines ?? {},
          circles: widget.circles ?? {},
          myLocationEnabled: widget.showMyLocation,
          myLocationButtonEnabled: widget.showMyLocationButton,
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
          mapType: widget.mapType,
          onTap: widget.onTap,
          onLongPress: widget.onLongPress,
        ),
        if (widget.customFloatingButton != null)
          Positioned(
            bottom: 20.h,
            right: 20.w,
            child: widget.customFloatingButton!,
          ),
      ],
    );
  }

  void _setDarkMapStyle() {
    _controller?.setMapStyle('''
    [
      {
        "elementType": "geometry",
        "stylers": [{"color": "#1d2c4d"}]
      },
      {
        "elementType": "labels.text.fill",
        "stylers": [{"color": "#8ec3b9"}]
      },
      {
        "elementType": "labels.text.stroke",
        "stylers": [{"color": "#1a3646"}]
      },
      {
        "featureType": "road",
        "elementType": "geometry",
        "stylers": [{"color": "#304a7d"}]
      },
      {
        "featureType": "road",
        "elementType": "labels.text.fill",
        "stylers": [{"color": "#98a5be"}]
      }
    ]
    ''');
  }

  // Public methods to control the map
  void animateToLocation(LatLng location, {double zoom = 15.0}) {
    _controller?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: location, zoom: zoom),
      ),
    );
  }

  void zoomIn() {
    _controller?.animateCamera(CameraUpdate.zoomIn());
  }

  void zoomOut() {
    _controller?.animateCamera(CameraUpdate.zoomOut());
  }

  GoogleMapController? get controller => _controller;
}