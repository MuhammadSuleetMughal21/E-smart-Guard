import 'package:flutter/material.dart';
import 'dart:async';
import 'package:nfc_manager/nfc_manager.dart';

class NfcReaderScreen extends StatefulWidget {
  @override
  _NfcReaderScreenState createState() => _NfcReaderScreenState();
}

class _NfcReaderScreenState extends State<NfcReaderScreen> {
  int scanCounter = 0;
  int totalLaps = 3;
  int scannedTagsCount = 0;
  int maxTagsAllowed = 3;
  int secondsRemaining = 0;
  bool isScanning = false;
  Duration scanInterval = const Duration(seconds: 5);
  final NfcManager nfcManager = NfcManager.instance;

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    startNfcScan();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining > 0) {
        setState(() {
          secondsRemaining--;
        });
        if (isScanning && secondsRemaining == 0) {
          _showErrorMessage();
        }
      }
    });
  }

  Future<void> startNfcScan() async {
    for (int i = 0; i < totalLaps; i++) {
      await _scanOnce();
      isScanning = false;
    }
    isScanning = true;
  }

  Future<void> _scanOnce() async {
    try {
      await nfcManager.startSession(onDiscovered: (NfcTag tag) async {
        await Future.delayed(const Duration(seconds: 1));
        setState(() {
          scannedTagsCount++;
          secondsRemaining = scanInterval.inSeconds; // Reset the timer
        });

        if (scannedTagsCount > maxTagsAllowed) {
          setState(() {
            scannedTagsCount = 0;
            scanCounter++;
          });
        }

        if (scanCounter >= totalLaps) {
          await nfcManager.stopSession();
          _timer.cancel();
        }
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  void _showErrorMessage() {
    if (isScanning) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Time Ended'),
            content: const Text('Time runned out'),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NFC Reader'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Scanned Tags:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              '$scannedTagsCount / $maxTagsAllowed',
              style: const TextStyle(fontSize: 16),
            ),
            if (scannedTagsCount >= maxTagsAllowed)
              const Text(
                'Maximum tags scanned',
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
            Text(
              'Next scan in: $secondsRemaining seconds',
              style: const TextStyle(fontSize: 16),
            ),
            ElevatedButton(
              onPressed: () async {
                // await _runScanningLoop();
              },
              child: const Text('Run Scanning Loop'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    NfcManager.instance.stopSession();
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }
}
