import 'package:flutter/material.dart';

void showErrorDialog(String errorMessage, BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      title: Container(
        alignment: Alignment.centerRight,
          child: Text("حدث خطأ",style: Theme.of(context).textTheme.headline2)
      ),
      content: Text(errorMessage,textAlign: TextAlign.right,style: Theme.of(context).textTheme.headline2!
          .copyWith(fontSize: 15)),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: Text("تم",style: Theme.of(context).textTheme.headline2),
        ),
      ],
    ),
  );
}
