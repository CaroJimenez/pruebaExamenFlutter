import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:prueba/modules/restaurant_details.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final CollectionReference _restaurantsRef =
      FirebaseFirestore.instance.collection('restaurantes');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Restaurantes"),
      automaticallyImplyLeading: true),
      body: StreamBuilder<QuerySnapshot>(
        stream: _restaurantsRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No hay restaurantes disponibles"));
          }

          final restaurantDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: restaurantDocs.length,
            itemBuilder: (context, index) {
              final restaurantData = restaurantDocs[index].data() as Map<String, dynamic>;
              final name = restaurantData['name'] ?? 'Sin nombre';
              final description = restaurantData['description'] ?? 'Sin descripción';
              final images = restaurantData['images'] as List<dynamic>? ?? [];

              return GestureDetector(
                onTap: () {
                    final description = restaurantData['description'];
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RestaurantDetails(description: description)
                      ),
                    );
                  },
                
                 child:  Card(

                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Imagen del restaurante (si existe)
                    images.isNotEmpty
                        ? Image.network(
                            images[0], // Usamos la primera imagen como portada
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 200,
                          )
                        : const SizedBox(
                            height: 200,
                            child: Center(child: Text("Imagen no disponible")),
                          ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          
                        ],
                      ),
                    ),
                  ],
                ),
              ));
            },
          );
        },
      ),
    );
  }
}
