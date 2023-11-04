import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PokemonSearch(),
    );
  }
}

class PokemonSearch extends StatefulWidget {
  @override
  _PokemonSearchState createState() => _PokemonSearchState();
}

class _PokemonSearchState extends State<PokemonSearch> {
  String pokemonName = "";
  Map<String, dynamic> pokemonData = {};

  Future<void> fetchPokemon(String name) async {
    final response = await http.get(Uri.parse("https://pokeapi.co/api/v2/pokemon/$name"));

    if (response.statusCode == 200) {
      setState(() {
        pokemonData = json.decode(response.body);
      });
    } else {
      setState(() {
        pokemonData = {};
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PokeAPI Pokémon Search'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/pokemonbg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(16.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      pokemonName = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Introduce el nombre de un Pokémon',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  fetchPokemon(pokemonName);
                },
                child: Text('Buscar'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red, // Button background color
                  onPrimary: Colors.white, // Text color
                  padding: EdgeInsets.all(16.0),
                ),
              ),
              if (pokemonData.isNotEmpty)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Table(
                    border: TableBorder.all(),
                    children: [
                      TableRow(
                        children: [
                          TableCell(
                            child: Text('Nombre: ${pokemonData['name']}',
                                style: TextStyle(fontSize: 16.0)),
                          ),
                          TableCell(
                            child: Text('Altura: ${pokemonData['height']}',
                                style: TextStyle(fontSize: 16.0)),
                          ),
                          TableCell(
                            child: Text('Peso: ${pokemonData['weight']}',
                                style: TextStyle(fontSize: 16.0)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              if (pokemonData.isEmpty)
                Text('Pokémon no encontrado',
                    style: TextStyle(
                      color: Colors.orange, // Text color
                      fontSize: 20.0,
                    )),
            ],
          ),
        ),
      ),
    );
  }
}