import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodel/experience viewmodel.dart';

class ExperiencePage extends StatefulWidget {
  const ExperiencePage({super.key});

  @override
  State<ExperiencePage> createState() => _ExperiencePageState();
}

class _ExperiencePageState extends State<ExperiencePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ExperienceViewModel>(
      builder: (context, expViewModel, child) {
        return Scaffold(
          backgroundColor: Color(0xFFEFF9FF),
          body: SizedBox(
            height: 800,
            width: 360,
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
                          size: 22,
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Text(
                          "Experience",
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
                  padding: EdgeInsets.only(top: 15),
                  child: Center(
                    child: Container(
                      height: 55,
                      width: 55,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: Icon(
                        CupertinoIcons.briefcase,
                        size: 26,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    "Work Experience & Skills",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 4, left: 40, right: 40),
                  child: Text(
                    "Tell us about your experience and skills to get better job opportunities.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15, left: 15, bottom: 6),
                  child: Text(
                    "Years of Experience",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    height: 48,
                    width: 330,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: TextField(
                        controller: expViewModel.expController,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "e.g., 3 Years",
                          isDense: true,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 12, left: 15, bottom: 6),
                  child: Text(
                    "Service Category (Select one)",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: expViewModel.categories.map((category) {
                      final isSelected = expViewModel.selectedCategory == category;
                      return GestureDetector(
                        onTap: () {
                          expViewModel.selectCategory(category);
                        },
                        child: Container(
                          height: 32,
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: isSelected ? Color(0xFF2979FF) : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: isSelected ? Colors.transparent : Colors.black12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                CupertinoIcons.checkmark,
                                size: 14,
                                color: isSelected ? Colors.white : Colors.black54,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 6),
                                child: Text(
                                  category,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: isSelected ? Colors.white : Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 12, left: 15, bottom: 6),
                  child: Text(
                    "Qualification",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    height: 48,
                    width: 330,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: TextField(
                        controller: expViewModel.qualController,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "e.g., ITI Electrical Diploma",
                          isDense: true,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 12, left: 15, bottom: 6),
                  child: Text(
                    "Work Experience Description",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    height: 95,
                    width: 330,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 55,
                            child: TextField(
                              controller: expViewModel.descriptionController,
                              maxLines: 3,
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Describe your professional background...",
                                isDense: true,
                              ),
                            ),
                          ),
                          Text(
                            "Max 500 characters",
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.black45,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 20),
                  child: GestureDetector(
                    onTap: expViewModel.isLoading
                        ? null
                        : () async {
                      bool success = await expViewModel.saveExperience(context);
                      if (!context.mounted) return;
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Experience verified")),
                        );
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      height: 50,
                      width: 330,
                      decoration: BoxDecoration(
                        color: Color(0xFF2979FF),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Center(
                        child: expViewModel.isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                          "Save Experience",
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