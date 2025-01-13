import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:newsapi/models/Article.dart';

class Viewarticle extends StatefulWidget {
  final Article article;
  const Viewarticle({super.key, required this.article});

  @override
  _ViewarticleState createState() => _ViewarticleState();
}

class _ViewarticleState extends State<Viewarticle> {
  Color buttonColor = Colors.blue;

  Future<void> _launchInBrowserView(Uri url) async {
    if (!await launchUrl(url)) {
      setState(() {
        buttonColor = Colors.red;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not launch the article source.'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      setState(() {
        buttonColor = Colors.blue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final article = widget.article;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'View Article',
            style: TextStyle(overflow: TextOverflow.ellipsis),
          ),
          backgroundColor: Colors.blue,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (article.imageUrl != null)
                Image.network(article.imageUrl!, fit: BoxFit.cover),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      article.description,
                      style: TextStyle(color: Colors.black, fontSize: 15),
                      softWrap: true,
                    ),
                    SizedBox(height: 20),
                    if (article.content != null) Text(article.content!),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                      ),
                      onPressed: () {
                        if (article.href != null) {
                          _launchInBrowserView(Uri.parse(article.href!));
                        }
                      },
                      child: Text(article.href != null
                          ? 'View Article Source'
                          : 'No Article Source'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
