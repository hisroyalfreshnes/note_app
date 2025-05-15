import 'package:flutter/material.dart';
import 'package:note_app/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({
    super.key,
    required this.cardTitle,
    required this.cardBody,
    required this.cardCreated,
  });

  final String cardTitle;
  final String cardBody;
  final String cardCreated;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    return Column(
      children: [
        Container(
          height: 160,
          width: 165,
          decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[850] : const Color(0xFFA3EBF6),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(15.0),
                topLeft: Radius.circular(15.0),
              )),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      cardTitle,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.push_pin,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              SizedBox(
                width: 168,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    cardBody,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 165,
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[850] : Colors.white,
            border: Border.all(
              color: Colors.grey,
            ),
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          cardCreated,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
