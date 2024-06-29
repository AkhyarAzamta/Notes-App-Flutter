import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:notes_app_flutter/notes/get_notes.dart';

class UpdateNoteScreen extends StatefulWidget {
  final String noteId;
  const UpdateNoteScreen({super.key, required this.noteId});
  @override
  // ignore: library_private_types_in_public_api
  _UpdateNoteScreenState createState() => _UpdateNoteScreenState();
}

class _UpdateNoteScreenState extends State<UpdateNoteScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  String? accessToken;
  bool isValid = false;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    _loadAccessToken();
    _getNotesById();
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

  void _getNotesById() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoading = true;
    });
    try {
      final response = await Dio().get(
        'http://192.168.100.6:3000/notes/${widget.noteId}',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${prefs.getString('accessToken')}',
          },
        ),
      );
      if (response.statusCode == 200) {
        setState(() {
          name.text = response.data['name'];
          description.text = response.data['description'];
        });
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
    _validateInputs();
  }

  void _updateNote(
    String name,
    String description,
    String accessToken,
  ) async {
    try {
      setState(() {
        isLoading = true;
      });
      final response = await Dio().patch(
        'http://192.168.100.6:3000/notes/${widget.noteId}',
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
      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const GetNotesScreen(),
          ),
        );
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
        title: const Text('Edit Note', style: TextStyle(color: Colors.black)),
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
                  onChanged: (_) => _validateInputs(),
                  decoration: const InputDecoration(
                    labelText: 'Masukan nama',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              FractionallySizedBox(
                widthFactor: 0.7,
                child: TextField(
                  controller: description,
                  onChanged: (_) => _validateInputs(),
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
                          ? () => _updateNote(
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
                          padding: EdgeInsets.symmetric(vertical: 14),
                          child: Text(
                            'Simpan perubahan data',
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
