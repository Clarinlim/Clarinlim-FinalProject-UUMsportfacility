import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

 
class MapSampleState extends StatefulWidget {
  @override
  _MapSampleStateState createState() => _MapSampleStateState();
}

class _MapSampleStateState extends State<MapSampleState> {
Completer<GoogleMapController> _controller = Completer();
static final LatLng _center =const LatLng(6.4739, 100.5052);
MapType _currentMapType = MapType.normal;
final Set<Marker> _markers = {};
LatLng _lastMapPosition = _center;


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Map Location'),
        ),
        body: Stack(children: <Widget>[
          GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
           zoom: 18.4746,
            ),
            mapType: _currentMapType,
            markers: _markers,
            onCameraMove: _onCameraMove,
           ),
        Padding(
         padding: const EdgeInsets.all(16.0),
         child: Align(
          alignment: Alignment.topRight,
          child:Column(
          children:<Widget>[
          FloatingActionButton(
          onPressed: () => _onMapTypeButtonPressed,
          materialTapTargetSize: MaterialTapTargetSize.padded,
          backgroundColor: Colors.green,
          child: const Icon(Icons.map, size: 36.0),
        ),
        SizedBox(height:16.0),
        FloatingActionButton(
       onPressed: _onAddMarkerButtonPressed,
       materialTapTargetSize: MaterialTapTargetSize.padded,
       backgroundColor: Colors.green,
       child: const Icon(Icons.add_location, size: 36.0),
     ),

            ]
          )
           
        ))],)
        
           
           
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }
  void _onMapTypeButtonPressed() {
  setState(() {
    _currentMapType = _currentMapType == MapType.normal
        ? MapType.satellite
        : MapType.normal;
  });
}

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }
  void _onAddMarkerButtonPressed() {
  setState(() {
    _markers.add(Marker(
      // This marker id can be anything that uniquely identifies each marker.
      markerId: MarkerId(_lastMapPosition.toString()),
      position: _lastMapPosition,
      infoWindow: InfoWindow(
        title: 'Sport center',
        snippet: 'UUM Sport Facility',
      ),
      icon: BitmapDescriptor.defaultMarker,
    ));
  });
}
}