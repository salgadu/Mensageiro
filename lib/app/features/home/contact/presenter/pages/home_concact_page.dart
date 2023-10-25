import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mensageiro/app/features/home/contact/domain/entity/contact.dart';
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
          title: Text('Add New Contact'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Name'),
                onChanged: (value) {
                  newContactName = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Phone Number'),
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
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Add the new contact using controller
                controller.addContact(newContactName as Contact, newContactNumber);

                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contatos'),
        actions: [
          // Add contact action button
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _openAddContactDialog(context),
          ),
        ],
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
