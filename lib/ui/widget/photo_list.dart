import 'package:awesome_app/models/photo_model.dart';
import 'package:awesome_app/ui/page/photo_detail_page.dart';
import 'package:awesome_app/ui/widget/photo_list_card.dart';
import 'package:flutter/material.dart';

class PhotoList extends StatefulWidget {
  final List<PhotoModel> photoList;
  PhotoList({Key? key, required this.photoList}) : super(key: key);

  @override
  State<PhotoList> createState() => _PhotoListState();
}

class _PhotoListState extends State<PhotoList> {
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        return Column(
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
                    child: PhotoListCard(
                      photo: photoData,
                    ),
                  ))
              .toList(),
        );
      }, addAutomaticKeepAlives: false, childCount: 1),
    );
  }
}
