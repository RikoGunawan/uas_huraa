import 'package:flutter/material.dart';

import '../../models/post.dart';
import '../../services/post_service.dart';

class PostScreen extends StatefulWidget {
  final Post post;

  const PostScreen({super.key, required this.post});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  late Future<Post?> postFuture;

  @override
  void initState() {
    super.initState();
    postFuture = getPostById(widget.post.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Post?>(
        future: postFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('Post not found'));
          }

          final post = snapshot.data!;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 44, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: widget.post.aspectRatio ?? 1.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.network(
                        widget.post.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: Text('Image not available'),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 16.0),

                  // Statistik dengan Ikon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildStatLike(
                        icon: Icons.favorite,
                        color: Colors.red,
                        value: post.likes.toString(),
                        onTap: () {
                          // Handle like increment logic here
                        },
                      ),
                      const SizedBox(width: 30.0),
                      _buildStatShare(
                        icon: Icons.share,
                        color: Colors.green,
                        value: post.shares.toString(),
                        onTap: () {
                          // Handle share increment logic here
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),

                  // Post Title

                  Text(
                    post.name,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    post.description,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

// Widget Statistik Like dengan Ikon
  Widget _buildStatLike({
    required IconData icon,
    required Color color,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, size: 20.0, color: color),
          const SizedBox(height: 8.0),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

// Widget Statistik Share dengan Ikon
  Widget _buildStatShare(
      {required IconData icon,
      required Color color,
      required String value,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, size: 20.0, color: color),
          const SizedBox(height: 8.0),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
