import 'package:flutter/material.dart';

//these are all the text styles for the report page headings and description.
const kTextStyleOfHeadings = TextStyle(
  color: Colors.white,
  height: 1.5,
  fontWeight: FontWeight.bold,
  fontSize: 20.0,
);

const kTextStyleForData = TextStyle(
//color: Colors.white,
  fontSize: 13.0,
  height: 2,
  fontWeight: FontWeight.w300,
);
const kTextStyleForData1 = TextStyle(
  color: Colors.white,
  fontSize: 15.0,
  height: 2,
  fontWeight: FontWeight.w300,
);

const kTextStyleForUrl = TextStyle(
    decoration: TextDecoration.underline,
    color: Colors.blue,
    height: 1.2,
    fontSize: 10.0,
    fontWeight: FontWeight.w300);

    const kTextStyleforLabelText= TextStyle(
      color: Colors.white,
    );

//colour for heading
const colourHeading = 0xFF6DB891; //Kelly green
const colourbelow = 0xFFF0F0EB; 
const cardColor = 0xFF333333; 
const buttonColor = 0xFFE84C3D; 
const backgroundColor = 0xFF111111;

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

//for the design structure for the rows in the report page
class ReportRows extends StatelessWidget {
  final colourOfTheBackground;
  final String textString;
  final styleOfText;
  ReportRows(
      {@required this.colourOfTheBackground,
      this.textString,
      @required this.styleOfText});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ReusableCard(
        colour: Color(colourOfTheBackground),
        cardChild: Text(
          textString,
          style: styleOfText,
        ),
      ),
    );
  }
}
//GestureDetector(
//   onTap: () {
//     onPress();
//   },

//to display the common information about the user like email,phone number
class CommonInfo extends StatelessWidget {
  final String heading;
  final String data;
  CommonInfo({this.heading, this.data});

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Row(
        children: <Widget>[
          Text(
            heading,
            style: kTextStyleForData1,
            textAlign: TextAlign.left,
          ),
          Text(
            data,
            style: kTextStyleForData1,
            textAlign: TextAlign.left,
          ),
        ],
      ),
      alignment: Alignment.bottomLeft,
    );
  }
}

class MaterialButtonWidget extends StatelessWidget {
  final Function() onPressed;
  final Color color;
  final String text;

  MaterialButtonWidget(
      {Key key,
      @required this.onPressed,
      @required this.color,
      @required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
              shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        elevation: 18.0,
        clipBehavior: Clip.antiAlias,
          child: MaterialButton(
            height: 50,
        onPressed: onPressed,
        child: Center(
          child: Text(
            text,
            style: TextStyle(color: Colors.black),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}