import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swupp/models/trade_item_card_details.dart';
import 'package:swupp/pages/items_details_page.dart';
import 'package:swupp/pages/login.dart';
import 'package:swupp/pages/main_page.dart';
import 'package:swupp/pages/registration_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TradeItemCardDetails(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          textTheme: GoogleFonts.openSansTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        routes: {
          ItemsDetailsPage.routName: (context) => const ItemsDetailsPage()
        },
        home: const MainPage(),
      ),
    );
  }
}
