import 'package:flutter/cupertino.dart';

class NudgerAlert {
  void showAlertDialog(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('You are almost there!'),
        content: const Text(
            'Looks like you have not stood up in a while. Stand up soon for this hour to count.'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}
