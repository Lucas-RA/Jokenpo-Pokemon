import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(PokemonJokenpoApp());
}

class PokemonJokenpoApp extends StatelessWidget {
  const PokemonJokenpoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: JoKenPokemonScreen(),
    );
  }
}

class Pokemon {
  final String name;
  final String imagePath;

  Pokemon({required this.name, required this.imagePath});
}

// final pokemons = [
//   Pokemon(name: "Bulbassaur", imagePath: "images/bulbassaur.png"),
//   Pokemon(name: "Charmander", imagePath: "images/charmander.png"),
//   Pokemon(name: "Squirtle", imagePath: "images/squirtle.png"),
// ];

class JoKenPokemonScreen extends StatefulWidget {
  const JoKenPokemonScreen({super.key});
  @override
  State<JoKenPokemonScreen> createState() => _JoKenPokemonScreenState();
}

class _JoKenPokemonScreenState extends State<JoKenPokemonScreen> {
  final List<Pokemon> pokemons = [
    Pokemon(name: 'Charmander', imagePath: 'images/charmander.png'),
    Pokemon(name: 'Bulbassaur', imagePath: 'images/bulbassaur.png'),
    Pokemon(name: 'Squirtle', imagePath: 'images/squirtle.png'),
  ];

  Pokemon? playerChoice;
  Pokemon? computerChoice;
  String result = '';

  void _play(Pokemon selected) {
    final random = Random();
    final compChoice = pokemons[random.nextInt(pokemons.length)];

    String battleResult;

    if (selected.name == compChoice.name) {
      battleResult = 'Empate!';
    } else if ((selected.name == 'Charmander' &&
            compChoice.name == 'Bulbassaur') ||
        (selected.name == 'Bulbassaur' && compChoice.name == 'Squirtle') ||
        (selected.name == 'Squirtle' && compChoice.name == 'Charmander')) {
      battleResult = 'Você Venceu!';
    } else {
      battleResult = 'Você Perdeu!';
    }
    setState(() {
      playerChoice = selected;
      computerChoice = compChoice;
      result = battleResult;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      body: SafeArea(
        child: Column(
          children: [
            PokemonHeader(),
            Expanded(
              child: BattleArena(
                result: result,
                playerPokemon: playerChoice,
                enemyPokemon: computerChoice,
              ),
            ),
            PokemonFooter(
              pokemons: pokemons,
              playerChoice: playerChoice,
              onSelected: _play,
            ),
          ],
        ),
      ),
    );
  }
}


class PokemonFooter extends StatelessWidget {
  const PokemonFooter({
    super.key,
    required this.pokemons,
    this.playerChoice,
    required this.onSelected,
  });

  final List<Pokemon> pokemons;
  final Pokemon? playerChoice;
  final Function(Pokemon) onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Faça sua jogada de mestre",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Row(
            children: pokemons.map((p) {
              return Expanded(
                child: PokemonOption(
                  selected: playerChoice == p,
                  pokemon: p,
                  onSelected: (pokemon) => onSelected(p),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class PokemonLogo extends StatelessWidget {
  const PokemonLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Image.asset('images/logo_pokemon.png', height: 200),
    );
  }
}

class PokemonHeader extends StatelessWidget {
  const PokemonHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PokemonLogo(),
        // Text("")
      ],
    );
  }
}

class PokemonCard extends StatelessWidget {
  const PokemonCard({
    super.key,
    required this.pokemon,
    required this.playerName,
    required this.mirror,
  });

  final Pokemon? pokemon;
  final String playerName;
  final bool mirror;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          flex: 3,
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(mirror ? 3.14159 : 0),
            child: Image.asset(pokemon!.imagePath, fit: BoxFit.contain),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          pokemon!.name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(playerName),
      ],
    );
  }
}

class BattleEmptyState extends StatelessWidget {
  const BattleEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.catching_pokemon, size: 80, color: Colors.red),
          SizedBox(height: 16),
          Text(
            "Escolha seu Pokemon para iniciar a batalha!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class BattleResult extends StatelessWidget {
  final String result;

  const BattleResult({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        result,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.red,
        ),
      ),
    );
  }
}

class BattleView extends StatelessWidget {
  const BattleView({
    super.key,
    required this.playerPokemon,
    required this.enemyPokemon,
    required this.result,
  });

  final Pokemon playerPokemon;
  final Pokemon? enemyPokemon;
  final String result;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: PokemonCard(
                  pokemon: playerPokemon,
                  playerName: "Jogador",
                  mirror: false,
                ),
              ),
              Expanded(
                child: PokemonCard(
                  pokemon: enemyPokemon,
                  playerName: "Computador",
                  mirror: true,
                ),
              ),
            ],
          ),
        ),
        BattleResult(result: result),
      ],
    );
  }
}

class BattleArena extends StatelessWidget {
  const BattleArena({
    super.key,
    required this.playerPokemon,
    required this.enemyPokemon,
    required this.result,
  });

  final Pokemon? playerPokemon;
  final Pokemon? enemyPokemon;
  final String result;

  @override
  Widget build(BuildContext context) {
    if (playerPokemon == null) {
      return const BattleEmptyState();
    }

    return BattleView(
      playerPokemon: playerPokemon!,
      enemyPokemon: enemyPokemon,
      result: result,
    );
  }
}

class PokemonOption extends StatelessWidget {
  final bool selected;
  final Pokemon pokemon;
  final Function(Pokemon) onSelected;

  const PokemonOption({
    super.key,
    required this.selected,
    required this.pokemon,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSelected(pokemon),
      child: Column(
        children: [
          Image.asset(
            selected
                ? "images/pokeball_selected.png"
                : "images/pokeball_unselected.png",
            width: 40,
            height: 40,
          ),
          const SizedBox(height: 4),
          Text(pokemon.name, style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}
