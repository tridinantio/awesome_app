import 'package:awesome_app/models/photo_model.dart';
import 'package:awesome_app/ui/page/photo_detail_page.dart';
import 'package:awesome_app/ui/widget/photo_grid_card.dart';
import 'package:awesome_app/ui/widget/photo_list_card.dart';
import 'package:flutter/material.dart';

class PhotoGrid extends StatefulWidget {
  final List<PhotoModel> photoList;
  PhotoGrid({Key? key, required this.photoList}) : super(key: key);

  @override
  State<PhotoGrid> createState() => _PhotoGridState();
}

class _PhotoGridState extends State<PhotoGrid> {
  @override
  Widget build(BuildContext context) {
    return SliverGrid.count(
      crossAxisCount: 2,
      mainAxisSpacing: 10.0,
      crossAxisSpacing: 10.0,
      childAspectRatio: 1,
      children: widget.photoList
          .map((photoData) => GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PhotoDetailPage(photoData: photoData),
                    ),
                  );
                },
                child: PhotoGridCard(
                  photo: photoData,
                ),
              ))
          .toList(),
    );
  }
}
