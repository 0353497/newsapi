import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:newsapi/components/bigcard.dart';

// Fetch news for a specific search query
Future<List<dynamic>> fetchSearchResults(String query) async {
  var url = 'https://newsapi.org/v2/everything?' +
      'q=${query}&' +
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

class SearchResult extends StatelessWidget {
  final String query;

  const SearchResult({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search Results',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchSearchResults(query),
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
            var articles = snapshot.data!;

            if (articles.isEmpty) {
              return Center(child: Text('No articles found for "$query"'));
            }

            return ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                var article = articles[index];
                return Bigcard(
                  title: article['title'] ?? 'No title',
                  description: article['description'] ?? 'No description',
                  imageUrl: article['urlToImage'],
                  href: article['url'],
                  width: double.infinity,
                  height: 300,
                );
              },
            );
          }
          return Center(child: Text('No data available'));
        },
      ),
    );
  }
}
