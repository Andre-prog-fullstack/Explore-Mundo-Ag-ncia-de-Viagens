import 'package:flutter/material.dart';

void main() => runApp(const ExploreMundoApp());

class ExploreMundoApp extends StatelessWidget {
  const ExploreMundoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Explore Mundo - Agência de Viagens',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  int _currentBannerIndex = 0;

  // Função helper para carregar imagens (local ou internet)
  Widget _carregarImagem(Map<String, dynamic> destino, {
    required double height,
    BoxFit fit = BoxFit.cover,
  }) {
    final isLocal = destino['tipo'] == 'local';

    if (isLocal) {
      return Image.asset(
        destino['imagem'],
        height: height,
        width: double.infinity,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return _buildFallbackImage(destino, height);
        },
      );
    } else {
      return Image.network(
        destino['imagem'],
        height: height,
        width: double.infinity,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return _buildFallbackImage(destino, height);
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: height,
            color: Colors.grey[200],
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      );
    }
  }

  Widget _buildFallbackImage(Map<String, dynamic> destino, double height) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            destino['cor'] ?? Colors.blue,
            (destino['cor'] ?? Colors.blue).withOpacity(0.7),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_on,
              size: 50,
              color: Colors.white.withOpacity(0.9),
            ),
            const SizedBox(height: 10),
            Text(
              destino['nome'],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Lista de destinos - USANDO IMAGENS LOCAIS
  final List<Map<String, dynamic>> _destinos = [
    {
      'nome': 'Paris, França',
      'descricao': 'A cidade do amor e da luz',
      'imagem': 'assets/images/paris.jpg',  // ✅ Nome correto
      'avaliacao': 5,
      'preco': 'R\$ 4.500',
      'cor': Colors.blue,
      'tipo': 'local', // Indica imagem local
    },
    {
      'nome': 'Maldivas',
      'descricao': 'Paraíso tropical com águas cristalinas',
      'imagem': 'assets/images/maldivas.jpg',  // ✅ Nome correto
      'avaliacao': 5,
      'preco': 'R\$ 8.900',
      'cor': Colors.cyan,
      'tipo': 'local',
    },
    {
      'nome': 'Tóquio, Japão',
      'descricao': 'Tradição e modernidade em harmonia',
      'imagem': 'assets/images/toquio.jpg',  // ✅ CORRIGIDO: era toquio.jpg, agora é japao.jpg
      'avaliacao': 4,
      'preco': 'R\$ 6.200',
      'cor': Colors.purple,
      'tipo': 'local',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Explore Mundo',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => _mostrarMenu(context),
          ),
        ],
      ),
      body: ListView(
        children: [
          // Banner de Destaque (Slideshow)
          _buildBannerDestaque(),

          // Barra de Pesquisa Rápida
          _buildBarraPesquisa(),

          // Título dos Destinos
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Destinos Populares',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Lista de Destinos
          ..._destinos.map((destino) => _buildDestinoCard(context, destino)),

          // Seção Sobre Nós
          _buildSobreNos(),

          // Seção de Contato
          _buildSecaoContato(),

          const SizedBox(height: 20),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _mostrarFormularioReserva(context),
        backgroundColor: Colors.orange,
        icon: const Icon(Icons.flight_takeoff),
        label: const Text('Fazer Reserva'),
      ),
    );
  }

  // Banner de Destaque com imagens dos destinos
  Widget _buildBannerDestaque() {
    final destino = _destinos[_currentBannerIndex];

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetalhesDestinoPage(destino: destino),
          ),
        );
      },
      child: Stack(
        children: [
          // Imagem (local ou da internet)
          _carregarImagem(destino, height: 250),

          // Gradiente sobre a imagem
          Container(
            height: 250,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),

          // Texto sobre a imagem
          Positioned(
            bottom: 60,
            left: 20,
            right: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  destino['nome'],
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        offset: Offset(2, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  destino['descricao'],
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        offset: Offset(1, 1),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Botões de navegação
          Positioned(
            bottom: 10,
            right: 10,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        _currentBannerIndex = (_currentBannerIndex - 1) % _destinos.length;
                        if (_currentBannerIndex < 0) _currentBannerIndex = _destinos.length - 1;
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        _currentBannerIndex = (_currentBannerIndex + 1) % _destinos.length;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          // Indicador de posição
          Positioned(
            bottom: 20,
            left: 20,
            child: Row(
              children: List.generate(
                _destinos.length,
                    (index) => Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentBannerIndex == index
                        ? Colors.white
                        : Colors.white.withOpacity(0.4),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Barra de Pesquisa
  Widget _buildBarraPesquisa() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: '🔎 Pesquisar destinos...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          filled: true,
          fillColor: Colors.grey[100],
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
            },
          ),
        ),
        onSubmitted: (valor) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Buscando por: $valor')),
          );
        },
      ),
    );
  }

  // Card de Destino
  Widget _buildDestinoCard(BuildContext context, Map<String, dynamic> destino) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetalhesDestinoPage(destino: destino),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem ou container colorido
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              child: _carregarImagem(destino, height: 180),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          destino['nome'],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        children: List.generate(
                          5,
                              (index) => Icon(
                            index < destino['avaliacao']
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    destino['descricao'],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'A partir de ${destino['preco']}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => _mostrarFormularioReserva(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                        ),
                        child: const Text('Reservar'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Seção Sobre Nós
  Widget _buildSobreNos() {
    return Container(
      padding: const EdgeInsets.all(32),
      color: Colors.blue[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sobre a Explore Mundo',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Somos uma agência de viagens dedicada a proporcionar experiências inesquecíveis. Com mais de 15 anos de experiência, levamos você aos destinos mais incríveis do mundo com segurança, conforto e os melhores preços.',
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatCard('500+', 'Destinos'),
              _buildStatCard('10k+', 'Clientes'),
              _buildStatCard('15+', 'Anos'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String numero, String label) {
    return Column(
      children: [
        Text(
          numero,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }

  // Seção de Contato
  Widget _buildSecaoContato() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Entre em Contato',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(Icons.phone, color: Colors.blue),
            title: const Text('(31) 3456-7890'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Ligando...')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.email, color: Colors.blue),
            title: const Text('contato@exploremundo.com.br'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Abrindo e-mail...')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.location_on, color: Colors.blue),
            title: const Text('Av. Um, 175 - Santa Luzia, MG'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Abrindo mapa...')),
              );
            },
          ),
        ],
      ),
    );
  }

  // Menu de Navegação
  void _mostrarMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.flight_takeoff),
              title: const Text('Destinos'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.card_travel),
              title: const Text('Pacotes de Viagem'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Abrindo Pacotes de Viagem')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.contact_phone),
              title: const Text('Contato'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Abrindo Contato')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Sobre Nós'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Abrindo Sobre Nós')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Formulário de Reserva
  void _mostrarFormularioReserva(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Fazer Reserva'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Nome Completo',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Telefone',
                  prefixIcon: Icon(Icons.phone),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Destino Desejado',
                  prefixIcon: Icon(Icons.location_on),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Reserva enviada com sucesso!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Enviar'),
          ),
        ],
      ),
    );
  }
}

// ==================== PÁGINA DE DETALHES DO DESTINO ====================
class DetalhesDestinoPage extends StatelessWidget {
  final Map<String, dynamic> destino;

  const DetalhesDestinoPage({super.key, required this.destino});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                destino['nome'],
                style: const TextStyle(
                  shadows: [
                    Shadow(color: Colors.black, offset: Offset(1, 1), blurRadius: 3),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Container colorido de fundo
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          destino['cor'] ?? Colors.blue,
                          (destino['cor'] ?? Colors.blue).withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                  // Imagem
                  Image.network(
                    destino['imagem'],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              destino['cor'] ?? Colors.blue,
                              (destino['cor'] ?? Colors.blue).withOpacity(0.7),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.flight_takeoff,
                            size: 100,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                      );
                    },
                  ),
                  // Gradiente
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.5),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: List.generate(
                          5,
                              (index) => Icon(
                            index < destino['avaliacao']
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 30,
                          ),
                        ),
                      ),
                      Text(
                        destino['preco'],
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Sobre o Destino',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    destino['descricao'],
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'O que está incluído:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _buildInclusoItem('Passagem aérea ida e volta'),
                  _buildInclusoItem('Hospedagem em hotel 5 estrelas'),
                  _buildInclusoItem('Café da manhã incluído'),
                  _buildInclusoItem('Transfers aeroporto-hotel'),
                  _buildInclusoItem('Seguro viagem'),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Reserva iniciada!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(Icons.flight_takeoff),
                      label: const Text(
                        'Reservar Agora',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInclusoItem(String texto) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 20),
          const SizedBox(width: 10),
          Text(texto, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}