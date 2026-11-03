import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodel/editpersonal viewmodel.dart';

class Edit extends StatefulWidget {
  final String? initialName;
  final String? initialEmail;

  const Edit({
    super.key,
    this.initialName,
    this.initialEmail,
  });

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EditProfileViewModel>(context, listen: false).loadUserData(
        name: widget.initialName,
        email: widget.initialEmail,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EditProfileViewModel>(
      builder: (context, editProvider, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFEFF9FF),
          body: SizedBox(
            height: 800,
            width: 360,
            child: SafeArea(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
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
                        const Padding(
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
                    padding: const EdgeInsets.only(
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
                                    : const AssetImage("lib/asset/44-extractpics.jpg") as ImageProvider),
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
                                  child: const Icon(
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
                          padding: const EdgeInsets.only(
                            left: 18,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                editProvider.nameController.text.isEmpty
                                    ? "Suresh Babu"
                                    : editProvider.nameController.text,
                                style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const Padding(
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
                    padding: const EdgeInsets.only(
                      left: 18,
                      right: 18,
                      top: 20,
                    ),
                    child: Container(
                      height: 200, // Adjusted height for Name and Email fields only
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 15,
                              right: 15,
                              top: 15,
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 27,
                                  backgroundColor: const Color(0xFFE7F3FF),
                                  child: Icon(
                                    CupertinoIcons.person,
                                    color: Colors.blue[800],
                                    size: 25,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 12,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Full name",
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 3,
                                        ),
                                        child: SizedBox(
                                          width: 220,
                                          child: TextField(
                                            controller: editProvider.nameController,
                                            onChanged: (val) => setState(() {}),
                                            style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w700,
                                            ),
                                            decoration: const InputDecoration(
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
                            padding: const EdgeInsets.only(
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
                            padding: const EdgeInsets.only(
                              left: 15,
                              right: 15,
                              top: 9,
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 27,
                                  backgroundColor: const Color(0xFFE7F3FF),
                                  child: Icon(
                                    CupertinoIcons.mail,
                                    color: Colors.blue[800],
                                    size: 25,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 12,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Email address",
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 3,
                                        ),
                                        child: SizedBox(
                                          width: 220,
                                          child: TextField(
                                            controller: editProvider.mailController,
                                            style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w700,
                                            ),
                                            decoration: const InputDecoration(
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
                    padding: const EdgeInsets.only(
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
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
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
                            padding: const EdgeInsets.only(
                              left: 20,
                              top: 15,
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 17,
                                  backgroundColor: const Color(0xFFF0F0F0),
                                  child: Icon(
                                    CupertinoIcons.calendar,
                                    size: 17,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                const Padding(
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
                                const Text(
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
                            padding: const EdgeInsets.only(
                              left: 20,
                              top: 12,
                            ),
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  radius: 17,
                                  backgroundColor: Color(0xFFDDF7E8),
                                  child: Icon(
                                    CupertinoIcons.checkmark,
                                    size: 17,
                                    color: Colors.green,
                                  ),
                                ),
                                const Padding(
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
                                const Text(
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
                    padding: const EdgeInsets.only(
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
                            const SnackBar(
                              content: Text("Profile updated successfully!"),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
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
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
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