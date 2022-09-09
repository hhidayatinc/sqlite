import 'package:flutter/material.dart';
import 'package:sqlite/database/db_helper.dart';
import 'package:sqlite/interface/form_kontak.dart';
import 'package:sqlite/interface/list_kontak.dart';
import 'package:sqlite/model/kontak.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Data Kontak",
      home: ListKontakPage(),
    );
  }
}