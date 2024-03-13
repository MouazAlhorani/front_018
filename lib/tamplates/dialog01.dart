import 'package:excel/excel.dart' as ex;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' as df;

class DialogofimportM extends ConsumerWidget {
  const DialogofimportM(
      {super.key,
      required this.headers,
      required this.data,
      required this.createbulkfunction});
  final List headers;
  final List data;
  final Function createbulkfunction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (data.isEmpty) {
      return const AlertDialog(
        content: Text("لا يوجد اي بيانات لعرضها"),
      );
    } else {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          scrollable: true,
          title: const Text("سيتم إضافة البيانات التالية:"),
          content: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ...headers.sublist(1).map((i) => SizedBox(
                        width: 150,
                        child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blueGrey.withOpacity(0.6),
                            ),
                            child: Text(
                              "$i",
                              textAlign: TextAlign.center,
                            ))))
                  ],
                ),
                ...data.map((e) => Row(
                      children: [
                        ...e.values
                            .toList()
                            .sublist(1, headers.length)
                            .map((i) {
                          print(i.runtimeType);
                          return SizedBox(
                              width: 150,
                              child: Container(
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              width: 2,
                                              color: Colors.blueGrey))),
                                  child: Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: Text(
                                      i == ''
                                          ? ''
                                          : i.runtimeType ==
                                                  ex.DateTimeCellValue
                                              ? df.DateFormat(
                                                      'yyyy-MM-dd HH:mm')
                                                  .format(DateTime.parse("$i"))
                                              : "$i",
                                      textAlign: TextAlign.center,
                                    ),
                                  )));
                        })
                      ],
                    )),
              ],
            ),
          ),
          actions: [
            TextButton.icon(
                onPressed: () async =>
                    await createbulkfunction(data.toString()),
                icon: const Icon(Icons.create_new_folder),
                label: const Text("تأكيد"))
          ],
        ),
      );
    }
  }
}
