
<p align="center"><img width=12.5% src="screenshots/app_icon.png"></p>
<h1 align="center">Librebook</h1>
<h4 align="center">A minimal front-end library genesis client, built by Flutter</h4>

<p align="center">
  <img alt="GitHub issues" src="https://img.shields.io/github/issues/bagaswastu/librebook">
  <img alt="Codemagic" src="https://api.codemagic.io/apps/6003d2461b08f3ec61b49785/6003d2461b08f3ec61b49784/status_badge.svg">
  <img alt="GitHub release (latest by date including pre-releases)" src="https://img.shields.io/github/v/release/bagaswastu/librebook?include_prereleases">
  <img alt="GitHub" src="https://img.shields.io/github/license/bagaswastu/librebook">
</p>

Note: This project is now archived. See: https://github.com/atticdev/librebook/issues/12#issuecomment-922854960

## Description
Librebook is an open-source front-end application to help the users download the book easily from library genesis.

## Features
- [x] General book download
- [x] Fantasy book download
- [x] IPFS download mirror
- [x] Change download location
- [x] Dark mode
- [ ] Syncronize scraper settings (on progress)
- [ ] Search history (on progress)

## Screenshots
<table>
  <tr align="center">
    <td><img src="screenshots/1.png" width="441"/></td>
    <td><img src="screenshots/3.png" width="441"/></td>
    <td><img src="screenshots/downloading.gif" width="441" /></td>
  </tr> 
</table>

## Download
You can download the application from [Codemagic](https://codemagic.io/apps/6003d2461b08f3ec61b49785/6003d2461b08f3ec61b49784/latest_build) by downloading **app-release.apk**.

## Contributing
Any contributions you make are **greatly appreciated**. However, for major changes, please open an issue first to discuss what you would like to change.

### Languages
You can add localizations by creating a json file in `lang/[LANGUAGE_CODE].json` and adding the language to `supportedLocales` in [`lib/main.dart`](https://github.com/bagaswastu/librebook/blob/master/lib/main.dart#) and [`lib/app_localizations.dart`](https://github.com/bagaswastu/librebook/blob/master/lib/app_localizations.dart)

## License
Distributed under the MIT License. See [LICENSE](LICENSE) for more information.
