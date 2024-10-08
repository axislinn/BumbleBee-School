import 'package:bumblebee_school/bloc/Admin+Teacher/auth/login_bloc/login_event.dart';
import 'package:bumblebee_school/bloc/Admin+Teacher/auth/login_bloc/login_state.dart';
import 'package:bumblebee_school/data/repositories/Admin+Teacher/user_repository.dart';
import 'package:bumblebee_school/models/Admin+Teacher/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository;
  final storage = FlutterSecureStorage();

  LoginBloc({required this.userRepository}) : super(LoginInitial()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
  }

  Future<void> _onLoginButtonPressed(LoginButtonPressed event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      UserModel user = await userRepository.authenticate(
        email: event.email,
        password: event.password,
      );

      // Store token in secure storage
      await storage.write(key: 'userToken', value: user.token); // Ensure the key is consistent
      String rolesAsString = user.roles.join(',');
      await storage.write(key: 'userRole', value: rolesAsString);

      emit(LoginSuccess(user: user));
    } catch (error) {
      print('LoginBloc: Error during login - $error');
      emit(LoginFailure(error: error.toString()));
    }
  }
}
