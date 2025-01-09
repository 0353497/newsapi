import 'package:flutter/material.dart';

class Bigcard extends StatelessWidget {
  final String title;
  final String description;
  final String? imageUrl;
  final String? href;
  final double? width;
  final double? height;

  const Bigcard({
    super.key,
    required this.title,
    required this.description,
    this.imageUrl,
    this.href,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height ?? double.infinity,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.network(
                  imageUrl!,
                  width: double.infinity,
                  height: height != null ? height! * 0.6 : null,
                  fit: BoxFit.cover,
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 10),
                  if (imageUrl == null)
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.clip,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
