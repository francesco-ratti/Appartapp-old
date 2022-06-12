import 'package:appartapp/classes/like_from_user.dart';
import 'package:appartapp/classes/runtime_store.dart';
import 'package:appartapp/widgets/tab_widget_lessor.dart';
import 'package:appartapp/widgets/tenant_model.dart';
import 'package:appartapp/widgets/tab_widget_tenant.dart';
import 'package:appartapp/widgets/tab_widget_loading.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class TenantViewer extends StatelessWidget {
  bool tenantLoaded;
  bool lessor; //if you want to visualize a lessor set true,
  LikeFromUser? currentLikeFromUser;

  TenantViewer(
      {Key? key,
      required this.tenantLoaded,
      required this.lessor,
      this.currentLikeFromUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: RuntimeStore.backgroundColor,
      child: (currentLikeFromUser == null)
          ? (Center(
              child: Text(
              "Nessun nuovo utente",
              style: TextStyle(color: Colors.white),
            )))
          : SlidingUpPanel(
              color: Colors.transparent.withOpacity(0.7),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.0),
                topRight: Radius.circular(24.0),
              ),
              isDraggable: tenantLoaded,
              panelBuilder: (scrollController) => !tenantLoaded
                  ? TabWidgetLoading()
                  : lessor
                      ? TabWidgetLessor(
                          scrollController: scrollController,
                          currentLessor: currentLikeFromUser!.user)
                      : TabWidgetTenant(
                          scrollController: scrollController,
                          currentTenant: currentLikeFromUser!.user,
                          apartment: currentLikeFromUser!.apartment,
                          locked: true,
                        ),
              body: tenantLoaded
                  ? TenantModel(
                      currentTenant: currentLikeFromUser!.user,
                      lessor: lessor,
                    )
                  : Center(
                      child: CircularProgressIndicator(
                      value: null,
                    )),
              defaultPanelState: lessor ? PanelState.CLOSED : PanelState.OPEN,
            ),
    );
  }
}
