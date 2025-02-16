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

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

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
                      color: Color(0xFF4CAF50), // Light green glow
                      blurRadius: 8.0,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Login'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  // TODO: Implement sign up navigation
                },
                child: const Text('Don\'t have an account? Sign up'),
              ),
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

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget currentPage;
    switch (_selectedIndex) {
      case 0:
        currentPage = ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "What's happening in the reptile world?",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            ...List.generate(10, (index) => PostCard(
              username: "ReptileLover${index + 1}",
              timeAgo: "${index + 1}h ago",
              content: _getSamplePost(index),
              likes: (index + 1) * 5,
              comments: (index + 1) * 3,
            )),
          ],
        );
        break;
      case 1:
        currentPage = const AlbumsPage();
        break;
      case 2:
        currentPage = const FeedPage();
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Column(
              children: [
                SizedBox(
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildNavItem('Post', 0),
                      _buildNavItem('Albums', 1),
                      _buildNavItem('Feed', 2),
                    ],
                  ),
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
              ],
            ),
          ),
        ),
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
                      username.substring(0, 1).toUpperCase(),
                      style: const TextStyle(fontSize: 20),
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

class AlbumsPage extends StatefulWidget {
  const AlbumsPage({super.key});

  @override
  State<AlbumsPage> createState() => _AlbumsPageState();
}

class _AlbumsPageState extends State<AlbumsPage> {
  Set<int> hoveredIndices = {};

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
      itemCount: 20,
      itemBuilder: (context, index) {
        return MouseRegion(
          onEnter: (_) => setState(() => hoveredIndices.add(index)),
          onExit: (_) => setState(() => hoveredIndices.remove(index)),
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              children: [
                AnimatedScale(
                  scale: hoveredIndices.contains(index) ? 1.1 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: Image.network(
                    'https://picsum.photos/seed/${index + 100}/300/300',
                    fit: BoxFit.cover,
                  ),
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
                          'Reptile ${index + 1}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: hoveredIndices.contains(index) ? 16 : 14,
                          ),
                        ),
                        if (hoveredIndices.contains(index))
                          Text(
                            'Click to view album',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
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
        );
      },
    );
  }
}

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final List<String> contentTypes = List.generate(30, (index) => 
    index % 3 == 0 ? 'video' : 'image'
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
