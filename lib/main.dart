import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fixmatepartner/viewmodel/active%20viewmodel.dart';
import 'package:fixmatepartner/viewmodel/addnew%20service%20viewmodel.dart';
import 'package:fixmatepartner/viewmodel/auth%20viewmodel.dart';
import 'package:fixmatepartner/viewmodel/cancelled%20viewmodel.dart';
import 'package:fixmatepartner/viewmodel/earnings%20viewmodel.dart';
import 'package:fixmatepartner/viewmodel/editpersonal%20viewmodel.dart';
import 'package:fixmatepartner/viewmodel/editservice%20viewmodel.dart';
import 'package:fixmatepartner/viewmodel/experience%20viewmodel.dart';
import 'package:fixmatepartner/viewmodel/government%20id%20viewmodel.dart';
import 'package:fixmatepartner/viewmodel/home%20viewmodel.dart';
import 'package:fixmatepartner/viewmodel/job%20completed%20viewmodel.dart';
import 'package:fixmatepartner/viewmodel/job%20viewmodel.dart';
import 'package:fixmatepartner/viewmodel/personal%20info%20viewmodel.dart';
import 'package:fixmatepartner/viewmodel/profile%20viewmodel.dart';
import 'package:fixmatepartner/viewmodel/service%20and%20price%20viewmodel.dart';
import 'package:fixmatepartner/viewmodel/verify%20viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'view/splash.dart';
import 'firebase_options.dart';





void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try{
    await Supabase.initialize(
      url: 'https://xtfrnvrjyhsdhjjdfakb.supabase.co',
      anonKey: 'sb_publishable_Jk7FVbxh9Lo81pZXJfOT6w_x_owhVqO',
    );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );}catch (e) {
    debugPrint("Firebase initialization error: $e");
  }
  runApp( Proclass());
}

class Proclass extends StatelessWidget {
  const Proclass({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ActiveViewModel()),
        ChangeNotifierProvider(create: (context) => AddNewViewModel()),
        ChangeNotifierProvider(create: (context) => AuthViewModel()),
        ChangeNotifierProvider(create: (context) => CancelledJobsViewModel()),
        ChangeNotifierProvider(create: (context) => EarningsViewModel()),
        ChangeNotifierProvider(create: (context) => EditProfileViewModel()),
        ChangeNotifierProvider(create: (context) => EditServiceViewModel()),
        ChangeNotifierProvider(create: (context) => ExperienceViewModel()),
        ChangeNotifierProvider(create: (context) => GovernmentIdViewModel()),
        ChangeNotifierProvider(create: (context) => HomeViewModel()),
        ChangeNotifierProvider(create: (context) => JobCompletedViewModel()),
        ChangeNotifierProvider(create: (context) => JobsViewModel()),
        ChangeNotifierProvider(create: (context) => PersonalInfoViewModel()),
        ChangeNotifierProvider(create: (context) => ProfileViewModel()),
        ChangeNotifierProvider(create: (context) => ServicesPricingViewModel()),
        ChangeNotifierProvider(create: (context) => VerifyProfileViewModel()),

      ],
      child:  MaterialApp (
        home: Splash(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}