import 'package:mensageiro/app/features/auth/login/domain/entity/logged_user.dart';
import 'package:mobx/mobx.dart';

part 'auth_store.g.dart';

class AuthStore = AuthStoreBase with _$AuthStore;

abstract class AuthStoreBase with Store {
  @observable
  LoggedUser? user;

  @action
  setUser(LoggedUser? value) => user = value;
}
