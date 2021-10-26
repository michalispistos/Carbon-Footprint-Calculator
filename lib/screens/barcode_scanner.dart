import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

void main() => runApp(MaterialApp(
    home:QRCode(),
  )
);

class QRCode extends StatefulWidget {
  const QRCode({Key? key}) : super(key: key);

  @override
  _QRCodeState createState() => _QRCodeState();
}

class _QRCodeState extends State<QRCode> {
 String _data = "";


  _scan() async{
    await FlutterBarcodeScanner.scanBarcode("#000000", "Cancel", true, ScanMode.BARCODE)
        .then((value) => setState((){
          _data= value;
    }));
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FlatButton(
        onPressed: () => _scan(),
        child: Text("Scan Barcode")),
        Text(_data),

      ]
    ));
  }
}
