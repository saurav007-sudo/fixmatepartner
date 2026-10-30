import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodel/editpersonal viewmodel.dart';

class Edit extends StatefulWidget {
  const Edit({super.key});

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EditProfileViewModel>(context, listen: false).loadUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EditProfileViewModel>(
      builder: (context, editProvider, child) {
        return Scaffold(
          backgroundColor: Color(0xFFEFF9FF),
          body: SizedBox(
            height: 800,
            width: 360,
            child: SafeArea(
              child: ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 15,
                      right: 15,
                      top: 10,
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            CupertinoIcons.arrow_left,
                            size: 28,
                            color: Colors.blue[900],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 22,
                          ),
                          child: Text(
                            "Edit Personal info",
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 13,
                      top: 18,
                    ),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 52,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 48,
                                backgroundImage: editProvider.selectedImageFile != null
                                    ? (kIsWeb
                                    ? NetworkImage(editProvider.selectedImageFile!.path) as ImageProvider
                                    : FileImage(File(editProvider.selectedImageFile!.path)) as ImageProvider)
                                    : (editProvider.profileImageUrl != null && editProvider.profileImageUrl!.isNotEmpty
                                    ? NetworkImage(editProvider.profileImageUrl!) as ImageProvider
                                    : AssetImage("lib/asset/44-extractpics.jpg") as ImageProvider),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () => editProvider.pickImage(),
                                child: CircleAvatar(
                                  radius: 16,
                                  backgroundColor: Colors.blue[800],
                                  child: Icon(
                                    CupertinoIcons.camera_fill,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 18,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                editProvider.nameController.text.isEmpty
                                    ? "Suresh Babu"
                                    : editProvider.nameController.text,
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 4, right: 8),
                                child: Text(
                                  "Electrician",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 18,
                      right: 18,
                      top: 20,
                    ),
                    child: Container(
                      height: 365,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.15),
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: 15,
                              right: 15,
                              top: 15,
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 27,
                                  backgroundColor: Color(0xFFE7F3FF),
                                  child: Icon(
                                    CupertinoIcons.person,
                                    color: Colors.blue[800],
                                    size: 25,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: 12,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Full name",
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: 3,
                                        ),
                                        child: SizedBox(
                                          width: 220,
                                          child: TextField(
                                            controller: editProvider.nameController,
                                            onChanged: (val) => setState(() {}),
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w700,
                                            ),
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              isDense: true,
                                              contentPadding: EdgeInsets.zero,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 80,
                              right: 15,
                              top: 7,
                            ),
                            child: Container(
                              height: 1,
                              color: Colors.grey[300],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 15,
                              right: 15,
                              top: 9,
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 27,
                                  backgroundColor: Color(0xFFE7F3FF),
                                  child: Icon(
                                    CupertinoIcons.mail,
                                    color: Colors.blue[800],
                                    size: 25,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: 12,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Email address",
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: 3,
                                        ),
                                        child: SizedBox(
                                          width: 220,
                                          child: TextField(
                                            controller: editProvider.mailController,
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w700,
                                            ),
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              isDense: true,
                                              contentPadding: EdgeInsets.zero,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 80,
                              right: 15,
                              top: 7,
                            ),
                            child: Container(
                              height: 1,
                              color: Colors.grey[300],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 15,
                              right: 15,
                              top: 9,
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 27,
                                  backgroundColor: Color(0xFFE7F3FF),
                                  child: Icon(
                                    CupertinoIcons.phone,
                                    color: Colors.blue[800],
                                    size: 25,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: 12,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Phone number",
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: 3,
                                        ),
                                        child: SizedBox(
                                          width: 220,
                                          child: TextField(
                                            controller: editProvider.phoneController,
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w700,
                                            ),
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              isDense: true,
                                              contentPadding: EdgeInsets.zero,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 80,
                              right: 15,
                              top: 7,
                            ),
                            child: Container(
                              height: 1,
                              color: Colors.grey[300],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 15,
                              right: 15,
                              top: 9,
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 27,
                                  backgroundColor: Color(0xFFE7F3FF),
                                  child: Icon(
                                    CupertinoIcons.calendar,
                                    color: Colors.blue[800],
                                    size: 25,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: 12,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Date of Birth",
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: 3,
                                        ),
                                        child: SizedBox(
                                          width: 220,
                                          child: TextField(
                                            controller: editProvider.dobController,
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w700,
                                            ),
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              isDense: true,
                                              contentPadding: EdgeInsets.zero,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 18,
                      right: 18,
                      top: 18,
                    ),
                    child: Container(
                      height: 170,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.15),
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: 20,
                              top: 17,
                            ),
                            child: Text(
                              "Account Information",
                              style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 20,
                              top: 15,
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 17,
                                  backgroundColor: Color(0xFFF0F0F0),
                                  child: Icon(
                                    CupertinoIcons.calendar,
                                    size: 17,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: 10,
                                  ),
                                  child: Text(
                                    "Member since: ",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Text(
                                  "2026",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 20,
                              top: 12,
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 17,
                                  backgroundColor: Color(0xFFDDF7E8),
                                  child: Icon(
                                    CupertinoIcons.checkmark,
                                    size: 17,
                                    color: Colors.green,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: 10,
                                  ),
                                  child: Text(
                                    "Account status: ",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Text(
                                  "Verified",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 18,
                      right: 18,
                      top: 18,
                      bottom: 15,
                    ),
                    child: GestureDetector(
                      onTap: editProvider.isLoading
                          ? null
                          : () async {
                        bool success = await editProvider.saveChanges();
                        if (!context.mounted) return;
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Profile updated successfully!"),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Error updating profile"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      child: Container(
                        height: 58,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: editProvider.isLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text(
                            "Save Changes",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}