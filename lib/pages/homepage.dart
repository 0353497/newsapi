import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:newsapi/components/bigcard.dart';
import 'package:newsapi/pages/searchresult.dart';

// Fetch news for a specific subject
Future<List<dynamic>> fetchNews(String question) async {
  var url = 'https://newsapi.org/v2/everything?' +
      'q=${question}&' +
      'sortBy=popularity&' +
      'pageSize=20&' +
      'language=en&' +
      'apiKey=4da6ba9a02184b3ca6cd1c6f2173054e';

  final response = await http.get(Uri.parse(url));
  print('Fetching from URL: $url');

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    if (data['articles'] == null) {
      throw Exception('No articles key in API response');
    }
    var articles = data['articles'];
    List<dynamic> filteredArticles = articles.where((article) {
      return article['source']?['name'] != '[Removed]';
    }).toList();

    if (filteredArticles.isEmpty) {
      throw Exception('No articles found');
    }
    return filteredArticles;
  } else {
    throw Exception('Failed to load news');
  }
}

// Fetch news for multiple subjects
Future<Map<String, List<dynamic>>> fetchAllNews(List<String> subjects) async {
  Map<String, List<dynamic>> allNews = {};
  for (var subject in subjects) {
    try {
      allNews[subject] = await fetchNews(subject);
    } catch (e) {
      print('Error fetching news for $subject: $e');
      allNews[subject] = []; // Return an empty list if fetching fails
    }
  }
  return allNews;
}

// Homepage widget
final TextEditingController _controller = TextEditingController();
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Popular News',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.blue,
        ),
        body: FutureBuilder<Map<String, List<dynamic>>>(
          future: fetchAllNews(['software', 'education']),
          builder: (context, snapshot) {
            // If the future is still loading
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            // If an error occurred
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            // If the data is successfully fetched
            if (snapshot.hasData) {
              var allNews = snapshot.data!;

              if (allNews.isEmpty) {
                return Center(child: Text('No news available'));
              }

              return Scaffold(
                body: Container(
                  child: Column(
                    children: [
                      // Search Input
                      Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _controller,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Search subject',
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SearchResult(
                                            query: _controller.text,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: Text('Search'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // News Section
                      for (var subject in allNews.keys) ...[
                        Text(
                          '${subject[0].toUpperCase()}${subject.substring(1)} News',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          height: 250,
                          child: allNews[subject] != null &&
                                  allNews[subject]!.isNotEmpty
                              ? ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: allNews[subject]!.length,
                                  itemBuilder: (context, index) {
                                    var article = allNews[subject]![index];
                                    return Bigcard(
                                      title: article['title'] ?? 'No title',
                                      description: article['description'] ??
                                          'No description',
                                      imageUrl: article['urlToImage'],
                                      href: article['url'],
                                      width: 300,
                                      height: 300,
                                    );
                                  },
                                )
                              : Center(
                                  child:
                                      Text('No articles found for $subject')),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }

            // Fallback for unexpected cases
            return Center(child: Text('No data available'));
          },
        ),
      ),
    );
  }
}

void main() {
  runApp(Homepage());
}
