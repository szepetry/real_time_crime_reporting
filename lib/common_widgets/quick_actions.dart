import 'package:instant_reporter/AuthenticationHandle/LandingPage.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:flutter/material.dart';
import 'package:instant_reporter/Forms/ReportForm.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';


class QuickAction extends StatelessWidget {
 final QuickActions quickActions = QuickActions();
 String shortcut = "no action set";
 void setUpActions(){
  quickActions.setShortcutItems(<ShortcutItem>[
      ShortcutItem(
          type: 'inst1',
          localizedTitle: 'Create Report',
        //  icon: Platform.isAndroid ? 'quick_box' : 'QuickBox'
        ),
          ]);
 }
 void handleActions(){
   quickActions.initialize((type) { 
     if (type=='inst1') {
    //   Navigator.push(context, route)
     }
   });
 }
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}




// class Quick{  
//   String uid; 
//     UserDetails u = Provider.of<UserDetails>(context, listen: false);
//     //inherited widget using provider to access uid to all child widgets
//     uid = u.uid;
//   final QuickActions quickActions = QuickActions();
//  String shortcut = "no action set";
//  void setUpActions(){
//   quickActions.setShortcutItems(<ShortcutItem>[
//       ShortcutItem(
//           type: 'inst1',
//           localizedTitle: 'Create Report',
//           icon: Platform.isAndroid ? 'quick_box' : 'QuickBox'
//         ),
//           ]);
//  }

//  void handleActions() {
//   quickActions.initialize((shortcutType) {
//     if (shortcutType == 'inst1') {
//     Navigator.push(context, MaterialPageRoute(builder: (context) {
      
//     },)
//     Navigator.push(context, MaterialPageRoute(builder: (context) {
//       return ReportForm(id);
//     }));
//   }
     
//   });
// }
// }