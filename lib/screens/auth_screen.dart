import 'package:e_learning/models/error_messages.dart';
import 'package:e_learning/models/http_exception.dart';
import 'package:e_learning/models/main_data.dart';
import 'package:e_learning/providers/auth.dart';
import 'package:e_learning/screens/home_screen.dart';
import 'package:e_learning/screens/reset_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatelessWidget {
  static const routeName = "/auth";
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).canvasColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: AppBar(
            elevation: 0,
            backgroundColor: Theme.of(context).canvasColor,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 60, bottom: 20),
                width: context.screenWidth * 0.3,
                child: const Image(
                  image: AssetImage("assets/images/logo.png"),
                  fit: BoxFit.cover,
                ),
              ),
              const AuthCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({Key? key}) : super(key: key);
  @override
  AuthCardState createState() => AuthCardState();
}
enum AuthMode { login, signUp }
class AuthCardState extends State<AuthCard> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _isLoading = false;
  var _securePassword = true;
  AuthMode _authMode = AuthMode.login;
  final Map<String, dynamic> _authData = {
    'user_name': '',
    'password': '',
    'email': '',
  };

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
   _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    // Navigator.of(context).pushNamedAndRemoveUntil(HomeScreen.routeName, (r) => false);
    try {
      if (_authMode == AuthMode.login) {
        await Provider.of<Auth>(context, listen: false).login(email: _authData['email'],
            password: _authData['password']).then((_) {
          Navigator.of(context).pushNamedAndRemoveUntil(HomeScreen.routeName, (r) => false);
        });
      } else {
        await Provider.of<Auth>(context, listen: false).signUp(
          name: _authData['user_name'],
          password: _authData['password'],
          email: _authData['email'],
        ).then((_) {
          Navigator.of(context).pushNamedAndRemoveUntil(HomeScreen.routeName, (r) => false);
        });
      }
    } on HttpException catch (error) {
      var errorMessage = error.toString();
      showErrorDialog(errorMessage, context);
    } catch (error) {
      var errorMessage = error.toString();
      showErrorDialog(errorMessage, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchMode() {
    if (_authMode == AuthMode.login) {
      setState(() {
        _authMode = AuthMode.signUp;
      });
    } else {
      setState(() {
        _authMode = AuthMode.login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: SizedBox(
            width: double.infinity,
            child: Container(
              width: context.screenWidth * 0.75,
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (_authMode == AuthMode.signUp)
                        TextFormField(
                          //autofocus: true,
                          style: Theme.of(context).textTheme.bodyText1,
                          decoration: InputDecoration(
                            labelText: 'اسم المستخدم',
                            labelStyle: Theme.of(context).textTheme.bodyText2,
                            contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(2)),
                            // enabledBorder: OutlineInputBorder(
                            //   borderSide: BorderSide(color: Theme.of(context).indicatorColor),
                            // ),
                          ),
                          keyboardType: TextInputType.text,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'اسم المستخدم مطلوب';
                            }
                            return null;
                          },
                          onSaved: (val) {
                            _authData['user_name'] = val;
                          },
                        ),
                      if (_authMode == AuthMode.signUp)
                        const SizedBox(height: 20),
                      TextFormField(
                        //autofocus: true,
                        style: Theme.of(context).textTheme.bodyText1,
                        decoration: InputDecoration(
                          labelText: 'البريد الإلكتروني',
                          labelStyle: Theme.of(context).textTheme.bodyText1,
                          contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(2)),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'البريد الإلكتروني مطلوب';
                          }
                          if (!val.contains('@')) {
                            return 'البريد الإلكتروني غير صالح';
                          }
                          return null;
                        },
                        onSaved: (val) {
                          _authData['email'] = val;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        //autofocus: true,
                        style: Theme.of(context).textTheme.bodyText1,
                        decoration: InputDecoration(
                          labelText: 'كلمة المرور',
                          labelStyle: Theme.of(context).textTheme.bodyText1,
                          contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(2),),
                          suffixIcon: IconButton(
                            icon: _securePassword ? const Icon(FontAwesomeIcons.eye) : const Icon(FontAwesomeIcons.eyeSlash),
                            onPressed: (){
                              setState(() {
                                _securePassword = !_securePassword;
                              });
                            },
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        obscureText: _securePassword,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'كلمة المرور مطلوب';
                          }
                          return null;
                        },
                        onSaved: (val) {
                          _authData['password'] = val;
                        },
                      ),
                      const SizedBox(height: 20),
                      if (_isLoading)
                        const CircularProgressIndicator()
                      else
                        SizedBox(
                          height: 60,
                          width: context.screenWidth * 0.9,
                          child: ElevatedButton(
                            onPressed: _submit,
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).backgroundColor),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                            child:  Text(
                              _authMode == AuthMode.signUp ? 'تسجيل' : 'دخول',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                        ),
                      if (_authMode == AuthMode.login)
                        Container(
                          margin: const EdgeInsets.only(top: 15,right: 5),
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed(ResetPasswordScreen.routeName);
                            },
                            child: Text(
                              "نسيت كلمة المرور؟",
                              style: Theme.of(context).textTheme.headline3!.copyWith(
                                color: Theme.of(context).backgroundColor,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 10),
                      Container(
                        alignment: Alignment.topCenter,
                        margin: const EdgeInsets.only(top: 30),
                        child: Text(
                          _authMode == AuthMode.login ?
                          'ليس لديك حساب؟' : 'لديك حساب بالفعل؟',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                          width: context.screenWidth * 0.9,
                          height: 52,
                          child: OutlinedButton(
                            onPressed: _switchMode,
                            style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all(const Color.fromRGBO(232, 237, 255,1)),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(2)),
                              ),
                            ),
                            child: Text(
                              _authMode == AuthMode.login ?
                              'تسجيل حساب جديد' : 'دخول لحسابي',
                              style: Theme.of(context).textTheme.headline6!.copyWith(
                                color: const Color.fromRGBO(69, 104, 61,1),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
