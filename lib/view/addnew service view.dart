import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodel/addnew service viewmodel.dart';

class AddNew extends StatefulWidget {
  const AddNew({super.key});

  @override
  State<AddNew> createState() => _AddNewState();
}

class _AddNewState extends State<AddNew> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AddNewViewModel>(
      builder: (context, addNewViewModel, child) {
        return Scaffold(
          backgroundColor: Color(0xFFEFF9FF),
          body: addNewViewModel.isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 15, left: 15, right: 15),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          Icon(
                            CupertinoIcons.arrow_left,
                            size: 18,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 85),
                      child: Text(
                        "Add New Service",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15, left: 15, right: 15),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage("lib/image/logo.png"),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "Technician: Suresh Babu",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 12, left: 15, bottom: 6),
                child: Text(
                  "Service Name",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black54,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TextField(
                        controller: addNewViewModel.serviceNameController,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter Service Name ",
                          hintStyle: TextStyle(fontSize: 12, color: Colors.black54),
                          isDense: true,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 12, left: 15, bottom: 6),
                child: Text(
                  "Description",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black54,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 13),
                child: Container(
                  height: 75,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: TextField(
                      controller: addNewViewModel.descriptionController,
                      maxLines: 3,
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText:
                        "Describe the service (e.g., 'I will assemble your flat-pack furniture'). Include details like what's covered and what's not.",
                        hintStyle: TextStyle(fontSize: 11, color: Colors.black54),
                        isDense: true,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 12, left: 15, bottom: 6),
                child: Text(
                  "Price",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black54,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        Text(
                          "₹",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: Colors.black87,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: SizedBox(
                            width: 270,
                            child: TextField(
                              controller: addNewViewModel.priceController,
                              keyboardType: TextInputType.number,
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Enter Price",
                                hintStyle: TextStyle(fontSize: 14, color: Colors.black54),
                                isDense: true,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 12, left: 15, bottom: 4),
                child: Text(
                  "Minimum Charge",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black54,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 12, left: 15, bottom: 6),
                child: Text(
                  "Portfolio Images (Optional)",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black54,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Container(
                      height: 65,
                      width: 72,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: Icon(CupertinoIcons.photo, size: 24, color: Colors.black54),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Container(
                        height: 65,
                        width: 72,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black38, style: BorderStyle.solid),
                        ),
                        child: Icon(CupertinoIcons.add, size: 24, color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 20),
                child: GestureDetector(
                  onTap: () async {
                    bool success = await addNewViewModel.createService(context);
                    if (success) {
                      if (!context.mounted) return;
                      Navigator.pop(context);
                    }
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color(0xFF2979FF),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Center(
                      child: Text(
                        "Create Service",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}