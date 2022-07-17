import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Sample extends StatefulWidget {
  @override
  _SampleState createState() => new _SampleState();
}

class _SampleState extends State<Sample> {
  List<String> countries = <String>['Belgium','France','Italy','Germany','Spain','Portugal'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){_showDialog();});
  }

  _showDialog() async{
    await showDialog<String>(
      context: context,
      builder: (BuildContext context){
        return new CupertinoAlertDialog(
          title: new Text('Please select'),
          actions: <Widget>[
            new CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: (){Navigator.of(context).pop('Cancel');},
              child: new Text('Cancel'),
            ),
            new CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: (){Navigator.of(context).pop('Accept');},
              child: new Text('Accept'),
            ),
          ],
          content: new SingleChildScrollView(
            child: new Material(
              child: new MyDialogContent(countries: countries),
            ),
          ),
        );
      },
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Container();
  }
}

class MyDialogContent extends StatefulWidget {
  MyDialogContent({
    Key key,
    this.countries,
  }): super(key: key);

  final List<String> countries;

  @override
  _MyDialogContentState createState() => new _MyDialogContentState();
}

class _MyDialogContentState extends State<MyDialogContent> {
  int _selectedIndex = 0;

  @override
  void initState(){
    super.initState();
  }

  _getContent(){
    if (widget.countries.length == 0){
      return new Container();
    }

    return new Column(
        children: new List<RadioListTile<int>>.generate(
            widget.countries.length,
                (int index){
              return new RadioListTile<int>(
                value: index,
                groupValue: _selectedIndex,
                title: new Text(widget.countries[index]),
                onChanged: (int value) {
                  setState((){
                    _selectedIndex = value;
                  });
                },
              );
            }
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return _getContent();
  }
}