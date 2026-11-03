import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'job completed view.dart';

class PaymentSummaryPage extends StatefulWidget {
  final String jobId;

  PaymentSummaryPage({super.key, required this.jobId});

  @override
  State<PaymentSummaryPage> createState() => _PaymentSummaryPageState();
}

class _PaymentSummaryPageState extends State<PaymentSummaryPage> {
  String selectedPaymentMethod = 'Razorpay';
  bool _isProcessing = false;

  late Razorpay razorpay;

  @override
  void initState() {
    super.initState();
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }

  @override
  void dispose() {
    razorpay.clear();
    super.dispose();
  }

  // Helper method to fetch basePrice from partners collection
  Future<double> _fetchPartnerBasePrice(String? partnerId, double fallbackPrice) async {
    if (partnerId == null || partnerId.isEmpty) return fallbackPrice;
    try {
      // Check 'partners' collection first
      var doc = await FirebaseFirestore.instance.collection('partners').doc(partnerId).get();
      if (doc.exists && doc.data()?['basePrice'] != null) {
        return double.tryParse(doc.data()!['basePrice'].toString()) ?? fallbackPrice;
      }

      // Fallback check 'partner' collection (singular)
      var docSingular = await FirebaseFirestore.instance.collection('partner').doc(partnerId).get();
      if (docSingular.exists && docSingular.data()?['basePrice'] != null) {
        return double.tryParse(docSingular.data()!['basePrice'].toString()) ?? fallbackPrice;
      }
    } catch (e) {
      debugPrint("Error fetching partner base price: $e");
    }
    return fallbackPrice;
  }

  void openRazorpayCheckout(double totalAmount) {
    var options = {
      "key": 'rzp_test_To44MxPJaLfMbr',
      'amount': (totalAmount * 100).toInt(),
      'name': 'Fixmate Services',
      'description': 'Service Payment',
      'prefill': {
        'contact': '7356476921',
        'email': 'surumiziya818@gmail.com',
      }
    };
    try {
      razorpay.open(options);
    } catch (e) {
      log(e.toString());
    }
  }

