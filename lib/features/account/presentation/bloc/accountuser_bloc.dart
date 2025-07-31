// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bankapp3/features/account/data/datasource/accountlocaldatasource.dart';
import 'package:bankapp3/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:bloc/bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

import 'package:bankapp3/features/account/domain/entities/useraccount.dart';
import 'package:bankapp3/features/account/domain/usecases/change_email_usecase.dart';
import 'package:bankapp3/features/account/domain/usecases/change_name_usecase.dart';
import 'package:bankapp3/features/account/domain/usecases/change_numer_usecas.dart';
import 'package:bankapp3/features/account/domain/usecases/charge_another_account.dart';
import 'package:bankapp3/features/account/domain/usecases/getinfo_usecas.dart';

part 'accountuser_event.dart';
part 'accountuser_state.dart';

class AccountuserBloc extends Bloc<AccountuserEvent, AccountuserState> {
  final ChangeEmail changeEmail;
  final ChangeName changeName;
  final ChangeNumber changeNumber;
  final ChargeAnotherAcoount chargeAnotherAcoount;
  final GetInfo getInfo;
  final AuthLocalDataSource localDataSource;
  final Accountlocaldatasource localDataSourceAccount;

  AccountuserBloc(
    this.changeEmail,
    this.changeName,
    this.changeNumber,
    this.chargeAnotherAcoount,
    this.getInfo,
    this.localDataSource,
    this.localDataSourceAccount,
  ) : super(AccountuserInitial()) {
    on<GetAccountInfoEvent>(_getAccountInfoEvent);
    on<ChangeEmailEvent>(_changeEmailEvent);
    on<ChangeNameEvent>(_changeNameEvent);
    on<ChangeNumberEvent>(_changeNumberEvent);
    on<ChargeAmountEvent>(_chargeAmountEvent);
  }

  Future<void> _getAccountInfoEvent(
    GetAccountInfoEvent event,
    Emitter<AccountuserState> emit,
  ) async {
    emit(AccountLoading());

    try {
      // هنا نستخدم التابع القديم للحصول على userId كـ String
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

  Future<void> _changeEmailEvent(
    ChangeEmailEvent event,
    Emitter<AccountuserState> emit,
  ) async {
    emit(AccountLoading());

    final result = await changeEmail.execute(email: event.newEmail);

    result.fold(
      (error) => emit(AccountError(error)),
      (message) => emit(AccountUpdated(message)),
    );
  }

  Future<void> _changeNameEvent(
    ChangeNameEvent event,
    Emitter<AccountuserState> emit,
  ) async {
    emit(AccountLoading());

    final result = await changeName.execute(name: event.newName);

    result.fold(
      (error) => emit(AccountError(error)),
      (message) => emit(AccountUpdated(message)),
    );
  }

  Future<void> _changeNumberEvent(
    ChangeNumberEvent event,
    Emitter<AccountuserState> emit,
  ) async {
    emit(AccountLoading());

    final result = await changeNumber.execute(number: event.newNumber);

    result.fold(
      (error) => emit(AccountError(error)),
      (message) => emit(AccountUpdated(message)),
    );
  }

  Future<void> _chargeAmountEvent(
    ChargeAmountEvent event,
    Emitter<AccountuserState> emit,
  ) async {
    emit(AccountLoading());

    try {
      // جلب رقم البطاقة باستخدام التابع القديم getCardNumber()
      final senderCardNumber = await localDataSourceAccount.getCardNumber();

      if (senderCardNumber == null || senderCardNumber.isEmpty) {
        emit(AccountError('رقم البطاقة غير موجود في التخزين المحلي'));
        return;
      }

      final result = await chargeAnotherAcoount.execute(
        accountNumer1: senderCardNumber,
        accountNumer2: event.receiverCardNumber,
        amount: event.amount,
      );

      result.fold(
        (error) => emit(AccountError(error)),
        (message) => emit(ChargeSuccess(message)),
      );
    } catch (e) {
      emit(AccountError('حدث خطأ أثناء التحويل: ${e.toString()}'));
    }
  }
}
