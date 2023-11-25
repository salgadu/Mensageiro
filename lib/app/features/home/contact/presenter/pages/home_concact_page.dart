import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:mensageiro/app/core/components/cutom_contact_card.dart';
import 'package:mensageiro/app/core/components/page_title.dart';
import 'package:mensageiro/app/core/components/rounded_item.dart';
import 'package:mensageiro/app/core/components/svg_asset.dart';
import 'package:mensageiro/app/core/components/text.dart';
import 'package:mensageiro/app/core/components/title_textfield.dart';
import 'package:mensageiro/app/core/constants/colors.dart';
import 'package:mensageiro/app/core/constants/const.dart';
import 'package:mensageiro/app/core/constants/fonts_sizes.dart';
import 'package:mensageiro/app/features/home/contact/domain/entity/contact.dart';
import 'package:mensageiro/app/features/home/contact/presenter/pages/contacts_controller.dart';

class HomeContactPage extends StatefulWidget {
  final ContactsController controller;
  final String id;

  const HomeContactPage({Key? key, required this.controller, required this.id})
      : super(key: key);

  @override
  _HomeContactPageState createState() => _HomeContactPageState();
}

class _HomeContactPageState extends State<HomeContactPage> {
  late ContactsController controller;
  List<Contact> filterContacts = [];

  var number = MaskTextInputFormatter(
    mask: '+55 (##) # ####-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
  }

  loadContact() async {
    if (widget.id.isNotEmpty && !controller.isLoading) {
      int numero = int.parse(widget.id);
      Modular.to.pushNamed('/home/chat/',
          arguments: controller.listContacts![numero]);
    }
  }

  // Function to open the add contact dialog
  void _openAddContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        String newContactName = '';
        String newContactNumber = '';

