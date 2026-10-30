import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'botom.dart';
import '../viewmodel/auth viewmodel.dart';

class Create extends StatelessWidget {
  const Create({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text(
              "Create Partner Account",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800, color: Colors.black),
            ),
          ),
          body: authViewModel.isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView(
            children: [
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 28, left: 10, right: 10),
                    child: TextField(
                      controller: authViewModel.createNameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightBlue),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        hintText: "Enter your name",
                        label: Text("Name", style: TextStyle(fontWeight: FontWeight.w800)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 28, left: 10, right: 10),
                    child: TextField(
                      controller: authViewModel.createMailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightBlue),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        hintText: "Enter your Email",
                        label: Text("Email", style: TextStyle(fontWeight: FontWeight.w800)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 28, left: 10, right: 10),
                    child: TextField(
                      controller: authViewModel.createPassController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightBlue),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        hintText: "Enter your password",
                        label: Text("Password", style: TextStyle(fontWeight: FontWeight.w800)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 28, left: 10, right: 10),
                    child: TextField(
                      controller: authViewModel.createPass2Controller,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightBlue),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        hintText: "Enter confirm password",
                        label: Text("Confirm Password", style: TextStyle(fontWeight: FontWeight.w800)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 28, left: 10, right: 10),
                    child: TextField(
                      controller: authViewModel.createAddressController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightBlue),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        hintText: "Enter your address",
                        label: Text("Address", style: TextStyle(fontWeight: FontWeight.w800)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 28, left: 10, right: 10),
                    child: TextField(
                      controller: authViewModel.createMobController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightBlue),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        hintText: "Enter your phone number",
                        label: Text("Phone number", style: TextStyle(fontWeight: FontWeight.w800)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 165.0, top: 15),
                    child: Text(
                      "Select Category",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                    ),
                  ),
                  SizedBox(
                    height: 180,
                    child: Padding(
                      padding: EdgeInsets.only(top: 18.0),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisExtent: 38,
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 20,
                        ),
                        itemCount: authViewModel.serviceCategories.length,
                        itemBuilder: (context, index) {
                          bool isSelected = authViewModel.selectedCategoryIndex == index;
                          return GestureDetector(
                            onTap: () => authViewModel.selectCategory(index),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isSelected ? Colors.blue : Colors.blue[100],
                                  border: Border.all(
                                    color: isSelected ? Colors.blue.shade900 : Colors.black,
                                    width: isSelected ? 2 : 1,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Center(
                                  child: Text(
                                    authViewModel.serviceCategories[index],
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 18,
                                      color: isSelected ? Colors.white : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 28, left: 10, right: 10, bottom: 30),
                    child: GestureDetector(
                      onTap: () async {
                        String? errorMessage = await authViewModel.signup();
                        if (!context.mounted) return;
                        if (errorMessage == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Partner Account Created Successfully"),
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
                              content: Text(errorMessage),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      child: Container(
                        height: 47,
                        width: 400,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            "CREATE",
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}