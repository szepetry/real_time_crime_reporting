class Validator{
bool userAuth;
  bool policeAuth;
   String phoneNo;
  String aadhar;
  String enteredPassword;
  String rePassword;
  Validator({bool u_auth,bool p_auth,String ph,String adhar,String pass,String re_pass}){
    this.userAuth=u_auth;
    this.policeAuth=p_auth;
    this.phoneNo=ph;
    this.aadhar=adhar;
    this.enteredPassword=pass;
    this.rePassword=re_pass;
  }

   bool checkIfAadharExists() {
    if (userAuth == false && policeAuth == false) {
      return false;
    }
    return true;
  }
   bool validatePasswords() {
    bool enabled = false;
     (enteredPassword == rePassword) ? enabled = true : enabled = false;
     return enabled;
    }
    bool checkIfFieldsEmpty(){
    if(phoneNo==null || aadhar==null || enteredPassword==null|| rePassword==null)
    return true;
    else 
    return false;
  }

}