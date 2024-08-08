import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //Variavel para exibir o cep
  String resultado = '';

  TextEditingController txtcep = TextEditingController();

  void buscacep() async {
    // 1 passo - recuperar/pegar o cep do txt
    String cep = txtcep.text.replaceAll("-", "");

    // 2 passo - Definir a URL da API
    String url = "https://viacep.com.br/ws/$cep/json/";

    // 3 passo - criar varial para armazenar a resposta da req
    http.Response response;

    //4 passo efetuar a requisição para a URL pelo metodo get

    //sincrona -> Faz a quesição e ja tem resposta direta
    //Assincrona -> Demora um tempo para o retorno

    // await - > Tem tempo de resposta
    response = await http.get(Uri.parse(url));

    //Exibindo resultados no console
    print("Resposta " + response.body);

    //exibindo o status da consukta
    print("StatusCode" + response.statusCode.toString());

    //convertendo o resultado para exibir na tela
    Map<String, dynamic> dados = json.decode(response.body);

    String logradouro = dados["logradouro"];
    String bairro = dados["bairro"];
    String localidade = dados["localidade"];
    String uf = dados["uf"];
    String ibge = dados["ibge"];
    String ddd = dados["ddd"];

    String endereco =
        " $logradouro,\n Bairro: $bairro,\n Cidade: $localidade,\n Estado: $uf,\n Codigo IBGE: $ibge,\n DDD: $ddd ";

    setState(() {
      resultado = endereco;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consultando Cep na Web'),
        backgroundColor: Color.fromARGB(143, 226, 45, 45),
      ),
      body: Container(
        padding: const EdgeInsets.all(40),
        child: Center(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 40),
              TextField(
                controller: txtcep,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: 'Digite um cep: (ex: 00000-000)'),
                style: const TextStyle(fontSize: 20, color: Colors.blueAccent),
              ),

              ///Espaço entre o botão
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: buscacep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 4, 240, 12),
                ),
                child: const Text(
                  'Consultar',
                  style: const TextStyle(fontSize: 20, color: Colors.black),
                ),
              ),
              const SizedBox(height: 40),
              Text(
                resultado,
                style: const TextStyle(
                    fontSize: 20 // Aumentando o tamanho da fonte
                    ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
