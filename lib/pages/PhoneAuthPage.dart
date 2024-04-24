import 'dart:async';
import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:thirder/Service/Auth_Service.dart';

class PhoneAuthPage extends StatefulWidget {
  const PhoneAuthPage({super.key});

  @override
  State<PhoneAuthPage> createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {
  int start = 30;
  bool wait = false;
  String buttonName = "send";
  TextEditingController phoneController = TextEditingController();
  AuthClass authClass = AuthClass();
  String verificationFinal = "";
  String smsCode = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text(
          "Sign Up",
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            SizedBox(
              height: 120,
            ),
            textField(),
            SizedBox(
              height: 30,
            ),
            Container(
              width: MediaQuery.of(context).size.width - 30,
              child: Row(
                children: [
                  Expanded(
                      child: Container(
                    height: 1,
                    color: Colors.grey,
                    margin: EdgeInsets.symmetric(horizontal: 12),
                  )),
                  Text(
                    "Enter 6 digit OTP",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  Expanded(
                      child: Container(
                    height: 1,
                    color: Colors.grey,
                    margin: EdgeInsets.symmetric(horizontal: 12),
                  )),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            otpField(),
            SizedBox(
              height: 40,
            ),
            RichText(
                text: TextSpan(children: [
              TextSpan(
                text: "send OTP again in ",
                style: TextStyle(fontSize: 16, color: Colors.yellowAccent),
              ),
              TextSpan(
                text: "00:$start",
                style: TextStyle(fontSize: 16, color: Colors.pinkAccent),
              ),
              TextSpan(
                  text: " Sec ",
                  style: TextStyle(fontSize: 16, color: Colors.yellowAccent))
            ])),
            SizedBox(
              height: 150,
            ),
            InkWell(
              onTap: () {
                authClass.signInwithPhoneNumber(
                    verificationFinal, smsCode, context);
              },
              child: Container(
                height: 60,
                width: MediaQuery.of(context).size.width - 60,
                decoration: BoxDecoration(
                  color: Color(0xffff9601),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text(
                    "Lets Go",
                    style: TextStyle(
                      fontSize: 17,
                      color: Color(0xfffbe2ae),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void startTimer() {
    const onsec = Duration(seconds: 1);
    Timer timer = Timer.periodic(onsec, (timer) {
      if (start == 0) {
        setState(() {
          timer.cancel();
          wait = false;
        });
      } else {
        setState(() {
          start--;
        });
      }
    });
  }

  Widget otpField() {
    return OTPTextField(
      length: 6,
      width: MediaQuery.of(context).size.width - 34,
      fieldWidth: 58,
      style: TextStyle(fontSize: 17, color: Colors.white),
      otpFieldStyle: OtpFieldStyle(
          backgroundColor: Color(0xff1d1d1d), borderColor: Colors.white),
      textFieldAlignment: MainAxisAlignment.spaceAround,
      fieldStyle: FieldStyle.underline,
      onCompleted: (pin) {
        print("Completed: " + pin);
        setState(() {
          smsCode = pin;
        });
      },
    );
  }

  Widget textField() {
    return Container(
        width: MediaQuery.of(context).size.width - 40,
        height: 60,
        decoration: BoxDecoration(
            color: Color(0xff1d1d1d), borderRadius: BorderRadius.circular(15)),
        child: TextFormField(
          controller: phoneController,
          style: TextStyle(color: Colors.white, fontSize: 17),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Enter your phone Number",
            hintStyle: TextStyle(color: Colors.white54, fontSize: 17),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 19, horizontal: 8),
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 15),
              child: Text(
                "( +250 )",
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
            ),
            suffixIcon: InkWell(
              onTap: wait
                  ? null
                  : () async {
                      startTimer();
                      setState(() {
                        wait = true;
                        start = 30;
                        buttonName = "Resend";
                      });
                      await authClass.verifyPhoneNumber(
                          "+91 ${phoneController}", context, setData);
                    },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 15,
                ),
                child: Text(
                  buttonName,
                  style: TextStyle(
                      color: wait ? Colors.grey : Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ));
  }

  void setData(String verificationId) {
    setState(() {
      verificationFinal = verificationId;
    });
    startTimer();
  }
}
