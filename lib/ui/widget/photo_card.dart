import 'package:awesome_app/models/photo_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class PhotoCard extends StatefulWidget {
  final PhotoModel photo;
  PhotoCard({Key? key, required this.photo}) : super(key: key);

  @override
  State<PhotoCard> createState() => _PhotoCardState();
}

class _PhotoCardState extends State<PhotoCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 4,
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        // color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
        //     .withOpacity(1.0)
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: CachedNetworkImage(
          progressIndicatorBuilder: (context, url, downloadProgress) => Center(
              child: CircularProgressIndicator(
                  color: Colors.grey, value: downloadProgress.progress)),
          imageUrl: widget.photo.src.original,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
