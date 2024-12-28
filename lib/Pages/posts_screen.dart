import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_tracker/Provider/api_provider.dart';
import 'package:task_tracker/Provider/theme_provider.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  PostsScreenState createState() => PostsScreenState();
}

class PostsScreenState extends State<PostsScreen> {
  TextEditingController search = TextEditingController();

  @override
  void initState() {
    super.initState();
    // ... Fetching all posts
    Future.microtask(
        () => Provider.of<ApiProvider>(context, listen: false).fetchAllPosts());
  }

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final apiProvider = Provider.of<ApiProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
        actions: [
          IconButton(
            icon: Icon(
              Provider.of<ThemeProvider>(context).themeMode == ThemeMode.light
                  ? Icons.nightlight_round
                  : Icons.wb_sunny,
            ),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          apiProvider.fetchAllPosts();
          search.clear();
        },
        child: Icon(Icons.refresh),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: search,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Filter by User ID',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () {
                    final userId = int.tryParse(search.text.trim());
                    if (userId != null) {
                      apiProvider.filterPosts(userId);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please enter a valid User ID')),
                      );
                    }
                  },
                  icon: Icon(Icons.search),
                ),
              ),
            ),
          ),
          apiProvider.error.isNotEmpty
              ? Center(
                  child: Text(
                  apiProvider.error,
                  textAlign: TextAlign.center,
                ))
              : Expanded(
                  child: apiProvider.loading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : apiProvider.posts.isEmpty
                          ? Center(
                              child: Text(
                                apiProvider.error.isNotEmpty
                                    ? apiProvider.error
                                    : 'No posts available.',
                              ),
                            )
                          : ListView.builder(
                              itemCount: apiProvider.posts.length,
                              itemBuilder: (context, index) {
                                final post = apiProvider.posts[index];
                                return Card(
                                  elevation: 5,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.all(16),
                                    leading: Icon(
                                      Icons.article,
                                      color: Colors.deepPurple,
                                      size: 30,
                                    ),
                                    title: Text(
                                      'Title: ${post.title}',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepPurple[800],
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Body: ${post.body}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'ID: ${post.id}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.blueGrey,
                                          ),
                                        ),
                                      ],
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
