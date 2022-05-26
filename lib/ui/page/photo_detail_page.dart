import 'package:awesome_app/models/photo_model.dart';
import 'package:flutter/material.dart';

class PhotoDetailPage extends StatefulWidget {
  final PhotoModel photoData;
  const PhotoDetailPage({Key? key, required this.photoData}) : super(key: key);

  @override
  State<PhotoDetailPage> createState() => _PhotoDetailPageState();
}

class _PhotoDetailPageState extends State<PhotoDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [],
      )),
    );
  }
}
