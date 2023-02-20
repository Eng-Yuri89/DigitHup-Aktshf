import 'package:e_learning/models/error_messages.dart';
import 'package:e_learning/models/http_exception.dart';
import 'package:e_learning/models/main_data.dart';
import 'package:e_learning/providers/auth.dart';
import 'package:e_learning/screens/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetPasswordScreen extends StatelessWidget {
  static const routeName = "/reset-screen";

  const ResetPasswordScreen({Key? key}) : super(key: key);

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

class AuthCardState extends State<AuthCard> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _isLoading = false;
  TextEditingController emailController = TextEditingController();

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
      await Provider.of<Auth>(context, listen: false)
          .resetPassword(email: emailController.text);
    } on HttpException catch (error) {
      var errorMessage = error.toString();
     // showErrorDialog(errorMessage, context);
      if (errorMessage == 'done') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              "تم إرسال رابط تعيين كلمة المرور إلي حسابك بنجاح",
              style: TextStyle(fontFamily: 'Cairo'),
            ),
            backgroundColor: Theme.of(context).backgroundColor,
            duration: const Duration(seconds: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
      else{
        showErrorDialog(errorMessage, context);
      }
    } catch (error) {
      var errorMessage = error.toString();
      showErrorDialog(errorMessage, context);
    }
    setState(() {
      _isLoading = false;
    });
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
                      Container(
                        width: context.screenWidth * 0.8,
                        margin: const EdgeInsets.all(15),
                        child: const Text("سيتم إعادة رابط تعيين"
                            "  كلمة المرور إلي بريدك حتي تتمكن من إعادة الدخول مرة أخري",
                        textAlign: TextAlign.center,),
                      ),
                      TextFormField(
                        //autofocus: true,
                        style: Theme.of(context).textTheme.bodyText1,
                        decoration: InputDecoration(
                          labelText: 'البريد الإلكتروني',
                          labelStyle: Theme.of(context).textTheme.bodyText1,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 10.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(2)),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'البريد الإلكتروني مطلوب';
                          }
                          if (!val.contains('@')) {
                            return 'البريد الإلكتروني غير صالح';
                          }
                          return null;
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
                            child: const Text(
                              "إرسال الرابط",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                        ),
                      const SizedBox(height: 10),
                      Container(
                        alignment: Alignment.topCenter,
                        margin: const EdgeInsets.only(top: 30),
                        child: Text(
                          'لديك حساب بالفعل؟',
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
                          onPressed: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                AuthScreen.routeName, (route) => false);
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color.fromRGBO(232, 237, 255, 1)),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2)),
                            ),
                          ),
                          child: Text(
                            'دخول لحسابي',
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(
                                  color: const Color.fromRGBO(69, 104, 61, 1),
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
