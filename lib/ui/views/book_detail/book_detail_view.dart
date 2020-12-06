import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:librebook/controllers/download_controller.dart';
import 'package:librebook/models/book_model.dart';
import 'package:librebook/ui/shared/theme.dart';
import 'package:librebook/ui/shared/ui_helper.dart';
import 'package:librebook/ui/widgets/image_error_widget.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:shimmer/shimmer.dart';

class BookDetailView extends StatefulWidget {
  final Book book;

  const BookDetailView({Key key, @required this.book}) : super(key: key);

  @override
  _BookDetailViewState createState() => _BookDetailViewState();
}

class _BookDetailViewState extends State<BookDetailView> {
  DownloadController _downloadController = Get.put(DownloadController());
  bool isDownloaded = false;

  @override
  void initState() {
    super.initState();
    // check is book already downloaded
    _downloadController.isCompleted(widget.book.md5);
    _downloadController.init();
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloading');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          Obx(() {
            if (_downloadController.isAlreadyDownloaded.value) {
              return IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    Get.dialog(AlertDialog(
                      title: Text('Confirmation'),
                      content: Text('Are you sure want to delete this book?'),
                      actions: [
                        MaterialButton(
                          onPressed: () => Get.back(),
                          child: Text('No'),
                        ),
                        MaterialButton(
                          onPressed: () async {
                            final path = await _downloadController
                                .getPath(widget.book.md5);
                            await _downloadController.deleteBook(
                                widget.book.md5, path);
                            Get.back();
                          },
                          child: Text('Yes'),
                        ),
                      ],
                    ));
                  });
            } else {
              return Container();
            }
          }),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _coverImage(),
              horizontalSpaceSmall,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _title(),
                    verticalSpaceSmall,
                    _authors(),
                    verticalSpaceLarge,
                  ],
                ),
              ),
            ],
          ),
          verticalSpaceMedium,
          _language(),
          verticalSpaceMedium,
          Obx(
            () => _downloadController.isAlreadyDownloaded.value
                ? _completedButton()
                : _actionButton(),
          ),
          verticalSpaceSmall,
          Divider(
            height: 10,
          ),
          verticalSpaceSmall,
          _description()
        ],
      ),
    );
  }

  Column _description() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        verticalSpaceSmall,
        Text(widget.book.description.isEmpty
            ? 'No Description'
            : widget.book.description),
      ],
    );
  }

  Widget _actionButton() {
    return MaterialButton(
        child: Text('Download'),
        color: secondaryColor,
        onPressed: () async {
          await _downloadController.download(widget.book);
        });
  }

  Row _language() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Text(
                  widget.book.language,
                  style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w600,
                      fontSize: 16),
                ),
                horizontalSpaceTiny,
                Icon(
                  OMIcons.language,
                  color: Colors.grey[800],
                ),
              ],
            ),
            verticalSpaceTiny,
            Text(
              'Language',
              style: TextStyle(color: Colors.grey[700], fontSize: 12),
            )
          ],
        ),
        Container(
          height: 30,
          width: 0.4,
          color: Colors.grey[800],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Text(
                  widget.book.format.toUpperCase(),
                  style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w600,
                      fontSize: 16),
                ),
                horizontalSpaceTiny,
                Icon(
                  OMIcons.book,
                  color: Colors.grey[700],
                ),
              ],
            ),
            verticalSpaceTiny,
            Text(
              'Format',
              style: TextStyle(color: Colors.grey[800], fontSize: 12),
            )
          ],
        )
      ],
    );
  }

  Text _authors() {
    return Text(
      widget.book.authors.join(', '),
      style: TextStyle(fontSize: 15),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Text _title() {
    return Text(
      widget.book.title,
      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 21),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Hero _coverImage() {
    return Hero(
      tag: 'image' + widget.book.id,
      child: Container(
        height: Get.height / 6,
        width: Get.height / 8,
        decoration: BoxDecoration(border: Border.all(color: Colors.grey[300])),
        child: CachedNetworkImage(
          imageUrl: widget.book.cover,
          placeholder: (context, url) => Shimmer.fromColors(
            baseColor: Colors.grey[300],
            highlightColor: Colors.grey[100],
            child: Container(
              width: double.infinity,
              color: Colors.white,
            ),
          ),
          fit: BoxFit.fill,
          errorWidget: (context, _, __) {
            return ImageErrorWidget();
          },
        ),
      ),
    );
  }

  Widget _completedButton() {
    return MaterialButton(
      child: Text('Open Book'),
      color: secondaryColor,
      onPressed: () => _downloadController.openFile(widget.book),
    );
  }
}
