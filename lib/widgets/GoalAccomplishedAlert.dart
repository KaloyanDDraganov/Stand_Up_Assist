import 'package:flutter/cupertino.dart';

class GoalAccomplishedAlert {
  // This shows a CupertinoModalPopup which hosts a CupertinoAlertDialog.
  void showAlertDialog(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Well done!'),
        content: const Text('You have accomplished your goal.'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            /// This parameter indicates this action is the default,
            /// and turns the action's text to bold text.
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
