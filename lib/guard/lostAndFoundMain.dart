import 'package:flutter/material.dart';
import 'package:palmbook_ios/guard/lost_and_found.dart';
import 'package:palmbook_ios/guard/scanLostAndFound.dart';
import 'package:gap/gap.dart';

class lostAndFoundMain extends StatelessWidget {
  const lostAndFoundMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color(0xFF7785FC),
          elevation: 0,
          title: const Text("Lost & Found"),
          centerTitle: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(15),
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          titleTextStyle: const TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      body: Padding(
        padding: EdgeInsets.all(width*.07),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => Lost_And_Found(),));
              },
              child: Container(
                height: height*.3,
                width: width*.9,
                decoration: BoxDecoration(
                    color: const Color(0xFF7785FC),
                    borderRadius: BorderRadius.circular(25)
                ),
                child: Center(
                  child: Text(
                    "Upload Item",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                  ),
                ),
              ),
            ),
            Gap(50),
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ScanLostAndFound(),));
              },
              child: Container(
                height: height*.3,
                width: width*.9,
                decoration: BoxDecoration(
                    color: const Color(0xFF7785FC),
                    borderRadius: BorderRadius.circular(25)
                ),
                child: Center(
                  child: Text(
                    "Scan Item",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
