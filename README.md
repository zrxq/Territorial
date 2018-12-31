# Territorial

The iOS app for ~all~ some of your geofencing needs.

## Purpose

This is an iOS application that detects if the device is located inside of a geofence area. 

Geofence area is defined as a combination of some geographic point, radius, and specific WiFi network name. A device is considered to be inside of the geofence area if the device is connected to the specified WiFi network or remains geographically inside the defined circle.

Note that if device coordinates are reported outside of the zone, but the device still connected to the specific WiFi network, then the device is treated as being inside the geofence area.

## Building

1. Download and open the project.
1. Build and run using either the simulator or a real device.
   1. Simulator doesn't support WiFi info. Location support is also very limited. 
   1. Running the project on a device will require an Apple Developer Program membership. Access WiFi Information Entitlement is only available to paid accounts 🤷‍♀️
1. Geofence to your heart's content.

P.S. Tap and hold to move or drag-and-drop the pin on the map. As ridiculous as it is, that is how standard MKMapView behaves.
