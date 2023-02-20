import 'package:e_learning/models/main_data.dart';
import 'package:e_learning/providers/auth.dart';
import 'package:e_learning/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeleteAccountScreen extends StatelessWidget {
  static const routeName = "/delete_account";
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    Future<void> _submit() async {
      Provider.of<Auth>(context, listen: false).deleteAccount().then((value) =>
          Provider.of<Auth>(context, listen: false).logout().then((value) =>
          Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false)));
    }
    return Directionality(
      textDirection: TextDirection.rtl, // setting rtl
      child: Scaffold(
        key: _scaffoldKey,
        appBar:  const PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: PageAppBar(title: "حذف الحساب",elevate: 0.5),
        ),
        body: Center(
          child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(25),
                  margin: EdgeInsets.only(top: 30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Color.fromRGBO(113, 12, 12, 1),
                  ),
                  child: Icon(
                    Icons.delete_forever,
                    size: 70,
                    color: Colors.white,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: const Text(
                    "حذف الحساب بشكل نهائي!!",
                    style: TextStyle(fontSize: 18, color: Colors.black,fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  width: 220,
                  child: const Text("عند حذف الحساب لن تتمكن  من الوصول مرة أخري إلي معلوماتك أو الطلبات التي قمت بشرائها",
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20,),
                SizedBox(
                  height: 52,
                  width: context.screenWidth * 0.9,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).backgroundColor),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    child: Text(
                      "تأكيد الحذف",
                      style: Theme.of(context).textTheme.headline3,
                    ),
                  ),
                ),
              ],
          ),
        ),
      ),
    );
  }
}