        return AlertDialog(
          title: const Text(
            'Novo contato',
            textAlign: TextAlign.center,
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 12),
              _buildAlertDialogTextField(
                hintText: 'Nome',
                onChanged: (value) {
                  newContactName = value;
                },
              ),
              SizedBox(height: 12),
              _buildAlertDialogTextField(
                hintText: 'Numero',
                keyboardType: TextInputType.phone,
                inputFormatters: [number],
                onChanged: (value) {
                  newContactNumber = value;
                },
              ),
              SizedBox(height: 12),
            ],
          ),

          actions: [
            _buildElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              backgroundColor: Colors.red,
              icon: Icons.close,
            ),
            _buildElevatedButton(
              onPressed: () {
                controller.addContactF(
                  newContactName,
                  newContactNumber.replaceAll(RegExp(r'[^0-9]'), ''),
                );
                Navigator.of(context).pop(); // Close the dialog
              },
              backgroundColor: Colors.green,
              icon: Icons.check,
            ),
          ],
          backgroundColor: Colors.white, // Adjust the transparency here
          elevation: 5, // You can adjust the elevation as well
        );
      },
    );
  }

  Widget _buildAlertDialogTextField({
    required String hintText,
    TextEditingController? controller,
    bool obscureText = false,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, insira $hintText';
        }
        return null;
      },
      controller: controller,
      onChanged: onChanged,
      obscureText: obscureText,
      style: TextStyle(
        fontFamily: 'Dylan Medium',
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 16.0,
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFF7F5F7)),
        ),
      ),
    );
  }

  Widget _buildElevatedButton({
    required VoidCallback onPressed,
    required Color backgroundColor,
    required IconData icon,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: backgroundColor,
        onPrimary: Colors.white,
        padding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
      ),
      child: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => _openAddContactDialog(context),
      //   backgroundColor: Colors.white,
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(30.0),
      //   ),
      //   child: const Icon(Icons.add, color: Colors.black),
      // ),

      body: SafeArea(
        child: Observer(builder: (_) {
          if (controller.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (controller.isError) {
            return const Center(
              child: Text('Erro ao carregar contatos'),
            );
          } else {
            loadContact();
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: AppConst.sidePadding),
                      child: Row(
                        children: [
                          const PageTitle(
                            title: 'Contatos',
                            fontSize: AppFontSize.fz14,
                          ),
                        ],
                      ),
                    ),
                  ),
                  //ROUNDED ITEMS
                  Container(
                      color: AppColors.white,
                      padding: EdgeInsets.symmetric(
                          horizontal: AppConst.sidePadding),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RoundedItem(
                            fontSize: AppFontSize.fz06,
                            size: 60,
                            icon: 'phone-dark.svg',
                            title: 'Ligações',
                            iconSize: 20,
                          ),
                          RoundedItem(
                              fontSize: AppFontSize.fz06,
                              size: 60,
                              icon: 'helpdesk.svg',
                              title: 'Chamadas',
                              iconSize: 20),
                          RoundedItem(
                              fontSize: AppFontSize.fz06,
                              size: 60,
                              icon: 'chat-dark.svg',
                              title: 'Conversas',
                              iconSize: 20),
                          RoundedItem(
                              fontSize: AppFontSize.fz06,
                              backgroundcolor: AppColors.black,
                              size: 60,
                              icon: 'contact-dark.svg',
                              title: 'Contatos',
                              iconColor: AppColors.white,
                              iconSize: 20),
                        ],
                      )),

                  //BUSCAR CONTATO
                  Container(
                    color: AppColors.newGrey,
                    padding: EdgeInsets.symmetric(
                        horizontal: AppConst.sidePadding, vertical: 20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 6),
                      decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(50)),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: AppSvgAsset(
                              image: 'search.svg',
                              color: AppColors.grey,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TitleTextField(
                              hintText: 'Buscar',
                              borderColor: Colors.transparent,
                              onChanged: (text) {
                                var listContacts = controller.listContacts!
                                    .where((element) => element.name
                                        .toLowerCase()
                                        .contains(text.toLowerCase()))
                                    .toList();
                                controller.setFilterContacts(listContacts);
                              },
                            ),
                          ),
                          InkWell(
                            onTap: () => _openAddContactDialog(context),
                            child: const SizedBox(
                              width: 20,
                              height: 20,
                              child: AppSvgAsset(
                                image: 'add-user.svg',
                                color: AppColors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  //FILTROS
                  Container(
                    color: AppColors.newGrey,
                    padding: EdgeInsets.symmetric(
                      horizontal: AppConst.sidePadding * 2,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                          text: 'TODOS',
                          fontSize: AppFontSize.fz05,
                          fontWeight: 'medium',
                          letterSpacing: 1.5,
                          color: AppColors.darkBlue,
                        ),
                        AppText(
                          text: 'CLIENTES',
                          fontSize: AppFontSize.fz05,
                          fontWeight: 'medium',
                          letterSpacing: 1.5,
                          color: AppColors.grey,
                        ),
                        AppText(
                          text: 'EXECUTIVO',
                          fontSize: AppFontSize.fz05,
                          fontWeight: 'medium',
                          letterSpacing: 1.5,
                          color: AppColors.grey,
                        ),
                      ],
                    ),
                  ),

                  //LISTA DE CONTATOS
                  Container(
                    color: AppColors.newGrey,
                    // height: MediaQuery.of(context).size.height,
                    padding: EdgeInsets.symmetric(
                        horizontal: AppConst.sidePadding, vertical: 20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20.0,
                        horizontal: 10.0,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(45),
                        color: AppColors.white,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: controller.filterContacts.map((contact) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: InkWell(
                              onTap: () => Modular.to
                                  .pushNamed('/home/chat/', arguments: contact),
                              child: CustomContactCard(
                                  icon: 'profile.svg',
                                  color: AppColors.grey,
                                  title: contact.name),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  // const SizedBox(height: 100)
                ],
              ),
            );
          }
        }),
      ),
    );
  }
}
