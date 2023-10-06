import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:testing/list_data.dart';
import 'package:testing/side_menu.dart';

class EditData extends StatefulWidget {
  const EditData(
      {Key? key,
      required this.nama,
      required this.no_telepon,
      required this.id})
      : super(key: key);
  final String nama;
  final String no_telepon;
  final String id;
  @override
  _EditDataState createState() => _EditDataState();
}

class _EditDataState extends State<EditData> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController no_teleponController = TextEditingController();

  Future updateData(String nama, String no_telepon) async {
    final baseUrl =
        // ? 'http://192.168.20.21/api-flutter/index.php'
        'http://localhost/api-flutter/index.php';

    final headers = <String, String>{'Content-Type': 'application/json'};
    final requestBody = <String, dynamic>{
      'id': widget.id,
      'nama': nama,
      'no_telepon': no_telepon,
    };

    final response = await http.put(
      Uri.parse(baseUrl),
      headers: headers,
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return responseData;
    } else {
      throw Exception('Failed to update data');
    }
  }

  @override
  void initState() {
    super.initState();
    namaController.text = widget.nama;
    no_teleponController.text = widget.no_telepon;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Data Contact'),
      ),
      drawer: const SideMenu(),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              controller: namaController,
              decoration: const InputDecoration(
                hintText: 'Nama Contact',
              ),
            ),
            TextField(
              controller: no_teleponController,
              decoration: const InputDecoration(
                hintText: 'no_telepon',
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final nama = namaController.text;
                final no_telepon = no_teleponController.text;

                final result = await updateData(nama, no_telepon);

                if (result['pesan'] == 'berhasil') {
                  // ignore: use_build_context_synchronously
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Data berhasil di update'),
                        content: const Text(''),
                        actions: [
                          TextButton(
                            child: const Text('OK'),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ListData(),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
                setState(() {});
              },
              child: const Text('Update Contact'),
            )
          ],
        ),
      ),
    );
  }
}
