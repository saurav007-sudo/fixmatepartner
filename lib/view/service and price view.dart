import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/service and price model.dart';
import '../view/editservice view.dart';
import '../viewmodel/service and price viewmodel.dart';

class ServicesPricing extends StatefulWidget {
  const ServicesPricing({super.key});

  @override
  State<ServicesPricing> createState() => _ServicesPricingState();
}

class _ServicesPricingState extends State<ServicesPricing> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ServicesPricingViewModel>(
      builder: (context, servicesPricingViewModel, child) {
        return Scaffold(
          backgroundColor: Color(0xFFEFF9FF),
          body: StreamBuilder<DocumentSnapshot>(
            stream: servicesPricingViewModel.getPartnerProfileStream(),
            builder: (context, snapshot) {
              var data = snapshot.data?.data() as Map<String, dynamic>?;
              ServicesPricingModel model = ServicesPricingModel.fromMap(data);

              ImageProvider avatarImage;
              if (model.profileImageUrl != null && model.profileImageUrl!.isNotEmpty) {
                avatarImage = NetworkImage(model.profileImageUrl!);
              } else {
                avatarImage = AssetImage("lib/image/profile3.jpg");
              }

              return ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 15, left: 15, right: 15),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(17),
                            ),
                            child: Icon(
                              CupertinoIcons.arrow_left,
                              size: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Text(
                            "Services & Pricing",
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
                    padding: EdgeInsets.only(
                      left: 13,
                      top: 18,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 52,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 48,
                            backgroundImage: avatarImage,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 18,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                model.partnerName,
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 4, right: 8
                                ),
                                child: Text(
                                  model.serviceName,
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
                    padding: EdgeInsets.only(top: 15, left: 18, bottom: 8),
                    child: Text(
                      "My Services",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                    child: Container(
                      height: 105,
                      width: 330,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(CupertinoIcons.bolt, size: 16, color: Colors.blue),
                                Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: Text(
                                    model.serviceName,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 4),
                              child: Text(
                                model.serviceDescription,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 12),
                              child: Row(
                                children: [
                                  Text(
                                    "₹${model.basePrice} onwards",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 170),
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => EditService()),
                                            );
                                          },
                                          child: Text(
                                            "Edit",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 4),
                                          child: Icon(
                                            CupertinoIcons.arrow_right,
                                            size: 14,
                                            color: Colors.blue,
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
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}