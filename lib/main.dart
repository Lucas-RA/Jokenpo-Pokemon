// Biblioteca matemática do Dart.
// Usada aqui para gerar números aleatórios (escolha do computador)
import 'dart:math';

// Biblioteca principal do Flutter com os widgets de interface
import 'package:flutter/material.dart';

// Função principal do aplicativo Flutter
// Todo app começa por aqui
void main() {
  // Inicializa o aplicativo chamando o widget principal
  runApp(PokemonJokenpoApp());
}

// Widget raiz do aplicativo
// Stateless porque não possui estado que muda
class PokemonJokenpoApp extends StatelessWidget {
  const PokemonJokenpoApp({super.key});

  // Método responsável por construir a interface
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Remove a faixa DEBUG do canto da tela
      debugShowCheckedModeBanner: false,

      // Define o tema do aplicativo
      theme: ThemeData(useMaterial3: true),

      // Define a tela inicial do aplicativo
      home: JoKenPokemonScreen(),
    );
  }
}

// Classe modelo que representa um Pokémon
// Usada para armazenar nome e imagem
class Pokemon {
  // Nome do Pokémon
  final String name;

  // Caminho da imagem do Pokémon
  final String imagePath;

  // Construtor que exige nome e imagem
  Pokemon({required this.name, required this.imagePath});
}

// Widget principal da tela do jogo
// Stateful porque o estado muda durante a partida
class JoKenPokemonScreen extends StatefulWidget {
  const JoKenPokemonScreen({super.key});

  @override
  State<JoKenPokemonScreen> createState() => _JoKenPokemonScreenState();
}

// Classe que controla o estado da tela
class _JoKenPokemonScreenState extends State<JoKenPokemonScreen> {
  // Lista com os Pokémons disponíveis no jogo
  final List<Pokemon> pokemons = [
    Pokemon(name: 'Charmander', imagePath: 'images/charmander.png'),
    Pokemon(name: 'Bulbassaur', imagePath: 'images/bulbassaur.png'),
    Pokemon(name: 'Squirtle', imagePath: 'images/squirtle.png'),
  ];

  // Pokémon escolhido pelo jogador
  Pokemon? playerChoice;

  // Pokémon escolhido pelo computador
  Pokemon? computerChoice;

  // Resultado da batalha
  String result = '';

  // Método que executa a lógica da rodada
  void _play(Pokemon selected) {
    // Cria gerador de número aleatório
    final random = Random();

    // Computador escolhe um Pokémon aleatoriamente
    final compChoice = pokemons[random.nextInt(pokemons.length)];

    String battleResult;

    // Verifica empate
    if (selected.name == compChoice.name) {
      battleResult = 'Empate!';
    }
    // Condições de vitória do jogador
    else if ((selected.name == 'Charmander' &&
            compChoice.name == 'Bulbassaur') ||
        (selected.name == 'Bulbassaur' && compChoice.name == 'Squirtle') ||
        (selected.name == 'Squirtle' && compChoice.name == 'Charmander')) {
      battleResult = 'Você Venceu!';
    }
    // Caso contrário o jogador perde
    else {
      battleResult = 'Você Perdeu!';
    }

    // Atualiza o estado da interface
    // Sempre que setState é chamado a tela é redesenhada
    setState(() {
      playerChoice = selected;
      computerChoice = compChoice;
      result = battleResult;
    });
  }

  // Método responsável por construir a interface da tela
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Cor de fundo da tela
      backgroundColor: Colors.orange[50],

