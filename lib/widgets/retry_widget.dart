import 'package:flutter/material.dart';

class RetryWidget extends StatelessWidget {
  final Function() retryCallback;
  final String message;
  final Color textColor;
  final Color? backgroundColor;
  final String retryButtonText;

  const RetryWidget(
      {Key? key,
      required this.retryCallback,
      required this.textColor,
      this.message =
          "Impossibile connettersi.\nControlla la connessione e riprova",
      this.backgroundColor,
      this.retryButtonText = "Riprova"})
      : super(key: key);

  Widget buildBody() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
        child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 8.0),
                  child: Text(
                    message,
                    style: TextStyle(color: textColor),
                    textAlign: TextAlign.center,
                  )),
              ElevatedButton(
                  child: Text(retryButtonText, style: const TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
                  onPressed: retryCallback)
            ])));
  }

  @override
  Widget build(BuildContext context) {
    return backgroundColor != null
        ? Container(
            child: buildBody(),
            color: backgroundColor,
          )
        : buildBody();
  }
}
