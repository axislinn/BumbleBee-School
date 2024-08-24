import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();

      try {
        // Simulate a login process
        await Future.delayed(Duration(seconds: 2));
        if (event.email == 'test@test.com' && event.password == 'password') {
          yield LoginSuccess();
        } else {
          yield LoginFailure(error: 'Invalid credentials');
        }
      } catch (error) {
        yield LoginFailure(error: error.toString());
      }
    }
  }
}
