import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mouaz_app_018/controllers/stlfunction.dart';
import 'package:mouaz_app_018/tamplates/navbarM.dart';
import 'package:mouaz_app_018/views/accounts.dart';
import 'package:mouaz_app_018/views/accounts_edit.dart';
import 'package:mouaz_app_018/views/dailytasks.dart';
import 'package:mouaz_app_018/views/dailytasks_edit.dart';
import 'package:mouaz_app_018/views/dailytasksreport.dart';
import 'package:mouaz_app_018/views/dailytasksreport_edit.dart';
import 'package:mouaz_app_018/views/help.dart';
import 'package:mouaz_app_018/views/help_edit.dart';
import 'package:mouaz_app_018/views/homepage.dart';
import 'package:mouaz_app_018/views/login.dart';
import 'package:mouaz_app_018/views/reminds.dart';

class IconAnimatNotifier extends StateNotifier<bool> {
  IconAnimatNotifier({required this.custom}) : super(custom);
  final custom;
  onhover() {
    state = true;
  }

  onexit() {
    state = false;
  }

  ontap() {
    state = state == true ? false : true;
  }
}

var notifiershowsettingsHomepage =
    StateNotifierProvider<IconAnimatNotifier, bool>(
        (ref) => IconAnimatNotifier(custom: HomePage.mysettingshow));

var notifierrightbuttonNav = StateNotifierProvider<IconAnimatNotifier, bool>(
    (ref) => IconAnimatNotifier(custom: NavBarMrightside.itemanimation));
var notifierleftbuttonNav = StateNotifierProvider<IconAnimatNotifier, bool>(
    (ref) => IconAnimatNotifier(custom: NavBarMleftside.itemanimation));

class RebuildListMapNotifier extends StateNotifier<List<Map>> {
  RebuildListMapNotifier({required this.custom}) : super(custom);
  final List<Map> custom;

  swappasswordstatus({index}) {
    state = [
      ...state.sublist(0, index),
      state[index] = {
        ...state[index],
        'suffix_icon': state[index]['suffix_icon'] == Icons.visibility
            ? Icons.visibility_off
            : Icons.visibility,
        'obscuretext': state[index]['obscuretext'] ? false : true
      },
      ...state.sublist(index + 1)
    ];
  }

  chooseitemdromdopdown({x, index}) {
    state = [
      ...state.sublist(0, index),
      state[index] = {...state[index], 'selected': x},
      ...state.sublist(index + 1)
    ];
  }

  switchkey({x, index}) {
    state = [
      ...state.sublist(0, index),
      state[index] = {...state[index], 'value': x},
      ...state.sublist(index + 1)
    ];
  }

  checkbox({x, index}) {
    state = [
      ...state.sublist(0, index),
      state[index] = {...state[index], 'check': x},
      ...state.sublist(index + 1)
    ];
  }

  addcomment({index}) {
    state = [
      ...state.sublist(0, index),
      state[index] = {
        ...state[index],
        'comment': state[index]['comment'] ? false : true
      },
      ...state.sublist(index + 1)
    ];
  }

  onhovermainitem({index}) {
    try {
      state = [
        ...custom.sublist(0, index),
        custom[index] = {...custom[index], 'choose': true},
        ...custom.sublist(index + 1)
      ];
    } catch (e) {
      null;
    }
  }

  onexitmainitem({index}) {
    try {
      state = [
        ...custom.sublist(0, index),
        custom[index] = {...custom[index], 'choose': false},
        ...custom.sublist(index + 1)
      ];
    } catch (e) {
      null;
    }
  }
}

var notifierswaphiddenpassLogin =
    StateNotifierProvider<RebuildListMapNotifier, List<Map>>(
        (ref) => RebuildListMapNotifier(custom: LogIN.logininput));
var notifierAccountsEdit =
    StateNotifierProvider<RebuildListMapNotifier, List<Map>>(
        (ref) => RebuildListMapNotifier(custom: AccountsE.localdata));
var notifierHelpEdit = StateNotifierProvider<RebuildListMapNotifier, List<Map>>(
    (ref) => RebuildListMapNotifier(custom: HelpE.localdata));
var notifierDailyTasksEdit =
    StateNotifierProvider<RebuildListMapNotifier, List<Map>>(
        (ref) => RebuildListMapNotifier(custom: DailyTasksE.localdata));
var notifierDailyTasksReportsEdit =
    StateNotifierProvider<RebuildListMapNotifier, List<Map>>(
        (ref) => RebuildListMapNotifier(custom: DailyTasksReportsE.localdata));

var notifierRemindsEdit =
    StateNotifierProvider<RebuildListMapNotifier, List<Map>>(
        (ref) => RebuildListMapNotifier(custom: DailyTasksReportsE.localdata));
var notifiermainitemsHomepage =
    StateNotifierProvider<RebuildListMapNotifier, List<Map>>(
        (ref) => RebuildListMapNotifier(custom: HomePage.mainitems));

