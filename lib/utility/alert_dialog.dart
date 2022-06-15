import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyAlertDialog {
  showAlertDialog(
    IconData icon,
    BuildContext context,
    String textTitle,
    String textContent,
    String textButton,
    VoidCallback onPressedYes,
  ) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Column(
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.redAccent),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  textTitle,
                  style: const TextStyle(
                    overflow: TextOverflow.clip,
                    fontSize: 18.0,
                    color: Colors.black45,
                    fontFamily: 'FC-Minimal-Regular',
                  ),
                ),
              ],
            ),
            const Divider(
              thickness: 1,
              height: 5,
              color: Colors.black54,
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
        content: Text(
          textContent,
          style: const TextStyle(
            overflow: TextOverflow.clip,
            fontSize: 18.0,
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
                textButton,
                style: const TextStyle(color: Colors.red),
              )),
          CupertinoDialogAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'ยกเลิก',
              style: TextStyle(color: Colors.red),
            ),
          )
        ],
      ),
    );
  }

  showtDialog(
    BuildContext context,
    IconData icon,
    String textTitle,
    String textContent,
  ) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Column(
          children: [
            Row(
              children: [
                Icon(icon),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  textTitle,
                  style: const TextStyle(
                    overflow: TextOverflow.clip,
                    fontSize: 18.0,
                    color: Colors.black45,
                    fontFamily: 'FC-Minimal-Regular',
                  ),
                ),
              ],
            ),
            const Divider(
              thickness: 1,
              height: 5,
              color: Colors.black54,
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
        content: Text(
          textContent,
          style: const TextStyle(
            overflow: TextOverflow.clip,
            fontSize: 18.0,
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
