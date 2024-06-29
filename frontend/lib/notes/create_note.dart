import 'package:flutter/material.dart';
import 'package:notes_app_flutter/notes/get_notes.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateNotesScreen extends StatefulWidget {
  const CreateNotesScreen({super.key});
  @override
// ignore: library_private_types_in_public_api
  _CreateNotesScreenState createState() => _CreateNotesScreenState();
}

class _CreateNotesScreenState extends State<CreateNotesScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  String? accessToken;
  bool isValid = false;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    _loadAccessToken();
  }

  void _loadAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      accessToken = prefs.getString('accessToken') ?? '';
    });
  }

  void _validateInputs() {
    setState(() {
      isValid = name.text.isNotEmpty && description.text.isNotEmpty;
    });
  }

  void createNotes(
    String name,
    String description,
    String accessToken,
  ) async {
    try {
      setState(() {
        isLoading = true;
      });
      final response = await Dio().post(
        'http://localhost:3000/notes',
        data: {
          'name': name,
          'description': description,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      if (response.statusCode == 201) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const GetNotesScreen(),
          ),
        );
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Notes', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const GetNotesScreen()));
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              FractionallySizedBox(
                widthFactor: 0.7,
                child: TextField(
                  controller: name,
                  onChanged: (value) => _validateInputs(),
                  decoration: const InputDecoration(
                    labelText: 'Masukan nama ',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              FractionallySizedBox(
                widthFactor: 0.7,
                child: TextField(
                  controller: description,
                  onChanged: (value) => _validateInputs(),
                  decoration: const InputDecoration(
                    labelText: 'Masukan deskripsi',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              FractionallySizedBox(
                widthFactor: 0.7,
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : isValid
                          ? () => createNotes(
                              name.text, description.text, accessToken!)
                          : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: isLoading
                      ? const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 36, vertical: 12),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child:
                                CircularProgressIndicator(color: Colors.black),
                          ))
                      : const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 12),
                          child: Text(
                            'Simpan data',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20)
            ],
          ),
        ),
      ),
    );
  }
}
