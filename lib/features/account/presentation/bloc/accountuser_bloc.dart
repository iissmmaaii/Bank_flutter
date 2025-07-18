// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:bankapp3/features/account/domain/entities/useraccount.dart';
import 'package:bankapp3/features/account/domain/usecases/change_email_usecase.dart';
import 'package:bankapp3/features/account/domain/usecases/change_name_usecase.dart';
import 'package:bankapp3/features/account/domain/usecases/change_numer_usecas.dart';
import 'package:bankapp3/features/account/domain/usecases/charge_another_account.dart';
import 'package:bankapp3/features/account/domain/usecases/getinfo_usecas.dart';
import 'package:bankapp3/features/auth/data/datasources/auth_local_datasource.dart';

part 'accountuser_event.dart';
part 'accountuser_state.dart';

class AccountuserBloc extends Bloc<AccountuserEvent, AccountuserState> {
  final ChangeEmail changeEmail;
  final ChangeName changeName;
  final ChangeNumber changeNumber;
  final ChargeAnotherAcoount chargeAnotherAcoount;
  final GetInfo getInfo;
  final AuthLocalDataSource localDataSource;

  AccountuserBloc(
    this.changeEmail,
    this.changeName,
    this.changeNumber,
    this.chargeAnotherAcoount,
    this.getInfo,
    this.localDataSource,
  ) : super(AccountuserInitial()) {
    on<GetAccountInfoEvent>(_getaccountinfoevent);
    on<ChangeEmailEvent>(_changeemailevent);
  }
  Future<void> _changeemailevent(
    ChangeEmailEvent event,
    Emitter<AccountuserState> emit,
  ) async {
    emit(AccountLoading());
  }

  Future<void> _getaccountinfoevent(
    GetAccountInfoEvent event,
    Emitter<AccountuserState> emit,
  ) async {
    emit(AccountLoading());

    try {
      final userIdString = await localDataSource.getUserId();

      if (userIdString != null && userIdString.isNotEmpty) {
        final result = await getInfo.execute(id: userIdString);
        emit(
          result.fold(
            (error) => AccountError(error),
            (userAccount) => AccountLoaded(userAccount),
          ),
        );
      } else {
        emit(AccountError('معرف المستخدم غير موجود في التخزين'));
      }
    } catch (e) {
      emit(AccountError('حدث خطأ: ${e.toString()}'));
    }
  }
}
