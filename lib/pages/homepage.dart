import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:newsapi/components/bigcard.dart';

// Updated URL with language and pageSize parameters
Future<List<dynamic>> fetchNews(String question) async {
  var url = 'https://newsapi.org/v2/everything?' +
      'q=${question}&' +
      'sortBy=popularity&' +
      'pageSize=20&' +
      'language=en&' +
      'apiKey=4da6ba9a02184b3ca6cd1c6f2173054e';

  final response = await http.get(Uri.parse(url));
  print('fetching from ur;: ${url}');
  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    var articles = data['articles'];
    List<dynamic> filteredArticles = articles.where((article) {
      return article['source']['name'] != '[Removed]';
    }).toList();
    if (filteredArticles.length < 1) {
      throw Exception('No articles found that are not removed');
    }
    return filteredArticles;
  } else {
    throw Exception('Failed to load news');
  }
}

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
        body: FutureBuilder<List<dynamic>>(
          future: fetchNews('software'), // Fetch the news
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

              return Scaffold(
                body: Container(
                  child: Column(
                    children: [
                      Text(
                        'Popular News',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        height: 250, // Set a fixed height for the ListView
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: articles.length,
                          itemBuilder: (context, index) {
                            var article = articles[index];
                            return Bigcard(
                              title: article['title'],
                              description: article['description'],
                              imageUrl: article['urlToImage'],
                              href: article['url'],
                              width: 350,
                              height: 200,
                            );
                          },
                        ),
                      ),
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
