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
          url: 'https://images.unsplash.com/photo-1590005354167-6da97870c757',
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
          url: 'https://images.unsplash.com/photo-1582847607988-c44e76abbce7',
          title: 'Leopard Gecko',
          createdAt: DateTime(2024, 1, 7),
        ),
        AlbumImage(
          url: 'https://images.unsplash.com/photo-1582847608635-87b0494c7b22',
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

class AlbumDetailPage extends StatefulWidget {
  final Album album;

  const AlbumDetailPage({
    super.key,
    required this.album,
  });

  @override
  State<AlbumDetailPage> createState() => _AlbumDetailPageState();
}

class _AlbumDetailPageState extends State<AlbumDetailPage> {
  Set<int> hoveredIndices = {};

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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.album.title),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              widget.album.description,
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
              itemCount: widget.album.images.length,
              itemBuilder: (context, index) {
                final image = widget.album.images[index];
                return MouseRegion(
                  onEnter: (_) => setState(() => hoveredIndices.add(index)),
                  onExit: (_) => setState(() => hoveredIndices.remove(index)),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FullScreenImage(
                            imageUrl: image.url,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Hero(
                            tag: image.url,
                            child: _buildImageWithFallback(image.url),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: IconButton(
                              icon: Icon(
                                image.isFavorite ? Icons.favorite : Icons.favorite_border,
                                color: image.isFavorite ? Colors.red : Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  image.isFavorite = !image.isFavorite;
                                });
                              },
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      image.title,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      _formatDate(image.createdAt),
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontSize: 12,
                                      ),
                                    ),
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

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final List<String> contentTypes = List.generate(30, (index) => 
    index % 2 == 0 ? 'photo' : 'video'
  );
  Set<int> hoveredIndices = {};

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(4),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        childAspectRatio: 1,
      ),
      itemCount: 30,
      itemBuilder: (context, index) {
        return MouseRegion(
          onEnter: (_) => setState(() => hoveredIndices.add(index)),
          onExit: (_) => setState(() => hoveredIndices.remove(index)),
          child: Card(
            margin: EdgeInsets.zero,
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              children: [
                AnimatedScale(
                  scale: hoveredIndices.contains(index) ? 1.1 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: Image.network(
                    'https://picsum.photos/seed/${index + 200}/200/200',
                    fit: BoxFit.cover,
                  ),
                ),
                if (contentTypes[index] == 'video')
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(
                        Icons.play_circle_outline,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(hoveredIndices.contains(index) ? 0.9 : 0.7),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.favorite,
                              color: Colors.white,
                              size: hoveredIndices.contains(index) ? 18 : 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${(index + 1) * 11}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: hoveredIndices.contains(index) ? 14 : 12,
                              ),
                            ),
                          ],
                        ),
                        if (hoveredIndices.contains(index))
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              contentTypes[index] == 'video' ? 'Watch video' : 'View image',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
