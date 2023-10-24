import 'package:mensageiro/app/core/store/auth/auth_status.dart';
import 'package:mensageiro/app/core/store/auth/auth_store.dart';
import 'package:mensageiro/app/features/auth/register/domain/entity/register_auth.dart';
import 'package:mensageiro/app/features/auth/register/domain/usecases/auth_register.dart';
import 'package:mobx/mobx.dart';

part 'register_controller.g.dart';

class RegisterController = RegisterControllerBase with _$RegisterController;

abstract class RegisterControllerBase with Store {
  final AuthStore authStore;
  final IRegisterUser register;

  RegisterControllerBase({required this.authStore, required this.register});

  @observable
  bool isLoading = false;

  @observable
  bool isError = false;

  @action
  setLoadind(bool value) => isLoading = value;

  @action
  setError(bool value) => isError = value;

  Future<void> registerUser({required RegisterAuth data}) async {
    authStore.setAuthStatus(AuthStatus.Unauteticated);
    final result = await register(data);
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
