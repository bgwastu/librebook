
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:librebook/app_localizations.dart';
import 'package:librebook/controllers/settings_controller.dart';
import 'package:librebook/ui/shared/ui_helper.dart';
import 'package:package_info/package_info.dart';

class SettingView extends StatelessWidget {
  final _settingsController = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Obx(
          () => SwitchListTile(
            title: Text(AppLocalizations.of(context).translate('dark-mode'),
                style: Theme.of(context).textTheme.bodyText1),
            activeColor: Get.theme.primaryColor,
            subtitle: Text('Switch to dark mode'),
            secondary: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Icon(Icons.brightness_4),
            ),
            value: _settingsController.isDarkMode.value,
            onChanged: (val) => _settingsController.setDarkMode(val),
          ),
        ),
        
        Divider(
          height: 2,
          thickness: 1,
        ),
        ListTile(
          title: Text(
            AppLocalizations.of(context).translate('about'),
          
            style: Get.textTheme.bodyText1,
          ),
          subtitle: Text('About this app'),
          leading: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Icon(
              Icons.info_outline,
              size: 26,
            ),
          ),
          onTap: () async {
            final packageInfo = await PackageInfo.fromPlatform();
            showAboutDialog(
              context: context,
              applicationIcon: Container(
                  width: 60,
                  height: 60,
                  child: Image.asset('assets/icon/icon.png')),
              applicationVersion: 'v' + packageInfo.version,
              children: [
                verticalSpaceMedium,
                Text(
                  AppLocalizations.of(context)
                      .translate('librebook-description'),
                  style: TextStyle(fontSize: 14),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
