import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mensageiro/app/features/home/contact/presenter/pages/contacts_controller.dart';

class HomeContactPage extends StatefulWidget {
  final ContactsController controller;
  const HomeContactPage({super.key, required this.controller});

  @override
  State<HomeContactPage> createState() => _HomeContactPageState();
}

class _HomeContactPageState extends State<HomeContactPage> {
  late ContactsController controller;
  @override
  void initState() {
    super.initState();
    controller = widget.controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            itemCount: controller.listContacts.length,
            itemBuilder: (_, index) {
              final contact = controller.listContacts[index];
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
