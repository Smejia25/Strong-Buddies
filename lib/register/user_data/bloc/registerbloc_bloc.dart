import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:strong_buddies_connect/register/user_data/model/register_user.dart';
import 'package:strong_buddies_connect/shared/services/auth_service.dart';
import 'package:strong_buddies_connect/shared/services/user_collection.dart';
part 'registerbloc_event.dart';
part 'registerbloc_state.dart';

class RegisterBloc extends Bloc<RegisterblocEvent, RegisterblocState> {
  final _auth = AuthService();
  final _userCollection = UserCollection();

  @override
  RegisterblocState get initialState => RegisterblocInitial();

  @override
  Stream<RegisterblocState> mapEventToState(
    RegisterblocEvent event,
  ) async* {
    if (event is CreateUserEvent) {
      yield RegisterInProcess();
      try {
        await _auth.registerUser(event.user.email, event.user.password);
        // await _userCollection.setUserInfo(event.user);
        yield UserCreated();
      } catch (e) {
        print(e.toString());
        yield RegisterWithError(e.toString());
      }
    }
  }
}
