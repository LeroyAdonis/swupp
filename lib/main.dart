import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swupp/models/trade_item_card_details.dart';
import 'package:swupp/pages/items_details_page.dart';
import 'package:swupp/pages/sign_in_screen.dart';
import 'package:swupp/pages/main_page.dart';
import 'package:swupp/pages/sign_up_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:swupp/pages/users/userList.dart';
import 'package:swupp/pages/users/user_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => TradeItemCardDetails(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserData(
            email: "",
            fullName: "",
            location: "",
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
            textTheme: GoogleFonts.montserratTextTheme(
              Theme.of(context).textTheme,
            ),
            primaryColor: Color(0xff62cdf6)),
        routes: {
          ItemsDetailsPage.routName: (context) => const ItemsDetailsPage()
        },
        home: const MainPage(),
      ),
    );
  }
}
