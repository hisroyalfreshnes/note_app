import 'package:flutter/material.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: GestureDetector(
                      onTap: () {}, child: const Icon(Icons.add)),
                  title: const Text("add new category"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
