import 'package:mensageiro/app/core/store/auth/auth_status.dart';
import 'package:mensageiro/app/core/store/auth/auth_store.dart';
import 'package:mensageiro/app/features/auth/login/domain/usecase/login_with_email_and_password.dart';
import 'package:mobx/mobx.dart';

part 'login_controller.g.dart';

class LoginController = LoginControllerBase with _$LoginController;

abstract class LoginControllerBase with Store {
  final ILoginWithEmailAndPassword login;
  final AuthStore authStore;

  LoginControllerBase({required this.login, required this.authStore});

  @observable
  bool isLoading = false;

  @observable
  bool isError = false;

  @action
  setLoadind(bool value) => isLoading = value;

  @action
  setError(bool value) => isError = value;

  singIn({required String email, required String password}) async {
    authStore.setAuthStatus(AuthStatus.Unauteticated);
    final result = await login(email: email, password: password);
    setLoadind(true);
    setError(false);
    result.fold((error) {
      setError(true);
    }, (user) {
      authStore.setUser(user);
      authStore.setAuthStatus(AuthStatus.Authenticated);
    });
    setLoadind(false);
  }
}
