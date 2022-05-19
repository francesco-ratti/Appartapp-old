import 'dart:ui';

import 'package:appartapp/classes/like_from_user.dart';
import 'package:appartapp/classes/user.dart';
import 'package:appartapp/classes/runtime_store.dart';
import 'package:appartapp/widgets/tenant_model.dart';
import 'package:appartapp/widgets/tab_widget_tenant.dart';
import 'package:appartapp/widgets/tab_widget_loading.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class TenantViewer extends StatelessWidget {
  bool tenantLoaded;
  LikeFromUser? currentLikeFromUser;

  TenantViewer(
      {Key? key, required this.tenantLoaded, required this.currentLikeFromUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: RuntimeStore.backgroundColor,
      child: (currentLikeFromUser == null) ? (Center(
          child: Text("no tenants",
          style: TextStyle(
            color: Colors.white
          ),)
      )) : SlidingUpPanel(
        color: Colors.transparent.withOpacity(0.7),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
        isDraggable: tenantLoaded,
        panelBuilder: (scrollController) => tenantLoaded
            ? TabWidgetTenant(
                scrollController: scrollController,
                currentTenant: currentLikeFromUser!.user)
            : TabWidgetLoading(),
        body: tenantLoaded
            ? TenantModel(currentTenant: currentLikeFromUser!.user)
            : Center(
                child: CircularProgressIndicator(
                value: null,
              )),
      ),
    );
  }
}