// RebuildMainApp__
class RebuildLocalDataNotifier extends StateNotifier<List> {
  RebuildLocalDataNotifier({required this.custom}) : super(custom);
  final List custom;

  rebuild(model, ctx, {reportdate}) async {
    state = model == 'dailytasksreports'
        ? await StlFunction.getalldata(
            model: model, ctx: ctx, reportdate: reportdate)
        : await StlFunction.getalldata(model: model, ctx: ctx);
    state = model == 'dailytasksreports'
        ? [
            ...state.map((o) {
              List x = [];
              x.clear();
              for (var i in DailyTasksReports.userreportsshow) {
                if ("${i['fields']['report_id']}" == "${o['pk']}") {
                  x.add(i['fields']['user_id']);
                }
              }
              return {
                ...o,
                'choose': false,
                'search': true,
                'sorted': true,
                'shownby': x
              };
            }),
          ]
        : [
            ...state.map(
                (o) => {...o, 'choose': false, 'search': true, 'sorted': true}),
          ];
    return state;
  }

  chooseitem({index}) {
    state = [
      ...state.sublist(0, index).map((e) => e),
      state[index] = {
        ...state[index],
        'choose': state[index]['choose'] == true ? false : true
      },
      ...state.sublist(index + 1).map((e) => e),
    ];
  }

  chooseallitemsfromsearch() {
    state = [
      ...state.where((i) => i['search']).map((e) => {
            ...e,
            'choose': state
                    .where((element) => element['search'])
                    .every((element) => element['choose'])
                ? false
                : true
          }),
      ...state.where((i) => i['search'] == false).map((e) => e),
    ];
  }

  chooseallitems() {
    state = [
      ...state.map((e) => {
            ...e,
            'search': true,
            'choose': state.every((element) => element['choose']) ? false : true
          }),
    ];
  }

  search({required String word, required List<String>? searchrange}) {
    if (word.isEmpty) {
      state = [
        ...state.map((e) => {...e, 'search': true})
      ];
    } else {
      state = [
        ...state.map((e) => {...e, 'search': false})
      ];
      state = [
        ...state.map((e) => {
              ...e,
              'search': searchrange!.any((element) => e['fields'][element]
                  .toString()
                  .toLowerCase()
                  .contains(word.toLowerCase()))
            })
      ];
    }
  }

  sort({sortby}) {
    state = [...state.map((e) => e)];

    if (sortby == 'pk') {
      !state.any((element) => element['sorted'])
          ? state.sort((a, b) => a[sortby].compareTo(b[sortby]))
          : state.sort((a, b) => b[sortby].compareTo(a[sortby]));
      state = [
        ...state.map((element) =>
            {...element, 'sorted': element['sorted'] ? false : true})
      ];
    } else {
      !state.any((element) => element['sorted'])
          ? state.sort((a, b) =>
              "${a['fields'][sortby]}".compareTo("${b['fields'][sortby]}"))
          : state.sort((a, b) =>
              "${b['fields'][sortby]}".compareTo("${a['fields'][sortby]}"));
      state = [
        ...state.map((element) =>
            {...element, 'sorted': element['sorted'] ? false : true})
      ];
    }
  }
}

var notifierAccountsdata =
    StateNotifierProvider<RebuildLocalDataNotifier, List>(
        (ref) => RebuildLocalDataNotifier(custom: Accounts.localdata));
var notifierHelpdata = StateNotifierProvider<RebuildLocalDataNotifier, List>(
    (ref) => RebuildLocalDataNotifier(custom: Help.localdata));
var notifierDailyTasksdata =
    StateNotifierProvider<RebuildLocalDataNotifier, List>(
        (ref) => RebuildLocalDataNotifier(custom: DailyTasks.localdata));
var notifierDailyTasksReportdata =
    StateNotifierProvider<RebuildLocalDataNotifier, List>(
        (ref) => RebuildLocalDataNotifier(custom: DailyTasksReports.localdata));
var notifierRemindsdata = StateNotifierProvider<RebuildLocalDataNotifier, List>(
    (ref) => RebuildLocalDataNotifier(custom: Reminds.localdata));

class SetDate extends StateNotifier<DateTime> {
  SetDate({required this.custom}) : super(custom);
  final DateTime custom;
  setdate({ctx}) async {
    DateTime? selecteddate = await showDatePicker(
        context: ctx,
        firstDate: DateTime.parse('2024-01-01'),
        lastDate: DateTime.parse('2025-01-01'));
    if (selecteddate != null) {
      state = selecteddate;
      return selecteddate;
    } else {
      state = DateTime.now();
      return DateTime.now();
    }
  }

  setdefault() {
    state = DateTime.now();
  }
}

var notifierDailyTasksReportdataSetDate =
    StateNotifierProvider<SetDate, DateTime>(
        (ref) => SetDate(custom: DailyTasksReports.reportdate));
