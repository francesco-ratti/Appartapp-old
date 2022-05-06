import 'package:appartapp/classes/apartment.dart';
import 'package:appartapp/classes/runtime_store.dart';
import 'package:appartapp/widgets/apartment_model.dart';
import 'package:appartapp/widgets/tab_widget.dart';
import 'package:appartapp/widgets/tab_widget_loading.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ApartmentViewer extends StatelessWidget {

  bool apartmentLoaded;
  Apartment currentApartment;

  ApartmentViewer({Key? key, required this.apartmentLoaded, required this.currentApartment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container (
      color: RuntimeStore.backgroundColor,
      child: SlidingUpPanel(
        color: Colors.transparent.withOpacity(0.7),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
        isDraggable: apartmentLoaded,
        panelBuilder: (scrollController) =>
        apartmentLoaded ? TabWidget(
            scrollController: scrollController,
            currentApartment: currentApartment) : TabWidgetLoading(),
        body: apartmentLoaded ? ApartmentModel(currentApartment: currentApartment) : Center(
            child: CircularProgressIndicator(
              value: null,
            )),
      ),
    );
  }
}
