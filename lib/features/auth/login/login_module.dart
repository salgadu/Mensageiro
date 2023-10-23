import 'package:flutter_modular/flutter_modular.dart';
import 'package:mensageiro/features/auth/login/domain/repository/login_repository.dart';
import 'package:mensageiro/features/auth/login/external/datasource/firebase_repository_datasource_impl.dart';
import 'package:mensageiro/features/auth/login/infra/datasource/login_datasource.dart';
import 'package:mensageiro/features/auth/login/infra/repository/login_repository_impl.dart';
import 'package:mensageiro/features/auth/login/presenter/pages/login_page.dart';
import 'package:mensageiro/features/auth/register/domain/usecases/auth_register.dart';

class LoginModule extends Module {
  @override
  void binds(i) {
    i.add<LoginRepository>(LoginRepositoryImpl.new);
    i.add<ILoginDatasource>(FireBaseRepositoryDataSourceImpl.new);
    i.add<IRegisterUser>(RegisterUser.new);
  }

  @override
  void routes(r) {
    r.child('/', child: (context) => LoginPage());
  }
}
