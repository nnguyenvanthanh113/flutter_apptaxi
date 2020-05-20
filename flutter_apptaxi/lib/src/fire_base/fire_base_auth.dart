import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
class FireAuth{
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void signUp(String email, String pass,String name,String phone,
      Function onSuccess,Function(String) onRegisterError){
      _firebaseAuth.createUserWithEmailAndPassword(email: email, password: pass).then((user){

        _createUser(user.user.uid, name, phone,onSuccess,onRegisterError);
        print(user);
      }).catchError((err){
        _onSignUpErr(err.code, onRegisterError);
      });

  }
  _createUser(String userId,String name,String phone,
      Function onSuccess,Function(String) onRegisterError){
    var user = {
      "name" : name,
      "phone" : phone
    };
      var ref = FirebaseDatabase.instance.reference().child("users");
      ref.child(userId).set(user).then((user){
      onSuccess();
        //success
      }).catchError((err){
          onRegisterError("Signup fail ! please try again");
      });
  }
  void _onSignUpErr(String code, Function(String) onRegisterError) {
    print(code);
    switch (code) {
      case "ERROR_INVALID_EMAIL":
      case "ERROR_INVALID_CREDENTIAL":
        onRegisterError("Invalid email");
        break;
      case "ERROR_EMAIL_ALREADY_IN_USE":
        onRegisterError("Email has existed");
        break;
      case "ERROR_WEAK_PASSWORD":
        onRegisterError("The password is not strong enough");
        break;
      default:
        onRegisterError("SignUp fail, please try again");
        break;
    }
  }

  //dang nhap
  void signIn(String email,String pass,Function onSuccess,
      Function(String) onSignInError)
  {
    _firebaseAuth.signInWithEmailAndPassword(email: email, password: pass)
        .then((user){
          print("on sign in success");
          onSuccess();
    }).catchError((err){
      onSignInError("Sign In fail, please try again !");
    });
  }
}