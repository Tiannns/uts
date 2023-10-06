import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:testing/edit_data.dart';
import 'package:testing/side_menu.dart';
import 'package:testing/tambah_data.dart';

class ListData extends StatefulWidget {
  const ListData({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ListDataState createState() => _ListDataState();
}

class _ListDataState extends State<ListData> {
  List<Map<String, String>> dataContact = [];
  String url =
      // ? 'http://192.168.20.21/api-flutter/index.php'
      'http://localhost/api-flutter/index.php';
  // String url = 'http://localhost/api-flutter/index.php';
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        dataContact = List<Map<String, String>>.from(data.map((item) {
          return {
            'nama': item['nama'] as String,
            'no_telepon': item['no_telepon'] as String,
            'email': item['email'] as String,
          };
        }));
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future deleteData(int id) async {
    final response = await http.delete(Uri.parse('$url?id=$id'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to delete data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Data Contact'),
      ),
      drawer: const SideMenu(),
      body: Column(children: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const TambahData(),
              ),
            );
          },
          child: const Text('Tambah Data Contact'),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: dataContact.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(dataContact[index]['nama']!),
                subtitle:
                    Text('no_telepon: ${dataContact[index]['no_telepon']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.visibility),
                      onPressed: () {
                        lihatContact(context, index);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        editContact(context, index);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        deleteData(int.parse(dataContact[index]['id']!))
                            .then((result) {
                          if (result['pesan'] == 'berhasil') {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Data berhasil di hapus'),
                                    content: const Text(''),
                                    actions: [
                                      TextButton(
                                        child: const Text('OK'),
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const ListData(),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                });
                          }
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        )
      ]),
    );
  }

  void editContact(BuildContext context, int index) {
    final Map<String, dynamic> contact = dataContact[index];
    final String id = contact['id'] as String;
    final String nama = contact['nama'] as String;
    final String no_telepon = contact['no_telepon'] as String;

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) =>
          EditData(id: id, nama: nama, no_telepon: no_telepon),
    ));
  }

  void lihatContact(BuildContext context, int index) {
    final contact = dataContact[index];
    final nama = contact['nama'] as String;
    final no_telepon = contact['no_telepon'] as String;
    final email = contact['email'] as String;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
          title: const Center(child: Text('Detail Contact')),
          content: SizedBox(
            height: 100,
            child: Column(
              children: [
                Text('Nama : $nama'),
                Text('no_telepon: $no_telepon'),
                Text('email: $email')
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
