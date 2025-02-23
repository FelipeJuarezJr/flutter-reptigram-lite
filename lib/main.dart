import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ReptiGram Lite',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green.shade900,
          brightness: Brightness.dark,
          background: Colors.black,
          surface: Colors.black,
        ),
        scaffoldBackgroundColor: Colors.black,
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: const WelcomePage(),
    );
  }
}

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool _showSignUp = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _usernameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                'ReptiGram Lite',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B5E20),
                  shadows: [
                    Shadow(
                      color: Color(0xFF4CAF50),
                      blurRadius: 8.0,
                    ),
                    Shadow(offset: Offset(-1, -1), color: Color(0xFF0A2A0A)),
                    Shadow(offset: Offset(1, -1), color: Color(0xFF0A2A0A)),
                    Shadow(offset: Offset(1, 1), color: Color(0xFF0A2A0A)),
                    Shadow(offset: Offset(-1, 1), color: Color(0xFF0A2A0A)),
                  ],
                ),
              ),
              const Spacer(),
              if (!_showSignUp) ...[
                // Login Form
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PostPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: const Color(0xFF1B5E20),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Login'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _showSignUp = true;
                    });
                  },
                  child: const Text('Don\'t have an account? Sign up'),
                ),
              ] else ...[
                // Sign Up Form
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement sign up logic
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PostPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: const Color(0xFF1B5E20),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Sign Up'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _showSignUp = false;
                    });
                  },
                  child: const Text('Already have an account? Login'),
                ),
              ],
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class Post {
  final String content;
  final String username;
  final DateTime timestamp;
  int likes;
  int comments;

  Post({
    required this.content,
    required this.username,
    required this.timestamp,
    this.likes = 0,
    this.comments = 0,
  });
}

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final TextEditingController _postController = TextEditingController();
  final List<Post> _posts = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Add sample posts
    for (int i = 0; i < 10; i++) {
      _posts.add(Post(
        content: _getSamplePost(i),
        username: "ReptileLover${i + 1}",
        timestamp: DateTime.now().subtract(Duration(hours: i + 1)),
        likes: (i + 1) * 5,
        comments: (i + 1) * 3,
      ));
    }
  }

  void _submitPost() {
    if (_postController.text.trim().isNotEmpty) {
      setState(() {
        _posts.insert(0, Post(
          content: _postController.text,
          username: "ReptileLover", // You can customize this
          timestamp: DateTime.now(),
          likes: 0,
          comments: 0,
        ));
        _postController.clear();
      });
    }
  }

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  Widget _buildCommonNavMenu() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem('Post', 0),
            _buildNavItem('Albums', 1),
            _buildNavItem('Feed', 2),
          ],
        ),
        Container(
          width: double.infinity,
          height: 2,
          child: Stack(
            children: [
              Positioned(
                left: _selectedIndex * (MediaQuery.of(context).size.width / 3),
                width: MediaQuery.of(context).size.width / 3,
                child: Container(
                  height: 2,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        if (_selectedIndex == 2) // Only show icons for Feed Page
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.grid_on),
                  color: const Color(0xFF1B5E20),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.star),
                  color: const Color(0xFF1B5E20),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.play_circle_outline),
                  color: const Color(0xFF1B5E20),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.person_outline),
                  color: const Color(0xFF1B5E20),
                  onPressed: () {},
                ),
              ],
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget currentPage;
    switch (_selectedIndex) {
      case 0:
        currentPage = Column(
          children: [
            _buildCommonNavMenu(),
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: _postController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: "What's happening in the reptile world?",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _submitPost,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            backgroundColor: const Color(0xFF1B5E20),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Submit Post'),
                        ),
                      ],
                    ),
                  ),
                  ..._posts.map((post) => PostCard(
                    username: post.username,
                    timeAgo: _getTimeAgo(post.timestamp),
                    content: post.content,
                    likes: post.likes,
                    comments: post.comments,
                  )).toList(),
                ],
              ),
            ),
          ],
        );
        break;
      case 1:
        currentPage = Column(
          children: [
            _buildCommonNavMenu(),
            const Expanded(child: AlbumsPage()),
          ],
        );
        break;
      case 2:
        currentPage = Column(
          children: [
            _buildCommonNavMenu(),
            const Expanded(child: FeedPage()),
          ],
        );
        break;
      default:
        currentPage = const SizedBox.shrink();
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        scrolledUnderElevation: 0,
        title: const Text(
          'ReptiGram Lite',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B5E20),
            shadows: [
              Shadow(
                color: Color(0xFF4CAF50),
                blurRadius: 8.0,
              ),
              Shadow(offset: Offset(-1, -1), color: Color(0xFF0A2A0A)),
              Shadow(offset: Offset(1, -1), color: Color(0xFF0A2A0A)),
              Shadow(offset: Offset(1, 1), color: Color(0xFF0A2A0A)),
              Shadow(offset: Offset(-1, 1), color: Color(0xFF0A2A0A)),
            ],
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const WelcomePage()),
              );
            },
            child: const Text('Log Out'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: currentPage,
    );
  }

  Widget _buildNavItem(String label, int index) {
    return InkWell(
      onTap: () => setState(() => _selectedIndex = index),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: _selectedIndex == index ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  String _getSamplePost(int index) {
    final samplePosts = [
      "Just got a new baby bearded dragon! 🦎 Can't wait to watch it grow!",
      "My ball python shed perfectly today. So satisfying! 🐍✨",
      "Question: What's the best substrate for a leopard gecko? Need advice! 🦎",
      "Check out my corn snake's new terrarium setup! #ReptileCare",
      "My iguana is getting so big! Remember when she was just a baby? 🦎💚",
      "PSA: Remember to keep your heat lamps on during winter! #ReptileCare",
      "First time breeding crested geckos. Wish me luck! 🦎",
      "My tortoise absolutely destroying his lunch today 🐢 #TortoiseLove",
      "New UVB setup installed! Making sure my scaley friends get the best care.",
      "Just witnessed my gecko catch a cricket mid-air! Natural hunter! 🦎"
    ];
    return samplePosts[index];
  }
}

class PostCard extends StatelessWidget {
  final String username;
  final String timeAgo;
  final String content;
  final int likes;
  final int comments;

  const PostCard({
    super.key,
    required this.username,
    required this.timeAgo,
    required this.content,
    required this.likes,
    required this.comments,
  });

  String _getRandomReptileEmoji() {
    final reptiles = ['🦎', '🐊', '🐢', '🐍', '🦕', '🐉', '🐲'];
    return reptiles[DateTime.now().microsecond % reptiles.length];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      _getRandomReptileEmoji(),
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      timeAgo,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(content),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.favorite_border, size: 20, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text('$likes'),
                const SizedBox(width: 16),
                Icon(Icons.chat_bubble_outline, size: 20, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text('$comments'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AlbumImage {
  final String url;
  final String title;
  final DateTime createdAt;
  bool isFavorite;

  AlbumImage({
    required this.url,
    required this.title,
    required this.createdAt,
    this.isFavorite = false,
  });
}

class Album {
  final String title;
  final String description;
  final List<AlbumImage> images;
  final DateTime createdAt;

  Album({
    required this.title,
    required this.description,
    required this.images,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}

class AlbumsPage extends StatefulWidget {
  const AlbumsPage({super.key});

  @override
  State<AlbumsPage> createState() => _AlbumsPageState();
}

class _AlbumsPageState extends State<AlbumsPage> {
  Set<int> hoveredIndices = {};

  final List<Album> albums = [
    Album(
      title: 'My Bearded Dragon',
      description: 'Journey of Thor from baby to adult',
      createdAt: DateTime(2024, 1, 15),
      images: [
        AlbumImage(
          url: 'https://images.unsplash.com/photo-1590005176489-db2e714711fc',
          title: 'Thor basking',
          createdAt: DateTime(2024, 1, 15),
        ),
        AlbumImage(
          url: 'https://images.unsplash.com/photo-1591438677015-d1d1a31c6e0f',
          title: 'Feeding time',
          createdAt: DateTime(2024, 1, 16),
        ),
      ],
    ),
    Album(
      title: 'Ball Python Collection',
      description: 'My beautiful morphs',
      createdAt: DateTime(2024, 1, 10),
      images: [
        AlbumImage(
          url: 'https://images.unsplash.com/photo-1585095595274-aeffac74e394',
          title: 'Ball Python',
          createdAt: DateTime(2024, 1, 10),
        ),
        AlbumImage(
          url: 'https://images.unsplash.com/photo-1585095595277-e2fad3a0f68e',
          title: 'Ball Python',
          createdAt: DateTime(2024, 1, 11),
        ),
        AlbumImage(
          url: 'https://images.unsplash.com/photo-1585095595285-91c7bf27ed4c',
          title: 'Ball Python',
          createdAt: DateTime(2024, 1, 12),
        ),
      ],
    ),
    Album(
      title: 'Gecko Paradise',
      description: 'My leopard gecko family',
      createdAt: DateTime(2024, 1, 5),
      images: [
        AlbumImage(
          url: 'https://images.unsplash.com/photo-1582847607825-2c8ed4c3dd8c',
          title: 'Leopard Gecko',
          createdAt: DateTime(2024, 1, 5),
        ),
        AlbumImage(
          url: 'https://images.unsplash.com/photo-1582847607854-3093e4892c44',
          title: 'Leopard Gecko',
          createdAt: DateTime(2024, 1, 6),
        ),
        AlbumImage(
          url: 'https://images.unsplash.com/photo-1582847607888-c44e76abbce7',
          title: 'Leopard Gecko',
          createdAt: DateTime(2024, 1, 7),
        ),
        AlbumImage(
          url: 'https://images.unsplash.com/photo-1582847607988-c44e76abbce7',
          title: 'Leopard Gecko',
          createdAt: DateTime(2024, 1, 8),
        ),
      ],
    ),
    Album(
      title: 'Chameleon Chronicles',
      description: 'Color-changing moments',
      createdAt: DateTime(2024, 1, 2),
      images: [
        AlbumImage(
          url: 'https://images.unsplash.com/photo-1580407836821-0fe8c46a2e21',
          title: 'Chameleon',
          createdAt: DateTime(2024, 1, 2),
        ),
        AlbumImage(
          url: 'https://images.unsplash.com/photo-1580407835676-e0c17d9195b3',
          title: 'Chameleon',
          createdAt: DateTime(2024, 1, 3),
        ),
        AlbumImage(
          url: 'https://images.unsplash.com/photo-1580407834105-5e04fbf6c8a5',
          title: 'Chameleon',
          createdAt: DateTime(2024, 1, 4),
        ),
      ],
    ),
    Album(
      title: 'Tortoise Tales',
      description: 'Life in the slow lane',
      createdAt: DateTime(2023, 12, 30),
      images: [
        AlbumImage(
          url: 'https://images.unsplash.com/photo-1597162216923-ba6d99390c1f',
          title: 'Tortoise',
          createdAt: DateTime(2023, 12, 30),
        ),
        AlbumImage(
          url: 'https://images.unsplash.com/photo-1597162216924-c1f1489f90d3',
          title: 'Tortoise',
          createdAt: DateTime(2023, 12, 31),
        ),
        AlbumImage(
          url: 'https://images.unsplash.com/photo-1597162216922-c1f1489f90d2',
          title: 'Tortoise',
          createdAt: DateTime(2024, 1, 1),
        ),
      ],
    ),
    Album(
      title: 'Corn Snake Collection',
      description: 'Beautiful morphs and patterns',
      createdAt: DateTime(2023, 12, 25),
      images: [
        AlbumImage(
          url: 'https://images.unsplash.com/photo-1585095595275-e2f1d9d34e03',
          title: 'Corn Snake',
          createdAt: DateTime(2023, 12, 25),
        ),
        AlbumImage(
          url: 'https://images.unsplash.com/photo-1585095595278-3e5f9a1db4d9',
          title: 'Corn Snake',
          createdAt: DateTime(2023, 12, 26),
        ),
        AlbumImage(
          url: 'https://images.unsplash.com/photo-1585095595280-3e5f9a1db4da',
          title: 'Corn Snake',
          createdAt: DateTime(2023, 12, 27),
        ),
      ],
    ),
    Album(
      title: 'Blue Tongue Skinks',
      description: 'My Australian friends',
      createdAt: DateTime(2023, 12, 20),
      images: [
        AlbumImage(
          url: 'https://images.unsplash.com/photo-1590691566705-5b66e76d3c6c',
          title: 'Blue Tongue Skink',
          createdAt: DateTime(2023, 12, 20),
        ),
        AlbumImage(
          url: 'https://images.unsplash.com/photo-1590691566706-5b66e76d3c6d',
          title: 'Blue Tongue Skink',
          createdAt: DateTime(2023, 12, 21),
        ),
        AlbumImage(
          url: 'https://images.unsplash.com/photo-1590691566707-5b66e76d3c6e',
          title: 'Blue Tongue Skink',
          createdAt: DateTime(2023, 12, 22),
        ),
      ],
    ),
    Album(
      title: 'Green Iguana Journey',
      description: 'Watch them grow',
      createdAt: DateTime(2023, 12, 15),
      images: [
        AlbumImage(
          url: 'https://images.unsplash.com/photo-1590692464430-96ff0b97a258',
          title: 'Green Iguana',
          createdAt: DateTime(2023, 12, 15),
        ),
        AlbumImage(
          url: 'https://images.unsplash.com/photo-1590692464431-96ff0b97a259',
          title: 'Green Iguana',
          createdAt: DateTime(2023, 12, 16),
        ),
        AlbumImage(
          url: 'https://images.unsplash.com/photo-1590692464432-96ff0b97a260',
          title: 'Green Iguana',
          createdAt: DateTime(2023, 12, 17),
        ),
      ],
    ),
    Album(
      title: 'Tegu Time',
      description: 'My Argentine black and white tegu',
      createdAt: DateTime(2023, 12, 10),
      images: [
        AlbumImage(
          url: 'https://images.unsplash.com/photo-1590693870249-d6ef10fcd0c2',
          title: 'Tegu',
          createdAt: DateTime(2023, 12, 10),
        ),
        AlbumImage(
          url: 'https://images.unsplash.com/photo-1590693870250-d6ef10fcd0c3',
          title: 'Tegu',
          createdAt: DateTime(2023, 12, 11),
        ),
        AlbumImage(
          url: 'https://images.unsplash.com/photo-1590693870251-d6ef10fcd0c4',
          title: 'Tegu',
          createdAt: DateTime(2023, 12, 12),
        ),
      ],
    ),
    Album(
      title: 'Monitor Magic',
      description: 'Life with my savannah monitor',
      createdAt: DateTime(2023, 12, 5),
      images: [
        AlbumImage(
          url: 'https://images.unsplash.com/photo-1590694436798-9e8d8b4f5b3f',
          title: 'Savannah Monitor',
          createdAt: DateTime(2023, 12, 5),
        ),
        AlbumImage(
          url: 'https://images.unsplash.com/photo-1590694436799-9e8d8b4f5b40',
          title: 'Savannah Monitor',
          createdAt: DateTime(2023, 12, 6),
        ),
        AlbumImage(
          url: 'https://images.unsplash.com/photo-1590694436800-9e8d8b4f5b41',
          title: 'Savannah Monitor',
          createdAt: DateTime(2023, 12, 7),
        ),
      ],
    ),
  ];

  void _openAlbum(BuildContext context, Album album) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AlbumDetailPage(album: album),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildImageWithFallback(String imageUrl) {
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: const Icon(
            Icons.pets,
            size: 50,
            color: Colors.white70,
          ),
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: albums.length,
      itemBuilder: (context, index) {
        return MouseRegion(
          onEnter: (_) => setState(() => hoveredIndices.add(index)),
          onExit: (_) => setState(() => hoveredIndices.remove(index)),
          child: GestureDetector(
            onTap: () => _openAlbum(context, albums[index]),
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  AnimatedScale(
                    scale: hoveredIndices.contains(index) ? 1.1 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: _buildImageWithFallback(albums[index].images.first.url),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(hoveredIndices.contains(index) ? 0.9 : 0.8),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            albums[index].title,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: hoveredIndices.contains(index) ? 16 : 14,
                            ),
                          ),
                          if (hoveredIndices.contains(index)) ...[
                            const SizedBox(height: 2),
                            Text(
                              'Created: ${_formatDate(albums[index].createdAt)}',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              albums[index].description,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class AlbumDetailPage extends StatelessWidget {
  final Album album;

  const AlbumDetailPage({
    super.key,
    required this.album,
  });

  Widget _buildImageWithFallback(String imageUrl) {
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: const Icon(
            Icons.pets,
            size: 50,
            color: Colors.white70,
          ),
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(album.title),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              album.description,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: album.images.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullScreenImage(
                          imageUrl: album.images[index].url,
                        ),
                      ),
                    );
                  },
                  child: Hero(
                    tag: album.images[index].url,
                    child: _buildImageWithFallback(album.images[index].url),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImage({
    super.key,
    required this.imageUrl,
  });

  Widget _buildImageWithFallback(String imageUrl) {
    return Image.network(
      imageUrl,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.black,
          child: const Icon(
            Icons.pets,
            size: 100,
            color: Colors.white70,
          ),
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Center(
          child: Hero(
            tag: imageUrl,
            child: _buildImageWithFallback(imageUrl),
          ),
        ),
      ),
    );
  }
}

class FeedItem {
  final String imageUrl;
  final String username;
  final String title;
  final DateTime createdAt;
  bool isFollowing;
  bool isFavorite;

  FeedItem({
    required this.imageUrl,
    required this.username,
    required this.title,
    DateTime? createdAt,
    this.isFollowing = false,
    this.isFavorite = false,
  }) : createdAt = createdAt ?? DateTime.now();
}

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  Set<int> hoveredIndices = {};
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  List<FeedItem> _feedItems = [];
  
  // Expanded list of reptile images
  final List<String> sampleImages = [
    // Bearded Dragons
    'https://images.unsplash.com/photo-1590005176489-db2e714711fc',
    'https://images.unsplash.com/photo-1576381394626-53b3d2d48145',
    'https://images.unsplash.com/photo-1590005354167-6da97870c757',
    'https://images.unsplash.com/photo-1591438677015-d1d1a31c6e0f',
    'https://images.unsplash.com/photo-1590005354138-25a427439b63',
    
    // Ball Pythons
    'https://images.unsplash.com/photo-1585095595274-aeffac74e394',
    'https://images.unsplash.com/photo-1585095595277-e2fad3a0f68e',
    'https://images.unsplash.com/photo-1585095595185-3aa15d06e57c',
    'https://images.unsplash.com/photo-1543694327-b6c0fc1b9ae1',
    'https://images.unsplash.com/photo-1531578944014-664cdd4b3ad5',
    
    // Leopard Geckos
    'https://images.unsplash.com/photo-1590283603385-17ffb3a7f29f',
    'https://images.unsplash.com/photo-1580407836821-0fe8c46a2e21',
    'https://images.unsplash.com/photo-1597162216923-ba6d99390c1f',
    'https://images.unsplash.com/photo-1445820133247-bfef5c9a55c7',
    'https://images.unsplash.com/photo-1590283603385-17ffb3a7f29d',
    
    // Chameleons
    'https://images.unsplash.com/photo-1590691566705-5b66e76d3c6c',
    'https://images.unsplash.com/photo-1580541631971-c25e86667ed5',
    'https://images.unsplash.com/photo-1581923627606-796716a0d66b',
    'https://images.unsplash.com/photo-1581923627606-796716a0d66c',
    'https://images.unsplash.com/photo-1581923627606-796716a0d66d',
    
    // Green Iguanas
    'https://images.unsplash.com/photo-1590692464430-96ff0b97a258',
    'https://images.unsplash.com/photo-1582847607825-2c8ed4c3dd8c',
    'https://images.unsplash.com/photo-1576381394626-53b3d2d48146',
    'https://images.unsplash.com/photo-1576381394626-53b3d2d48147',
    'https://images.unsplash.com/photo-1576381394626-53b3d2d48148',
    
    // Tortoises & Turtles
    'https://images.unsplash.com/photo-1590693870249-d6ef10fcd0c2',
    'https://images.unsplash.com/photo-1437622368342-7a3d73a34c8f',
    'https://images.unsplash.com/photo-1549813816-94c3e4a6dd77',
    'https://images.unsplash.com/photo-1549813816-94c3e4a6dd78',
    'https://images.unsplash.com/photo-1549813816-94c3e4a6dd79',
    
    // Blue Tongue Skinks
    'https://images.unsplash.com/photo-1590005354407-afc2f142b917',
    'https://images.unsplash.com/photo-1590005354407-afc2f142b918',
    'https://images.unsplash.com/photo-1590005354407-afc2f142b919',
    'https://images.unsplash.com/photo-1590005354407-afc2f142b920',
    'https://images.unsplash.com/photo-1590005354407-afc2f142b921',
  ];

  final List<String> usernames = [
    // Bearded Dragon Enthusiasts
    'BeardedDragonPro', 'DragonKeeper', 'DesertDragon', 'PogonaPal', 'DragonWhisperer',
    
    // Python Specialists
    'BallPythonPro', 'SnakeCharmer', 'PythonParadise', 'RoyalKeeper', 'MorphMaster',
    
    // Gecko Experts
    'GeckoGuru', 'LeopardLover', 'GeckoGuardian', 'SpottedSpecialist', 'NightGecko',
    
    // Chameleon Enthusiasts
    'ChamQueen', 'ColorMaster', 'ChamCare', 'RainbowReptiles', 'ChamChampion',
    
    // Iguana Keepers
    'IguanaKing', 'GreenGuardian', 'IguanaIsland', 'CrestKeeper', 'IguanaInspired',
    
    // Tortoise & Turtle Fans
    'TortoiseLover', 'ShellSeeker', 'TortLife', 'SlowAndSteady', 'ShellShow',
    
    // Skink Specialists
    'SkinkKeeper', 'BlueTongued', 'SkinkLife', 'AussieReptiles', 'SkinkSpotter',
  ];

  final List<String> titles = [
    // Bearded Dragon Titles
    'Morning Basking Session', 'Feeding Time Fun', 'Desert Dragon Display', 'Beardie Bath Time', 'Head Bob Dance',
    
    // Ball Python Titles
    'Royal Python Portrait', 'Perfect Morph', 'Coiled Beauty', 'Shed Success', 'Feeding Strike',
    
    // Gecko Titles
    'Night Hunt', 'Gecko Smile', 'Vertical Climb', 'Spotted Beauty', 'Tail Drop Defense',
    
    // Chameleon Titles
    'Rainbow Display', 'Branch Master', 'Tongue Strike', 'Color Change', 'Cham Close-up',
    
    // Iguana Titles
    'Basking Beauty', 'Green Giant', 'Crest Display', 'Iguana Diet', 'Scale Details',
    
    // Tortoise Titles
    'Shell Patterns', 'Tortoise Trek', 'Gentle Giant', 'Garden Explorer', 'Tortoise Treat',
    
    // Skink Titles
    'Blue Tongue Flash', 'Skink Sunbath', 'Scale Pattern', 'Aussie Beauty', 'Tongue Flick',
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadInitialItems();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  FeedItem _generateFeedItem(int index) {
    return FeedItem(
      imageUrl: sampleImages[index % sampleImages.length],
      username: usernames[index % usernames.length],
      title: titles[index % titles.length],
    );
  }

  void _loadInitialItems() {
    for (int i = 0; i < 24; i++) {
      _feedItems.add(_generateFeedItem(i));
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent * 0.7 && !_isLoading) {
      _loadMoreItems();
    }
  }

  Future<void> _loadMoreItems() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 500));
    final currentLength = _feedItems.length;
    for (int i = 0; i < 12; i++) {
      _feedItems.add(_generateFeedItem(currentLength + i));
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _openFullScreenImage(BuildContext context, FeedItem item, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenFeedImage(
          feedItem: item,
          onFavoriteChanged: (bool isFavorite) {
            setState(() {
              item.isFavorite = isFavorite;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: _isLoading 
                ? _feedItems.length + 3 
                : _feedItems.length,
            itemBuilder: (context, index) {
              if (index >= _feedItems.length) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final item = _feedItems[index];
              return MouseRegion(
                onEnter: (_) => setState(() => hoveredIndices.add(index)),
                onExit: (_) => setState(() => hoveredIndices.remove(index)),
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => _openFullScreenImage(context, item, _feedItems.indexOf(item)),
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        AnimatedScale(
                          scale: hoveredIndices.contains(index) ? 1.1 : 1.0,
                          duration: const Duration(milliseconds: 200),
                          child: _buildImageWithFallback(item.imageUrl),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                item.isFavorite = !item.isFavorite;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                item.isFavorite ? Icons.favorite : Icons.favorite_border,
                                color: item.isFavorite ? Colors.red : Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        if (hoveredIndices.contains(index))
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.8),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                              child: Text(
                                item.username,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildImageWithFallback(String imageUrl) {
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: const Icon(
            Icons.pets,
            size: 50,
            color: Colors.white70,
          ),
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

class FullScreenFeedImage extends StatelessWidget {
  final FeedItem feedItem;
  final Function(bool) onFavoriteChanged;

  const FullScreenFeedImage({
    super.key,
    required this.feedItem,
    required this.onFavoriteChanged,
  });

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.5),
        foregroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              feedItem.username,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              _formatDate(feedItem.createdAt),
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              feedItem.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: feedItem.isFavorite ? Colors.red : Colors.white,
            ),
            onPressed: () {
              onFavoriteChanged(!feedItem.isFavorite);
            },
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Center(
              child: Hero(
                tag: feedItem.imageUrl,
                child: Image.network(
                  feedItem.imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.black,
                      child: const Icon(
                        Icons.pets,
                        size: 100,
                        color: Colors.white70,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Text(
                feedItem.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
