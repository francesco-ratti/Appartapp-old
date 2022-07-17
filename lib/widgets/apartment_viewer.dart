import 'package:appartapp/entities/apartment.dart';
import 'package:appartapp/entities/user.dart';
import 'package:appartapp/utils_classes/runtime_store.dart';
import 'package:appartapp/widgets/apartment_model.dart';
import 'package:appartapp/widgets/tab_widget.dart';
import 'package:appartapp/widgets/tab_widget_loading.dart';
import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ApartmentViewer extends StatelessWidget {
  final bool apartmentLoaded;
  final Apartment? currentApartment;
  final User? owner;
  final bool showContact;

  const ApartmentViewer(
      {Key? key,
      required this.apartmentLoaded,
      required this.currentApartment,
      this.owner,
      this.showContact = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: RuntimeStore.backgroundColor,
        child: RuntimeStore().useMobileLayout
            ? mobileLayout(
                apartmentLoaded, currentApartment, owner, showContact)
            : tabletLayout(
                apartmentLoaded, currentApartment, owner, showContact));
  }
}

SlidingUpPanel mobileLayout(bool apartmentLoaded, Apartment? currentApartment,
    User? owner, bool showContact) {
  return SlidingUpPanel(
    color: Colors.transparent.withOpacity(0.7),
    borderRadius: const BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    ),
    isDraggable: apartmentLoaded && currentApartment != null,
    panelBuilder: (scrollController) => apartmentLoaded
        ? TabWidget(
            scrollController: scrollController,
            currentApartment: currentApartment as Apartment,
            owner: owner,
            showContact: showContact,
          )
        : const TabWidgetLoading(),
    body: apartmentLoaded
        ? ApartmentModel(currentApartment: currentApartment as Apartment)
        : const Center(
            child: CircularProgressIndicator(
            value: null,
          )),
  );
}

Row tabletLayout(bool apartmentLoaded, Apartment? currentApartment, User? owner,
    bool showContact) {
  return Row(
    children: [
      Expanded(
        flex: 100,
        child: apartmentLoaded
            ? ApartmentModel(currentApartment: currentApartment as Apartment)
            : const Center(
                child: CircularProgressIndicator(
                value: null,
              )),
      ),
      Expanded(
          flex: 1,
          child: Blur(
              child: Container(
            color: Colors.brown,
          ))),
      Expanded(
        flex: 50,
        child: apartmentLoaded
            ? TabWidget(
                scrollController: ScrollController(),
                currentApartment: currentApartment as Apartment,
                owner: owner,
                showContact: showContact,
              )
            : const TabWidgetLoading(),
      )
    ],
  );
}
