import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  void _settingsPressed() {
    setState(() {
      apiInfo._info = "Cake";
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
                _settingsPressed();
              },
            ),
          ],
        ),
        body: Builder(
            builder: (context) =>
                Center(
                  child: ClipRRect (
                    borderRadius: BorderRadius.circular(8.0),
                    child: Container(
                      height: (MediaQuery.of(context).size.height) / 8,
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: Material(
                        color: Colors.black87,
                        child: apiTextBox(context,apiInfo),
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

Widget apiTextBox(BuildContext context, ApiInfo apiInfo){

  String _apiValue = apiInfo._info;

  return InkWell(
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
    );
}

class ApiInfo{
  String _info = "cookie";
}