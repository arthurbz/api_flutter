import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String text = "";

  final myController = TextEditingController();

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  void attText(apiText) {
    setState(() {
      text = apiText;
    });
  }

  Future<String> cotacaoUSD() async {
      String url = 'https://economia.awesomeapi.com.br/all/';
      url += myController.text;
      var response = await http
      .get(Uri.encodeFull(url), );
      Map<String, dynamic> moeda = jsonDecode(response.body);
      var m_lista = moeda[myController.text];
      String apiText = ('Hoje ${m_lista['code']} 1 vale ${m_lista['codein']} ${m_lista['bid']}');
      attText(apiText);
  }

  Future<String> descobreCEP() async {
    String url = 'https://cep.awesomeapi.com.br/json/';
    url += myController.text;
    var response = await http
    .get(Uri.encodeFull(url), headers: {});//O headers do http seria mais apropriado para colocar os dados,
    Map<String, dynamic> cep = jsonDecode(response.body);//mas por algum motivo não consigo passar as variáveis como parâmetro ¯\_(ツ)_/¯
    String apiText = ('CEP ${cep['cep']}\nRua ${cep['address_name']}\nBairro ${cep['district']}\nCidade ${cep['city']}');
    attText(apiText);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text('Flutter ^-^'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Moeda ou CEP',
              style: TextStyle(
              fontSize: 32,
              color: Colors.lightBlueAccent ),
            ),

            Container(
              margin: const EdgeInsets.all(20.0),
              padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: myController,
                  decoration: InputDecoration(  
                  border: OutlineInputBorder(),
                  labelText: 'Não sou à prova de usuários!!!',
                  ),
                ),
            ),

            RaisedButton(
              onPressed: cotacaoUSD,
              child: Text('API Moedas ')
            ),

            RaisedButton(
              onPressed: descobreCEP,
              child: Text('API CEP')
            ),

            RaisedButton(
              onPressed: () {
                Route route = MaterialPageRoute(builder: (context) => SobrePage());
                Navigator.push(context, route);
              },
              child: Text('Sobre')
            ),
            
            Text(text,
              style: TextStyle(
              fontSize: 20,
              color: Colors.lightBlueAccent ),
            ),
          ],
        ),
      ),
    );
  }
}

class SobrePage extends StatelessWidget {

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('GRUPO'),
        ),
        body: new Center(
          child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
              Container(
                margin: const EdgeInsets.all(20.0),
                padding: const EdgeInsets.all(10.0),
                child: FlutterLogo(
                  size: 100.0,
                ),
            ),
            Text('GRUPO:\nArthur\nGregori\nLeonardo',
              textAlign: TextAlign.center,
                style: TextStyle(
                fontSize: 30,
                color: Colors.lightBlueAccent ),),
           ],
         ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Route route = MaterialPageRoute(builder: (context) => MyHomePage());
            Navigator.push(context, route);
          },
          tooltip: 'Voltar',
          child: Icon(Icons.arrow_back),
      ),
      );
    }
  }
