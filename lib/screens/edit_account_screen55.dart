import 'package:e_learning/models/main_data.dart';
import 'package:e_learning/providers/auth.dart';
import 'package:e_learning/widgets/app_bar.dart';
import 'package:e_learning/widgets/app_navigation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class EditAccountScreen extends StatefulWidget {
  static const routeName = "/edit-account";

  const EditAccountScreen({Key? key}) : super(key: key);

  @override
  EditAccountScreenState createState() => EditAccountScreenState();
}

class EditAccountScreenState extends State<EditAccountScreen> {
  var _isLoading = false;
  var _securePassword = true;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        //key: _scaffoldKey,
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: PageAppBar(title: "تعديل بياناتي",elevate: 0.5),
        ),
        body: Container(
          margin: const EdgeInsets.only(top: 30),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: Container(
                      width: context.screenWidth * 0.75,
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        // key: _formKey,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
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
                                initialValue: "محمد احمد",
                                keyboardType: TextInputType.text,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'اسم المستخدم مطلوب';
                                  }
                                  return null;
                                },
                                onSaved: (val) {
                                  // _authData['user_name'] = val;
                                },
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                               // autofocus: true,
                                style: Theme.of(context).textTheme.bodyText1,
                                decoration: InputDecoration(
                                  labelText: 'البريد الإلكتروني',
                                  labelStyle: Theme.of(context).textTheme.bodyText1,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(2)),
                                  // enabledBorder: OutlineInputBorder(
                                  //   borderSide: BorderSide(color: Theme.of(context).indicatorColor),
                                  // ),
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
                                initialValue: "Ali@gmail.com",
                                onSaved: (val) {
                                  // _authData['email'] = val;
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
                                  // enabledBorder: OutlineInputBorder(
                                  //   borderSide: BorderSide(color: Theme.of(context).indicatorColor),
                                  // ),
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
                                  //_authData['password'] = val;
                                },
                              ),
                              const SizedBox(height: 20),
                              // if (_isLoading)
                              if (1 > 5)
                                const CircularProgressIndicator()
                              else
                                SizedBox(
                                  height: 60,
                                  width: context.screenWidth * 0.9,
                                  child: ElevatedButton(
                                    onPressed: (){},
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(
                                          Theme.of(context).backgroundColor),
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(2),
                                        ),
                                      ),
                                    ),
                                    child:  Text('حفظ التعديلات',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
            ),
          ),
        ),
        bottomNavigationBar: const AppNavigation(index: 3),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Provider.of<Auth>(context, listen: false).logout().then((_) {
              Navigator.of(context).pushNamedAndRemoveUntil('/', (r) => false);
            });
          },
          backgroundColor: Theme.of(context).backgroundColor,
          tooltip: "تسجيل خروج",
          child: const Icon(FontAwesomeIcons.arrowRightFromBracket),
        ),
      ),
    );
  }
}
