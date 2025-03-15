import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBf2rv_asH86gY2fEGY4yUw4NJYRr5nfnw",
      authDomain: "reptigram-lite.firebaseapp.com",
      databaseURL: "https://reptigram-lite-default-rtdb.firebaseio.com",
      projectId: "reptigram-lite",
      storageBucket: "reptigram-lite.firebasestorage.app",
      messagingSenderId: "1023144692222",
      appId: "1:1023144692222:web:a2f83e6788f1e0293018af",
      measurementId: "G-XHBMWC2VD6"
    ),
  );
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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      // Create user in Firebase Auth
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Store additional user data in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'username': _usernameController.text,
        'email': _emailController.text,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PostPage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Sign up failed')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PostPage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Login failed')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
                AutofillGroup(
                  child: Column(
                    children: [
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        autofillHints: const [AutofillHints.email],
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
                        autocorrect: false,
                        enableSuggestions: false,
                        autofillHints: const [AutofillHints.password],
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : () {
                    if (_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
                      _handleLogin();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: const Color(0xFF1B5E20),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading ? const CircularProgressIndicator() : const Text('Login'),
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
                  onPressed: _isLoading ? null : () {
                    if (_emailController.text.isNotEmpty && 
                        _passwordController.text.isNotEmpty &&
                        _usernameController.text.isNotEmpty) {
                      _handleSignUp();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: const Color(0xFF1B5E20),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading ? const CircularProgressIndicator() : const Text('Sign Up'),
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
  final _feedKey = GlobalKey<_FeedPageState>();
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
        if (_selectedIndex == 2)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.grid_on),
                  color: const Color(0xFF1B5E20),
                  onPressed: () {
                    print('Grid icon pressed');
                    _feedKey.currentState?.setFeedType(FeedType.images);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.star),
                  color: const Color(0xFF1B5E20),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.play_circle_outline),
                  color: const Color(0xFF1B5E20),
                  onPressed: () {
                    print('Video icon pressed');
                    _feedKey.currentState?.setFeedType(FeedType.videos);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.people_outline),
                  color: const Color(0xFF1B5E20),
                  onPressed: () {
                    print('People icon pressed');
                    _feedKey.currentState?.setFeedType(FeedType.groups);
                  },
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
            Expanded(child: FeedPage(key: _feedKey)),
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

class Folder {
  final String name;
  final String description;
  final List<AlbumImage> images;
  final List<Folder> subfolders;
  final DateTime createdAt;
  final String? thumbnailUrl;

  Folder({
    required this.name,
    required this.description,
    required this.images,
    List<Folder>? subfolders,
    DateTime? createdAt,
    this.thumbnailUrl,
  }) : 
    subfolders = subfolders ?? [],
    createdAt = createdAt ?? DateTime.now();
}

class AlbumsPage extends StatefulWidget {
  const AlbumsPage({super.key});

  @override
  State<AlbumsPage> createState() => _AlbumsPageState();
}

class _AlbumsPageState extends State<AlbumsPage> {
  Set<int> hoveredIndices = {};
  List<Folder> folders = [
    Folder(
      name: 'Bearded Dragons',
      description: 'My bearded dragon collection',
      thumbnailUrl: 'https://images.unsplash.com/photo-1590005176489-db2e714711fc',
      images: [
        AlbumImage(
          url: 'https://images.unsplash.com/photo-1590005176489-db2e714711fc',
          title: 'Thor basking',
          createdAt: DateTime.now(),
        ),
        // ... more images
      ],
    ),
    // ... more folders
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateFolderDialog(context),
        child: const Icon(Icons.create_new_folder),
        backgroundColor: const Color(0xFF1B5E20),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 1,
        ),
        itemCount: folders.length,
        itemBuilder: (context, index) {
          return _buildFolderCard(folders[index], index);
        },
      ),
    );
  }

  Widget _buildFolderCard(Folder folder, int index) {
    return MouseRegion(
      onEnter: (_) => setState(() => hoveredIndices.add(index)),
      onExit: (_) => setState(() => hoveredIndices.remove(index)),
      child: GestureDetector(
        onTap: () => _openFolder(context, folder),
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              AnimatedScale(
                scale: hoveredIndices.contains(index) ? 1.1 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: folder.thumbnailUrl != null
                    ? Image.network(
                        folder.thumbnailUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildFolderIcon();
                        },
                      )
                    : _buildFolderIcon(),
              ),
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
                        folder.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${folder.images.length} images',
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
      ),
    );
  }

  Widget _buildFolderIcon() {
    return Container(
      color: const Color(0xFF1B5E20).withOpacity(0.1),
      child: const Icon(
        Icons.folder,
        size: 64,
        color: Color(0xFF1B5E20),
      ),
    );
  }

  void _openFolder(BuildContext context, Folder folder) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FolderPage(folder: folder),
      ),
    );
  }

  Future<void> _showCreateFolderDialog(BuildContext context) async {
    final nameController = TextEditingController();
    final descController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Folder'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Folder Name',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: descController,
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                setState(() {
                  folders.add(Folder(
                    name: nameController.text,
                    description: descController.text,
                    images: [],
                  ));
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}

class FolderPage extends StatefulWidget {
  final Folder folder;

  const FolderPage({
    super.key,
    required this.folder,
  });

  @override
  State<FolderPage> createState() => _FolderPageState();
}

class _FolderPageState extends State<FolderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.folder.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.create_new_folder),
            onPressed: () => _showCreateFolderDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.add_photo_alternate),
            onPressed: () => _showAddImageDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          if (widget.folder.subfolders.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Subfolders',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemCount: widget.folder.subfolders.length,
                itemBuilder: (context, index) {
                  final subfolder = widget.folder.subfolders[index];
                  return Card(
                    margin: const EdgeInsets.only(right: 8),
                    child: InkWell(
                      onTap: () => _openFolder(context, subfolder),
                      child: Container(
                        width: 100,
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.folder,
                              size: 40,
                              color: Color(0xFF1B5E20),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              subfolder.name,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
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
          if (widget.folder.images.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Images',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ],
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: widget.folder.images.length,
              itemBuilder: (context, index) {
                final image = widget.folder.images[index];
                return GestureDetector(
                  onTap: () => _openFullScreenImage(context, image),
                  child: Image.network(
                    image.url,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.broken_image),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _openFolder(BuildContext context, Folder folder) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FolderPage(folder: folder),
      ),
    );
  }

  Future<void> _showCreateFolderDialog(BuildContext context) async {
    final nameController = TextEditingController();
    final descController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Subfolder'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Folder Name',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: descController,
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                setState(() {
                  widget.folder.subfolders.add(Folder(
                    name: nameController.text,
                    description: descController.text,
                    images: [],
                  ));
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _openFullScreenImage(BuildContext context, AlbumImage image) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImage(imageUrl: image.url),
      ),
    );
  }

  Future<void> _showAddImageDialog(BuildContext context) async {
    // Here you would implement image picking functionality
    // For now, we'll just show a placeholder dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Image'),
        content: const Text('Image picking functionality coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
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
      fit: BoxFit.cover,
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

// Add this enum before the FeedItem class
enum FeedType {
  images,
  videos,
  groups
}

class FeedItem {
  final String imageUrl;
  final String username;
  final String title;
  final DateTime createdAt;
  bool isFollowing;
  bool isFavorite;
  final bool isVideo; // Add this field
  final String? videoUrl; // Add this field

  FeedItem({
    required this.imageUrl,
    required this.username,
    required this.title,
    DateTime? createdAt,
    this.isFollowing = false,
    this.isFavorite = false,
    this.isVideo = false,
    this.videoUrl,
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
  FeedType _currentFeedType = FeedType.images;
  
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

  // Add this sample video URL list
  final List<String> sampleVideos = [
    'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    'https://storage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    'https://storage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
    'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
  ];

  final List<Group> _groups = [
    Group(
      name: 'Gecko Lovers',
      description: 'A community for leopard gecko enthusiasts and owners',
      imageUrl: 'assets/images/gecko.jpg',
      memberCount: 1250,
    ),
    Group(
      name: 'Turtle Enthusiasts',
      description: 'Share your turtle and tortoise care tips and experiences',
      imageUrl: 'assets/images/turtle.jpg',
      memberCount: 890,
    ),
    Group(
      name: 'Boa Constrictor Group',
      description: 'For boa constrictor owners and admirers',
      imageUrl: 'assets/images/snake.jpg',
      memberCount: 650,
    ),
    Group(
      name: 'Bearded Dragon Club',
      description: 'Everything about bearded dragons and their care',
      imageUrl: 'assets/images/dragon.jpg',
      memberCount: 2100,
    ),
    Group(
      name: 'Chameleon Community',
      description: 'Discuss chameleon species, care, and breeding',
      imageUrl: 'assets/images/chameleon.jpg',
      memberCount: 780,
    ),
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

  void setFeedType(FeedType type) {
    print('Setting feed type to: $type');
    setState(() {
      _currentFeedType = type;
      _feedItems.clear();
      if (type != FeedType.groups) {
        _loadInitialItems();
      }
    });
  }

  void _loadInitialItems() {
    final newItems = <FeedItem>[];
    for (int i = 0; i < 24; i++) {
      newItems.add(_generateFeedItem(i));
    }
    
    setState(() {
      _feedItems = newItems;
    });
    
    print('Loaded ${_feedItems.length} items. Feed type: $_currentFeedType');
  }

  FeedItem _generateFeedItem(int index) {
    if (_currentFeedType == FeedType.videos) {
      return FeedItem(
        imageUrl: sampleImages[index % sampleImages.length],
        username: 'VideoCreator${index + 1}',
        title: 'Reptile Video #${index + 1}',
        isVideo: true,
        videoUrl: sampleVideos[index % sampleVideos.length], // Use the sample videos
      );
    } else {
      return FeedItem(
        imageUrl: sampleImages[index % sampleImages.length],
        username: usernames[index % usernames.length],
        title: titles[index % titles.length],
        isVideo: false,
      );
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

  void _openFullScreenItem(BuildContext context, FeedItem item, int index) {
    if (item.isVideo) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoPlayerScreen(
            videoUrl: item.videoUrl!,
            feedItem: item,
          ),
        ),
      );
    } else {
      _openFullScreenImage(context, item, index);
    }
  }

  void _openFullScreenImage(BuildContext context, FeedItem item, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenFeedImage(
          feedItem: item,
          onFavoriteChanged: (isFavorite) {
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
    print('Current feed type: $_currentFeedType');
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          color: _currentFeedType == FeedType.groups 
              ? Colors.blue.withOpacity(0.1) 
              : _currentFeedType == FeedType.videos 
                  ? Colors.red.withOpacity(0.1) 
                  : Colors.green.withOpacity(0.1),
          child: Text(
            _currentFeedType == FeedType.groups 
                ? 'Groups' 
                : _currentFeedType == FeedType.videos 
                    ? 'Video Feed' 
                    : 'Image Feed',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: _currentFeedType == FeedType.groups
              ? _buildGroupsList()
              : _buildMediaGrid(),
        ),
      ],
    );
  }

  Widget _buildGroupsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _groups.length,
      itemBuilder: (context, index) {
        final group = _groups[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.pets,
                  size: 30,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            title: Text(
              group.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(group.description),
                const SizedBox(height: 4),
                Text(
                  '${group.memberCount} members',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            trailing: ElevatedButton(
              onPressed: () {
                setState(() {
                  final groupIndex = _groups.indexOf(group);
                  _groups[groupIndex] = Group(
                    name: group.name,
                    description: group.description,
                    imageUrl: group.imageUrl,
                    memberCount: group.isJoined 
                        ? group.memberCount - 1 
                        : group.memberCount + 1,
                    isJoined: !group.isJoined,
                  );
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: group.isJoined 
                    ? Colors.grey 
                    : const Color(0xFF1B5E20),
                foregroundColor: Colors.white,
              ),
              child: Text(group.isJoined ? 'Leave' : 'Join'),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMediaGrid() {
    return GridView.builder(
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
            onTap: () => _openFullScreenItem(context, item, index),
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
                  if (item.isVideo)
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
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

// Add this new class for video playback
class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  final FeedItem feedItem;

  const VideoPlayerScreen({
    super.key,
    required this.videoUrl,
    required this.feedItem,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _isLiked = false;
  double _sliderValue = 0.0;
  String _currentPosition = '0:00';
  String _totalDuration = '0:00';

  @override
  void initState() {
    super.initState();
    _isLiked = widget.feedItem.isFavorite;
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() {
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
          _totalDuration = _formatDuration(_controller.value.duration);
        });
        _controller.addListener(_videoListener);
      });
  }

  void _videoListener() {
    if (_controller.value.isPlaying != _isPlaying) {
      setState(() {
        _isPlaying = _controller.value.isPlaying;
      });
    }
    
    final position = _controller.value.position;
    final duration = _controller.value.duration;
    
    if (duration.inMilliseconds > 0) {
      setState(() {
        _sliderValue = position.inMilliseconds / duration.inMilliseconds;
        _currentPosition = _formatDuration(position);
      });
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _controller.removeListener(_videoListener);
    _controller.dispose();
    super.dispose();
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
              widget.feedItem.username,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.feedItem.title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height - kToolbarHeight,
          ),
          child: AspectRatio(
            aspectRatio: 9 / 16,
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (_isInitialized)
                  FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller.value.size.width,
                      height: _controller.value.size.height,
                      child: VideoPlayer(_controller),
                    ),
                  )
                else
                  const CircularProgressIndicator(),
                
                // Like button overlay on the right
                Positioned(
                  right: 16,
                  bottom: 100,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isLiked = !_isLiked;
                            widget.feedItem.isFavorite = _isLiked;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _isLiked ? Icons.favorite : Icons.favorite_border,
                            color: _isLiked ? Colors.red : Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Like',
                        style: TextStyle(
                          color: _isLiked ? Colors.red : Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                // Video controls overlay
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
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
                    child: Column(
                      children: [
                        // Progress bar
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: Colors.white,
                            inactiveTrackColor: Colors.white30,
                            thumbColor: Colors.white,
                            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                            overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                          ),
                          child: Slider(
                            value: _sliderValue,
                            onChanged: (value) {
                              final duration = _controller.value.duration;
                              final newPosition = duration * value;
                              _controller.seekTo(newPosition);
                            },
                          ),
                        ),
                        
                        // Time and controls
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _currentPosition,
                              style: const TextStyle(color: Colors.white),
                            ),
                            IconButton(
                              icon: Icon(
                                _isPlaying ? Icons.pause : Icons.play_arrow,
                                color: Colors.white,
                                size: 32,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (_isPlaying) {
                                    _controller.pause();
                                  } else {
                                    _controller.play();
                                  }
                                });
                              },
                            ),
                            Text(
                              _totalDuration,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Group {
  final String name;
  final String description;
  final String imageUrl;
  final int memberCount;
  final bool isJoined;

  Group({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.memberCount,
    this.isJoined = false,
  });
}
