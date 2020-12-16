import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:librebook/controllers/settings_controller.dart';
import 'package:librebook/ui/shared/string.dart';
import 'package:librebook/ui/shared/theme.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingView extends StatefulWidget {
  @override
  _SettingViewState createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  final _settingsController = SettingsController();

  @override
  void initState() {
    super.initState();
    _settingsController.getAll();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(top: 16, left: 8, right: 8),
      children: [
        Card(
          color: Colors.amber,
          child: Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 16, right: 8, left: 8),
            child: Text('Currently under development', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Mirror',
            style: TextStyle(
                color: secondaryColor,
                fontSize: 14,
                fontWeight: FontWeight.w600),
          ),
        ),
        ListTile(
          title: Text('General book'),
          subtitle: Text('Libgen general category scraping url'),
          leading: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Icon(
              Icons.link,
              color: Colors.grey[700],
              size: 26,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
          onTap: () async {
            final mirror1 = await _settingsController.getGeneralMirror1();
            final mirror2 = await _settingsController.getGeneralMirror2();
            Get.dialog(AlertDialog(
              title: Text('General Book URL'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    initialValue: mirror1,
                    decoration: InputDecoration(
                      labelText: 'Mirror 1',
                    ),
                    onChanged: (value) =>
                        _settingsController.generalBookMirror1.value = value,
                  ),
                  TextFormField(
                    initialValue: mirror2,
                    decoration: InputDecoration(
                      labelText: 'Mirror 2',
                    ),
                    onChanged: (value) =>
                        _settingsController.generalBookMirror2.value = value,
                  ),
                ],
              ),
              actions: [
                MaterialButton(
                  onPressed: () async {
                    await _settingsController.setGeneralMirror1();
                    await _settingsController.setGeneralMirror2();
                    Get.back();
                  },
                  child: Text(
                    'Save',
                    style: TextStyle(color: secondaryColor),
                  ),
                )
              ],
            ));
          },
        ),
        Divider(
          height: 2,
          thickness: 1,
        ),
        ListTile(
          title: Text('Fantasy book'),
          subtitle: Text('Libgen fantasy category scraping url'),
          leading: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Icon(
              Icons.link,
              color: Colors.grey[700],
              size: 26,
            ),
          ),
          onTap: () async {
            final mirror1 = await _settingsController.getFictionMirror1();
            final mirror2 = await _settingsController.getFictionMirror2();
            Get.dialog(AlertDialog(
              title: Text('Fiction Book URL'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    initialValue: mirror1,
                    decoration: InputDecoration(
                      labelText: 'Mirror 1',
                    ),
                    onChanged: (value) =>
                        _settingsController.fictionBookMirror1.value = value,
                  ),
                  TextFormField(
                    initialValue: mirror2,
                    decoration: InputDecoration(
                      labelText: 'Mirror 2',
                    ),
                    onChanged: (value) =>
                        _settingsController.fictionBookMirror2.value = value,
                  ),
                ],
              ),
              actions: [
                MaterialButton(
                  onPressed: () async {
                    await _settingsController.setFictionMirror1();
                    await _settingsController.setFictionMirror2();
                    Get.back();
                  },
                  child: Text(
                    'Save',
                    style: TextStyle(color: secondaryColor),
                  ),
                )
              ],
            ));
          },
        ),
        Divider(
          height: 2,
          thickness: 1,
        ),
        ListTile(
          title: Text('Libgen url'),
          subtitle: Obx(() => Text(_settingsController.libgenUrl?.value)),
          leading: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Icon(
              Icons.link,
              color: Colors.grey[700],
              size: 26,
            ),
          ),
          onTap: () async {
            final libgenUrl = await _settingsController.getLibgenUrl();
            Get.dialog(AlertDialog(
              title: Text('Libgen URL'),
              content: TextFormField(
                initialValue: libgenUrl,
                decoration: InputDecoration(
                  labelText: 'Mirror 2',
                ),
                onChanged: (value) =>
                    _settingsController.libgenUrl.value = value,
              ),
              actions: [
                MaterialButton(
                  onPressed: () async {
                    await _settingsController.setLibgenUrl();
                    Get.back();
                    Get.reset();
                  },
                  child: Text(
                    'Save',
                    style: TextStyle(color: secondaryColor),
                  ),
                )
              ],
            ));
          },
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Others',
            style: TextStyle(
                color: secondaryColor,
                fontSize: 14,
                fontWeight: FontWeight.w600),
          ),
        ),
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
          onTap: () {},
        ),
      ],
    );
  }
}
