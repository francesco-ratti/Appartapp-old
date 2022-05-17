import 'package:appartapp/classes/user.dart';
import 'package:flutter/material.dart';

class TenantModel extends StatefulWidget {
  User currentTenant;

  TenantModel({
    required this.currentTenant,
  });

  @override
  _TenantModel createState() => _TenantModel();
}

class _TenantModel extends State<TenantModel> {
  int currentIndex = 0;
  int numImages = 0;

  @override
  void initState() {
    super.initState();
    numImages = widget.currentTenant.images.length;
  }

  @override
  void didUpdateWidget(covariant TenantModel oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    numImages = widget.currentTenant.images.length;
    currentIndex = 0;
  }

  @override
  Widget build(BuildContext context) =>
      Stack(fit: StackFit.expand, children: <Widget>[
        widget.currentTenant.images[currentIndex],
        GestureDetector(
          onTapUp: (TapUpDetails details) {
            final RenderBox? box = context.findRenderObject() as RenderBox;
            final localOffset = box!.globalToLocal(details.globalPosition);
            final x = localOffset.dx;

            // if x is less than halfway across the screen and user is not on first image
            if (x < box.size.width / 2) {
              setState(() {
                if (currentIndex > 0) {
                  setState(() {
                    currentIndex--;
                  });
                }
              });
            } else {
              // Assume the user tapped on the other half of the screen and check they are not on the last image
              if (currentIndex < numImages - 1) {
                setState(() {
                  currentIndex++;
                });
              }
            }
          },
        )
      ]);
}
