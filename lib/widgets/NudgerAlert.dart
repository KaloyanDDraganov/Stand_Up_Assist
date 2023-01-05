import 'package:flutter/cupertino.dart';

class NudgerAlert {
  // This shows a CupertinoModalPopup which hosts a CupertinoAlertDialog.
  void showAlertDialog(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('You are almost there!'),
        content: const Text(
            'Looks like you have not stood up in a while. Stand up soon for this hour to count.'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            /// This parameter indicates this action is the default,
            /// and turns the action's text to bold text.
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
