import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:SANS/src/api/api_manager.dart';
import 'package:SANS/src/api/location_controller.dart';
import 'package:SANS/src/api/location_service.dart';
import 'package:SANS/src/screens/emergency/emergency.dart';
import 'package:SANS/src/widgets/custom_scaffold.dart';
import 'package:SANS/src/widgets/main_button.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  final int id_user;
  const HomeScreen({super.key, required this.id_user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiManager apiManager = ApiManager('https://server-sans.vercel.app');
  String? name;
  final LocationController locationController =
      Get.put<LocationController>(LocationController());

  @override
  void initState() {
    LocationService.instance.getUserLocation(controller: locationController);
    super.initState();
    _getUser();
  }

  Future<void> _getUser() async {
    try {
      final endpoint = '/dataUser/${widget.id_user}';
      final http.Response response = await apiManager.getUserData(endpoint);

      final data = jsonDecode(response.body);
      if (data.containsKey('nameUser')) {
        setState(() {
          name = data['nameUser'];
        });
      }
    } catch (error) {
      print('Gagal memuat data user: $error');
    }
  }

  Future<String> _getAddressFromCoordinate(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placemarks[0];

      return '${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}';
    } catch (e) {
      print('Error getting address: $e');
      return 'Error getting address';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return CustomScaffold(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: screenHeight * 0.35,
            width: screenWidth,
            color: const Color.fromRGBO(199, 54, 89, 1),
            child: Stack(
              children: [
                Positioned(
                  top: 10,
                  left: 60,
                  right: 10,
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  top: 80,
                  left: 10,
                  right: 10,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/images/SANS.png',
                          scale: 1.5,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Smart Ambulance Navigated System',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            fontStyle: FontStyle.italic,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 135,
                  right: 10,
                  left: 10,
                  child: Container(
                    height: screenHeight * 0.13,
                    width: screenWidth,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(169, 29, 58, 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Obx(() {
                      final location = locationController.userLocation.value;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Halo ${name ?? ''}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          if (locationController.isAccessingLocation.value)
                            const Center(
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          else if (location != null)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FutureBuilder<String>(
                                future: _getAddressFromCoordinate(
                                    location.latitude!, location.longitude!),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Text(
                                      'Memuat lokasi...',
                                      style: TextStyle(color: Colors.white),
                                    );
                                  } else if (snapshot.hasError) {
                                    return const Text(
                                      'Gagal mendapat lokasi',
                                      style: TextStyle(color: Colors.white),
                                    );
                                  } else {
                                    return Text(
                                        snapshot.data ??
                                            'Alamat tidak tersedia',
                                        style: const TextStyle(
                                            color: Colors.white),
                                        overflow: TextOverflow.visible);
                                  }
                                },
                              ),
                            )
                          else if (locationController
                              .errorDescription.value.isNotEmpty)
                            Text(
                              locationController.errorDescription.value,
                              style: const TextStyle(color: Colors.white),
                            )
                          else
                            const Text(
                              'Lokasi tidak tersedia',
                              style: TextStyle(color: Colors.white),
                            ),
                        ],
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          MainButton(
            height: 80,
            width: screenWidth * 0.9,
            buttonText: 'DARURAT',
            buttonColor: const Color.fromRGBO(199, 54, 89, 1),
            textColor: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w800,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      EmergencyScreen(id_user: widget.id_user),
                ),
              );
            },
          ),
          const SizedBox(
            height: 10,
          ),
          MainButton(
            height: 80,
            width: screenWidth * 0.9,
            buttonText: 'NON-DARURAT',
            buttonColor: const Color.fromRGBO(238, 238, 238, 1),
            textColor: const Color.fromRGBO(199, 54, 89, 1),
            fontSize: 25,
            fontWeight: FontWeight.w800,
          ),
        ],
      ),
    );
  }
}
