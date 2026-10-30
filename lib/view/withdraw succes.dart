import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WithdrawalSuccessful extends StatelessWidget {
  final double amount;
  final String transactionId;
  final String timestamp;

  const WithdrawalSuccessful({
    super.key,
    required this.amount,
    required this.transactionId,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color(0xFFEFF9FF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               Spacer(),
              Container(
                height: 90,
                width: 90,
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(45),
                  border: Border.all(color: Colors.green.shade200, width: 2),
                ),
                child:  Center(
                  child: Icon(
                    CupertinoIcons.checkmark_alt,
                    size: 50,
                    color: Colors.green,
                  ),
                ),
              ),
               SizedBox(height: 25),
               Text(
                "Withdrawal Successful!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Colors.black87,
                ),
              ),
               SizedBox(height: 8),
              Text(
                "Your money has been successfully transferred.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
               SizedBox(height: 35),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.12),
                      blurRadius: 10,
                      offset:  Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                         Text("Amount Withdrawn", style: TextStyle(fontSize: 14, color: Colors.grey)),
                        Text(
                          "₹${amount.toStringAsFixed(2)}",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.blue[900]),
                        ),
                      ],
                    ),
                     Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(color: Color(0xFFF0F0F0)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                         Text("Transaction ID", style: TextStyle(fontSize: 14, color: Colors.grey)),
                        Text(transactionId, style:  TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                      ],
                    ),
                     SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                         Text("Date", style: TextStyle(fontSize: 14, color: Colors.grey)),
                        Text(timestamp, style:  TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ],
                ),
              ),
               Spacer(),
              GestureDetector(
                onTap: () => Navigator.popUntil(context, (route) => route.isFirst),
                child: Container(
                  height: 55,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color:  Color(0xFF2979FF),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child:  Center(
                    child: Text(
                      "Done",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),
                    ),
                  ),
                ),
              ),
               SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}