import 'package:flutter/material.dart';
import 'package:mouaz_app_018/controllers/stlfunction.dart';
import 'package:mouaz_app_018/data/basicdata.dart';

class OnChooseBar extends StatelessWidget {
  const OnChooseBar(
      {super.key,
      required this.localdata,
      required this.ref,
      required this.refnotifier,
      required this.searchcontroller,
      required this.name,
      required this.model});
  final List localdata;
  final String name, model;

  final ref;
  final refnotifier;
  final TextEditingController searchcontroller;
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: localdata.any((e) => e['choose']),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Visibility(
              visible: !localdata.every((element) => element['choose']),
              child: TextButton.icon(
                  onPressed: () {
                    ref.read(refnotifier.notifier).chooseallitemsfromsearch();
                  },
                  icon: const Icon(Icons.select_all),
                  label: Text(
                    !localdata
                            .where((element) => element['search'])
                            .every((element) => element['choose'])
                        ? "اختيار الكل ضمن مجال البحث"
                        : "إلغاء التحديد",
                    style: Theme.of(context).textTheme.bodyMedium,
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton.icon(
                onPressed: () {
                  searchcontroller.text = '';
                  ref.read(refnotifier.notifier).chooseallitems();
                },
                icon: const Icon(Icons.select_all),
                label: Text(
                  !localdata.every((element) => element['choose'])
                      ? "اختيار الكل"
                      : "إلغاء التحديد",
                  style: Theme.of(context).textTheme.bodyMedium,
                )),
          ),
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (_) {
                      return Directionality(
                        textDirection: TextDirection.rtl,
                        child: AlertDialog(
                          scrollable: true,
                          title: const Text("سيتم حذف العناصر التالية:"),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: model == 'accounts'
                                ? [
                                    ...localdata
                                        .where((element) =>
                                            element['choose'] &&
                                            "${element['pk']}" != '1' &&
                                            "${element['pk']}" !=
                                                "${BasicData.userinfo![0]['pk']}")
                                        .map((e) => Text(
                                            "# ${e['pk']} ${e['fields'][name]}"))
                                  ].isEmpty
                                    ? [
                                        const Text(
                                            "لم تقم باختيار اي عنصر .. علما انه لا يمكن اختيار حسابك الشخصي او حيساب المسؤول الاساسي")
                                      ]
                                    : [
                                        ...localdata
                                            .where((element) =>
                                                element['choose'] &&
                                                "${element['pk']}" != '1' &&
                                                "${element['pk']}" !=
                                                    "${BasicData.userinfo![0]['pk']}")
                                            .map((e) => Text(
                                                "# ${e['pk']} ${e['fields'][name]}"))
                                      ]
                                : [
                                    ...localdata
                                        .where((element) => element['choose'])
                                        .map((e) => Text(
                                            "# ${e['pk']} ${e['fields'][name]}"))
                                  ],
                          ),
                          actions: [
                            TextButton(
                                onPressed: model == 'accounts' &&
                                        [
                                          ...localdata
                                              .where((element) =>
                                                  element['choose'] &&
                                                  "${element['pk']}" != '1' &&
                                                  "${element['pk']}" !=
                                                      "${BasicData.userinfo![0]['pk']}")
                                              .map((e) => Text(
                                                  "# ${e['pk']} ${e['fields'][name]}"))
                                        ].isEmpty
                                    ? () {
                                        Navigator.pop(context);
                                      }
                                    : () async => await StlFunction.deletebulk(
                                          notifier: refnotifier,
                                          ctx: context,
                                          ref: ref,
                                          model: model,
                                          ids: model == 'accounts'
                                              ? "${[
                                                  ...localdata
                                                      .where((element) =>
                                                          element['choose'] &&
                                                          "${element['pk']}" !=
                                                              '1' &&
                                                          "${element['pk']}" !=
                                                              "${BasicData.userinfo![0]['pk']}")
                                                      .map((e) => "${e['pk']}")
                                                ]}"
                                              : "${[
                                                  ...localdata
                                                      .where((element) =>
                                                          element['choose'])
                                                      .map((e) => "${e['pk']}")
                                                ]}",
                                        ),
                                child: const Text("تأكيد"))
                          ],
                        ),
                      );
                    });
              },
              icon: const CircleAvatar(
                backgroundColor: Colors.redAccent,
                child: Icon(
                  Icons.delete_forever,
                  color: Colors.white,
                ),
              ))
        ],
      ),
    );
  }
}
