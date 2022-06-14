import 'package:appartapp/classes/like_from_user.dart';
import 'package:appartapp/classes/runtime_store.dart';
import 'package:appartapp/widgets/tab_widget_lessor.dart';
import 'package:appartapp/widgets/tenant_model.dart';
import 'package:appartapp/widgets/tab_widget_tenant.dart';
import 'package:appartapp/widgets/tab_widget_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class TenantViewer extends StatefulWidget {
  bool tenantLoaded;
  bool lessor; //if you want to visualize a lessor set true,
  LikeFromUser? currentLikeFromUser;
  Function(bool value) updateUI;
  bool match;

  TenantViewer(
      {Key? key,
      required this.tenantLoaded,
      required this.lessor,
      this.currentLikeFromUser,
      required this.updateUI,
      required this.match})
      : super(key: key);

  @override
  _TenantViewer createState() => _TenantViewer();
}

class _TenantViewer extends State<TenantViewer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: RuntimeStore.backgroundColor,
      child: (widget.currentLikeFromUser == null)
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
              isDraggable: widget.tenantLoaded,
              panelBuilder: (scrollController) => !widget.tenantLoaded
                  ? TabWidgetLoading()
                  : widget.lessor
                      ? TabWidgetLessor(
                          scrollController: scrollController,
                          currentLessor: widget.currentLikeFromUser!.user)
                      : TabWidgetTenant(
                          scrollController: scrollController,
                          currentTenant: widget.currentLikeFromUser!.user,
                          apartment: widget.currentLikeFromUser!.apartment,
                          match: widget.match,
                          updateUi: widget.updateUI,
                        ),
              body: widget.tenantLoaded
                  ? TenantModel(
                      currentTenant: widget.currentLikeFromUser!.user,
                      lessor: widget.lessor,
                      match: widget.match)
                  : Center(
                      child: CircularProgressIndicator(
                      value: null,
                    )),
              defaultPanelState:
                  widget.lessor ? PanelState.CLOSED : PanelState.OPEN,
            ),
    );
  }
}
