import 'package:awesome_app/cubit/cubit/photo_cubit.dart';
import 'package:awesome_app/services/photo_services.dart';
import 'package:awesome_app/shared/theme.dart';
import 'package:awesome_app/ui/widget/photo_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  bool isFetching = false;
  bool maxReached = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<PhotoCubit>().fetchPhotoList();
  }

  Future<void> fetchPagination() async {
    setState(() {
      isLoading = true;
    });
    await context.read<PhotoCubit>().fetchPhotoListPagination();
  }

  @override
  Widget build(BuildContext context) {
    Widget backgroundImage() {
      return Image.network(
        "https://source.unsplash.com/random",
        fit: BoxFit.cover,
      );
    }

    Widget content() {
      return BlocConsumer<PhotoCubit, PhotoState>(
        listener: (context, state) {
          // TODO: implement listener
          if (state is PhotoSuccess) {
            print(state.photoList.length);
            if (state.photoList.length < 10) {
              setState(() {
                isLoading = false;
              });
            }
          }
        },
        builder: (context, state) {
          if (state is PhotoLoading) {
            return SliverList(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
                return Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    const Center(
                        child: CircularProgressIndicator(
                      color: Colors.grey,
                    )),
                  ],
                );
              }, childCount: 1),
            );
          } else if (state is PhotoSuccess) {
            return SliverList(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
                return Column(
                  children: state.photoList
                      .map((photoData) =>
                          // CachedNetworkImage(
                          //       imageUrl: photoData.src.original,
                          //       fit: BoxFit.cover,
                          //     ))
                          // .toList(),
                          PhotoCard(
                            photo: photoData,
                          ))
                      .toList(),
                );
              }, addAutomaticKeepAlives: false, childCount: 1),
            );
          } else {
            return SliverList(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
                return Container(
                  color: index.isOdd ? Colors.white : Colors.black12,
                  height: 100.0,
                  child: Center(child: Text("Gagal fetch foto")),
                );
              }, childCount: 1),
            );
          }
        },
      );
    }

    Widget actionIcons() {
      return Row(
        children: [
          Icon(Icons.list_rounded),
          SizedBox(
            width: 20,
          ),
          Icon(Icons.grid_view_rounded),
          SizedBox(
            width: 16,
          ),
        ],
      );
    }

    return Scaffold(
        body: NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        final metrics = scrollNotification.metrics;
        if (scrollNotification is ScrollEndNotification) {
          if (metrics.atEdge) {
            bool isTop = metrics.pixels == 0;
            if (isTop) {
              print('At the top');
            } else {
              print('At the bottom');

              //DETECT SCROLL END

              fetchPagination();
              print('pagination');
            }
          }
        }
        return true;
      },
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            actions: [actionIcons()],
            pinned: true,
            centerTitle: true,
            floating: true,
            expandedHeight: MediaQuery.of(context).size.height / 3,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                'Awesome',
              ),
              background: backgroundImage(),
            ),
          ),
          content()
        ],
      ),
    ));
  }
}
