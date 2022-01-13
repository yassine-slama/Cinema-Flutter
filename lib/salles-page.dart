// ignore_for_file: prefer_const_constructors, unnecessary_this

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';

class SallesPage extends StatefulWidget {
  dynamic cinema;
  SallesPage(this.cinema);

  @override
  _SallesPageState createState() => _SallesPageState();
}

class _SallesPageState extends State<SallesPage> {
  List<dynamic> listSalles;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Salle de cinema ${widget.cinema['name']}'),
      ),
      body: Center(
        child: this.listSalles == null
            ? CircularProgressIndicator()
            : ListView.builder(
                itemCount:
                    (this.listSalles == null) ? 0 : this.listSalles.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Color(0xFFB71C1C),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          RaisedButton(
                            color: Color(0xFFD6D6D6),
                            child: Text(
                              this.listSalles[index]['name'],
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              loadProjections(this.listSalles[index]);
                            },
                          ),
                          if (this.listSalles[index]['projections'] != null)
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: Image.network(
                                        "http://192.168.1.128:9090/imageFilm/2",
                                        //"http://192.168.1.15:9090/imageFilm/$this.listSalles[index]['currentProjection'][6]['film']['id']",
                                        //"http://192.168.1.15:9090/imageFilm/salles[2][projections][_embedded][projections][3]['film']['id']",
                                        width: 150,
                                        scale: 1.0),
                                  ),
                                  Column(
                                    children: <Widget>[
                                      ...(this.listSalles[index]['projections']
                                              as List<dynamic>)
                                          .map((projection) {
                                        return RaisedButton(
                                          color: (this.listSalles[index]
                                                          ['currentProjection']
                                                      ['id'] ==
                                                  projection['id'])
                                              ? Color(0xFF212121)
                                              : Color(0xFF76FF03),
                                          child: Text(
                                              "${projection['seance']['heureDebut']} (${projection['film']['duree']}, Prix=${projection['prix']} )",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12)),
                                          onPressed: () {
                                            loadTicket(projection,
                                                this.listSalles[index]);
                                          },
                                        );
                                      })
                                    ],
                                  )
                                ],
                              ),
                            ),
                          if (this.listSalles[index]['currentProjection'] !=
                                  null &&
                              this.listSalles[index]['currentProjection']
                                      ['listTickets'] !=
                                  null &&
                              this
                                      .listSalles[index]['currentProjection']
                                          ['listTickets']
                                      .length >
                                  0)
                            Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text(
                                        "le nombre de places disponibles :${this.listSalles[index]['currentProjection']['nombrePlaceDisponible']}")
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(6, 2, 6, 3),
                                  child: TextField(
                                    decoration:
                                        InputDecoration(hintText: 'Your Name'),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(6, 2, 6, 3),
                                  child: TextField(
                                    decoration: InputDecoration(
                                        hintText: 'Code Payement'),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(6, 2, 6, 3),
                                  child: TextField(
                                    decoration: InputDecoration(
                                        hintText: 'Nombre de Ticket'),
                                  ),
                                ),
                                Container(
                                  child: RaisedButton(
                                    child: Text("Reserver"),
                                    onPressed: () {},
                                  ),
                                ),
                                Wrap(
                                  children: <Widget>[
                                    ...this
                                        .listSalles[index]['currentProjection']
                                            ['listTickets']
                                        .map((ticket) {
                                      if (ticket['reserve'] == false) {
                                        return Container(
                                          width: 50,
                                          padding: EdgeInsets.all(2),
                                          child: RaisedButton(
                                            color: Color(0xFF212121),
                                            child: Text(
                                              "${ticket['place']['numero']}",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white),
                                            ),
                                            onPressed: () {},
                                          ),
                                        );
                                      } else
                                        return Container();
                                    })
                                  ],
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  );
                }),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loadSalles();
  }

  void loadSalles() {
    String url = this.widget.cinema['_links']['salles']['href'];

    // String url = "http://192.168.1.15:9090/salles";

    http.get(Uri.parse(url)).then((resp) {
      setState(() {
        this.listSalles = json.decode(resp.body)['_embedded']['salles'];
      });
    }).catchError((err) {
      print(err);
    });
  }

  void loadProjections(salle) {
    //String url1 =
    //  "http://1192.168.1.15:9090/salles/${salle['id']}/projections?projection=p1";
    String url2 = salle['_links']['projections']['href']
        .toString()
        .replaceAll("{?projection}", "?projection=p1");
    //  print(url1);
    print(url2);

    http.get(Uri.parse(url2)).then((resp) {
      setState(() {
        salle['projections'] =
            json.decode(resp.body)['_embedded']['projections'];
        salle['currentProjection'] = salle['projections'][0];
        salle['currentProjection']['listTickets'] = [];
        // print(salle['projections']);
      });
    }).catchError((err) {
      print(err);
    });
  }

  void loadTicket(projection, salle) {
    // String url =
    // "http://192.168.1.15:9090/projections/1/tickets?projection=ticketProj";

    String url = projection['_links']['tickets']['href']
        .toString()
        .replaceAll("{?projection}", "?projection=ticketProj");

    print(url);

    http.get(Uri.parse(url)).then((resp) {
      setState(() {
        projection['listTickets'] =
            json.decode(resp.body)['_embedded']['tickets'];
        salle['currentProjection'] = projection;
        projection['nombrePlaceDisponible'] = nombrePlaceDisponible(projection);
      });
    }).catchError((err) {
      print(err);
    });
  }

  nombrePlaceDisponible(projection) {
    int nombre = 0;
    for (int i = 0; i < projection['tickets'].length; i++) {
      if (projection['tickets'][i]['reserve'] == false) ++nombre;
    }
    return nombre;
  }
}
