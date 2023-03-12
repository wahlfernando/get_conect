import 'dart:developer';

import 'package:get/get.dart';
import 'package:get_conect_exemple/models/user_model.dart';

// Usado como base o json_rest_server para testes de conexão e autenticação
// ==>  https://pub.dev/packages/json_rest_server   <==

class UserRepository {
  final restClient = GetConnect(timeout: const Duration(milliseconds: 600));

  UserRepository() {
    restClient.httpClient.baseUrl = 'http://192.168.1.11:8080';
    restClient.httpClient.errorSafety = false;

    restClient.httpClient.addRequestModifier<Object?>(
      (request) {
        // addRequestModifier metodo que faz com ue seja chamado toda vez que um request esta sendo chamado
        // pod ser feito alguma lógica de operação.
        log('Url que está sendo chamado ${request.url.toString()}');
        request.headers['start-time'] = DateTime.now().toIso8601String();
        return request;
      },
    );

    var total = 0;
    // autenticador: vai tentar 3 vezes para a conexão com o backend
    // ==> apenas usando como exemplo fixos para demostração do GetConnect()
    restClient.httpClient.addAuthenticator<Object?>((request) async {
      log('Sendo chamaod o addAuthenticator!!');
      total++;
      const email = 'wahlfernando@yahoo.com.br';
      final password = (total == 3 ? '132' : 'hdhdhdhdhdhdhdhd');

      final result = await restClient
          .post('/auth', {"email": email, "password": password});

      if (!result.hasError) {
        final accessToken = result.body['access_token'];
        final type = result.body['type'];

        if (accessToken != null) {
          request.headers['authorization'] = '$type $accessToken';
        } else {
          log('');
        }
      }

      return request;
    });

    restClient.httpClient.addResponseModifier((request, response) {
      response.headers?['end-time'] = DateTime.now().toIso8601String();
      return response;
    });
  }

  Future<List<UserModel>> findAll() async {
    final result = await restClient.get('/users');

    if (result.hasError) {
      throw Exception('erro ao buscar usuário: ${result.statusText}');
    }

    // logs de acompanhamento de empo de tratativa do evendo de _findAll(),
    // server para que possamos acompanhar ou até mndar essas informações para o back e poder melhorar o retorno.
    log(result.request?.headers['start-time'] ?? '');
    log(result.headers?['end-time'] ?? '');

    return result.body
        .map<UserModel>((user) => UserModel.fromMap(user))
        .toList();
  }

  Future<void> save(UserModel user) async {
    final result = await restClient.post('/users', user.toMap());

    if (result.hasError) {
      throw Exception('erro ao salvar usuário: ${result.statusText}');
    }
  }

  Future<void> deleteUser(UserModel user) async {
    final result = await restClient.delete('/users/${user.id}');

    if (result.hasError) {
      throw Exception('erro ao deletar usuário: ${result.statusText}');
    }
  }

  Future<void> updateUser(UserModel user) async {
    final result = await restClient.put('/users/${user.id}', user.toMap());

    if (result.hasError) {
      throw Exception('erro ao atualizar usuário: ${result.statusText}');
    }
  }
}