      // SafeArea evita que elementos fiquem atrás do notch ou barra de status
      body: SafeArea(
        child: Column(
          children: [
            // Cabeçalho com a logo do Pokémon
            PokemonHeader(),

            // Área principal da batalha
            Expanded(
              child: BattleArena(
                result: result,
                playerPokemon: playerChoice,
                enemyPokemon: computerChoice,
              ),
            ),

            // Rodapé com os botões de escolha
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

// Widget responsável pelo rodapé com as opções de Pokémon
class PokemonFooter extends StatelessWidget {
  const PokemonFooter({
    super.key,
    required this.pokemons,
    this.playerChoice,
    required this.onSelected,
  });

  // Lista de Pokémons disponíveis
  final List<Pokemon> pokemons;

  // Pokémon escolhido pelo jogador
  final Pokemon? playerChoice;

  // Função que será chamada ao selecionar um Pokémon
  final Function(Pokemon) onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Espaçamento interno
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Texto do rodapé
          const Text(
            "Faça sua jogada de mestre",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // Linha com as opções de Pokémon
          Row(
            children: pokemons.map((p) {
              // Para cada Pokémon cria um botão
              return Expanded(
                child: PokemonOption(
                  // Verifica se o Pokémon está selecionado
                  selected: playerChoice == p,

                  // Pokémon da opção
                  pokemon: p,

                  // Função executada ao clicar
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

// Widget que exibe a logo do Pokémon no topo da tela
class PokemonLogo extends StatelessWidget {
  const PokemonLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Espaçamento lateral
      padding: const EdgeInsets.symmetric(horizontal: 32.0),

      // Carrega a imagem da logo
      child: Image.asset('images/logo_pokemon.png', height: 200),
    );
  }
}

// Widget do cabeçalho da aplicação
class PokemonHeader extends StatelessWidget {
  const PokemonHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Exibe a logo
        PokemonLogo(),

        // Espaço para futuros elementos
        // Text("")
      ],
    );
  }
}

// Card que exibe o Pokémon na batalha
class PokemonCard extends StatelessWidget {
  const PokemonCard({
    super.key,
    required this.pokemon,
    required this.playerName,
    required this.mirror,
  });

  // Pokémon exibido
  final Pokemon? pokemon;

  // Nome do jogador (Jogador ou Computador)
  final String playerName;

  // Define se a imagem será espelhada
  final bool mirror;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Área da imagem
        Flexible(
          flex: 3,
          child: Transform(
            // Centraliza a transformação
            alignment: Alignment.center,

            // Espelha a imagem se mirror for true
            transform: Matrix4.rotationY(mirror ? 3.14159 : 0),

            // Carrega imagem do Pokémon
            child: Image.asset(pokemon!.imagePath, fit: BoxFit.contain),
          ),
        ),

        const SizedBox(height: 4),

        // Nome do Pokémon
        Text(
          pokemon!.name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),

        // Nome do jogador
        Text(playerName),
      ],
    );
  }
}

// Tela exibida antes de iniciar a batalha
class BattleEmptyState extends StatelessWidget {
  const BattleEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Ícone de pokebola
          Icon(Icons.catching_pokemon, size: 80, color: Colors.red),

          SizedBox(height: 16),

          // Mensagem inicial
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

// Widget que mostra o resultado da batalha
class BattleResult extends StatelessWidget {
  final String result;

  const BattleResult({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Espaçamento vertical
      padding: const EdgeInsets.symmetric(vertical: 12),

      child: Text(
        result,

        // Estilo do texto do resultado
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.red,
        ),
      ),
    );
  }
}

// Widget que exibe a batalha
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
        // Área dos Pokémons
        Expanded(
          child: Row(
            children: [
              // Pokémon do jogador
              Expanded(
                child: PokemonCard(
                  pokemon: playerPokemon,
                  playerName: "Jogador",
                  mirror: false,
                ),
              ),

              // Pokémon do computador
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

        // Resultado da batalha
        BattleResult(result: result),
      ],
    );
  }
}

// Widget que decide se mostra a tela inicial ou a batalha
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
    // Se o jogador ainda não escolheu um Pokémon
    if (playerPokemon == null) {
      return const BattleEmptyState();
    }

    // Caso contrário mostra a batalha
    return BattleView(
      playerPokemon: playerPokemon!,
      enemyPokemon: enemyPokemon,
      result: result,
    );
  }
}

// Widget que representa o botão de escolha de Pokémon
class PokemonOption extends StatelessWidget {
  // Indica se o Pokémon está selecionado
  final bool selected;

  // Pokémon da opção
  final Pokemon pokemon;

  // Função executada ao clicar
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
      // Detecta clique do usuário
      onTap: () => onSelected(pokemon),

      child: Column(
        children: [
          // Imagem da pokebola (selecionada ou não)
          Image.asset(
            selected
                ? "images/pokeball_selected.png"
                : "images/pokeball_unselected.png",
            width: 40,
            height: 40,
          ),

          const SizedBox(height: 4),

          // Nome do Pokémon
          Text(pokemon.name, style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}
