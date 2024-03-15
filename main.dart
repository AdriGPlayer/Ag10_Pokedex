import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class Pokemon {
  final String name;
  final String type;
  final String category;
  final String image;
  final String description;
  final List<String> abilities;
  final List<String> weaknesses;

  Pokemon({
    required this.name,
    required this.type,
    required this.category,
    required this.image,
    required this.description,
    required this.abilities,
    required this.weaknesses,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      name: json['name'],
      type: json['type'],
      category: json['category'],
      image: json['image'],
      description: json['description'],
      abilities: List<String>.from(json['abilities']),
      weaknesses: List<String>.from(json['weaknesses']),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokémon App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PokemonListScreen(),
    );
  }
}

class PokemonListScreen extends StatefulWidget {
  @override
  _PokemonListScreenState createState() => _PokemonListScreenState();
}

class _PokemonListScreenState extends State<PokemonListScreen> {
  late List<Pokemon> pokemons = [];

  @override
  void initState() {
    super.initState();
    loadPokemons();
  }

  Future<String> _loadPokemonAsset() async {
    return await rootBundle.loadString('assets_json/pokemon_data.json');
  }

  Future loadPokemons() async {
    String jsonString = await _loadPokemonAsset();
    final jsonResponse = json.decode(jsonString);
    setState(() {
      pokemons =
          jsonResponse.map<Pokemon>((data) => Pokemon.fromJson(data)).toList();
    });
  }

  void _showPokemonDetails(BuildContext context, Pokemon pokemon) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(pokemon.name),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tipo: ${pokemon.type}'),
                Text('Categoría: ${pokemon.category}'),
                Text('Descripción: ${pokemon.description}'),
                Text('Habilidades: ${pokemon.abilities.join(', ')}'),
                Text('Debilidades: ${pokemon.weaknesses.join(', ')}'),
                Image.asset(
                  pokemon.image,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pokémon'),
      ),
      body: pokemons.isNotEmpty
          ? ListView.builder(
              itemCount: pokemons.length,
              itemBuilder: (context, index) {
                final pokemon = pokemons[index];
                return ListTile(
                  title: Text(pokemon.name),
                  onTap: () => _showPokemonDetails(context, pokemon),
                );
              },
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}

