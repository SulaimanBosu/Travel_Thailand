import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resize/resize.dart';

class MyAlertDialog {
  showcupertinoDialog(
    BuildContext context,
    String textContent,
  ) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) {
          return Theme(
            data: Theme.of(context).copyWith(backgroundColor: Colors.amber),
                  child: CupertinoAlertDialog(
              content: Text(
                textContent,
                style: TextStyle(
                  overflow: TextOverflow.clip,
                  fontSize: 20.0 .sp,
                  color: Colors.black45,
                  fontFamily: 'FC-Minimal-Regular',
                ),
                textAlign: TextAlign.center,
              ),
              actions: <CupertinoDialogAction>[
                CupertinoDialogAction(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          );
        });
  }

  showAlertDialog(

    BuildContext context,
    String textContent,
    String textButtonYes,
    String textButtonNo,
    VoidCallback onPressedYes,
  ) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        
        content: Text(
          textContent,
          style: TextStyle(
            overflow: TextOverflow.clip,
            fontSize: 18.0.sp,
            color: Colors.black45,
            fontFamily: 'FC-Minimal-Regular',
          ),
          textAlign: TextAlign.center,
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
              // isDefaultAction: true,
              onPressed: onPressedYes,
              child: Text(
                textButtonYes,
                style: const TextStyle(color: Colors.red),
              )),
          CupertinoDialogAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child:  Text(
              textButtonNo,
              style: const TextStyle(color: Colors.red),
            ),
          )
        ],
      ),
    );
  }

  showtDialog(
    BuildContext context,
    String textContent,
  ) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
    
        content: Text(
          textContent,
          style: TextStyle(
            overflow: TextOverflow.clip,
            fontSize: 18.0.sp,
            color: Colors.black45,
            fontFamily: 'FC-Minimal-Regular',
          ),
          textAlign: TextAlign.center,
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'ตกลง',
                style: TextStyle(color: Colors.red),
              )),
        ],
      ),
    );
  }

  MyAlertDialog();
}
