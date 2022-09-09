import 'package:flutter/material.dart';
import 'package:sqlite/database/db_helper.dart';
import 'package:sqlite/interface/form_kontak.dart';
import 'package:sqlite/model/kontak.dart';

class ListKontakPage extends StatefulWidget {
  @override
  _ListKontakPageState createState() => _ListKontakPageState();
}

class _ListKontakPageState extends State<ListKontakPage> {
  List<Kontak> listKontak = [];
  DbHelper db = DbHelper();
  @override
  void initState() {
    _getAllKontak();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Center(
        child: Text("Kontak App"),
      )),
      body: ListView.builder(
        itemCount: listKontak.length,
        itemBuilder: (context, index) {
        Kontak kontak = listKontak[index];
        return Padding(
          padding: const EdgeInsets.only(top: 20),
          child: ListTile(
            leading: const Icon(
              Icons.person,
              size: 50,
            ),
            title: Text('${kontak.name}'),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text("Email: ${kontak.email}"),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text("Phone: ${kontak.mobileNo}"),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text("Company: ${kontak.company}"),
                )
              ],
            ),
            trailing: FittedBox(
              fit: BoxFit.fill,
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        _openFormEdit(kontak);
                      },
                      icon: const Icon(Icons.edit)),
                  IconButton(
                      onPressed: () {
                        AlertDialog hapus = AlertDialog(
                          title: const Text("Information"),
                          content: Container(
                            height: 80,
                            child: Column(
                              children: [
                                Text(
                                    "Yakin ingin menghapus data ${kontak.name}"),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  _deleteKontak(kontak, index);
                                  Navigator.pop(context);
                                },
                                child: const Text("Ya")),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Tidak"))
                          ],
                        );
                        showDialog(
                            context: context, builder: (context) => hapus);
                      },
                      icon: const Icon(Icons.delete))
                ],
              ),
            ),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _openFormCreate();
        },
      ),
    );
  }

  Future<void> _getAllKontak() async {
    var list = await db.getAllKontak();
    setState(() {
      listKontak.clear();
      list!.forEach((kontak) {
        listKontak.add(Kontak.fromMap(kontak));
      });
    });
  }

  Future<void> _openFormCreate() async {
    var result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => FormKontak()));
    if (result == 'save') {
      await _getAllKontak();
    };
  }

  Future<void> _deleteKontak(Kontak kontak, int position) async {
    await db.deleteKontak(kontak.id!);
    setState(() {
      listKontak.removeAt(position);
    });
  }

  Future<void> _openFormEdit(Kontak kontak) async {
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => FormKontak(kontak: kontak)));
    if (result == 'update') {
      await _getAllKontak();
    }
  }
}
