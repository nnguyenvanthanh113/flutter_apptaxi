import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterapptaxi/src/model/place_item_res.dart';
import 'package:flutterapptaxi/src/model/step_res.dart';
import 'package:flutterapptaxi/src/model/trip_info_res.dart';
import 'package:flutterapptaxi/src/reponsitory/place_service.dart';
import 'package:flutterapptaxi/src/resources/widgets/car_pickup.dart';
import 'package:flutterapptaxi/src/resources/widgets/home_menu.dart';
import 'package:flutterapptaxi/src/resources/widgets/ride_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  var _tripDistance = 0;
  //final Set<Marker> _markers =Set();
  final Map<String, Marker> _markers = <String, Marker>{};

  GoogleMapController _mapController;
  //Completer<GoogleMapController> _mapController = Completer();

  @override
  Widget build(BuildContext context) {
    //print("build UI");
    return Scaffold(
      key: _scaffoldKey,
      body: Container(

        constraints: BoxConstraints.expand(),
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            GoogleMap(
              //markers: _markers,
              mapType: MapType.normal,
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(12.268288, 109.201185),
                //target: LatLng(12.272021, 109.221012),
                //12.268288, 109.201185
                zoom: 14.4746,
              ),
            myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0.0,
                    title: Text(
                      "Taxi App",
                      style: TextStyle(color: Colors.black),
                    ),
                    leading: FlatButton(
                        onPressed: () {
                          print("click menu");
                          _scaffoldKey.currentState.openDrawer();
                        },
                        child: Image.asset("ic_menu.png")),
                    actions: <Widget>[Image.asset("ic_notify.png")],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: RidePicker(onPlaceSelected),
                    //child: RidePicker(),
                  ),
                ],
              ),
            ),
            Positioned(left: 20, right: 20, bottom: 40,
              height: 248,
              child: CarPickup(_tripDistance),
            )
          ],
        ),
      ),
      drawer: Drawer(
        child: HomeMenu(),
      ),
    );
  }


//  void onPlaceSelected(PlaceItemRes place, bool fromAddress) {
//    var mkId = fromAddress ? "from_address" : "to_address";
//    /// add to place marker
//_markers.add(Marker(markerId: MarkerId(mkId),onTap: (){
//
//  // tap vao thi lam gi
//},
//icon: BitmapDescriptor.defaultMarker
//    /// cai nay laic cua marker, ban BitmapDescription la kieu du lieu, ban tu tim cach chuyen tu image
//,position: LatLng(place.lat, place.lng)));
////add from marker
//
//    _markers.add(Marker(markerId: MarkerId("fromMarkerId"),position: LatLng(latitude, longitude)))
//setState(() {
//
//});
//    _moveCamera();
//    _checkDrawPolyline();
//    CameraPosition vegasPosition = CameraPosition(target: LatLng(12.270496, 109.200882), zoom: 10);
//  }
//
//  void _addMarker(String mkId, PlaceItemRes place) async {
//    // remove old
////    _markers.remove(mkId);
////    CameraPosition vegasPosition = CameraPosition(target: LatLng(36.0953103, -115.1992098), zoom: 10);
////    _mapController.clearMarkers();
//
//    _markers[mkId] = Marker(
//        markerId: MarkerId(mkId),
//        MarkerOptions(
//            position: LatLng(place.lat, place.lng),
//            infoWindowText: InfoWindowText(place.name, place.address)));
//
//    for (var m in _markers.values) {
//      await _mapController.addMarker(m.options);
//    }
//
//  ////test add location
////    _mapController.addMarker(
////
////      MarkerOptions(
////        position: LatLng(37.4219999, -122.0862462),
////      ),
////    );
//  }
  void onPlaceSelected(PlaceItemRes place, bool fromAddress) {
    var mkId = fromAddress ? "from_address" : "to_address";
    _addMarker(mkId, place);
    _moveCamera();
    _checkDrawPolyline();
  }

  void _addMarker(String mkId, PlaceItemRes place) async {
    // remove old
    _markers.remove(mkId);
    _mapController.clearMarkers();

    _markers[mkId] = Marker(
        mkId,
        MarkerOptions(
            position: LatLng(place.lat, place.lng),
            infoWindowText: InfoWindowText(place.name, place.address)));

    for (var m in _markers.values) {
      await _mapController.addMarker(m.options);
    }
  }

  void _moveCamera() {
    print("move camera: ");
    print(_markers);

    if (_markers.values.length > 1) {
      var fromLatLng = _markers["from_address"].options.position;
      var toLatLng = _markers["to_address"].options.position;

      LatLng s, n;
      if (fromLatLng.latitude <= toLatLng.latitude) {
        s = fromLatLng;
        n = toLatLng;
      }
      else {
        n = fromLatLng;
        s = toLatLng;
      }
      LatLngBounds bounds = LatLngBounds(northeast: n, southwest: s);
      _mapController.moveCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    } else {
      _mapController.moveCamera(CameraUpdate.newLatLng(
          _markers.values
              .elementAt(0)
              .options
              .position));
    }

    if (_markers.values.length > 1) {
      var fromLatLng = _markers["from_address"].options.position;
      var toLatLng = _markers["to_address"].options.position;

      var sLat, sLng, nLat, nLng;
      if(fromLatLng.latitude <= toLatLng.latitude) {
        sLat = fromLatLng.latitude;
        nLat = toLatLng.latitude;
      } else {
        sLat = toLatLng.latitude;
        nLat = fromLatLng.latitude;
      }

      if(fromLatLng.longitude <= toLatLng.longitude) {
        sLng = fromLatLng.longitude;
        nLng = toLatLng.longitude;
      } else {
        sLng = toLatLng.longitude;
        nLng = fromLatLng.longitude;
      }

      LatLngBounds bounds = LatLngBounds(northeast: LatLng(nLat, nLng), southwest: LatLng(sLat, sLng));
      _mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    } else {
      _mapController.animateCamera(CameraUpdate.newLatLng(
          _markers.values.elementAt(0).options.position));
    }
  }

  void _checkDrawPolyline() {
//  remove old polyline
    _mapController.clearPolylines();


    if (_markers.length > 1) {
      var from = _markers["from_address"].options.position;
      var to = _markers["to_address"].options.position;
      PlaceService.getStep(
          from.latitude, from.longitude, to.latitude, to.longitude)
          .then((vl) {
        TripInfoRes infoRes = vl;

        _tripDistance = infoRes.distance;
        setState(() {
        });
        List<StepsRes> rs = infoRes.steps;
        //List<StepsRes> rs = vl;
        List<LatLng> paths = new List();
        for (var t in rs) {
          paths.add(LatLng(t.startLocation.latitude, t.startLocation.longitude));
          paths.add(LatLng(t.endLocation.latitude, t.endLocation.longitude));
        }


        print(paths);
        _mapController.addPolyline(PolylineOptions(
            points: paths, color: Color(0xFF3ADF00).value, width: 10));
      });
    }
  }

}