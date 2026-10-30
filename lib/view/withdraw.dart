import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fixmatepartner/view/withdraw%20succes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class WithdrawEarnings extends StatefulWidget {
  const WithdrawEarnings({super.key});

  @override
  State<WithdrawEarnings> createState() => _WithdrawEarningsState();
}

class _WithdrawEarningsState extends State<WithdrawEarnings> {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final TextEditingController amountController = TextEditingController();

  late Razorpay razorpay;
  double availableEarnings = 0.0;

  @override
  void initState() {
    super.initState();
    initRazorpay();
  }

  void initRazorpay() {
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (PaymentSuccessResponse response) {
      log("Payment Success: ${response.paymentId}");
      deductEarningsAndComplete();
    });
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (PaymentFailureResponse response) {
      log("Payment Error: ${response.code} - ${response.message}");
      handlePaymentError();
    });
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, (ExternalWalletResponse response) {
      log("External Wallet: ${response.walletName}");
    });
  }

  // 1. Stream Jobs Earnings
  Stream<QuerySnapshot> getEarningsStream() {
    String partnerId = currentUser?.uid ?? '';
    return FirebaseFirestore.instance
        .collection('jobs')
        .where('partnerId', isEqualTo: partnerId)
        .where('status', whereIn: ['completed', 'closed'])
        .snapshots();
  }

  Stream<QuerySnapshot> getWithdrawalsStream() {
    String partnerId = currentUser?.uid ?? '';
    return FirebaseFirestore.instance
        .collection('withdrawals')
        .where('partnerId', isEqualTo: partnerId)
        .snapshots();
  }

  void calculateAvailableBalance(List<QueryDocumentSnapshot> jobDocs, List<QueryDocumentSnapshot> withdrawalDocs) {
    double totalEarnings = 0.0;
    for (var doc in jobDocs) {
      var data = doc.data() as Map<String, dynamic>;
      totalEarnings += double.tryParse(data['technicianEarnings']?.toString() ?? '0') ?? 0.0;
    }

    double totalWithdrawn = 0.0;
    for (var doc in withdrawalDocs) {
      var data = doc.data() as Map<String, dynamic>;
      totalWithdrawn += double.tryParse(data['amount']?.toString() ?? '0') ?? 0.0;
    }

    double netBalance = totalEarnings - totalWithdrawn;
    if (netBalance < 0) netBalance = 0.0;

    if (availableEarnings != netBalance) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            availableEarnings = netBalance;
          });
        }
      });
    }
  }

  void openRazorpayWithdrawal(double withdrawAmount) {
    var options = {
      "key": 'rzp_test_To44MxPJaLfMbr',
      'amount': (withdrawAmount * 100).toInt(),
      'name': 'Fixmate Partner Payout',
      'description': 'Earnings Withdrawal',
      'prefill': {
        'contact': '7356476921',
        'email': currentUser?.email ?? 'partner@fixmate.com',
      }
    };
    try {
      razorpay.open(options);
    } catch (e) {
      log("Error opening Razorpay: $e");
    }
  }

  void handlePaymentError() {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Payment Failed"),
          content: const Text("Withdrawal payment gateway failed! Please try again."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Go back"),
            )
          ],
        );
      },
    );
  }

  void setAmount(String val) {
    amountController.text = val;
    setState(() {});
  }

  Future<void> deductEarningsAndComplete() async {
    double withdrawVal = double.tryParse(amountController.text.trim()) ?? 0.0;
    if (withdrawVal <= 0) return;

    try {
      String partnerId = currentUser?.uid ?? '';
      String txnId = "TXN${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}";

      List<String> months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
      String formattedDate = "${DateTime.now().day} ${months[DateTime.now().month - 1]} ${DateTime.now().year}";

      await FirebaseFirestore.instance.collection('withdrawals').add({
        'partnerId': partnerId,
        'amount': withdrawVal,
        'method': 'Razorpay',
        'transactionId': txnId,
        'timestamp': FieldValue.serverTimestamp(),
      });

      amountController.clear();
      setState(() {});

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WithdrawalSuccessful(
            amount: withdrawVal,
            transactionId: txnId,
            timestamp: formattedDate,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error processing withdrawal: $e"), backgroundColor: Colors.red),
      );
    }
  }

  void validateAndWithdraw() {
    double withdrawVal = double.tryParse(amountController.text.trim()) ?? 0.0;
    if (withdrawVal <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid amount to withdraw")),
      );
      return;
    }
    if (withdrawVal > availableEarnings) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Amount exceeds available balance")),
      );
      return;
    }

    openRazorpayWithdrawal(withdrawVal);
  }

  @override
  void dispose() {
    razorpay.clear();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
        stream: getEarningsStream(),
        builder: (context, jobSnapshot) {
          if (jobSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return StreamBuilder<QuerySnapshot>(
            stream: getWithdrawalsStream(),
            builder: (context, withdrawalSnapshot) {
              if (jobSnapshot.hasData && withdrawalSnapshot.hasData) {
                calculateAvailableBalance(
                  jobSnapshot.data!.docs,
                  withdrawalSnapshot.data!.docs,
                );
              }

              return ListView(
                children: [
                  const ListTile(
                    title: Text(
                      "Withdraw",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 24,
                        color: Colors.black,
                      ),
                    ),
                  ),
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
                              color: Colors.grey.shade200,
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
                            "Withdraw Earnings",
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
                    padding: const EdgeInsets.only(top: 25),
                    child: Container(
                      height: 690,
                      width: 360,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEFF9FF),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 25),
                            child: Column(
                              children: [
                                Text(
                                  "₹${availableEarnings.toStringAsFixed(0)}",
                                  style: const TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF2979FF),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(top: 4),
                                  child: Text(
                                    "Available to Withdraw",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 20, right: 120, bottom: 8),
                            child: Text(
                              "Select Withdrawal Method",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Container(
                              height: 75,
                              width: 330,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.blue, width: 1.5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 45,
                                      width: 45,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEFF9FF),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(
                                        CupertinoIcons.creditcard_fill,
                                        size: 22,
                                        color: Color(0xFF2979FF),
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(left: 12),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Razorpay",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 2),
                                            child: Text(
                                              "Instant Payout Gateway",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black54,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    Container(
                                      height: 24,
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE2F6EA),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          "Selected",
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.green,
                                            fontWeight: FontWeight.w800,
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
                            padding: EdgeInsets.only(top: 15, right: 178, bottom: 8),
                            child: Text(
                              "Withdrawal Amount",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Container(
                              height: 56,
                              width: 330,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.black12),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0, left: 15, right: 15),
                                  child: TextField(
                                    controller: amountController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Enter amount",
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 8, left: 20, bottom: 12),
                            child: Text(
                              "Enter amount to withdraw",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () => setAmount("1000"),
                                  child: Container(
                                    height: 40,
                                    width: 72,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.black12),
                                    ),
                                    child: const Center(
                                      child: Text("₹1,000", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () => setAmount("5000"),
                                  child: Container(
                                    height: 40,
                                    width: 72,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.black12),
                                    ),
                                    child: const Center(
                                      child: Text("₹5,000", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () => setAmount("10000"),
                                  child: Container(
                                    height: 40,
                                    width: 72,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.black12),
                                    ),
                                    child: const Center(
                                      child: Text("₹10,000", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () => setAmount(availableEarnings.toStringAsFixed(0)),
                                  child: Container(
                                    height: 40,
                                    width: 72,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.black12),
                                    ),
                                    child: const Center(
                                      child: Text("MAX", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 25, left: 15, right: 15),
                            child: GestureDetector(
                              onTap: validateAndWithdraw,
                              child: Container(
                                height: 50,
                                width: 330,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2979FF),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: const Center(
                                  child: Text(
                                    "Confirm Withdrawal",
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