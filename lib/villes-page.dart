import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './cinemas-page.dart';

class VillePage extends StatefulWidget {
  @override
  _VillePageState createState() => _VillePageState();
}

class _VillePageState extends State<VillePage> {
  List<dynamic> listVilles;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Villes'),
      ),
      body: Center(
          child: this.listVilles == null
              ? CircularProgressIndicator()
              : ListView.builder(
                  itemCount:
                      (this.listVilles == null) ? 0 : this.listVilles.length,
                  itemBuilder: (context, index) {
                    return Card(
                        color: Color(0xFFB71C1C),
                        child: RaisedButton(
                          color: Color(0xFF212121),
                          child: Text(
                            this.listVilles[index]['name'],
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        new CinemasPage(listVilles[index])));
                          },
                        ));
                  })),
    );
  }

  @override
  void initState() {
    super.initState();
    loadVilles();
  }

  void loadVilles() {
    String url = "http://192.168.1.128:9090/villes";
    http.get(Uri.parse(url)).then((resp) {
      setState(() {
        this.listVilles = json.decode(resp.body)['_embedded']['villes'];
      });
    }).catchError((err) {
      print(err);
    });
  }
}
