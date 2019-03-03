import 'dart:async';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

import 'show_receipt_fields.dart';

class CameraScreen extends StatefulWidget {
  CameraScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController _cameraController;
  bool isElaborating = false;

  //Using the firebase ML library to extract the text from the photo
  Future _elaborateImage(BuildContext context) async {
    setState(() {
      isElaborating = true;
    });

    final path =  (await getTemporaryDirectory()).path + DateTime.now().toString();
    await _cameraController.takePicture(path);

    print("Image acquired with path = " + path);

    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFilePath(path);
    final TextRecognizer textRecognizer =
        FirebaseVision.instance.textRecognizer();

    print("Firebase initialized");

    final VisionText visionText =
        await textRecognizer.processImage(visionImage);

    await Navigator.push(context,
      MaterialPageRoute(
          builder: (context) => ShowReceiptFields(parsedText: visionText.text)
      )
    );

    //Changing the flag without calling setState, so that the build method is not called before launching ShowReceiptFields
    isElaborating = false;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: isElaborating
          ? CircularProgressIndicator()
          : Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _isCameraReady()
                ? AspectRatio(
                    aspectRatio: _cameraController.value.aspectRatio,
                    child: CameraPreview(_cameraController),
                  )
                : SizedBox()
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _elaborateImage(context),
        // onPressed: ()=>  setState(() { textValue = "Button pressed"; }),
        tooltip: 'Increment',
        child: Icon(Icons.photo_camera),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  @override
  //Init camera state
  void initState() {
    super.initState();

    availableCameras().then((cameras) async {
      _cameraController = new CameraController(
        cameras[0],
        ResolutionPreset.medium,
      );
      await _cameraController.initialize();
      setState(() {});
    }).catchError((error) {
      print("Error $error");
    });
  }

  @override
  //Dispose camera
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  bool _isCameraReady() =>
      _cameraController != null && _cameraController.value.isInitialized;
}
