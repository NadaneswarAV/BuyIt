import 'package:flutter/material.dart';

class NotificationPreferencesTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.notifications),
      title: const Text("Notification Preferences"),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => _NotificationPreferencesDialog(),
        );
      },
    );
  }
}

class _NotificationPreferencesDialog extends StatefulWidget {
  @override
  State<_NotificationPreferencesDialog> createState() => _NotificationPreferencesDialogState();
}

class _NotificationPreferencesDialogState extends State<_NotificationPreferencesDialog> {
  bool orderUpdates = true;
  bool promotions = false;
  bool appNews = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Notification Preferences'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text('Order Updates'),
              value: orderUpdates,
              onChanged: (val) => setState(() => orderUpdates = val),
            ),
            SwitchListTile(
              title: const Text('Promotions'),
              value: promotions,
              onChanged: (val) => setState(() => promotions = val),
            ),
            SwitchListTile(
              title: const Text('App News'),
              value: appNews,
              onChanged: (val) => setState(() => appNews = val),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            // TODO: Save preferences to server or local storage
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Preferences saved!')),
            );
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}