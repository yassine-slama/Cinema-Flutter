import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import './salles-page.dart';

class CinemasPage extends StatefulWidget {
  dynamic ville;
  CinemasPage(this.ville);

  @override
  _CinemasPageState createState() => _CinemasPageState();
}

class _CinemasPageState extends State<CinemasPage> {
  List<dynamic> listCinemas;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cinéma de ${widget.ville['name']}'),
      ),
      body: Center(
          child: this.listCinemas == null
              ? CircularProgressIndicator()
              : ListView.builder(
                  itemCount:
                      (this.listCinemas == null) ? 0 : this.listCinemas.length,
                  itemBuilder: (context, index) {
                    return Card(
                        color: Color(0xFFB71C1C),
                        child: RaisedButton(
                          color: Color(0xFF212121),
                          child: Text(
                            this.listCinemas[index]['name'],
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        new SallesPage(listCinemas[index])));
                          },
                        ));
                  })),
    );
  }

  @override
  void initState() {
    super.initState();
    loadCinemas();
  }

  void loadCinemas() {
    String url = this.widget.ville['_links']['cinemas']['href'];
    http.get(Uri.parse(url)).then((resp) {
      setState(() {
        this.listCinemas = json.decode(resp.body)['_embedded']['cinemas'];
      });
    }).catchError((err) {
      print(err);
    });
  }
}
