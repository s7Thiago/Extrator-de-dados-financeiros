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
  }
}
