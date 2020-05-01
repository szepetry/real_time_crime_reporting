import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instant_reporter/app/sign_in/AuthNew.dart';
import 'package:instant_reporter/common_widgets/form_submit_button.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _userAuth=false;
  bool _policeAuth=false;
  String enteredphoneNo;
  String smsCode;
  String verificationId;
  int count=0;
  String name;
  final TextEditingController _phNoController = TextEditingController();

  void checkIfUserOrPolice() async{
    enteredphoneNo=_phNoController.text.toString();
   await SearchUser("registered_user");
    await SearchUser("registered_police");
    showErrorMsg(_userAuth,_policeAuth);
    
   Navigator.push(context,
    MaterialPageRoute(
      builder: (context) => Authenticate(_userAuth,_policeAuth,false,'+91'+enteredphoneNo)
      )
      );
  }

  void SearchUser (String userType) async{
      
      var User_details = new List();
      await Firestore.instance.collection(userType)
      .getDocuments()
      .then((QuerySnapshot snapshot)
      {
    snapshot.documents.forEach((User) =>User_details.add(User.data));
     }); 
     var enteredphNo=_phNoController.text.toString();
     var phNo;
     for( int j =0 ; j <User_details.length ;j++){
       phNo=User_details[j]['phone'].toString();
       if(phNo.contains(enteredphNo) && userType=="registered_user"){
        setState(() {
          _userAuth=true;
          _policeAuth=false;
        });
        name=User_details[j]['name'].toString();
        
        }
      else if(phNo.contains(enteredphNo) && userType=="registered_police")
      {
        setState(() {
          _policeAuth=true;
          _userAuth=false;
        });
        name=User_details[j]['name'].toString();
      }
      phNo='';
     }   
     
    }

    void showErrorMsg(_userAuth,_policeAuth){
      if(_userAuth==false && _policeAuth==false)
      showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text('ERROR'),
            content: Text('Enter valid Credentials'),
            actions: <Widget>[
              FlatButton(onPressed: () => Navigator.of(context).pop(), child: Text('OK'),)
            ],
          );
        }
      );
    }

  @override
  Widget build(BuildContext context) {
    return 
      Scaffold(
        appBar: AppBar(
          title:Text(
            'Login',
           textAlign: TextAlign.center,
           ),
        ),
              body: Container(
                margin: EdgeInsets.all(8.0),
                              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                                child: Card(
                    child: Column(
                      //crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(height: 8.0),
                          TextField(
                          controller: _phNoController,
                          decoration: InputDecoration(
                        labelText: '  Enter 10 digit phone number',
                          hintText: '  +91 ',
                        
            ),
          ),
           SizedBox(height: 8.0),
        FormSubmitButton(
          text: 'Login',
          onPressed: () async{
            
            await checkIfUserOrPolice();
          },
        ),
        SizedBox(height: 16.0),
                      ],
                    ),
                  ),
                ),
              ),
      );
  }
}