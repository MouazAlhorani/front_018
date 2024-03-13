import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mouaz_app_018/controllers/provider_mz.dart';
import 'package:mouaz_app_018/controllers/stlfunction.dart';
import 'package:mouaz_app_018/views/logo.dart';

class LogIN extends ConsumerWidget {
  const LogIN({super.key});
  static List<Map> logininput = [
    {
      'controller': TextEditingController(),
      'suffix': false,
      'label': "اسم المستخدم",
      'prefix': Icons.person,
      'obscuretext': false,
      'validateerror': 'لا يمكن أن يكون اسم المستخدم فارغا',
      'keyboard': TextInputType.name
    },
    {
      'controller': TextEditingController(),
      'suffix': true,
      'suffix_icon': Icons.visibility,
      'label': "كلمة المرور",
      'prefix': Icons.key,
      'obscuretext': true,
      'validateerror': 'لا يمكن أن يكون حقل كلمة المرور فارغا',
      'keyboard': TextInputType.visiblePassword
    }
  ];
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    logininput = ref.watch(notifierswaphiddenpassLogin);
    GlobalKey<FormState> formkey = GlobalKey<FormState>();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Center(
          child: SizedBox(
            width: 400,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                    key: formkey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "تسجيل الدخول",
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          const Divider(),
                          ...logininput.map((e) => TextFormField(
                                style: Theme.of(context).textTheme.bodySmall,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return e['validateerror'];
                                  } else {
                                    return null;
                                  }
                                },
                                onEditingComplete: () async {
                                  if (formkey.currentState!.validate()) {
                                    await StlFunction.checklogin(
                                        type: true,
                                        ctx: context,
                                        username: logininput[0]['controller']
                                            .text
                                            .trim(),
                                        password:
                                            logininput[1]['controller'].text);
                                  }
                                },
                                maxLines: 1,
                                keyboardType: e['keyboard'],
                                controller: e['controller'],
                                textAlign: TextAlign.center,
                                obscureText: e['obscuretext'],
                                decoration: InputDecoration(
                                    suffix: e['suffix'] == false
                                        ? null
                                        : IconButton(
                                            onPressed: () {
                                              ref
                                                  .read(
                                                      notifierswaphiddenpassLogin
                                                          .notifier)
                                                  .swappasswordstatus(index: 1);
                                            },
                                            icon: Icon(e['suffix_icon'])),
                                    prefixIcon: Icon(e['prefix']),
                                    label: Text(e['label'])),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton.icon(
                                onPressed: () async {
                                  if (formkey.currentState!.validate()) {
                                    await StlFunction.checklogin(
                                        type: true,
                                        ctx: context,
                                        username: logininput[0]['controller']
                                            .text
                                            .trim(),
                                        password:
                                            logininput[1]['controller'].text);
                                  }
                                },
                                icon: const Icon(Icons.arrow_forward_ios),
                                label: Text(
                                  "دخول",
                                  style: Theme.of(context).textTheme.labelSmall,
                                )),
                          )
                        ],
                      ),
                    )),
              ),
            ),
          ),
        ),
        bottomNavigationBar: const SizedBox(height: 65, child: LoGoMz()),
      ),
    );
  }
}
