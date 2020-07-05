import 'package:auto_route/auto_route_annotations.dart';
import 'package:librebook/ui/views/home/home_view.dart';
import 'package:librebook/ui/views/splash/splash_view.dart';

@MaterialAutoRouter(routes: [
  MaterialRoute(page: SplashView, initial: true),
  MaterialRoute(page: HomeView),
])
class $Router {}
