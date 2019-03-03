import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';


class ShowReceiptFields extends StatelessWidget{
  final String parsedText;

  //Some text is required
  ShowReceiptFields({Key key, @required this.parsedText}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Show Receipt"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                child:  Text(
                    parsedText,
                    style: TextStyle(fontSize: 22.0)
                )
              ),
            ),
            RaisedButton(
              onPressed: () {
                // Navigate back to first route when tapped.
                Navigator.pop(context);
              },
              child: Text('Go back to camera!'),
            ),
          ],
        ),
      ),
    );
  }

}