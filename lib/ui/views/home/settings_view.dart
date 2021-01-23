import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:librebook/app_localizations.dart';
import 'package:librebook/controllers/settings_controller.dart';
import 'package:librebook/ui/shared/theme.dart';
import 'package:librebook/ui/shared/ui_helper.dart';
import 'package:librebook/ui/widgets/folder_picker/folder_picker.dart';
import 'package:librebook/ui/widgets/folder_picker/picker_common.dart';

class SettingView extends StatelessWidget {
  final _settingsController = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(top: 8, left: 8, right: 8),
      children: [
        ListTile(
            title: Text(
                AppLocalizations.of(context).translate('download-location')),
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
                Icons.save_outlined,
                size: 26,
              ),
            ),
            onTap: () async {
              var newDirectory = await FilesystemPicker.open(
                context: context,
                rootDirectory: Directory('/storage/emulated/0'),
                fsType: FilesystemType.folder,
                title:
                    AppLocalizations.of(context).translate('download-location'),
                rootName:
                    AppLocalizations.of(context).translate('internal-storage'),
                pickText: AppLocalizations.of(context)
                    .translate('download-location-save'),
                folderIconColor: primaryColor,
              );

              print(newDirectory);

              if (newDirectory != null) {
                // Do something with the picked directory
                _settingsController.setDownloadLocation(newDirectory);
              }
            }),
        Divider(
          height: 2,
          thickness: 1,
        ),
        Obx(
          () => SwitchListTile(
            // TODO: add localization context
            title: Text('Dark mode'),
            secondary: Icon(Icons.brightness_4),
            value: _settingsController.isDarkMode.value,
            onChanged: (val) => _settingsController.setDarkMode(val),
          ),
        ),
        Divider(
          height: 2,
          thickness: 1,
        ),
        ListTile(
          title: Text(AppLocalizations.of(context).translate('synchronize')),
          subtitle: Text(AppLocalizations.of(context)
              .translate('get-default-scraper-settings')),
          leading: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Icon(
              Icons.sync,
              size: 26,
            ),
          ),
          onTap: () {
            //TODO; implement synchronize settings
            Get.rawSnackbar(
                title:
                    AppLocalizations.of(context).translate('under-development'),
                message: AppLocalizations.of(context)
                    .translate('under-development-message'),
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
          title: Text(AppLocalizations.of(context).translate('about')),
          leading: Icon(
            Icons.info_outline,
            size: 26,
          ),
          onTap: () {
            Get.dialog(AboutDialog(
              applicationIcon: Container(
                  width: 60,
                  height: 60,
                  child: Image.asset('assets/icon/icon.png')),
              applicationVersion: 'v0.1-alpha',
              applicationLegalese: '© 2021 Bagas Wastu',
              children: [
                verticalSpaceMedium,
                Text(
                  AppLocalizations.of(context)
                      .translate('librebook-description'),
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ));
          },
        ),
      ],
    );
  }
}
