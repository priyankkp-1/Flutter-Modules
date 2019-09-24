import 'package:fireabase_firestore_demo/service/authentication.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'FirebaseAuthHomePage.dart';

class LoginSignUpPage extends StatefulWidget {
  final BaseAuth auth;
  final index;

  const LoginSignUpPage({this.index, this.auth});

  @override
  State<StatefulWidget> createState() => new _LoginSignupPage();
}

enum FormMode { LOGIN, SIGNUP }

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class _LoginSignupPage extends State<LoginSignUpPage> {
  final _formKey = new GlobalKey<FormState>();

  String _userId = "";
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;

  FormMode _formMode = FormMode.LOGIN;
  String _email;
  String _password;
  String _errorMessage;
  bool _isLoading = false;

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    super.initState();

    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user?.uid;
        }
        authStatus =
            user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }

  void _changeFormToSignUp() {
    _formKey.currentState.reset();
    _errorMessage = "";
    setState(() {
      _formMode = FormMode.SIGNUP;
    });
  }

  void _changeFormToLogin() {
    _formKey.currentState.reset();
    _errorMessage = "";
    setState(() {
      _formMode = FormMode.LOGIN;
    });
  }

  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _validateAndSubmitData() async {
    setState(() {
      _errorMessage = "";
      if (_email != null && _password != null) {
        _isLoading = true;
      } else {
        _isLoading = false;
      }
    });

    if (_validateAndSave()) {
      String userId = "";
      try {
        if (_formMode == FormMode.LOGIN) {
          userId = await widget.auth.signIn(_email, _password);
          print("Signed In $userId");
        } else {
          userId = await widget.auth.signUp(_email, _password);
          print("Signup : $userId");
        }

        if (userId.length > 0 && _formMode == FormMode.LOGIN) {
          _onLoggedIn();
        } else {
          widget.auth.sendEmailVerification();
          _showVerifyEmailSentDialog();
        }
      } catch (e) {
        print("Error : $e");
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _onLoggedIn() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
      });
    });
    setState(() {
      _isLoading = false;
      return Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => new FirebaseAuthHomePage(
                    auth: widget.auth,
                    userId: _userId,
                    onSignedOut: _onSignedOut,
                  )));
    });
  }

  void _onSignedOut() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
      print("called this signout");
      return new LoginSignUpPage(
        index: widget.index,
        auth: widget.auth,
//        onSignedIn: _onLoggedIn,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Firabase Auth"),
        ),
        body: Hero(
          tag: "link_${widget.index}",
          child: Stack(
            fit: StackFit.loose,
            children: <Widget>[
              _showBody(),
              _showCircularProgress(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content:
              new Text("Link to verify account has been sent to your email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                _changeFormToLogin();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _showBody() {
    return new Container(
      padding: EdgeInsets.all(5.0),
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            _showEmailInput(),
            _showPasswordInput(),
            _showSignupButton(),
            _shoLoginButton(),
          ],
        ),
      ),
    );
  }

  Widget _showEmailInput() {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
//        initialValue: "brijesh.devstree@gmail.com",
        decoration: new InputDecoration(
          hintText: "Email",
          icon: new Icon(
            Icons.mail,
            color: Colors.grey,
          ),
        ),
        validator: (value) => value.isEmpty ? "Email is required" : null,
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  Widget _showPasswordInput() {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: TextFormField(
        maxLines: 1,
        obscureText: true,
        keyboardType: TextInputType.text,
        autofocus: false,
//        initialValue: "brijesh@2018",
        decoration: new InputDecoration(
          hintText: "Password",
          icon: new Icon(
            Icons.lock,
            color: Colors.grey,
          ),
        ),
        validator: (value) => value.isEmpty ? "Password is required" : null,
        onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  Widget _showSignupButton() {
    return new FlatButton(
      onPressed: _formMode == FormMode.LOGIN
          ? _changeFormToSignUp
          : _changeFormToLogin,
      child: _formMode == FormMode.LOGIN
          ? new Text("Create account")
          : Text("Have an account"),
    );
  }

  Widget _shoLoginButton() {
    return new Padding(
      padding: EdgeInsets.all(5.0),
      child: new RaisedButton(
        onPressed: _validateAndSubmitData,
        child: _formMode == FormMode.LOGIN
            ? Text("Login")
            : Text("Create Account"),
      ),
    );
  }
}
