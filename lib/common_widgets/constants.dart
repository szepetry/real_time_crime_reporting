import 'package:flutter/material.dart';

//these are all the text styles for the report page headings and description.
const kTextStyleOfHeadings =  TextStyle(
   color: Colors.white,
            height: 1.5,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          );

const kTextStyleForData = TextStyle(
 // color: Colors.white,
            fontSize: 15.0,
            height: 2,
            fontWeight: FontWeight.w300,
          );

const kTextStyleForUrl=TextStyle(
          decoration: TextDecoration.underline,
          color: Colors.blue,
          height: 1.2,
          fontSize: 10.0,
          fontWeight: FontWeight.w300
          );

//colour for heading
const colourHeading =0xFF0A5E2AFF; 
const colourbelow = 0xFFB3E5FC;
          
class ReusableCard extends StatelessWidget {
  final Color colour;
  final Widget cardChild;
  // final Function onPress;
  ReusableCard({@required this.colour, this.cardChild});

  @override
  Widget build(BuildContext context) {
     return Container(
        child: cardChild,
        margin: EdgeInsets.all(2.0),
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: colour,
          borderRadius: BorderRadius.circular(5.0),
        ),
      );
    
  }
}

 //GestureDetector(
    //   onTap: () {
    //     onPress();       
    //   },