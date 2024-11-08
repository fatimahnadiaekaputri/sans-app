import 'package:flutter/material.dart';
import 'package:SANS/src/widgets/custom_scaffold.dart';

class EmergencyScreen extends StatefulWidget {
  final int id_user;
  const EmergencyScreen({super.key, required this.id_user});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          Text('emergency ${widget.id_user}'),
        ],
      ),
    );
  }
}
