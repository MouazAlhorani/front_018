import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mouaz_app_018/controllers/provider_mz.dart';
import 'package:mouaz_app_018/controllers/stlfunction.dart';
import 'package:mouaz_app_018/data/basicdata.dart';

class AccountsE extends ConsumerWidget {
  const AccountsE({super.key, this.mainE, this.selfedit = false});
  final Map? mainE;
  final bool selfedit;
  static List<Map> localdata = [
    {
      'type': 'tf',
      'label': 'الاسم',
      'controller': TextEditingController(),
      'keyboard': TextInputType.name,
      'validate_role': 'empty'
    },
    {
      'type': 'tf',
      'label': 'اسم المستخدم',
      'controller': TextEditingController(),
      'keyboard': TextInputType.name,
      'validate_role': 'empty'
    },
    {
      'type': 'tf',
      'label': 'الايميل',
      'controller': TextEditingController(),
      'keyboard': TextInputType.emailAddress
    },
    {
      'type': 'tf',
      'label': 'موبايل',
      'controller': TextEditingController(),
      'keyboard': TextInputType.phone
    },
    {
      'type': 'tf',
      'label': 'كلمة المرور',
      'hint': '',
      'obscuretext': true,
      'suffix_icon': Icons.visibility,
      'controller': TextEditingController(),
      'keyboard': TextInputType.visiblePassword,
      'validate_role': 'empty_if_not_e'
    },
    {
      'type': 'tf',
      'label': 'تأكيد كلمة المرور',
      'hint': '',
      'obscuretext': true,
      'suffix_icon': Icons.visibility,
      'controller': TextEditingController(),
      'keyboard': TextInputType.visiblePassword,
      'validate_role': 'not_eq_prev'
    },
    {
      'type': 'dropdown_permit',
      'selected': 'user',
    },
    {
      'type': 'enable',
      'value': true,
    }
  ];
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    localdata = ref.watch(notifierAccountsEdit);

    return Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
            child: Scaffold(
          appBar: AppBar(
            leading: mainE == null
                ? Icon(Icons.edit)
                : Hero(tag: '${mainE!['pk']}', child: Icon(Icons.edit)),
            title: Text(mainE == null ? "إنشاء حساب جديد" : "تعديل حساب"),
            actions: [
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_forward))
            ],
          ),
          body: localdata.isEmpty
              ? const Center(
                  child: Text("لا يوجد بيانات لعرضها"),
                )
              : SingleChildScrollView(
                  child: datacolumns(
                      ref: ref,
                      refnotifier: notifierAccountsEdit,
                      ctx: context)),
        )));
  }

  datacolumns({required WidgetRef ref, refnotifier, required ctx}) {
    GlobalKey<FormState> formkey = GlobalKey<FormState>();
    return Center(
      child: SizedBox(
        width: 500,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Form(
                    key: formkey,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ...localdata
                              .where((element) => element['type'] == 'tf')
                              .map((e) {
                            return SizedBox(
                              width: 400,
                              child: TextFormField(
                                style: Theme.of(ctx).textTheme.bodyMedium,
                                maxLines: e['maxlines'] ?? 1,
                                validator: (value) {
                                  switch (e['validate_role']) {
                                    case 'empty':
                                      if (e['controller'].text != null &&
                                          e['controller'].text.trim().isEmpty) {
                                        return "لا يمكن ان يكون الحقل فارغا";
                                      }
                                    case 'empty_if_not_e':
                                      if (mainE == null &&
                                          e['controller'].text != null &&
                                          e['controller'].text.isEmpty) {
                                        return "لا يمكن ان يكون الحقل فارغا";
                                      }

                                    case 'not_eq_prev':
                                      if (e['controller'].text !=
                                          localdata[localdata.indexOf(e) - 1]
                                                  ['controller']
                                              .text) {
                                        return "كلمات المرور غير متطابقة";
                                      }
                                  }
                                },
                                textAlign: TextAlign.center,
                                controller: e['controller'],
                                obscureText: e['obscuretext'] ?? false,
                                keyboardType: e['keyboard'],
                                decoration: InputDecoration(
                                  suffix: e['suffix_icon'] == null
                                      ? null
                                      : IconButton(
                                          onPressed: () => ref
                                              .read(refnotifier.notifier)
                                              .swappasswordstatus(
                                                  index: localdata.indexOf(e)),
                                          icon: Icon(e['suffix_icon'])),
                                  label: Text(e['label']),
                                  hintText: e['hint'],
                                ),
                              ),
                            );
                          })
                        ],
                      ),
                    )),
                Visibility(
                  visible: !selfedit,
                  child: SizedBox(
                    width: 400,
                    child: Row(
                      children: [
                        const Text("اختيار الصلاحيات : "),
                        DropdownButton(
                            value: localdata[6]['selected'],
                            items: [
                              ...[
                                'user',
                                'admin',
                                'superadmin'
                              ].map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                      e,
                                      style: Theme.of(ctx).textTheme.bodyMedium,
                                    ),
                                  ))
                            ],
                            onChanged: (x) {
                              ref
                                  .read(refnotifier.notifier)
                                  .chooseitemdromdopdown(x: x, index: 6);
                            })
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: !selfedit,
                  child: SizedBox(
                    width: 400,
                    child: Row(
                      children: [
                        Switch.adaptive(
                            value: localdata[7]['value'],
                            onChanged: (x) {
                              ref
                                  .read(refnotifier.notifier)
                                  .switchkey(x: x, index: 7);
                            }),
                        Text(localdata[7]['value']
                            ? "الحساب فعال"
                            : "الحساب معطل"),
                      ],
                    ),
                  ),
                ),
                const Divider(),
                TextButton.icon(
                    onPressed: () async {
                      if (formkey.currentState!.validate()) {
                        await StlFunction.createEdituser(
                            ctx: ctx, ref: ref, e: mainE);
                      }
                    },
                    icon: const Icon(Icons.save),
                    label: const Text("حفظ"))
              ],
            ),
            Visibility(
              visible: mainE != null &&
                  "${BasicData.userinfo![0]['pk']}" != "${mainE!['pk']}",
              child: Positioned(
                  left: 0.0,
                  child: Container(
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.transparent, Colors.redAccent])),
                    child: IconButton(
                      onPressed: () => showDialog(
                          context: ctx,
                          builder: (_) => AlertDialog(
                                title:
                                    const Text("هل أنت متأكد من حذف الحساب؟"),
                                actions: [
                                  IconButton(
                                      onPressed: () async =>
                                          await StlFunction.delete(
                                              notifier: notifierAccountsdata,
                                              ctx: ctx,
                                              ref: ref,
                                              model: 'accounts',
                                              id: "${mainE!['pk']}"),
                                      icon: Icon(Icons.delete_forever))
                                ],
                              )),
                      icon: Icon(
                        Icons.delete_forever,
                        color: Colors.white,
                      ),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
