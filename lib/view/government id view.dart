import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../viewmodel/government id viewmodel.dart';

class GovernmentIdPage extends StatefulWidget {
  const GovernmentIdPage({super.key});

  @override
  State<GovernmentIdPage> createState() => _GovernmentIdPageState();
}

class _GovernmentIdPageState extends State<GovernmentIdPage> {
  // List of ID types for the dropdown
  final List<String> idTypes = ['Aadhar card', 'Pancard', 'Driving License'];

  @override
  Widget build(BuildContext context) {
    return Consumer<GovernmentIdViewModel>(
      builder: (context, govIdViewModel, child) {
        // Ensure the dropdown value matches the controller text if valid, otherwise null
        String? selectedIdType = idTypes.contains(govIdViewModel.idTypeController.text)
            ? govIdViewModel.idTypeController.text
            : null;

        // Determine max length and formatters based on selected ID type
        int maxLength = 20; // Default limit
        List<TextInputFormatter> inputFormatters = [];
        String hintText = "Enter ID Number";

        if (selectedIdType == 'Aadhar card') {
          maxLength = 12;
          hintText = "Enter 12-digit Aadhar number";
          inputFormatters = [
            FilteringTextInputFormatter.digitsOnly, // Numbers only for Aadhar
            LengthLimitingTextInputFormatter(12),
          ];
        } else if (selectedIdType == 'Pancard') {
          maxLength = 10;
          hintText = "Enter 10-character PAN";
          inputFormatters = [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')), // Alphanumeric
            LengthLimitingTextInputFormatter(10),
          ];
        } else if (selectedIdType == 'Driving License') {
          maxLength = 15;
          hintText = "Enter up to 15-character DL";
          inputFormatters = [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')), // Alphanumeric
            LengthLimitingTextInputFormatter(15),
          ];
        }

        return Scaffold(
          backgroundColor: const Color(0xFFEFF9FF),
          body: SizedBox(
            height: 800,
            width: 360,
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          CupertinoIcons.arrow_left,
                          size: 22,
                          color: Colors.black,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Text(
                          "Government ID",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Center(
                    child: Container(
                      height: 55,
                      width: 55,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: const Icon(
                        CupertinoIcons.creditcard,
                        size: 26,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    "Verify Your Government ID",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 4, left: 30, right: 30),
                  child: Text(
                    "Upload a valid government ID to complete your verification. This helps us ensure trust and safety for everyone.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 15, left: 15, bottom: 6),
                  child: Text(
                    "ID Type",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                ),
                // Dropdown Box for ID Type
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    height: 48,
                    width: 330,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          const Icon(CupertinoIcons.doc_text, size: 18, color: Colors.black54),
                          const SizedBox(width: 10),
                          Expanded(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: selectedIdType,
                                hint: const Text(
                                  "Select ID Type",
                                  style: TextStyle(fontSize: 14, color: Colors.black45),
                                ),
                                icon: const Icon(Icons.arrow_drop_down, color: Colors.black54),
                                isExpanded: true,
                                items: idTypes.map((String type) {
                                  return DropdownMenuItem<String>(
                                    value: type,
                                    child: Text(
                                      type,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    setState(() {
                                      govIdViewModel.idTypeController.text = newValue;
                                      // Optional: clear ID number when type changes to prevent length conflicts
                                      govIdViewModel.idNumberController.clear();
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 12, left: 15, bottom: 6),
                  child: Text(
                    "ID Number",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    height: 48,
                    width: 330,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          const Icon(CupertinoIcons.number, size: 18, color: Colors.black54),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: SizedBox(
                              width: 260,
                              child: TextField(
                                controller: govIdViewModel.idNumberController,
                                inputFormatters: inputFormatters,
                                maxLength: maxLength,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: hintText,
                                  hintStyle: const TextStyle(fontSize: 14, color: Colors.black45),
                                  isDense: true,
                                  counterText: "", // Hides the default character counter text below field
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 12, left: 15, bottom: 6),
                  child: Text(
                    "Upload ID Photos",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: govIdViewModel.isLoading
                            ? null
                            : () => govIdViewModel.pickAndUploadImage(true),
                        child: Container(
                          height: 155,
                          width: 158,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.black12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Front Side",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Icon(
                                      CupertinoIcons.checkmark_circle_fill,
                                      size: 16,
                                      color: govIdViewModel.frontImageUrl != null ? Colors.green : Colors.grey,
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Container(
                                    height: 65,
                                    width: 138,
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      borderRadius: BorderRadius.circular(8),
                                      image: govIdViewModel.frontImageFile != null
                                          ? DecorationImage(
                                        image: kIsWeb
                                            ? NetworkImage(govIdViewModel.frontImageFile!.path) as ImageProvider
                                            : FileImage(File(govIdViewModel.frontImageFile!.path)),
                                        fit: BoxFit.cover,
                                      )
                                          : const DecorationImage(
                                        image: AssetImage("lib/image/logo.png"),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Center(
                                    child: Text(
                                      "Upload Photo",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      GestureDetector(
                        onTap: govIdViewModel.isLoading
                            ? null
                            : () => govIdViewModel.pickAndUploadImage(false),
                        child: Container(
                          height: 155,
                          width: 158,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.black12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Back Side",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Icon(
                                      CupertinoIcons.checkmark_circle_fill,
                                      size: 16,
                                      color: govIdViewModel.backImageUrl != null ? Colors.green : Colors.grey,
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Container(
                                    height: 65,
                                    width: 138,
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      borderRadius: BorderRadius.circular(8),
                                      image: govIdViewModel.backImageFile != null
                                          ? DecorationImage(
                                        image: kIsWeb
                                            ? NetworkImage(govIdViewModel.backImageFile!.path) as ImageProvider
                                            : FileImage(File(govIdViewModel.backImageFile!.path)),
                                        fit: BoxFit.cover,
                                      )
                                          : const DecorationImage(
                                        image: AssetImage("lib/image/logo.png"),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Center(
                                    child: Text(
                                      "Upload Photo",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 20),
                  child: GestureDetector(
                    onTap: govIdViewModel.isLoading
                        ? null
                        : () async {
                      bool success = await govIdViewModel.submitGovernmentId();
                      if (!context.mounted) return;
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Government ID submitted successfully!")),
                        );
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Please fill all details and upload both photos.")),
                        );
                      }
                    },
                    child: Container(
                      height: 50,
                      width: 330,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2979FF),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Center(
                        child: govIdViewModel.isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                          "Submit ID",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
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