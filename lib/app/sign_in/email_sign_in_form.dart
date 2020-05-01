import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instant_reporter/app/sign_in/AuthNew.dart';
import 'package:instant_reporter/common_widgets/form_submit_button.dart';
import 'package:instant_reporter/app/sign_in/login.dart';
import 'package:flutter/cupertino.dart';



class EmailSignInForm extends StatefulWidget {
  bool _userAuth;
  bool _policeAuth;
  String _name;
  EmailSignInForm(this._userAuth,this._policeAuth,this._name);

  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm>  {
  final TextEditingController _aadharController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  
   String phoneNo;
  String smsCode;
  String verificationId;
  

  void _toggleFormType() {
 
    _aadharController.clear();
    _phoneController.clear();
  }

  List<Widget> _buildChildren() {
    return [
SizedBox(height: 8.0),
      TextField(
        controller: _aadharController,
        decoration: InputDecoration(
          labelText: 'Enter 12 digit aadhar number',
          hintText: 'XXXXXXXXXXXX',
         errorText: null,
        ),
        
      ),
      SizedBox(height: 8.0),
      TextField(
        controller: _phoneController,
        onChanged: (value){
          this.phoneNo=value;
        },
        decoration: InputDecoration(
          labelText: 'Enter 10 digit Phone Number',
          hintText: '+91 ',
          errorText: null,
        ),
        obscureText: false,
      ),
      SizedBox(height: 8.0),
      FormSubmitButton(
        text: 'Register',
        onPressed: () async {
          if(validateLength())
            await _submit();
            else
            reEnterCreds(context);
        },
      ),
      SizedBox(height: 8.0),
      FlatButton(
        child: Text('Have an account? Log In'),
        onPressed:(){ Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => Login()),
  );
  },
      ),
    ];
  }

  bool validateLength(){
     bool enabled=false;
    setState(() {
      enabled=(_aadharController.text.toString().length==12) &&
      (_phoneController.text.toString().length==10);
    });
     return enabled; 
  }

  void reEnterCreds(BuildContext context){
     showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text('ERROR'),
            content: Text('Enter valid OTP'),
            actions: <Widget>[
              FlatButton(onPressed: () => Navigator.of(context).pop()
              ,child: Text('OK'),)
            ],
          );
        }
      );
  }

  void _submit() async{
          await SearchUser("user_aadhar");
        await SearchUser("police_aadhar");
      
          Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) =>Authenticate(widget._userAuth,widget._policeAuth,true,'+91'+this.phoneNo,widget._name)
      )
      );
  }

  
    Future<void> SearchUser (String Adhuser) async{
      var list1=[];
      var Aadhar;
      await Firestore.instance.collection(Adhuser)
      .getDocuments()
      .then((QuerySnapshot snapshot)
      {
    snapshot.documents.forEach((U_Aadhar) =>list1.add(U_Aadhar.data));
     }); 
     var AdhNum;
     var EnteredAdhNum;
     EnteredAdhNum=_aadharController.text.toString();
      for( var i =0 ; i <list1.length ;i++) 
     {
      AdhNum=list1[i]['aadhar'].toString();
      if(AdhNum.contains(EnteredAdhNum) && Adhuser==("user_aadhar")){
        setState(() {
          widget._userAuth=true;
          widget._policeAuth=false;
        });
        widget._name=list1[i]['name'].toString();
      }
      else if(AdhNum.contains(EnteredAdhNum) && Adhuser==("police_aadhar"))
      {
        setState(() {
          widget._policeAuth=true;
          widget._userAuth=false;
        });
        widget._name=list1[i]['name'].toString();
      }
      else{
        print('Not found');
      };
      AdhNum='';
    } 
    
    }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: _buildChildren(),
      ),
    );
  }
}

