import 'dart:developer';
import 'package:auto_login/src/config/app_exception.dart';
import 'package:auto_login/src/config/config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';

void handleError(Response response) {
  if (response.hasError) {
    if (response.status.isNotFound) {
      throw Exception(response.statusText);
    } else {
      throw Exception(response.body['message']);
    }
  }
}

logRequestData(Response response) {
  log('Calling API: ${response.request!.url.toString()}');
  log('Headers: ${response.request!.headers}');
  log('Status Code: ${response.statusCode}');
  log('Response: ${response.bodyString}');
}

Future actionHandler(BuildContext context, AsyncCallback action) async {
  context.loaderOverlay.show();
  try {
    await action();
  } on AppException catch (e, stackTrace) {
    if (kDebugMode) {
      print(stackTrace);
      log(e.toString());
    }
    Get.snackbar(e.prefix.tr, e.message.tr);
    // await Sentry.captureException(
    //   e,
    //   stackTrace: stackTrace,
    // );
  } catch (e, stackTrace) {
    if (kDebugMode) {
      print(stackTrace);
      log(e.toString());
    }
    // await Sentry.captureException(
    //   e,
    //   stackTrace: stackTrace,
    // );
    Get.snackbar(tkErrorTitle, tkSomethingWentWrongMessage.tr);
  } finally {
    context.loaderOverlay.hide();
  }
}
