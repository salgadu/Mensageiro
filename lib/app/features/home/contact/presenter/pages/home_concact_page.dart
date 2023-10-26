import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mensageiro/app/features/home/contact/presenter/pages/contacts_controller.dart';

class HomeContactPage extends StatefulWidget {
  final ContactsController controller;

  const HomeContactPage({Key? key, required this.controller}) : super(key: key);

  @override
  _HomeContactPageState createState() => _HomeContactPageState();
}

class _HomeContactPageState extends State<HomeContactPage> {
  late ContactsController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
  }

  // Function to open the add contact dialog
  void _openAddContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        String newContactName = '';
        String newContactNumber = '';

        return AlertDialog(
          title: const Text('Add New Contact'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Name'),
                onChanged: (value) {
                  newContactName = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Phone Number'),
                onChanged: (value) {
                  newContactNumber = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                controller.addContactF(newContactName, newContactNumber);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ElevatedButton(
        child: const Icon(Icons.add),
        onPressed: () => _openAddContactDialog(context),
      ),
      appBar: AppBar(
        title: const Text('Contatos'),
      ),
      body: Observer(builder: (_) {
        if (controller.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (controller.isError) {
          return const Center(
            child: Text('Erro ao carregar contatos'),
          );
        } else {
          return ListView.builder(
            itemCount: controller.listContacts?.length ?? 0,
            itemBuilder: (_, index) {
              final contact = controller.listContacts![index];
              return ListTile(
                title: Text(contact.name),
                subtitle: Text(contact.phone),
                leading: CircleAvatar(
                  backgroundImage: contact.photo != null
                      ? NetworkImage(contact.photo!)
                      : null,
                ),
              );
            },
          );
        }
      }),
    );
  }
}
