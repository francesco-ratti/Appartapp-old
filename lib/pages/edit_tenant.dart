import 'package:appartapp/classes/enum_month.dart';
import 'package:appartapp/classes/runtime_store.dart';
import 'package:appartapp/classes/user.dart';
import 'package:flutter/material.dart';
import 'package:appartapp/classes/enum_temporalq.dart';

class EditTenant extends StatefulWidget {
  String urlStr = "http://ratti.dynv6.net/appartapp-1.0-SNAPSHOT/api/reserved/edituser";
  Color bgColor = Colors.white;

  User user=RuntimeStore().getUser() as User;

  @override
  _EditTenantState createState() => _EditTenantState();
}

class TemporalQItem {
  const TemporalQItem(this.name, this.code);

  final String name;
  final String code;
}

class YesNoForList{
  String name;
  bool value;

  YesNoForList(this.name, this.value);
}

class _EditTenantState extends State<EditTenant> {
  final bioController = TextEditingController();
  final reasonController = TextEditingController();

  static YesNoForList yesYN=YesNoForList("Sì", true);
  static YesNoForList noYN=YesNoForList("No", false);

  Month? _month=null;

  YesNoForList? _petsItem=null;
  List<YesNoForList> _petsEntries=<YesNoForList>[
    yesYN,
    noYN
  ];

  TemporalQItem yesT=TemporalQItem("Sì", "Yes");
  TemporalQItem noT=TemporalQItem("No", "No");
  TemporalQItem sometimesT=TemporalQItem("Saltuariamente", "Sometimes");

  late List<TemporalQItem> temporalQValues;

  TemporalQItem? _smokertQItem=null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    temporalQValues=<TemporalQItem> [
      yesT,
      noT,
      sometimesT
    ];

    switch (widget.user.smoker) {
      case TemporalQ.Yes:
        _smokertQItem=yesT;
        break;
      case TemporalQ.No:
        _smokertQItem=noT;
        break;
      case TemporalQ.Sometimes:
        _smokertQItem=sometimesT;
        break;
      default: {}
    }
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
                controller: reasonController,
              )),
          Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                obscureText: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Stipendio medio mensile',
                ),
                controller: reasonController,
              )),
          Padding(
              padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
              child: Text("Fumi?")),
          Padding(
              padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
              child: DropdownButton<TemporalQItem>(
                value: _smokertQItem,
                hint: Text("Fumi?"),
                // Not necessary for Option 1
                onChanged: (newValue) {
                  setState(() {
                    _smokertQItem = newValue!;
                  });
                },
                items: temporalQValues.map((temporalQv) {
                  return DropdownMenuItem(
                    child: new Text(temporalQv.name),
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
                controller: reasonController,
              )) : SizedBox(),
          ElevatedButton(
              child: Text("Modifica"),
              onPressed: () {
              }),
        ],
      ),
    );
  }

}