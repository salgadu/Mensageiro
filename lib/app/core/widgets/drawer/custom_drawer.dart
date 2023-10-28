import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mensageiro/app/core/store/auth/auth_store.dart';

class CustomDrawer extends StatelessWidget {
  final AuthStore _authStore = Modular.get<AuthStore>();
  CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: _authStore.user?.photo?.isEmpty ?? true
                      ? null
                      : NetworkImage(
                          _authStore.user!.photo!,
                        ),
                  child: _authStore.user?.photo?.isEmpty ?? true
                      ? Text(
                          _authStore.user!.name.substring(0, 1),
                          style: GoogleFonts.spaceGrotesk()
                              .copyWith(fontSize: 25, color: Colors.white),
                        )
                      : null,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(_authStore.user?.name ?? '',
                    overflow: TextOverflow.clip,
                    maxLines: 1,
                    style: GoogleFonts.spaceGrotesk()
                        .copyWith(fontSize: 25, color: Colors.white))
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              ListTile(
                title: const Text('Item 1'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                title: const Text('Item 2'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
            ],
          ),
          Center(
            child: ElevatedButton(
                onPressed: () async => await _authStore.signOut(),
                child: const Text('Sair')),
          )
        ],
      ),
    );
  }
}
