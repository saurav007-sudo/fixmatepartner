import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'botom.dart';
import '../viewmodel/auth viewmodel.dart';
import 'forgot.dart';
import 'create.dart' as screen;

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: authViewModel.isLoading
              ? Center(child: CircularProgressIndicator())
              : Center(
            child: Padding(
              padding: EdgeInsets.only(top: 70),
              child: ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.0, left: 20, right: 20),
                    child: Container(
                      height: 180,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("lib/image/logo.png"),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 450,
                    width: 400,
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: 40, left: 17, right: 20),
                      child: Column(
                        children: [
                          TextField(
                            controller: authViewModel.loginMailController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.lightBlue),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              hintText: "Enter your email address",
                              labelStyle: TextStyle(fontWeight: FontWeight.w800),
                              label: Text("Email address"),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: TextField(
                              controller: authViewModel.loginPassController,
                              obscureText: true,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.lightBlue),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                hintText: "Enter your password",
                                labelStyle: TextStyle(fontWeight: FontWeight.w800),
                                label: Text("Password"),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 155, top: 8),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Forgot()));
                              },
                              child: Text(
                                "Forgot password?",
                                style: TextStyle(fontSize: 18, color: Colors.blueAccent, fontWeight: FontWeight.w800),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: GestureDetector(
                              onTap: () async {
                                bool success = await authViewModel.signin();
                                if (!context.mounted) return;
                                if (success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Login Successfully"),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => Bottom()),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Login failed"),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                height: 47,
                                width: 400,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    "Continue",
                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Text("------------------------ OR -----------------------", style: TextStyle(fontSize: 20)),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => screen.Create()));
                              },
                              child: Container(
                                height: 47,
                                width: 400,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.black),
                                ),
                                child: Center(
                                  child: Text(
                                    "Create new account",
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}