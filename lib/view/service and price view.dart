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
          backgroundColor: const Color(0xFFEFF9FF),
          body: StreamBuilder<DocumentSnapshot>(
            stream: servicesPricingViewModel.getPartnerProfileStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              var data = snapshot.data?.data() as Map<String, dynamic>?;
              ServicesPricingModel model = ServicesPricingModel.fromMap(data);

              // Extract work description from Partner collection (checking common field variations)
              String workDescription = data?['workDescription'] ??
                  data?['description'] ??
                  data?['bio'] ??
                  data?['about'] ??
                  data?['partnerDescription'] ??
                  model.serviceDescription; // Fallback to model's service description

              ImageProvider avatarImage;
              if (model.profileImageUrl != null && model.profileImageUrl!.isNotEmpty) {
                avatarImage = NetworkImage(model.profileImageUrl!);
              } else {
                avatarImage = const AssetImage("lib/image/profile3.jpg");
              }

              return ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
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
                            child: const Icon(
                              CupertinoIcons.arrow_left,
                              size: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const Padding(
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
                    padding: const EdgeInsets.only(
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
                          padding: const EdgeInsets.only(
                            left: 18,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                model.partnerName,
                                style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 4, right: 8
                                ),
                                child: Text(
                                  model.serviceName,
                                  style: const TextStyle(
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
                  const Padding(
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
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                    child: Container(
                      width: 330,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(CupertinoIcons.bolt, size: 16, color: Colors.blue),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Text(
                                    model.serviceName,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                // Displays the work description fetched from Partner collection
                                workDescription,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "₹${model.basePrice} onwards",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditService(
                                            initialServiceName: model.serviceName,
                                            initialDescription: workDescription,
                                            initialBasePrice: model.basePrice,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      children: const [
                                        Text(
                                          "Edit",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.blue,
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