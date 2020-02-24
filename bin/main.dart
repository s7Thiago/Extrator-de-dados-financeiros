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
  print('2 - Registrar a cotação de hoje');

  //? Armazenando opção escolhida pelo usuário através do teclado
  String option = stdin.readLineSync();

  // Tomando uma decisão de acordo com o que o usuário escolher
  switch (int.parse(option)) {
    case 1:
      today();
      break;

    case 2:
      registerData();
      break;

    default:
      print('\nOps... Opção inválida. Selecione uma opção válida!');
      menu();
      break;
  }
}

// Grava os dados da API, caso os atuais estejam desatualizados (de dias anteriores), ou não existam
registerData() async {
  var hgData = await getData();
  dynamic fileData = readFile();

//  Se o arquivo tiver algo salvo, transforma em um objeto a partir do json, se não, retorna uma lista vazia.
  fileData = (fileData != null && fileData.length > 0? json.decode(fileData) : List());

  bool fileExists = false;

  fileData.forEach((ocurrencies){

    print(ocurrencies['date']);

    if(ocurrencies['date'] == now())
      fileExists = true;
  });

  if(!fileExists) {
    fileData.add({"date": now(), "data": "${hgData['data']}"});

//    Preparando para salvar o arquivo
  Directory dir = Directory.current;
  File file = File(dir.path + '/dadosMoedas.txt');
  RandomAccessFile raf = file.openSync(mode: FileMode.write);

  raf.writeStringSync(json.encode(fileData).toString());
  raf.flushSync();
  raf.closeSync();

  print('######################## Dados Salvos Com Sucesso!!! ########################');
  } else {
    print('######################## Registro não adicionado. Já existem dados de hoje no arquivo ########################');
  }
}

// Retorna uma String com o conteúdo do arquivo de dados
String readFile() {
  Directory dir = Directory.current;
  File file = File(dir.path + '/dadosMoedas.txt');

  if(!file.existsSync()) {
    print('Arquivo ${file.path.split('\\')[file.path.split('\\').length - 1]} não encontrado');
  }

  return file.readAsStringSync();
}

// Retorna a cotação do dia de hoje
today() async {
  //* Buscando e armazenando os dados da api na variavel data
  var data = await getData();

  //* Exibindo os dados da api
  print('\n\n###################### HG Brasil ######################');
  print('${data['date']} -> ${data['data']}');
}

// Acessa a api da HG Brasil para e extrai os dados das cotações
Future getData() async {
  // Link da api que será acessada
  String url = 'https://api.hgbrasil.com/finance?key=28a5a045';

  // Solicitando uma resposta
  http.Response response = await http.get(url);

  // Verificando se a reposta foi recebida com sucesso
  if (response.statusCode == 200) {
//    Pegando  todos os dados no objeto currencies em results
    var data = json.decode(response.body)['results']['currencies'];

//  Pegando separadamente os dados de cada moeda:
    var usd = data['USD'];
    var eur = data['EUR'];
    var gbp = data['GBP'];
    var ars = data['ARS'];
    var btc = data['BTC'];

//  Colocando os dados das moedas em um Map
    Map formatedMap = Map();
    formatedMap['date'] = now();
    formatedMap['data'] =
        '${usd['name']} : ${usd['buy']} | '
        '${eur['name']} : ${eur['buy']} |'
        '${gbp['name']} : ${gbp['buy']} |'
        '${ars['name']} : ${ars['buy']} |'
        '${btc['name']} : ${btc['buy']} |';

    return formatedMap;
  } else {
    throw ('Falha!');
  }
}

// Retorna a data atual formatada
now(){
  var now = DateTime.now();
  return '${now.day.toString().padLeft(2, '0')}/${now.month.toString().toString().padLeft(2, '0')}/${now.year.toString().padLeft(2, '0')}';
}
