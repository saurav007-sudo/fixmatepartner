import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodel/editservice viewmodel.dart';

class EditService extends StatefulWidget {
  const EditService({super.key});

  @override
  State<EditService> createState() => _EditServiceState();
}

class _EditServiceState extends State<EditService> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EditServiceViewModel>(context, listen: false).loadServiceData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EditServiceViewModel>(
      builder: (context, editServiceViewModel, child) {
        return Scaffold(
          backgroundColor: Color(0xFFEFF9FF),
          body: SafeArea(
            child: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 15, left: 15, right: 15),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(
                          CupertinoIcons.arrow_left,
                          size: 18,
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 30),
                        child: Text(
                          "Edit Service",
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Editing: ${editServiceViewModel.serviceNameController.text}",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              "Category: ${editServiceViewModel.partnerCategory ?? 'General'}",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.black54,
                              ),
                            ),
                          ],
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
                      child: TextField(
                        controller: editServiceViewModel.serviceNameController,
                        onChanged: (val) => setState(() {}),
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 12, left: 15, bottom: 6),
                  child: Text(
                    "Service Description",
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
                    height: 65,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: TextField(
                        controller: editServiceViewModel.descriptionController,
                        maxLines: 2,
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 12, left: 15, right: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 6),
                        child: Text(
                          "Base Price (₹)",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      Container(
                        height: 48,
                        width: 160,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.black12),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: TextField(
                            controller: editServiceViewModel.basePriceController,
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 25, left: 15, right: 15),
                  child: GestureDetector(
                    onTap: editServiceViewModel.isLoading
                        ? null
                        : () async {
                      bool success = await editServiceViewModel.saveChanges();
                      if (!context.mounted) return;
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Service updated successfully in both profile and category!")),
                        );
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Error updating service")),
                        );
                      }
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color(0xFF0065B8),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Center(
                        child: editServiceViewModel.isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                          "Save Changes",
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
                Padding(
                  padding: EdgeInsets.only(top: 12, left: 15, right: 15, bottom: 20),
                  child: GestureDetector(
                    onTap: editServiceViewModel.isLoading
                        ? null
                        : () async {
                      bool success = await editServiceViewModel.deleteService();
                      if (!context.mounted) return;
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Service deleted successfully!")),
                        );
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Error deleting service")),
                        );
                      }
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: Center(
                        child: Text(
                          "Delete Service",
                          style: TextStyle(
                            color: Color(0xFFC62828),
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
          ),
        );
      },
    );
  }
}