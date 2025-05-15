import 'package:flutter/material.dart';

class DateCard extends StatelessWidget {
  const DateCard({
    super.key,
    required this.isDarkMode,
    required this.dateDay,
    required this.dateWeek,
  });

  final bool isDarkMode;
  final String dateDay;
  final String dateWeek;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: 60,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        color: isDarkMode ? Colors.grey[850] : Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              dateWeek,
              style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.grey[850],
                  fontSize: 10),
            ),
            Text(
              dateDay,
              style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.grey[850],
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
