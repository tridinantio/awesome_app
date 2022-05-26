import 'package:awesome_app/models/photo_model.dart';
import 'package:awesome_app/shared/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';

class PhotoDetailPage extends StatefulWidget {
  final PhotoModel photoData;
  const PhotoDetailPage({Key? key, required this.photoData}) : super(key: key);

  @override
  State<PhotoDetailPage> createState() => _PhotoDetailPageState();
}

class _PhotoDetailPageState extends State<PhotoDetailPage> {
  late Color dividerColor;

  @override
  void initState() {
    super.initState();
    dividerColor = HexColor(widget.photoData.avgColor);
  }

  //FUNCTION TO REDIRECT USER TO A SPECIFIC URL
  _launchURLBrowser(url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl((Uri.parse(url)));
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget image() {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      width: double.maxFinite,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        // color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
        //     .withOpacity(1.0)
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Hero(
          tag: "photo${widget.photoData.id}",
          child: CachedNetworkImage(
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                Center(
                    child: CircularProgressIndicator(
                        color: greyColor, value: downloadProgress.progress)),
            imageUrl: widget.photoData.src.large,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget detail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 16,
        ),
        Text(
          (widget.photoData.alt.isNotEmpty)
              ? widget.photoData.alt
              : "No title...",
          style: blackTextStyle.copyWith(fontSize: 24),
        ),
        SizedBox(
          height: 4,
        ),
        Divider(
          thickness: 5,
          color: dividerColor,
        ),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            _launchURLBrowser(widget.photoData.photographerUrl);
          },
          child: RichText(
              text: TextSpan(
                  text: 'by ',
                  style: blackTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w200,
                  ),
                  children: [
                TextSpan(
                    text: widget.photoData.photographer,
                    style: blackTextStyle.copyWith(
                        fontWeight: FontWeight.w300,
                        fontSize: 16,
                        fontStyle: FontStyle.italic)),
              ])),
        ),
        SizedBox(
          height: 16,
        ),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            _launchURLBrowser(widget.photoData.url);
          },
          child: RichText(
              text: TextSpan(
                  text: 'Photo URL: ',
                  style: blackTextStyle.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w200,
                  ),
                  children: [
                TextSpan(
                    text: widget.photoData.url,
                    style: blackTextStyle.copyWith(
                        fontWeight: FontWeight.w300,
                        fontSize: 14,
                        decoration: TextDecoration.underline)),
              ])),
        )
      ],
    );
  }

  Widget backButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Icon(
          Icons.arrow_back_ios,
          color: blackColor,
          size: 28,
        ),
      ),
    );
  }

  Widget content() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [backButton(), image(), detail()],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Expanded(child: SingleChildScrollView(child: content())),
        ],
      )),
    );
  }
}
