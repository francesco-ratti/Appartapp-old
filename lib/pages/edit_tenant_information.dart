import 'package:appartapp/entities/user.dart';
import 'package:appartapp/enums/enum_month.dart';
import 'package:appartapp/enums/enum_temporalq.dart';
import 'package:appartapp/model/user_handler.dart';
import 'package:appartapp/utils_classes/runtime_store.dart';
import 'package:appartapp/widgets/error_dialog_builder.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class EditTenantInformation extends StatefulWidget {
  final Color bgColor = Colors.white;

  final User user = RuntimeStore().getUser() as User;

  EditTenantInformation({Key? key}) : super(key: key);

  @override
  _EditTenantInformationState createState() => _EditTenantInformationState();
}

class YesNoForList {
  String name;
  bool value;

  YesNoForList(this.name, this.value);
}

class _EditTenantInformationState extends State<EditTenantInformation> {
  bool _isLoading = false;

  //Function()? updatedCallback=null;

  final bioController = TextEditingController();
  final reasonController = TextEditingController();
  final jobController = TextEditingController();
  final incomeController = TextEditingController();
  final petsController = TextEditingController();

  static YesNoForList yesYN = YesNoForList("Sì", true);
  static YesNoForList noYN = YesNoForList("No", false);

  Month? _month;
  TemporalQ? _smokerTQ;

  YesNoForList? _petsItem;
  final List<YesNoForList> _petsEntries = <YesNoForList>[yesYN, noYN];

  @override
  void initState() {
    super.initState();

    if (widget.user.bio.isNotEmpty) bioController.text = widget.user.bio;

    if (widget.user.reason.isNotEmpty) {
      reasonController.text = widget.user.reason;
    }

    if (widget.user.job.isNotEmpty) jobController.text = widget.user.job;

    _month = widget.user.month;
    _smokerTQ = widget.user.smoker;

    if (widget.user.hasSelectedPets()) {
      if (widget.user.hasPets()) {
        petsController.text = widget.user.pets;
        _petsItem = yesYN;
      } else {
        _petsItem = noYN;
      }
    } else {
      _petsItem = null;
    }

    if (widget.user.income.isNotEmpty) {
      incomeController.text = widget.user.income;
    }
  }

  /*
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (updatedCallback==null) {
      var fun = ModalRoute
          .of(context)!
          .settings
          .arguments;
      if (fun != null) {
        updatedCallback = fun as Function();
      }
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Le tue info da locatario'),
          backgroundColor: Colors.brown,
        ),
        body: ModalProgressHUD(
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "Queste informazioni verranno visualizzate nel tuo profilo dai proprietari degli appartamenti a cui metti like. Finchè non fornisci queste informazioni non potrai cercare appartamenti.",
                  style: TextStyle(color: Colors.black54),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    obscureText: false,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Bio',
                    ),
                    controller: bioController,
                  )),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    obscureText: false,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Perchè cerchi un appartamento?',
                    ),
                    controller: reasonController,
                  )),
              const Padding(
                  padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
                  child: Text("Mese in cui cerchi un appartamento")),
              Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
                  child: DropdownButton<Month>(
                    value: _month,
                    hint: const Text("Mese in cui cerchi un appartamento"),
                    // Not necessary for Option 1
                    onChanged: (newValue) {
                      setState(() {
                        _month = newValue!;
                      });
                    },
                    items: Month.values.map((monthItem) {
                      return DropdownMenuItem<Month>(
                        child: Text(monthItem.name),
                        value: monthItem,
                      );
                    }).toList(),
                  )),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    obscureText: false,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Che fai nella vita?',
                    ),
                    controller: jobController,
                  )),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    obscureText: false,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Introito medio mensile',
                    ),
                    controller: incomeController,
                  )),
              const Padding(
                  padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
                  child: Text("Fumi?")),
              Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
                  child: DropdownButton<TemporalQ>(
                    value: _smokerTQ,
                    hint: const Text("Fumi?"),
                    // Not necessary for Option 1
                    onChanged: (newValue) {
                      setState(() {
                        _smokerTQ = newValue!;
                      });
                    },
                    items: TemporalQ.values.map((temporalQv) {
                      return DropdownMenuItem(
                        child: Text(temporalQv.toItalianString()),
                        value: temporalQv,
                      );
                    }).toList(),
                  )),
              const Padding(
                  padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
                  child: Text("Hai animali domestici?")),
              Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
                  child: DropdownButton<YesNoForList>(
                    value: _petsItem,
                    hint: const Text("Hai animali domestici?"),
                    // Not necessary for Option 1
                    onChanged: (newValue) {
                      setState(() {
                        if (newValue != null) {
                          if (!newValue.value) {
                            /* user has selected no pets */
                            petsController.text = "";
                          }
                          setState(() {
                            _petsItem = newValue;
                          });
                        }
                      });
                    },
                    items: _petsEntries.map((temporalQv) {
                      return DropdownMenuItem(
                        child: Text(temporalQv.name),
                        value: temporalQv,
                      );
                    }).toList(),
                  )),
              (_petsItem != null && _petsItem!.value == true)
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        obscureText: false,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Quali?',
                        ),
                        controller: petsController,
                      ))
                  : const SizedBox(),
              ElevatedButton(
                  child: const Text("Modifica"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
                  onPressed: () {
                    String bio = bioController.text.trim();
                    String reason = reasonController.text.trim();
                    String job = jobController.text.trim();
                    String income = incomeController.text.trim();
                    String pets = petsController.text.trim();

                    setState(() {
                      _isLoading = true;
                    });

                    UserHandler.editTenantInformation(
                        bio,
                        reason,
                        job,
                        income,
                        _petsItem == noYN ? "No" : pets,
                        _month,
                        _smokerTQ, (User user) {
                      //onComplete
                      RuntimeStore().setUser(user);
                      Function() cbk = RuntimeStore().tenantInfoUpdated;
                      cbk();
                                          Navigator.pop(context);
                    }, () {
                      //onError
                      setState(() {
                        _isLoading = false;
                      });

                      Navigator.restorablePush(context,
                          ErrorDialogBuilder.buildConnectionErrorRoute);
                    });
                  }),
            ],
          ),
          inAsyncCall: _isLoading,
          // demo of some additional parameters
          opacity: 0.5,
          progressIndicator: const CircularProgressIndicator(),
        ));
  }
}
