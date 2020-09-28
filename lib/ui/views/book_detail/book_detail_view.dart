import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:librebook/models/book_model.dart';
import 'package:librebook/ui/shared/theme.dart';
import 'package:librebook/ui/shared/ui_helper.dart';
import 'package:librebook/ui/widgets/image_error_widget.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:shimmer/shimmer.dart';

class BookDetailView extends StatelessWidget {
  final Book book;

  const BookDetailView({Key key, @required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 160,
                width: 120,
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.grey[300])),
                child: CachedNetworkImage(
                  imageUrl: book.cover,
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
              horizontalSpaceSmall,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 21),
                    ),
                    verticalSpaceSmall,
                    Text(
                      book.authors.join(', '),
                      style: TextStyle(fontSize: 15),
                    ),
                    verticalSpaceLarge,
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    book.language,
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
                                style: TextStyle(
                                    color: Colors.grey[700], fontSize: 12),
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
                                    book.format.toUpperCase(),
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
                                style: TextStyle(
                                    color: Colors.grey[800], fontSize: 12),
                              )
                            ],
                          )
                        ],
                      )
                  ],
                ),
              ),
            ],
          ),
          verticalSpaceMedium,
          Row(
            children: [
              Expanded(
                child: MaterialButton(
                  child: Text('Download'),
                  color: secondaryColor,
                  onPressed: () {},
                ),
              ),
              horizontalSpaceSmall,
              Expanded(
                child: OutlineButton(
                  child: Text('Preview'),
                  textColor: secondaryColor,
                  color: secondaryColor,
                  onPressed: () {},
                ),
              ),
            ],
          ),
          verticalSpaceSmall,
          Divider(
            height: 10,
          ),
          verticalSpaceSmall,
          Text(
            'Description',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          verticalSpaceSmall,
          Text(book.description.isEmpty ? 'No Description': book.description),
        ],
      ),
    );
  }
}
