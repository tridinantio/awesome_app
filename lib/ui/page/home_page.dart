import 'package:awesome_app/cubit/cubit/photo_cubit.dart';
import 'package:awesome_app/services/photo_services.dart';
import 'package:awesome_app/shared/theme.dart';
import 'package:awesome_app/ui/widget/photo_grid_card.dart';
import 'package:awesome_app/ui/widget/photo_list_card.dart';
import 'package:awesome_app/ui/widget/photo_list.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:lottie/lottie.dart';
import 'package:restart_app/restart_app.dart';

import '../widget/photo_grid.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  bool isFetching = false;
  bool maxReached = false;
  bool listIsActive = true;
  bool gridIsActive = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<PhotoCubit>().fetchPhotoList();
  }

  //FUNCTION TO FETCH PAGINATION
  Future<void> fetchPagination() async {
    setState(() {
      isLoading = true;
    });
    await context.read<PhotoCubit>().fetchPhotoListPagination();
  }

  //FUNCTION TO REFRESH
  Future<void> onRefresh() async {
    setState(() {
      isLoading = false;
    });
    context.read<PhotoCubit>().fetchPhotoList();
  }

  @override
  Widget build(BuildContext context) {
    //TO SHOW CIRCULAR PROGRESS INDICATOR WHEN LOADING
    Widget loadingIndicator() {
      return SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          return Column(
            children: const [
              SizedBox(
                height: 20,
              ),
              Center(
                child: CircularProgressIndicator(
                  color: greyColor,
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          );
        }, childCount: 1),
      );
    }

    //WIDGET TO HANDLE NO CONNECTION
    Widget noConnectionMessage() {
      return Column(
        children: [
          SizedBox(
              height: 220, width: 220, child: Lottie.asset("assets/no.json")),
          SizedBox(
            height: 10,
          ),
          Text(
            "You are disconnected",
            style: blackTextStyle,
          ),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              Restart.restartApp(webOrigin: '/');
            },
            child: Text(
              "Tap here to restart",
              style: blackTextStyle.copyWith(color: activeColor),
            ),
          ),
        ],
      );
    }

    Widget noBackgroundImage() {
      return Container(
        color: greyColor,
        child: Icon(Icons.broken_image),
      );
    }

    //BACKGROUND IMAGE IN THE SLIVER
    Widget backgroundImage() {
      return ClipRRect(
        child: CachedNetworkImage(
          errorWidget: (context, url, error) => noBackgroundImage(),
          progressIndicatorBuilder: (context, url, downloadProgress) => Center(
              child: CircularProgressIndicator(
                  color: greyColor, value: downloadProgress.progress)),
          imageUrl: "https://source.unsplash.com/random",
          fit: BoxFit.cover,
        ),
      );
    }

    //ACTION ICONS/BUTTONS ON TOP RIGHT SIDE OF APPBAR
    Widget actionIcons() {
      return Row(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              if (!listIsActive) {
                setState(() {
                  gridIsActive = !gridIsActive;
                  listIsActive = !listIsActive;
                });
              }
            },
            child: Icon(
              Icons.list_rounded,
              color: (listIsActive ? activeColor : inactiveColor),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              if (!gridIsActive) {
                setState(() {
                  gridIsActive = !gridIsActive;
                  listIsActive = !listIsActive;
                });
              }
            },
            child: Icon(Icons.grid_view_rounded,
                color: (gridIsActive ? activeColor : whiteColor)),
          ),
          SizedBox(
            width: 16,
          ),
        ],
      );
    }

    Widget content() {
      return BlocConsumer<PhotoCubit, PhotoState>(
        listener: (context, state) {
          // LISTEN TO LOADING STATE OF THIS PAGE
          if (state is PhotoSuccess) {
            setState(() {
              isLoading = false;
            });
          }
        },
        builder: (context, state) {
          if (state is PhotoLoading) {
            return loadingIndicator();
          } else if (state is PhotoSuccess) {
            if (listIsActive) {
              return PhotoList(
                photoList: state.photoList,
              );
            } else {
              return PhotoGrid(
                photoList: state.photoList,
              );
            }
          } else {
            return SliverList(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
                return noConnectionMessage();
              }, childCount: 1),
            );
          }
        },
      );
    }

    return Scaffold(
        body: LazyLoadScrollView(
      onEndOfPage: () {
        //TO PREVENT CALLING fetchPagination TWICE
        if (!isLoading) {
          fetchPagination();
          print('pagination');
        }
      },
      child: RefreshIndicator(
        color: greyColor,
        onRefresh: onRefresh,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              actions: [actionIcons()],
              pinned: true,
              floating: true,
              expandedHeight: MediaQuery.of(context).size.height / 3,
              flexibleSpace: FlexibleSpaceBar(
                expandedTitleScale: 2,
                title: Text(
                  'Awesome',
                  style: whiteTextStyle,
                ),
                background: backgroundImage(),
              ),
            ),
            content(),
            if (isLoading) loadingIndicator()
          ],
        ),
      ),
    ));
  }
}
