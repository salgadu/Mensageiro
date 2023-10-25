import 'package:flutter_modular/flutter_modular.dart';
import 'package:mensageiro/app/core/store/auth/auth_status.dart';
import 'package:mensageiro/app/features/auth/login/domain/entity/logged_user.dart';
import 'package:mobx/mobx.dart';

part 'auth_store.g.dart';

class AuthStore = AuthStoreBase with _$AuthStore;

abstract class AuthStoreBase with Store {
  AuthStoreBase() {
    reaction((_) => authStatus, (_) {
      switch (authStatus) {
        case AuthStatus.Authenticated:
          Modular.to.navigate('/home/contacts/');
          break;
        case AuthStatus.Unauteticated:
          Modular.to.popAndPushNamed('/');
          break;
        default:
      }
    });
  }

  @observable
  AuthStatus? authStatus;

  @observable
  LoggedUser? user;

  @action
  setUser(LoggedUser? value) => user = value;

  @action
  setAuthStatus(AuthStatus value) => authStatus = value;
}
