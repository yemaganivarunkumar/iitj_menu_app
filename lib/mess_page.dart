import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class MessMenuPage extends StatefulWidget {
  const MessMenuPage({super.key});

  @override
  State<MessMenuPage> createState() => _MessMenuPageState();
}

class _MessMenuPageState extends State<MessMenuPage> {
  Map<String, dynamic>? messData;

  @override
  void initState() {
    super.initState();
    loadMenuData();
  }

  Future<void> loadMenuData() async {
    final String response = await rootBundle.loadString(
      'assets/mess_menu.json',
    );
    final data = json.decode(response);
    setState(() {
      messData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (messData == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final menu = messData!['menu'] as Map<String, dynamic>;
    final compulsory = messData!['compulsoryItems'] as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: const Text("IITJ Mess Menu"),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView.builder(
        itemCount: menu.length,
        itemBuilder: (context, index) {
          String day = menu.keys.elementAt(index);
          final meals = menu[day];

          return Card(
            margin: const EdgeInsets.all(10),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ExpansionTile(
              title: Text(
                day,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              children: [
                for (final mealType in [
                  'breakfast',
                  'lunch',
                  'snacks',
                  'dinner',
                ])
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mealType.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(" Common: ${meals['common'][mealType]}"),
                        Text(" Compulsory: ${compulsory[mealType]}"),
                        Text(" Veg: ${meals['veg'][mealType]}"),
                        Text(" Non-Veg: ${meals['nonveg'][mealType]}"),
                        Text(" Jain: ${meals['jain'][mealType]}"),
                        const Divider(),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
