import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:librebook/app_localizations.dart';
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
              ? Text(AppLocalizations.of(context).translate('downloading'))
              : Text(AppLocalizations.of(context).translate('waiting-for-server-reply'))
          : Text(AppLocalizations.of(context).translate('downloading')),
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
                    Text(progress.toString() + '%', style: Theme.of(Get.context).textTheme.subtitle2,),
                    Text(
                      Constants.formatBytes(received, 1) +
                          ' ' +
                          AppLocalizations.of(context).translate('of') +
                          ' ' +
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
        title: Text(AppLocalizations.of(context).translate('download-completed')),
        content: Text(AppLocalizations.of(context).translate('do-you-want-to-open-the-book')),
        actions: [
          MaterialButton(
            onPressed: () => Get.back(),
            child: Text(AppLocalizations.of(context).translate('no').toUpperCase(), style: TextStyle(color: secondaryColor)),
          ),
          MaterialButton(
            onPressed: () async {
              Get.back();
              final res = await OpenFile.open(fileDir, type: lookupMimeType(fileDir));
              if (res.type != ResultType.done) {
                Get.rawSnackbar(
                  message: res.message,
                  duration: Duration(milliseconds: 1500),
                  isDismissible: true,
                  title: AppLocalizations.of(context).translate('error'),
                );
              }
            },
            child: Text(
              AppLocalizations.of(context).translate('yes').toUpperCase(),
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
      title: Text(AppLocalizations.of(context).translate('error-occurred')),
      content: Text(AppLocalizations.of(context).translate('check-internet-error')),
    );
  }
}
