import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:mensageiro/app/core/widgets/drawer/custom_drawer.dart';
import 'package:mensageiro/app/features/home/contact/presenter/pages/contacts_controller.dart';

class HomeContactPage extends StatefulWidget {
  final ContactsController controller;

  const HomeContactPage({Key? key, required this.controller}) : super(key: key);

  @override
  _HomeContactPageState createState() => _HomeContactPageState();
}

class _HomeContactPageState extends State<HomeContactPage> {
  late ContactsController controller;

  var number = MaskTextInputFormatter(
      mask: '+55 (##) # ####-####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

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
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                inputFormatters: [number],
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
                controller.addContactF(
                  newContactName,
                  newContactNumber.replaceAll(RegExp(r'[^0-9]'), ''),
                );
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
      drawer: CustomDrawer(),
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
                onTap: () => Modular.to.pushNamed('/home/chat/',
                    arguments: controller.listContacts![index]),
                title: Text(contact.name),
                subtitle: Text(contact.phone),
                leading: CircleAvatar(
                  backgroundImage: contact.photo?.isEmpty ?? true
                      ? null
                      : NetworkImage(
                          contact.photo!,
                        ),
                  child: contact.photo?.isEmpty ?? true
                      ? Text(
                          contact.name.substring(0, 1),
                          style: GoogleFonts.spaceGrotesk()
                              .copyWith(fontSize: 25, color: Colors.white),
                        )
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
