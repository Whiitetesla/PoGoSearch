import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Infrastucture/TypeStringGenerator.dart';

void main() => runApp(HomePage());

class HomePage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ApiInfo apiInfo = ApiInfo();

  void _settingsPressed(String text) {
    setState(() {
      apiInfo._info = text;
      print('the button was pressed');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Welcome'),
          actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.settings),
              tooltip: 'General settings for the app',
              onPressed: () {
                _settingsPressed('cake');
              },
            ),
          ],
        ),
        body: Builder(
            builder: (context) =>
                ListView(
                  children: <Widget>[
                    Container(
                      child: RaisedButton(
                        child: Text('press to connect to api'),
                        onPressed: () async{
                          Post newPost = new Post(
                              types: ['psychic'],
                              combatPoints: 2000,
                              hitPoints: 100,
                              attackRelation: true,
                              doubleSuper: false,
                              onlyWeakness: false,
                              stab: true,
                              weaknessMove: true,
                              weaknessType: true
                          );
                          _settingsPressed(await createSearchString('https://pogosearchgeneratorapistaging.azurewebsites.net/api/types',
                              body: newPost.toMap()));
                        },
                      ),
                    ),
                    Container(
                      child: RaisedButton(
                        child: Text('press to get types from api'),
                        onPressed: () async{

                          var result = await fetchTypes('https://pogosearchgeneratorapistaging.azurewebsites.net/api/types');

                          print(result);

                          _settingsPressed(result);
                        },
                      ),
                    ),
                    apiTextBox(context, apiInfo),
                  ]
                ),
        ),
      ),
    );
  }
}

Widget apiTextBox(BuildContext context, ApiInfo apiInfo){

  String _apiValue = apiInfo._info;

  return ClipRRect (
    borderRadius: BorderRadius.circular(8.0),
    child: Container(
      height: (MediaQuery.of(context).size.height) / 8,
      width: MediaQuery.of(context).size.width / 1.5,
      child: Material(
        color: Colors.black87,
        child: InkWell(
          splashColor: Colors.white,
          onTap: (){
            ClipboardManager.copyToClipBoard("$_apiValue").then((result) {
              final snackBar = SnackBar(
                content: Text(
                  'Copied $_apiValue to Clipboard',
                  textAlign: TextAlign.center,
                ),
                duration: Duration(seconds: 1),
              );
              Scaffold.of(context).showSnackBar(snackBar);
            });
          },
          child: Text(
            "$_apiValue",
            style: TextStyle(
                fontSize: 12.0,
                color: Colors.white
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
  );
}

class ApiInfo{
  String _info = "cookie";
}