// home_controller
import 'dart:developer';

import 'package:get/get.dart';
import 'package:get_conect_exemple/models/user_model.dart';
import 'package:get_conect_exemple/repositories/user_repository.dart';

class HomeController extends GetxController with StateMixin<List<UserModel>> {
  final UserRepository _repository;

  @override
  onReady() {
    _findAll();
    super.onReady();
  }

  HomeController({required UserRepository repository})
      : _repository = repository;

  _findAll() async {
    try {
      change([], status: RxStatus.loading());

      final users = await _repository.findAll();

      var statusReturn = RxStatus.success();

      if (users.isEmpty) {
        statusReturn = RxStatus.empty();
      }

      change(users, status: statusReturn);
    } on Exception catch (e, s) {
      log('Erro ao buscar Usuário.', error: e, stackTrace: s);
      change(state, status: RxStatus.error());
    }
  }

  Future<void> register() async {
    try {
      final user = UserModel(
        name: 'Fernando',
        email: 'fernando@faw.com',
        password: '123456',
      );
      await _repository.save(user);
      _findAll();
    } on Exception catch (e, s) {
      log('Erro ao registrar usuário', error: e, stackTrace: s);
      Get.snackbar('Erro', 'Erro ao registrar usuário');
    }
  }

  Future<void> UpdateUser(UserModel user) async {
    try {
      user.name = 'Fulano modificado';
      user.email = 'teste@modificado.com';

      await _repository.updateUser(user);

      _findAll();
    } on Exception catch (e, s) {
      log('Erro ao atualizar usuário', error: e, stackTrace: s);
      Get.snackbar('Erro', 'Erro ao atualizar usuário');
    }
  }

  Future<void> delete(UserModel user) async {
    await _repository.deleteUser(user);
    Get.snackbar('Sicesso', 'Usuário deletado com sucesso!!');

  }
}
