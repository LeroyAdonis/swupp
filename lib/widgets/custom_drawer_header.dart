import 'package:flutter/material.dart';

class CustomDrawerHeader extends StatelessWidget {
  final String name;
  final String email;
  final String profileImageUrl;

  const CustomDrawerHeader({
    super.key,
    required this.name,
    required this.email,
    required this.profileImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: DrawerHeader(
          decoration: const BoxDecoration(color: Color(0xff171815)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(profileImageUrl),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5.0),
              Text(
                email,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ],
          )),
    );
  }
}
