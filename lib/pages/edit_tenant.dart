import 'package:appartapp/classes/enum_month.dart';
import 'package:appartapp/classes/runtime_store.dart';
import 'package:appartapp/classes/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:appartapp/classes/enum_temporalq.dart';

class EditTenant extends StatefulWidget {
  String urlStr = "http://ratti.dynv6.net/appartapp-1.0-SNAPSHOT/api/reserved/edituser";
  Color bgColor = Colors.white;

  User user=RuntimeStore().getUser() as User;

  @override
  _EditTenantState createState() => _EditTenantState();
}

class YesNoForList{
  String name;
  bool value;

  YesNoForList(this.name, this.value);
}

class _EditTenantState extends State<EditTenant> {

  void doUpdate(Function(String) updateUi, String bio, String reason, String job,
      String income, String pets, Month? month, TemporalQ? smoker) async {

    var dio = Dio();
    try {
      Response response = await dio.post(
        widget.urlStr,
        data: {
          "email": RuntimeStore().getEmail(),
          "password": RuntimeStore().getPassword(),
          "bio": bio,
          "reason": reason,
          "job": job,
          "income": income,
          "pets": pets,
          "month": month==null ? "" : month.toShortString(),
          "smoker": smoker==null ? "" : smoker.toShortString()
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
        ),
      );

      if (response.statusCode != 200)
        updateUi("Failure");
      else {
        updateUi("Updated");
        Map responseMap = response.data;
        RuntimeStore().setUser(User.fromMap(responseMap));
        Navigator.pop(context);
      }
    } on DioError catch (e) {
      if (e.response?.statusCode != 200) {
        updateUi("Failure");
      }
    }
  }

  final bioController = TextEditingController();
  final reasonController = TextEditingController();
  final jobController=TextEditingController();
  final incomeController=TextEditingController();
  final petsController=TextEditingController();

  static YesNoForList yesYN=YesNoForList("Sì", true);
  static YesNoForList noYN=YesNoForList("No", false);

  Month? _month=null;
  TemporalQ? _smokerTQ=null;

  YesNoForList? _petsItem=null;
  List<YesNoForList> _petsEntries=<YesNoForList>[
    yesYN,
    noYN
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.user.bio.isNotEmpty)
      bioController.text=widget.user.bio;

    if (widget.user.reason.isNotEmpty)
      reasonController.text=widget.user.reason;

    if (widget.user.job.isNotEmpty)
      jobController.text=widget.user.job;

    _month=widget.user.month;
    _smokerTQ=widget.user.smoker;

    if (widget.user.hasPets()) {
      petsController.text = widget.user.pets;
      _petsItem=yesYN;
    } else {
      _petsItem=noYN;
    }

    if (widget.user.income.isNotEmpty)
      incomeController.text=widget.user.income;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Le tue info da locatario')),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Queste informazioni verranno visualizzate nel tuo profilo dai proprietari degli appartamenti a cui metti like. Finchè non fornisci queste informazioni non potrai cercare appartamenti."),
          ),
          Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                obscureText: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Bio',
                ),
                controller: bioController,
              )),
          Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                obscureText: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Perchè cerchi un appartamento?',
                ),
                controller: reasonController,
              )),
          Padding(
              padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
              child: Text("Mese in cui cerchi un appartamento")),
          Padding(
              padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
              child: DropdownButton<Month>(
                value: _month,
                hint: Text("Mese in cui cerchi un appartamento"),
                // Not necessary for Option 1
                onChanged: (newValue) {
                  setState(() {
                    _month = newValue!;
                  });
                },
                items: Month.values.map((monthItem) {
                  return DropdownMenuItem<Month>(
                    child: new Text(monthItem.name),
                    value: monthItem,
                  );
                }).toList(),
              )),

          Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                obscureText: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Che lavoro fai?',
                ),
                controller: jobController,
              )),
          Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                obscureText: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Introito medio mensile',
                ),
                controller: incomeController,
              )),
          Padding(
              padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
              child: Text("Fumi?")),
          Padding(
              padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
              child: DropdownButton<TemporalQ>(
                value: _smokerTQ,
                hint: Text("Fumi?"),
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
          Padding(
              padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
              child: Text("Hai animali domestici?")),
          Padding(
              padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
              child: DropdownButton<YesNoForList>(
                value: _petsItem,
                hint: Text("Hai animali domestici?"),
                // Not necessary for Option 1
                onChanged: (newValue) {
                  setState(() {
                    if (newValue!=null) {
                      if (!newValue.value)
                        petsController.text="";
                      setState(() {
                        _petsItem = newValue;
                      });
                    }
                  });
                },
                items: _petsEntries.map((temporalQv) {
                  return DropdownMenuItem(
                    child: new Text(temporalQv.name),
                    value: temporalQv,
                  );
                }).toList(),
              )),
          (_petsItem != null && _petsItem!.value==true) ? Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                obscureText: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Quali?',
                ),
                controller: petsController,
              )) : SizedBox(),
          ElevatedButton(
              child: Text("Modifica"),
              onPressed: () {
                String bio=bioController.text.trim();
                String reason=reasonController.text.trim();
                String job=jobController.text.trim();
                String income=incomeController.text.trim();
                String pets=petsController.text.trim();

                doUpdate((p0) => null, bio, reason, job, income, pets, _month, _smokerTQ);
              }),
        ],
      ),
    );
  }

}