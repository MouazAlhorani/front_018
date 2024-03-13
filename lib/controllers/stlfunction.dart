import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:mouaz_app_018/controllers/provider_mz.dart';
import 'package:mouaz_app_018/data/basicdata.dart';
import 'package:mouaz_app_018/data/shared_pref_mz.dart';
import 'package:mouaz_app_018/tamplates/dialog01.dart';
import 'package:mouaz_app_018/views/accounts_edit.dart';
import 'package:mouaz_app_018/views/dailytasks_edit.dart';
import 'package:mouaz_app_018/views/dailytasksreport_edit.dart';
import 'package:mouaz_app_018/views/help_edit.dart';
import 'package:mouaz_app_018/views/homepage.dart';
import 'package:mouaz_app_018/views/login.dart';
import 'package:excel/excel.dart' as xl;
import 'package:intl/intl.dart' as df;
import 'package:url_launcher/url_launcher.dart';

class StlFunction {
  static snackbar({ctx, msg, color}) {
    return ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: color,
      dismissDirection: DismissDirection.up,
      duration: Duration(milliseconds: 1600),
    ));
  }

  static reqpuestGet({url, ctx}) async {
    var result = await http.get(Uri.parse(url));
    if (result.statusCode == 200) {
      return jsonDecode(result.body);
    } else {
      snackbar(
          ctx: ctx,
          msg: "لا يمكن الوصول للمخدم",
          color: Colors.deepOrangeAccent.withOpacity(0.5));
      return null;
    }
  }

  static reqpuestPost({required String url, body, ctx}) async {
    try {
      var result = await http.post(Uri.parse(url), body: body);
      if (result.statusCode == 200) {
        return jsonDecode(result.body);
      } else {
        snackbar(
            ctx: ctx,
            msg: "لا يمكن الوصول للمخدم",
            color: Colors.deepOrangeAccent.withOpacity(0.5));
        return null;
      }
    } catch (e) {
      snackbar(ctx: ctx, msg: "$e");
    }
  }

  static checklogin({ctx, username, password, type}) async {
    var result = await reqpuestPost(
        ctx: ctx,
        url: "${BasicData.baseurl}${BasicData.checklogin}",
        body: {'username': username, 'password': password});

    if (result != null) {
      if (result[0]['result'] == 'username_not_found') {
        if (type == true) {
          snackbar(ctx: ctx, msg: "الحساب غير موجود");
        }
        return false;
      } else if (result[0]['result'] == 'password_error') {
        if (type == true) {
          snackbar(ctx: ctx, msg: "كلمة المرور غير صحيحة");
        }
        return false;
      } else if (result[0]['fields']['enable'] == false) {
        if (type == true) {
          snackbar(ctx: ctx, msg: "الحساب معطَّل");
        }
        return false;
      } else {
        await SharedPref.setloginfo(logininfolist: [username, password]);
        BasicData.userinfo = result;
        if (type != null) {
          Navigator.pushReplacement(
              ctx, MaterialPageRoute(builder: (_) => const HomePage()));
          return true;
        }
        return true;
      }
    }
  }

  static logout({ctx}) async {
    for (var i in LogIN.logininput) {
      i['controller'].text = '';
    }
    await SharedPref.removeloginfo();
    await reqpuestPost(
        ctx: ctx,
        url: "${BasicData.baseurl}${BasicData.logout}",
        body: {'id': "${BasicData.userinfo![0]['pk']}"});
    return Navigator.pushReplacement(
        ctx, MaterialPageRoute(builder: (_) => const LogIN()));
  }

  static createExcel(
      {required List data, required List headers, pagename, required ctx}) {
    decriptpass(String text) {
      if (text.length == 1) {
        return text;
      } else {
        return text.substring(0, 1) + decriptpass(text.substring(2));
      }
    }

    xl.Excel excel = xl.Excel.createExcel();
    var sheet = excel.sheets['Sheet1'];

    for (var head in headers) {
      sheet!.cell(xl.CellIndex.indexByColumnRow(columnIndex: headers.indexOf(head), rowIndex: 0)).value =
          head.runtimeType == bool
              ? xl.BoolCellValue(head)
              : head.runtimeType == int
                  ? xl.IntCellValue(head)
                  : head.runtimeType == double
                      ? xl.DoubleCellValue(head)
                      : xl.TextCellValue(head);
    }

    for (var i in data) {
      sheet!
          .cell(xl.CellIndex.indexByColumnRow(
              columnIndex: 0, rowIndex: data.indexOf(i) + 1))
          .value = xl.TextCellValue(i['pk'].toString());
      for (var j
          in i['fields'].values.toList().sublist(0, headers.length - 1)) {
        sheet
                .cell(xl.CellIndex.indexByColumnRow(
                    columnIndex: i['fields'].values.toList().indexOf(j) + 1,
                    rowIndex: data.indexOf(i) + 1))
                .value =
            xl.TextCellValue(i['fields'].values.toList().indexOf(j) == 4 &&
                    pagename == 'accounts'
                ? decriptpass(j).toString()
                : j.toString() == 'null'
                    ? ''
                    : j.toString());
        sheet.setColumnAutoFit(i['fields'].values.toList().indexOf(j));
      }
    }
    excel.save(fileName: "$pagename.xlsx");
  }

  static importexcel(
      {ctx, headers, emptyroles, erroremptyrole, createbulkfunction}) async {
    List checkheaders = [], data = [];
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
      allowMultiple: false,
    );
    if (pickedFile != null) {
      var bytes = pickedFile.files.single.bytes;
      var excel = xl.Excel.decodeBytes(bytes!);
      check() {
        bool x = true;
        if (checkheaders.length != headers.length) {
          return false;
        } else {
          li:
          for (var i in headers) {
            if (i.toString() != checkheaders[headers.indexOf(i)].toString()) {
              x = false;
              break li;
            }
          }
          return x;
        }
      }

      try {
        ll:
        for (var row in excel.tables[excel.tables.keys.first]!.rows) {
          for (var i = 0;
              i < excel.tables[excel.tables.keys.first]!.maxColumns;
              i++) {
            checkheaders.add(row[i]!.value);
          }
          break ll;
        }
      } catch (o) {
        return null;
      }
      if (check()) {
        int x = 0;

        for (var row in excel.tables[excel.tables.keys.first]!.rows.skip(1)) {
          data.add({});
          for (var i = 0; i < headers.length; i++) {
            if (emptyroles != null && emptyroles.any((y) => row[y] == null)) {
              return showDialog(
                  context: ctx,
                  builder: (_) {
                    return AlertDialog(
                      content: Text(erroremptyrole),
                    );
                  });
            } else {
              data[x].addAll({headers[i]: row[i] == null ? '' : row[i]!.value});
            }
          }
          x++;
        }
        return showDialog(
            context: ctx,
            builder: (BuildContext context) {
              return DialogofimportM(
                createbulkfunction: createbulkfunction,
                headers: headers,
                data: data,
              );
            });
      } else {
        return showDialog(
            context: ctx,
            builder: (_) {
              return const AlertDialog(
                content: Text("الجدول غير مطابق للنموذج المطلوب"),
              );
            });
      }
    }
  }

  static getalldata({ctx, required model, reportdate}) async {
    var result = await reqpuestPost(
        ctx: ctx,
        url: "${BasicData.baseurl}${BasicData.getalldata}",
        body: {
          'username': BasicData.userinfo![0]['fields']['username'],
          'password': BasicData.userinfo![0]['fields']['password'],
          'model': model,
          'reportdate': model == 'dailytasksreports'
              ? reportdate == 'all'
                  ? 'all'
                  : reportdate == null
                      ? df.DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now())
                      : df.DateFormat("yyyy-MM-dd HH:mm").format(reportdate)
              : ''
        });
    if (result != null) {
      if (result.isNotEmpty && result[0]['result'] == 'redirect_login') {
        return 'redirect_login';
      } else {
        return result;
      }
    }
  }

  static getsingledata({ctx, required model, id}) async {
    var result = await reqpuestPost(
        ctx: ctx,
        url: "${BasicData.baseurl}${BasicData.getsingledata}",
        body: {
          'username': BasicData.userinfo![0]['fields']['username'],
          'password': BasicData.userinfo![0]['fields']['password'],
          'model': model,
          'id': id
        });
    if (result != null) {
      if (result.isNotEmpty && result[0]['result'] == 'redirect_login') {
        return 'redirect_login';
      } else {
        return result;
      }
    }
  }

  static creaebulkusers({ctx, data, ref}) async {
    var result = await StlFunction.reqpuestPost(
        ctx: ctx,
        url: "${BasicData.baseurl}${BasicData.createbulkusers}",
        body: {
          'username': BasicData.userinfo![0]['fields']['username'],
          'password': BasicData.userinfo![0]['fields']['password'],
          'records': data.toString()
        });
    if (result[0]['result'] == 'done') {
      Navigator.pop(ctx);
      snackbar(color: Colors.green, msg: "تمت العملية بنجاح", ctx: ctx);
      ref.read(notifierAccountsdata.notifier).rebuild('accounts', ctx);
    } else {
      Navigator.pop(ctx);
      ref.read(notifierAccountsdata.notifier).rebuild('accounts', ctx);
      return showDialog(
          context: ctx,
          builder: (_) {
            return AlertDialog(
              scrollable: true,
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                const Text("تم مع بعض الاخطاء"),
                Text(result[0]['errors']
                    .toString()
                    .replaceAll('[', '')
                    .replaceAll(']', '')
                    .replaceAll(' ', '')
                    .replaceAll(',\'', '')
                    .replaceAll('<>', '\n'))
              ]),
            );
          });
    }
  }

  static creaebulkhelps({ctx, data, ref}) async {
    var result = await StlFunction.reqpuestPost(
        ctx: ctx,
        url: "${BasicData.baseurl}${BasicData.createbulkhelps}",
        body: {
          'username': BasicData.userinfo![0]['fields']['username'],
          'password': BasicData.userinfo![0]['fields']['password'],
          'records': data.toString()
        });
    if (result[0]['result'] == 'done') {
      Navigator.pop(ctx);
      snackbar(color: Colors.green, msg: "تمت العملية بنجاح", ctx: ctx);
      ref.read(notifierHelpdata.notifier).rebuild('helps', ctx);
    } else {
      Navigator.pop(ctx);
      ref.read(notifierHelpdata.notifier).rebuild('helps', ctx);
      return showDialog(
          context: ctx,
          builder: (_) {
            return AlertDialog(
              scrollable: true,
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                const Text("تم مع بعض الاخطاء"),
                Text(result[0]['errors']
                    .toString()
                    .replaceAll('[', '')
                    .replaceAll(']', '')
                    .replaceAll(' ', '')
                    .replaceAll(',\'', '')
                    .replaceAll('<>', '\n'))
              ]),
            );
          });
    }
  }

  static createbulktasks({ctx, data, ref}) async {
    var result = await StlFunction.reqpuestPost(
        ctx: ctx,
        url: "${BasicData.baseurl}${BasicData.createbulktasks}",
        body: {
          'username': BasicData.userinfo![0]['fields']['username'],
          'password': BasicData.userinfo![0]['fields']['password'],
          'records': data.toString()
        });
    if (result[0]['result'] == 'done') {
      Navigator.pop(ctx);
      snackbar(color: Colors.green, msg: "تمت العملية بنجاح", ctx: ctx);
      ref.read(notifierDailyTasksdata.notifier).rebuild('dailytasks', ctx);
    } else {
      Navigator.pop(ctx);
      ref.read(notifierHelpdata.notifier).rebuild('dailytasks', ctx);
      return showDialog(
          context: ctx,
          builder: (_) {
            return AlertDialog(
              scrollable: true,
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                const Text("تم مع بعض الاخطاء"),
                Text(result[0]['errors']
                    .toString()
                    .replaceAll('[', '')
                    .replaceAll(']', '')
                    .replaceAll(' ', '')
                    .replaceAll(',\'', '')
                    .replaceAll('<>', '\n'))
              ]),
            );
          });
    }
  }

  static createbulktasksReports({ctx, data, required WidgetRef ref}) async {
    var result = await StlFunction.reqpuestPost(
        ctx: ctx,
        url: "${BasicData.baseurl}${BasicData.createbulkreports}",
        body: {
          'username': BasicData.userinfo![0]['fields']['username'],
          'password': BasicData.userinfo![0]['fields']['password'],
          'records': data.toString()
        });
    if (result[0]['result'] == 'done') {
      Navigator.pop(ctx);
      snackbar(color: Colors.green, msg: "تمت العملية بنجاح", ctx: ctx);
      ref
          .read(notifierDailyTasksdata.notifier)
          .rebuild('dailytasksreports', ctx);
    } else {
      Navigator.pop(ctx);
      ref.read(notifierHelpdata.notifier).rebuild('dailytasksreports', ctx);
      return showDialog(
          context: ctx,
          builder: (_) {
            return AlertDialog(
              scrollable: true,
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                const Text("تم مع بعض الاخطاء"),
                Text(result[0]['errors']
                    .toString()
                    .replaceAll('[', '')
                    .replaceAll(']', '')
                    .replaceAll(' ', '')
                    .replaceAll(',\'', '')
                    .replaceAll('<>', '\n'))
              ]),
            );
          });
    }
  }

  static createbulkreminds({ctx, data, required WidgetRef ref}) async {
    var result = await StlFunction.reqpuestPost(
        ctx: ctx,
        url: "${BasicData.baseurl}${BasicData.createbulkreminds}",
        body: {
          'username': BasicData.userinfo![0]['fields']['username'],
          'password': BasicData.userinfo![0]['fields']['password'],
          'records': data.toString()
        });
    if (result[0]['result'] == 'done') {
      Navigator.pop(ctx);
      snackbar(color: Colors.green, msg: "تمت العملية بنجاح", ctx: ctx);
      ref.read(notifierRemindsdata.notifier).rebuild('reminds', ctx);
    } else {
      Navigator.pop(ctx);
      ref.read(notifierRemindsdata.notifier).rebuild('reminds', ctx);
      return showDialog(
          context: ctx,
          builder: (_) {
            return AlertDialog(
              scrollable: true,
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                const Text("تم مع بعض الاخطاء"),
                Text(result[0]['errors']
                    .toString()
                    .replaceAll('[', '')
                    .replaceAll(']', '')
                    .replaceAll(' ', '')
                    .replaceAll(',\'', '')
                    .replaceAll('<>', '\n'))
              ]),
            );
          });
    }
  }

  static createEdituser({ctx, required WidgetRef ref, e}) async {
    var result = await reqpuestPost(
        ctx: ctx,
        url: "${BasicData.baseurl}${BasicData.createuser}",
        body: {
          'id': e != null ? "${e['pk']}" : '',
          'username': BasicData.userinfo![0]['fields']['username'],
          'password': BasicData.userinfo![0]['fields']['password'],
          'newfullname': AccountsE.localdata[0]['controller'].text,
          'newusername': AccountsE.localdata[1]['controller'].text,
          'newemail': AccountsE.localdata[2]['controller'].text,
          'newphone': AccountsE.localdata[3]['controller'].text,
          'newpassword': AccountsE.localdata[4]['controller'].text,
          'newadmin': AccountsE.localdata[6]['selected'],
          'newenable': AccountsE.localdata[7]['value'] ? '1' : '0',
        });
    if (result != null) {
      if (result[0]['result'] == 'redirect_login') {
        await logout(ctx: ctx);
      } else if (result[0]['result'] == 'done') {
        if (e != null && "${BasicData.userinfo![0]['pk']}" == "${e['pk']}") {
          await logout(ctx: ctx);
        } else {
          snackbar(color: Colors.green, msg: "تمت العملية بنجاح", ctx: ctx);
          ref.read(notifierAccountsdata.notifier).rebuild('accounts', ctx);
          Navigator.pop(ctx);
        }
      } else {
        snackbar(color: Colors.brown, msg: result[0]['result'], ctx: ctx);
      }
    }
  }

  static createEdithelp({ctx, required WidgetRef ref, e}) async {
    var result = await reqpuestPost(
        ctx: ctx,
        url: "${BasicData.baseurl}${BasicData.createhelp}",
        body: {
          'id': e == null ? 'null' : "${e['pk']}",
          'username': BasicData.userinfo![0]['fields']['username'],
          'password': BasicData.userinfo![0]['fields']['password'],
          'newhelpname': HelpE.localdata[0]['controller'].text,
          'newhelpdesc': HelpE.localdata[1]['controller'].text,
        });
    if (result != null) {
      if (result[0]['result'] == 'redirect_login') {
        await logout(ctx: ctx);
      } else if (result[0]['result'] == 'done') {
        snackbar(color: Colors.green, msg: "تمت العملية بنجاح", ctx: ctx);
        await ref.read(notifierHelpdata.notifier).rebuild('helps', ctx);
        Navigator.pop(ctx);
      } else {
        snackbar(color: Colors.brown, msg: result[0]['result'], ctx: ctx);
      }
    }
  }

  static createEditdailytask({ctx, required WidgetRef ref, e}) async {
    var result = await reqpuestPost(
        ctx: ctx,
        url: "${BasicData.baseurl}${BasicData.createtask}",
        body: {
          'id': e == null ? 'null' : "${e['pk']}",
          'username': BasicData.userinfo![0]['fields']['username'],
          'password': BasicData.userinfo![0]['fields']['password'],
          'newtask': DailyTasksE.localdata[0]['controller'].text,
          'newtaskhelp':
              DailyTasksE.localdata[1]['selected'].toString().split(' ')[1],
        });
    if (result != null) {
      if (result[0]['result'] == 'redirect_login') {
        await logout(ctx: ctx);
      } else if (result[0]['result'] == 'done') {
        snackbar(color: Colors.green, msg: "تمت العملية بنجاح", ctx: ctx);
        await ref
            .read(notifierDailyTasksdata.notifier)
            .rebuild('dailytasks', ctx);
        Navigator.pop(ctx);
      } else {
        snackbar(color: Colors.brown, msg: result[0]['result'], ctx: ctx);
      }
    }
  }

  static createEditdailytaskreport({ctx, required WidgetRef ref, e}) async {
    String report = '';
    for (var i in DailyTasksReportsE.localdata) {
      report += "- ";
      report += i['check'] ? "_تم_" : "_لا_";
      report += '${i['task']}\n';
      i['controller'].text.isNotEmpty
          ? report += '_comment_${i['controller'].text}\n'
          : null;
    }
    DailyTasksReportsE.maincomment.text.isNotEmpty
        ? report += '_maincomment_${DailyTasksReportsE.maincomment.text}\n'
        : null;
    var result = await reqpuestPost(
        ctx: ctx,
        url: "${BasicData.baseurl}${BasicData.createdailytaskreport}",
        body: {
          'id': e == null ? 'null' : "${e['pk']}",
          'username': BasicData.userinfo![0]['fields']['username'],
          'password': BasicData.userinfo![0]['fields']['password'],
          'createby': BasicData.userinfo![0]['fields']['fullname'],
          'report': report,
          'reportdate': df.DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())
        });
    if (result != null) {
      if (result[0]['result'] == 'redirect_login') {
        await logout(ctx: ctx);
      } else if (result[0]['result'] == 'done') {
        snackbar(color: Colors.green, msg: "تمت العملية بنجاح", ctx: ctx);
        await ref
            .read(notifierDailyTasksReportdata.notifier)
            .rebuild('dailytasksreports', ctx, reportdate: DateTime.now());
        Navigator.pop(ctx);
      } else {
        snackbar(color: Colors.brown, msg: result[0]['result'], ctx: ctx);
      }
    }
  }

  static createshowreportlog({ctx, reportid}) async {
    await reqpuestPost(
        ctx: ctx,
        url: "${BasicData.baseurl}${BasicData.createusershowreport}",
        body: {
          'username': BasicData.userinfo![0]['fields']['username'],
          'password': BasicData.userinfo![0]['fields']['password'],
          'userid': "${BasicData.userinfo![0]['pk']}",
          'reportid': reportid,
        });
  }

  static delete(
      {ctx, required WidgetRef ref, id, model, required notifier}) async {
    var result = await reqpuestPost(
        ctx: ctx,
        url: "${BasicData.baseurl}${BasicData.delete}",
        body: {
          'username': BasicData.userinfo![0]['fields']['username'],
          'password': BasicData.userinfo![0]['fields']['password'],
          'model': model,
          'id': id
        });
    if (result != null) {
      if (result[0]['result'] == 'redirect_login') {
        logout(ctx: ctx);
      } else if (result[0]['result'] == 'permission_error') {
        snackbar(color: Colors.redAccent, msg: "لا تملك صلاحيات", ctx: ctx);
        logout(ctx: ctx);
      } else {
        if (result[0]['result'] == 'done') {
          snackbar(color: Colors.green, msg: "تمت العملية بنجاح", ctx: ctx);
          ref.read(notifier.notifier).rebuild(model, ctx);
          Navigator.pop(ctx);
          Navigator.pop(ctx);
        } else {
          snackbar(color: Colors.brown, msg: result[0]['result'], ctx: ctx);
        }
      }
    }
  }

  static deletebulk(
      {ctx, required WidgetRef ref, ids, model, required notifier}) async {
    var result = await reqpuestPost(
        ctx: ctx,
        url: "${BasicData.baseurl}${BasicData.deletebulk}",
        body: {
          'username': BasicData.userinfo![0]['fields']['username'],
          'password': BasicData.userinfo![0]['fields']['password'],
          'model': model,
          'ids': ids
        });
    if (result != null) {
      if (result[0]['result'] == 'redirect_login') {
        logout(ctx: ctx);
      } else if (result[0]['result'] == 'permission_error') {
        snackbar(color: Colors.redAccent, msg: "لا تملك صلاحيات", ctx: ctx);
        logout(ctx: ctx);
      } else {
        if (result[0]['result'] == 'done') {
          snackbar(color: Colors.green, msg: "تمت العملية بنجاح", ctx: ctx);
          ref.read(notifier.notifier).rebuild(model, ctx);
          Navigator.pop(ctx);
        } else {
          snackbar(color: Colors.brown, msg: result[0]['result'], ctx: ctx);
        }
      }
    }
  }

  static proccesshelpcontent({required String content}) async {
    List<Map> y = [];
    for (var i in content.split('\n')) {
      for (var j in i.split(' ')) {
        await canLaunchUrl(Uri.parse(j))
            ? y.add({"t": j, 'v': true})
            : y.add({"t": "$j ", 'v': false});
      }
      y.last['t'] = y.last['t'].trim();
      y.add({'t': '\n', 'v': false});
    }
    return y;
  }

  static showhelp({ctx, id}) async {
    showDialog(
        context: ctx,
        builder: (_) {
          String helpname;
          List<Map> helpdesc = [];
          return FutureBuilder(future: Future(() async {
            var result = await StlFunction.getsingledata(
                model: 'helps', ctx: ctx, id: id);
            helpdesc = await StlFunction.proccesshelpcontent(
                content: result[0]['fields']['helpdesc']);
            return result;
          }), builder: (_, snap) {
            if (snap.hasData) {
              helpname = snap.data[0]['fields']['helpname'];

              return Directionality(
                textDirection: TextDirection.rtl,
                child: AlertDialog(
                    content: SelectableText.rich(TextSpan(children: [
                  TextSpan(text: "$helpname \n"),
                  ...helpdesc.map((i) => i['v']
                      ? TextSpan(
                          style: Theme.of(ctx)
                              .textTheme
                              .bodyMedium!
                              .copyWith(decoration: TextDecoration.underline),
                          text: i['t'],
                          recognizer: TapGestureRecognizer()
                            ..onTap =
                                () async => await launchUrl(Uri.parse(i['t'])))
                      : TextSpan(text: i['t']))
                ]))),
              );
            } else {
              return SizedBox();
            }
          });
        });
  }
}
