import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:todo/screens/home_screen.dart';

class FingerprintAuth extends StatefulWidget {
  @override
  _FingerprintAuthState createState() => _FingerprintAuthState();
}

class _FingerprintAuthState extends State<FingerprintAuth> {
  static final _scaffoldKey = GlobalKey<ScaffoldState>();
  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics;
  List<BiometricType> _availableBiometrics;
  bool _isAuthenticating = false;
  String _authorized = "Authenticating";

  Future<bool> _checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return false;

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });

    return canCheckBiometrics;
  }

  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics;

    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;

    setState(() {
      _availableBiometrics = availableBiometrics;
    });
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });

      authenticated = await auth.authenticateWithBiometrics(
          localizedReason: 'Scan your fingerprint to authenticate',
          useErrorDialogs: true,
          stickyAuth: true);

      setState(() {
        _isAuthenticating = false;
        _authorized = "Authenticating";
      });
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;

    if (authenticated) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    }
  }

  void cancelAuthentication() {
    auth.stopAuthentication();
  }

  @override
  void initState() {
    // TODO: implement initState
    _checkBiometrics().whenComplete(() {
      if (_canCheckBiometrics) {
        _authenticate();
      } else {
        _authorized = "Device does not have fingerprint hardware set up";
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Fingerprint Authentication"),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            Center(
                child: Icon(
              Icons.fingerprint_sharp,
              size: 100,
            )),
            SizedBox(height: 30,),
            RichText(
              text: TextSpan(
                  text: "Fingerprint\n\n",
                  style: TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                        text:
                            "Place your registered finger on the sensor for authentication")
                  ]),
              textAlign: TextAlign.center,
            ),
            Spacer(
              flex: 3,
            ),
          ],
        ),
      ),
    );
  }
}