  void handlePaymentError(PaymentFailureResponse response) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text("Something went wrong! Please try again."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Go back"),
            )
          ],
        );
      },
    );
  }

  void handleExternalWallet(ExternalWalletResponse response) {}

  Future<void> _completePaymentInFirestore(String method, double totalAmount, double technicianEarnings) async {
    setState(() {
      _isProcessing = true;
    });

    try {
      var bookingDoc = await FirebaseFirestore.instance.collection('bookings').doc(widget.jobId).get();
      var bookingData = bookingDoc.data() as Map<String, dynamic>?;
      String? partnerId = bookingData?['partnerId'] ?? bookingData?['technicianId'];

      Map<String, dynamic> updateData = {
        'paymentMethod': method,
        'paymentStatus': 'paid',
        'status': 'completed',
        'totalAmount': totalAmount,
        'technicianEarnings': technicianEarnings,
      };

      if (partnerId != null) {
        updateData['partnerId'] = partnerId;
      }

      await FirebaseFirestore.instance.collection('bookings').doc(widget.jobId).update(updateData);

      var jobRef = FirebaseFirestore.instance.collection('jobs').doc(widget.jobId);
      var jobDoc = await jobRef.get();
      if (jobDoc.exists) {
        await jobRef.update(updateData);
      } else {
        await jobRef.set({
          ...bookingData ?? {},
          ...updateData,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => JobCompletedPage(
            earnings: "₹${technicianEarnings.toStringAsFixed(0)}",
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Payment failed: $e"), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return "Not recorded";
    DateTime date = timestamp.toDate();
    return DateFormat('hh:mm a').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEFF9FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(CupertinoIcons.arrow_left, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Payment & Service Summary",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: Colors.black,
          ),
        ),
      ),
      body: _isProcessing
          ? Center(child: CircularProgressIndicator())
          : StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('bookings')
            .doc(widget.jobId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(
              child: Text(
                "Booking summary not found",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          var data = snapshot.data!.data() as Map<String, dynamic>;

          String serviceName = data['serviceName'] ?? 'Service';
          String technicianName = data['name'] ?? 'Technician';
          String? partnerId = data['partnerId'] ?? data['technicianId'];

          double initialBasePrice = double.tryParse(data['basePrice']?.toString() ?? '299') ?? 299.0;

          Timestamp? startTimeTs = data['startTime'] as Timestamp?;
          Timestamp? stopTimeTs = data['stopTime'] as Timestamp? ?? data['updatedAt'] as Timestamp?;

          String startTime = _formatTimestamp(startTimeTs);
          String stopTime = _formatTimestamp(stopTimeTs);

          return FutureBuilder<double>(
            future: _fetchPartnerBasePrice(partnerId, initialBasePrice),
            builder: (context, priceSnapshot) {
              double basePrice = priceSnapshot.data ?? initialBasePrice;
              double serviceFee = basePrice * 0.05;
              double platformFee = 25.0;
              double totalAmount = basePrice + serviceFee + platformFee;
              double technicianEarnings = totalAmount * 0.90;

              // Update razorpay success callback to use the dynamic total amount
              razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (PaymentSuccessResponse response) {
                log(response.toString());
                _completePaymentInFirestore('Razorpay', totalAmount, technicianEarnings);
              });

              return ListView(
                padding: EdgeInsets.all(16),
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.15),
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          serviceName,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Technician: $technicianName",
                          style: TextStyle(fontSize: 15, color: Colors.blue, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.15),
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Service Time Log",
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
                        ),
                        Divider(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(CupertinoIcons.play_circle_fill, color: Colors.green, size: 20),
                                SizedBox(width: 8),
                                Text("Start Time:", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                              ],
                            ),
                            Text(startTime, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                          ],
                        ),
                        SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(CupertinoIcons.stop_circle_fill, color: Colors.red, size: 20),
                                SizedBox(width: 8),
                                Text("Stop Time:", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                              ],
                            ),
                            Text(stopTime, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Price Details",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Base Price", style: TextStyle(fontSize: 15)),
                            Text("₹${basePrice.toStringAsFixed(0)}", style: TextStyle(fontSize: 15)),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Service Fee (5%)", style: TextStyle(fontSize: 15)),
                            Text("₹${serviceFee.toStringAsFixed(0)}", style: TextStyle(fontSize: 15)),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Platform Fee", style: TextStyle(fontSize: 15)),
                            Text("₹${platformFee.toStringAsFixed(0)}", style: TextStyle(fontSize: 15)),
                          ],
                        ),
                        Divider(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Total Payable", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                            Text("₹${totalAmount.toStringAsFixed(0)}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.blue)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  Text(
                    "Select Payment Method",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
                  ),
                  SizedBox(height: 10),
                  Column(
                    children: [
                      RadioListTile<String>(
                        value: 'Razorpay',
                        groupValue: selectedPaymentMethod,
                        onChanged: (value) => setState(() => selectedPaymentMethod = value!),
                        title: Text("Razorpay", style: TextStyle(fontWeight: FontWeight.w800)),
                      ),
                      RadioListTile<String>(
                        value: 'Cash',
                        groupValue: selectedPaymentMethod,
                        onChanged: (value) => setState(() => selectedPaymentMethod = value!),
                        title: Text("Cash", style: TextStyle(fontWeight: FontWeight.w800)),
                      ),
                    ],
                  ),

                  SizedBox(height: 25),

                  GestureDetector(
                    onTap: () {
                      if (selectedPaymentMethod == 'Razorpay') {
                        openRazorpayCheckout(totalAmount);
                      } else {
                        _completePaymentInFirestore('Cash', totalAmount, technicianEarnings);
                      }
                    },
                    child: Container(
                      height: 55,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          selectedPaymentMethod == 'Razorpay' ? "Pay with Razorpay" : "Confirm Cash Payment",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}