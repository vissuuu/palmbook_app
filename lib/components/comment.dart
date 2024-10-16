import 'package:flutter/material.dart';
import 'package:palmbook_ios/components/delete_button.dart';
import 'package:readmore/readmore.dart';

class Comment extends StatelessWidget {
  final String text;
  final String user;
  final String time;

  const Comment({
    super.key,
    required this.text,
    required this.user,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(7),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF979797).withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user,
                    style: TextStyle(
                      fontSize: 14.0, 
                      color: Colors.grey[700], 
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  // const SizedBox(width: 4.0),

                  // Text(
                  //   '|',
                  //   style: TextStyle(
                  //     color: Colors.grey[700],
                  //   ),
                  // ),
                  // const SizedBox(width: 4.0),

                  Text(
                    time,

                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey[500],

                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0), 
            
              ReadMoreText(
                text,
                trimLines: 3,
                colorClickableText: Colors.blue,
                trimMode: TrimMode.Line, 
                trimCollapsedText: 'Read more',
                trimExpandedText: '\nRead less',
                style: const TextStyle(
                  fontSize: 16.0, 
                  color: Colors.black,
                ),
                moreStyle: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.blue,
                ),
                lessStyle: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
