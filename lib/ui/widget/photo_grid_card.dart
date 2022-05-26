import 'package:awesome_app/models/photo_model.dart';
import 'package:awesome_app/shared/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class PhotoGridCard extends StatefulWidget {
  final PhotoModel photo;
  PhotoGridCard({Key? key, required this.photo}) : super(key: key);

  @override
  State<PhotoGridCard> createState() => _PhotoGridCardState();
}

class _PhotoGridCardState extends State<PhotoGridCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        // color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
        //     .withOpacity(1.0)
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Hero(
          tag: "photo${widget.photo.id}",
          child: CachedNetworkImage(
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                Center(
                    child: CircularProgressIndicator(
                        color: greyColor, value: downloadProgress.progress)),
            imageUrl: widget.photo.src.medium,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
