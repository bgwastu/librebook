import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:librebook/controllers/settings_controller.dart';
import 'package:librebook/ui/shared/theme.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

class SettingView extends StatelessWidget {
  final _settingsController = SettingsController();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(top: 16, left: 8, right: 8),
      children: [
        ListTile(
          title: Text('Download location'),
          subtitle: FutureBuilder(
            future: _settingsController.getDownloadLocation(),
            builder: (_, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data);
              } else {
                return Container();
              }
            },
          ),
          leading: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Icon(
              OMIcons.saveAlt,
              color: Colors.grey[700],
              size: 26,
            ),
          ),
          onTap: () async {
            // Directory newDirectory = await DirectoryPicker.pick(
            //     context: context,
            //     rootDirectory: await defaultDownloadLocation
            // );
            //
            // if (newDirectory != null) {
            //   // Do something with the picked directory
            //   print(newDirectory.path);
            //
            // } else {
            //   // User cancelled without picking any directory
            // }
          },
        ),
        Divider(
          height: 2,
          thickness: 1,
        ),
        ListTile(
          title: Text('About'),
          leading: Icon(
            OMIcons.info,
            color: Colors.grey[700],
            size: 26,
          ),
          onTap: () {
            Get.dialog(Theme(
              data: ThemeData(primaryColor: secondaryColor),
              child: AboutDialog(
                applicationVersion: 'v0.1-alpha',
              ),
            ));
          },
        ),
      ],
    );
  }
}
