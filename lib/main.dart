import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_admob/firebase_admob.dart';

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
  List<dynamic> dropdownItems = ["normal", "loading values"];
  String dropdownValue = 'normal';
  String dropdownValue2 = 'normal';

  var _combatPower = 2000;
  var _hitPoints = 100;
  var _attackRelation = true;
  var _doubleSuper = false;
  var _onlyWeakness = false;
  var _stab = true;
  var _weaknessMove = true;
  var _weaknessType = true;

  TextEditingController _combatController;
  TextEditingController _hitController;

  @override
  void initState() {
    fetchTypes('https://pogosearchgeneratorapistaging.azurewebsites.net/api/types')
        .then((value){
      setState(() {dropdownItems = value;});
    });

    super.initState();

    _combatController = new TextEditingController(text: _combatPower.toString());
    _hitController = new TextEditingController(text: _hitPoints.toString());
  }

  void _settingsPressed(String text) {
    setState(() {
      apiInfo._info = text;
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
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: new DropdownButton<String>(
                            hint: new Text("Select"),
                            value: dropdownValue,
                            onChanged: (String newValue) {

                              setState(() {
                                dropdownValue = newValue;
                              });
                            },
                            items: dropdownItems.map((dynamic item) {
                              return new DropdownMenuItem<String>(
                                value: item,
                                child: new Text(item),
                              );
                            }).toList(),
                          ),
                        ),
                        Expanded(
                          child: new DropdownButton<String>(
                            hint: new Text("Select"),
                            value: dropdownValue2,
                            onChanged: (String newValue) {

                              setState(() {
                                dropdownValue2 = newValue;
                              });
                            },
                            items: dropdownItems.map((dynamic item) {
                              return new DropdownMenuItem<String>(
                                value: item,
                                child: new Text(item),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                    new TextField(
                      decoration: new InputDecoration(labelText: "Combat Power"),
                      controller: _combatController,
                      keyboardType: TextInputType.number,
                    ),
                    new TextField(
                      decoration: new InputDecoration(labelText: "Hit Power"),
                      controller: _hitController,
                      keyboardType: TextInputType.number,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child:  CheckboxListTile(
                            title: const Text('STAB'),
                            value: _stab,
                            onChanged: (bool value) {
                              setState(() {_stab = value;});
                            },
                          ),
                        ),
                        Expanded(
                          child: CheckboxListTile(
                            title: const Text('Only\t Weakness'),
                            value: _onlyWeakness,
                            onChanged: (bool value) {
                              setState(() {_onlyWeakness = value;});
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child:  CheckboxListTile(
                            title: const Text('Attack\t Relation'),
                            value: _attackRelation,
                            onChanged: (bool value) {
                              setState(() {_attackRelation = value;});
                            },
                          ),
                        ),
                        Expanded(
                          child:  CheckboxListTile(
                            title: const Text('Weakness\t Type'),
                            value: _weaknessType,
                            onChanged: (bool value) {
                              setState(() {_weaknessType = value;});
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child:  CheckboxListTile(
                            title: const Text('DoubleSuper'),
                            value: _doubleSuper,
                            onChanged: (bool value) {
                              setState(() {_doubleSuper = value;});
                            },
                          ),
                        ),
                        Expanded(
                          child: CheckboxListTile(
                            title: const Text('Weakness\t Move'),
                            value: _weaknessMove,
                            onChanged: (bool value) {
                              setState(() {_weaknessMove = value;});
                            },
                          ),
                        ),
                      ],
                    ),
                    Container(
                      child: RaisedButton(
                        child: Text('Search'),
                        onPressed: () async{
                          Post newPost = new Post(
                              types: [dropdownValue,dropdownValue2].toList(),
                              combatPoints: int.parse(_combatController.text),
                              hitPoints: int.parse(_hitController.text),
                              attackRelation: _attackRelation,
                              doubleSuper: _doubleSuper,
                              onlyWeakness: _onlyWeakness,
                              stab: _stab,
                              weaknessMove: _weaknessMove,
                              weaknessType: _weaknessType
                          );
                          _settingsPressed(await createSearchString('https://pogosearchgeneratorapistaging.azurewebsites.net/api/types',
                              body: newPost.toMap()));
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
                  'Copied to Clipboard',
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
  String _info = "bug,ghost,dark&@1bug,@1ghost,@1dark&@2bug,@3bug,@2ghost,@3ghost,@2dark,@3dark&cp2000-&hp100-&!fighting&!poison";
}