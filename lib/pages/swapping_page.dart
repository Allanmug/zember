import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:io' as io;
import 'models/swapping_record.dart';

class SwappingPage extends StatefulWidget {
  @override
  _SwappingPageState createState() => _SwappingPageState();
}

class _SwappingPageState extends State<SwappingPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _riderIdController = TextEditingController();
  final TextEditingController _bikeIdController = TextEditingController();
  final TextEditingController _mileageController = TextEditingController();
  final TextEditingController _gaugeInController = TextEditingController();
  final TextEditingController _batteryInController = TextEditingController();
  final TextEditingController _gaugeOutController = TextEditingController();
  final TextEditingController _batteryOutController = TextEditingController();
  final TextEditingController _chargerController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  bool _isFormValid = false;

  @override
  void dispose() {
    _riderIdController.dispose();
    _bikeIdController.dispose();
    _mileageController.dispose();
    _gaugeInController.dispose();
    _batteryInController.dispose();
    _gaugeOutController.dispose();
    _batteryOutController.dispose();
    _chargerController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _scanQRCode(TextEditingController controller) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QRViewExample(controller: controller),
      ),
    );
    if (result != null && result is String) {
      setState(() {
        controller.text = result;
      });
    }
  }

  void _sendData() {
    if (_formKey.currentState?.validate() ?? false) {
      // Gather data from the form
      String riderId = _riderIdController.text;
      String bikeId = _bikeIdController.text;
      String mileage = _mileageController.text;
      String gaugeIn = _gaugeInController.text;
      String batteryIn = _batteryInController.text;
      String gaugeOut = _gaugeOutController.text;
      String batteryOut = _batteryOutController.text;
      String charger = _chargerController.text;
      String comment = _commentController.text;

      // Calculate the price
      double price =
          ((double.tryParse(gaugeOut) ?? 0) - (double.tryParse(gaugeIn) ?? 0)) *
              45;

      // Create a new SwappingRecord
      final newRecord = SwappingRecord(
        id: DateTime.now()
            .toString(), // Just using the current timestamp as an ID
        date: DateTime.now(),
        riderId: riderId,
        bikeId: bikeId,
        mileage: mileage,
        gaugeIn: gaugeIn,
        batteryIn: batteryIn,
        gaugeOut: gaugeOut,
        batteryOut: batteryOut,
        charger: charger,
        comment: comment,
        price: price,
      );

      Navigator.pop(context, newRecord);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Battery Swapping'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          onChanged: () {
            setState(() {
              _isFormValid = _formKey.currentState?.validate() ?? false;
            });
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildInputField(
                  label: 'Rider ID',
                  controller: _riderIdController,
                  isQRCodeField: true),
              SizedBox(height: 12),
              _buildInputField(
                  label: 'Bike ID',
                  controller: _bikeIdController,
                  isQRCodeField: true),
              SizedBox(height: 12),
              _buildInputField(
                  label: 'Mileage', controller: _mileageController),
              SizedBox(height: 12),
              _buildInputField(
                  label: 'Gauge In (%)', controller: _gaugeInController),
              SizedBox(height: 12),
              _buildInputField(
                  label: 'Battery In',
                  controller: _batteryInController,
                  isQRCodeField: true),
              SizedBox(height: 12),
              _buildInputField(
                  label: 'Gauge Out (%)', controller: _gaugeOutController),
              SizedBox(height: 12),
              _buildInputField(
                  label: 'Battery Out',
                  controller: _batteryOutController,
                  isQRCodeField: true),
              SizedBox(height: 12),
              _buildInputField(
                  label: 'Charger',
                  controller: _chargerController,
                  isQRCodeField: true),
              SizedBox(height: 12),
              _buildInputField(
                  label: 'Comment', controller: _commentController),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _isFormValid ? _sendData : null,
                    child: Text('Send'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
      {required String label,
      required TextEditingController controller,
      bool isQRCodeField = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        readOnly: isQRCodeField,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
        decoration: InputDecoration(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          labelText: label,
          suffixIcon: isQRCodeField
              ? IconButton(
                  icon: Icon(Icons.qr_code),
                  onPressed: () {
                    _scanQRCode(controller);
                  },
                )
              : null,
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class QRViewExample extends StatefulWidget {
  final TextEditingController controller;
  QRViewExample({required this.controller});

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  void reassemble() {
    super.reassemble();
    if (io.Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (io.Platform.isIOS) {
      controller?.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  controller?.dispose();
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      final code = scanData.code;
      if (code != null) {
        widget.controller.text = code;
        controller.dispose();
        Navigator.pop(context, code);
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
