import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:librebook/ui/shared/theme.dart';
import 'package:librebook/ui/shared/ui_helper.dart';
import 'package:librebook/utils/consts.dart';
import 'package:mime/mime.dart';
import 'package:open_file/open_file.dart';

class DownloadDialog extends StatelessWidget {
  final int progress;
  final int total;
  final int received;

  const DownloadDialog({
    Key key,
    @required this.progress,
    @required this.total,
    @required this.received,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: progress == 0
          ? total == -1
              ? Text('Downloading...')
              : Text('Waiting for server reply...')
          : Text('Downloading...'),
      content: progress == 0
          ? total == -1
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LinearProgressIndicator(),
                    verticalSpaceSmall,
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        Constants.formatBytes(received, 1),
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                )
              : LinearProgressIndicator()
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LinearProgressIndicator(value: progress / 100),
                verticalSpaceSmall,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(progress.toString() + '%'),
                    Text(
                      Constants.formatBytes(received, 1) +
                          ' of ' +
                          Constants.formatBytes(total, 1),
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                )
              ],
            ),
    );
  }
}

class DownloadCompletedDialog extends StatelessWidget {
  final String fileDir;

  const DownloadCompletedDialog({Key key, @required this.fileDir}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text('Download completed!'),
        content: Text('Do you want to open the book?'),
        actions: [
          MaterialButton(
            onPressed: () => Get.back(),
            child: Text('NO', style: TextStyle(color: secondaryColor)),
          ),
          MaterialButton(
            onPressed: () async {
              Get.back();
              final res = await OpenFile.open(fileDir,
                  type: lookupMimeType(fileDir));
              if (res.type != ResultType.done) {
                Get.rawSnackbar(
                  message: res.message,
                  duration: Duration(milliseconds: 1500),
                  isDismissible: true,
                  title: 'Error',
                );
              }
            },
            child: Text(
              'YES',
              style: TextStyle(color: secondaryColor),
            ),
          ),
        ]);
  }
}


class DownloadErrorDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Error has been occurred'),
      content: Text(':('),
    );
  }
}

