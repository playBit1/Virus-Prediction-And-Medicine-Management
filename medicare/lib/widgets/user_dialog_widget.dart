import 'dart:async';
import 'package:flutter/material.dart';
import 'package:medicare/database/authenticate.dart';

Future<void> signOutWithStream(
  BuildContext context,
  StreamSubscription medicationDataStream,
) async {
  medicationDataStream.cancel();
  await Authenticate().signOut().then(
        (value) => {
          Navigator.popUntil(
            context,
            ModalRoute.withName("/"),
          ),
        },
      );
}

Future<void> signOut(
  BuildContext context,
) async {
  await Authenticate().signOut().then(
        (value) => {
          Navigator.popUntil(
            context,
            ModalRoute.withName("/"),
          ),
        },
      );
}

Widget _changeUserName(
  BuildContext context,
  TextEditingController userName,
) {
  return Dialog(
    child: SizedBox(
      width: 220,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          const Text('Change Name'),
          SizedBox(
            width: 200,
            child: TextField(
              controller: userName,
              maxLength: 9,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 75),
            child: Row(
              children: [
                TextButton(
                  onPressed: () {
                    Authenticate().updateUserName(userName.text);
                    Navigator.pop(context);
                  },
                  child: const Text('Yes'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('No'),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget userDialogBoxMenu(
  BuildContext context,
  TextEditingController userName,
) {
  return Dialog(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25))),
    alignment: Alignment.topCenter,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Close'),
          ),
        ),
        const SizedBox(
          width: 270,
          child: Divider(
            thickness: 1,
            color: Colors.black,
          ),
        ),
        TextButton(
          onPressed: () {
            //Navigator.pop(context);
            showDialog(
              context: context,
              builder: ((BuildContext context) =>
                  _changeUserName(context, userName)),
            );
          },
          child: const Text('Change Name'),
        ),
        const SizedBox(
          width: 270,
          child: Divider(
            thickness: 1,
            color: Colors.black,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: TextButton(
            onPressed: () {
              signOut(context);
            },
            child: const Text(
              'Sign Out',
            ),
          ),
        )
      ],
    ),
  );
}

Widget userDialogBox(
  BuildContext context,
  TextEditingController userName,
  StreamSubscription medicationDataStream,
) {
  return Dialog(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25))),
    alignment: Alignment.topCenter,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Close'),
          ),
        ),
        const SizedBox(
          width: 270,
          child: Divider(
            thickness: 1,
            color: Colors.black,
          ),
        ),
        TextButton(
          onPressed: () {
            //Navigator.pop(context);
            showDialog(
              context: context,
              builder: ((BuildContext context) =>
                  _changeUserName(context, userName)),
            );
          },
          child: const Text('Change Name'),
        ),
        const SizedBox(
          width: 270,
          child: Divider(
            thickness: 1,
            color: Colors.black,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: TextButton(
            onPressed: () {
              signOutWithStream(context, medicationDataStream);
            },
            child: const Text(
              'Sign Out',
            ),
          ),
        )
      ],
    ),
  );
}
