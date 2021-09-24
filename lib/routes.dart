import 'package:findmee/admin/login.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Flurorouter {
  static final FluroRouter router = FluroRouter();

  static Handler _adminHandler = Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params)=>AdminLogin());

  static void defineRoutes() {
    router.define("/admin", handler: _adminHandler);
  }
}

