import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class ManageAddressesTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.location_on),
      title: const Text("Manage Addresses"),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => _ManageAddressesDialog(),
        );
      },
    );
  }
}

class _ManageAddressesDialog extends StatefulWidget {
  @override
  State<_ManageAddressesDialog> createState() => _ManageAddressesDialogState();
}

class _ManageAddressesDialogState extends State<_ManageAddressesDialog> {
  final addressController = TextEditingController();
  String? gpsAddress;
  String? error;

  Future<void> _getGpsAddress() async {
  setState(() {
    error = null;
  });
  try {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      setState(() {
        error = "Location permission denied";
      });
      return;
    }
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    if (placemarks.isNotEmpty) {
      final place = placemarks.first;
      gpsAddress = "${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}";
      addressController.text = gpsAddress!;
    } else {
      gpsAddress = "${position.latitude}, ${position.longitude}";
      addressController.text = gpsAddress!;
    }
  } catch (e) {
    setState(() {
      error = "Could not get GPS location: $e";
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Manage Address'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: addressController,
              decoration: const InputDecoration(labelText: 'Enter Address'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.gps_fixed),
              label: const Text('Use GPS'),
              onPressed: _getGpsAddress,
            ),
            if (error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(error!, style: const TextStyle(color: Colors.red)),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (addressController.text.isEmpty) {
              setState(() {
                error = "Address cannot be empty";
              });
              return;
            }
            // TODO: Save address to server or local storage
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Address saved: ${addressController.text}')),
            );
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}