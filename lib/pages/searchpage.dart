import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:newsapi/components/bigcard.dart';



class Searchpage extends StatelessWidget {
  const Searchpage({super.key});

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
          future: ,
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
                body: Container(),
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
