// import 'package:flutter/material.dart';
//
// class ReportButton extends StatelessWidget {
//   final void Function()? onTap;
//   const ReportButton({super.key, required this.onTap});
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: const Icon(
//         Icons.flag,
//         color: Colors.grey, // You can choose any color that represents reporting
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'wall_post.dart';



class ReportButton extends StatefulWidget {
  final void Function()? onTap;
  final bool report;
  const ReportButton({super.key, required this.onTap, this.report = false});

  @override
  _ReportButtonState createState() => _ReportButtonState();
}

class _ReportButtonState extends State<ReportButton> {
 // Track whether the report button was tapped
  late bool isReported ;
  @override
  void initState() {
    super.initState();
    isReported = widget.report; // Initialize the isReported state with widget.report
  }

  void _handleTap() {
    setState(() {
      isReported = !isReported; // Toggle the reporting state
    });
    if (widget.onTap != null) {
      widget.onTap!(); // Call the onTap callback if provided
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Icon(
        Icons.flag,
        color: isReported ? Colors.red : Colors.grey, // Change color based on state
      ),
    );
  }
}
