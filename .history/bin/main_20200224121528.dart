import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

void main() {
  menu();
}

void menu() {
  print('###################### Início ######################');
  print('\nSelecione uma das opções abaixo');

  print('1 - Ver cotação de hoje');

  //? Armazenando opção escolhida pelo usuário através do teclado
  String option = stdin.readLineSync();

  // Tomando uma decisão de acordo com o que o usuário escolher
  switch (int.parse(option)) {
    case 1:
      today();
      break;

    default:
      print('\nOps... Opção inválida. Selecione uma opção válida!');
      menu();
      break;
  }
}

// Retorna a cotação do dia de hoje
today() async {
  //* Buscando e armazenando os dados da api na variavel data
  var data = await getData();

  //* Exibindo os dados da api
  print('\n\n###################### HG Brasil ######################');
  print('${data['date']} -> ${data['data']}');
}

Future getData() async {
  // Link da api que será acessada
  String url = 'https://api.hgbrasil.com/finance?key=28a5a045';

  // Solicitando uma resposta
  http.Response response = await http.get(url);

  // Verificando se a reposta foi recebida com sucesso
  if (response.statusCode == 200) {
    var data = json.decode(response.body)['results']['currencies'];

    print(data);
  }
}
