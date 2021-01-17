import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:librebook/controllers/settings_controller.dart';
import 'package:librebook/ui/shared/theme.dart';
import 'package:librebook/ui/shared/ui_helper.dart';
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
            //TODO; implement download location
            Get.rawSnackbar(
                title: 'Under development',
                message: 'This feature is still under development',
                icon: Icon(
                  Icons.warning,
                  color: Colors.white,
                ),
                animationDuration: Duration(milliseconds: 500),
                duration: Duration(milliseconds: 1500));
          },
        ),
        Divider(
          height: 2,
          thickness: 1,
        ),
        ListTile(
          title: Text('Synchronize'),
          subtitle: Text('Get default scraper settings'),
          leading: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Icon(
              Icons.sync,
              color: Colors.grey[700],
              size: 26,
            ),
          ),
          onTap: () {
            //TODO; implement synchronize settings
            Get.rawSnackbar(
                title: 'Under development',
                message: 'This feature is still under development',
                icon: Icon(
                  Icons.warning,
                  color: Colors.white,
                ),
                animationDuration: Duration(milliseconds: 500),
                duration: Duration(milliseconds: 1500));
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
                applicationIcon: Container(
                    width: 60,
                    height: 60,
                    child: Image.asset('assets/icon/icon.png')),
                applicationVersion: 'v0.1-alpha',
                applicationLegalese: '© 2021 Bagas Wastu',
                children: [
                  verticalSpaceMedium,
                  Text(
                    'Librebook is an open-source to help the users get content easly from Libgen.\n\nJust rembember that this application has no affiliation whatsoever with Libgen.',
                    style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                  ),
                ],
              ),
            ));
          },
        ),
      ],
    );
  }
}
