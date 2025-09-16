import 'package:flutter/material.dart';

class PaymentMethodsTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.payment),
      title: const Text("Payment Methods"),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => _PaymentMethodsDialog(),
        );
      },
    );
  }
}

class _PaymentMethodsDialog extends StatefulWidget {
  @override
  State<_PaymentMethodsDialog> createState() => _PaymentMethodsDialogState();
}

class _PaymentMethodsDialogState extends State<_PaymentMethodsDialog> {
  List<Map<String, String>> paymentMethods = [
    {"type": "Visa", "last4": "1234"},
    {"type": "Mastercard", "last4": "5678"},
  ];

  final cardTypeController = TextEditingController();
  final cardNumberController = TextEditingController();
  String? error;

  void _addPaymentMethod() {
    if (cardTypeController.text.isEmpty || cardNumberController.text.length < 4) {
      setState(() {
        error = "Enter valid card type and last 4 digits";
      });
      return;
    }
    setState(() {
      paymentMethods.add({
        "type": cardTypeController.text,
        "last4": cardNumberController.text.substring(cardNumberController.text.length - 4),
      });
      cardTypeController.clear();
      cardNumberController.clear();
      error = null;
    });
  }

  void _removePaymentMethod(int index) {
    setState(() {
      paymentMethods.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Payment Methods'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...paymentMethods.asMap().entries.map((entry) {
              int idx = entry.key;
              var method = entry.value;
              return ListTile(
                leading: const Icon(Icons.credit_card),
                title: Text('${method["type"]} •••• ${method["last4"]}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removePaymentMethod(idx),
                ),
              );
            }),
            const Divider(),
            TextField(
              controller: cardTypeController,
              decoration: const InputDecoration(labelText: 'Card Type (e.g. Visa)'),
            ),
            TextField(
              controller: cardNumberController,
              decoration: const InputDecoration(labelText: 'Card Number'),
              keyboardType: TextInputType.number,
              maxLength: 16,
            ),
            if (error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(error!, style: const TextStyle(color: Colors.red)),
              ),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Add Card'),
              onPressed: _addPaymentMethod,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
        ElevatedButton(
          onPressed: () {
            // TODO: Save payment methods to server or local storage
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Payment methods updated!')),
            );
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}  