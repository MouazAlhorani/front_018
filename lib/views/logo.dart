import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mouaz_app_018/controllers/tween_mz.dart';

class LoGoMz extends ConsumerWidget {
  const LoGoMz({super.key});
  static double endvaluerotate = 0.0;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    endvaluerotate = 75.0;
    return Column(
      children: [
        const Divider(),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Stack(
              children: [
                TweenM(
                  begin: 0.0,
                  end: 1.0,
                  durationinmilli: 600,
                  type: 'scalex',
                  child: TweenM(
                      alignment: Alignment.bottomCenter,
                      begin: 0.0,
                      end: 1.0,
                      durationinmilli: 600,
                      type: 'opacity',
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                bottomRight: Radius.elliptical(5, 3)),
                            gradient: LinearGradient(colors: [
                              Colors.blueGrey.withOpacity(0.4),
                              Colors.transparent,
                              Colors.transparent,
                              Colors.deepPurpleAccent
                            ]),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(6, 6),
                                  blurRadius: 6.9)
                            ]),
                        width: 300,
                        height: 40,
                      )),
                ),
                Positioned(
                  left: 10,
                  bottom: 0,
                  child: TweenM(
                    begin: 0.0,
                    end: 1.0,
                    durationinmilli: 600,
                    type: 'scaley',
                    child: TweenM(
                        alignment: Alignment.bottomCenter,
                        begin: 0.0,
                        end: 1.0,
                        durationinmilli: 600,
                        type: 'opacity',
                        child: Container(
                          color: Colors.white,
                          width: 8,
                          height: 25,
                        )),
                  ),
                ),
                Positioned(
                  left: 25,
                  bottom: 5,
                  child: TweenM(
                    begin: 0.0,
                    end: 1.0,
                    durationinmilli: 700,
                    type: 'scaley',
                    child: TweenM(
                        alignment: Alignment.bottomCenter,
                        begin: 0.0,
                        end: 1.0,
                        durationinmilli: 700,
                        type: 'opacity',
                        child: Container(
                          color: Colors.white,
                          width: 8,
                          height: 25,
                        )),
                  ),
                ),
                Positioned(
                  left: 40,
                  bottom: 10,
                  child: TweenM(
                    begin: 0.0,
                    end: 1.0,
                    durationinmilli: 800,
                    type: 'scaley',
                    child: TweenM(
                        alignment: Alignment.bottomCenter,
                        begin: 0.0,
                        end: 1.0,
                        durationinmilli: 800,
                        type: 'opacity',
                        child: Container(
                          color: Colors.white,
                          width: 8,
                          height: 25,
                        )),
                  ),
                ),
                Positioned(
                  left: 55,
                  bottom: 2,
                  child: TweenM(
                    begin: 0.0,
                    end: 1.0,
                    durationinmilli: 900,
                    type: 'scaley',
                    child: TweenM(
                        alignment: Alignment.bottomCenter,
                        begin: 0.0,
                        end: 1.0,
                        durationinmilli: 900,
                        type: 'opacity',
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15)),
                              border:
                                  Border.all(color: Colors.white, width: 4)),
                          width: 30,
                          height: 25,
                        )),
                  ),
                ),
                Positioned(
                  left: 90,
                  bottom: 0,
                  child: TweenM(
                    begin: 0.0,
                    end: 1.0,
                    durationinmilli: 1000,
                    type: 'scaley',
                    child: TweenM(
                        alignment: Alignment.bottomCenter,
                        begin: 0.0,
                        end: 1.0,
                        durationinmilli: 1000,
                        type: 'opacity',
                        child: Container(
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              border: Border(
                                  bottom:
                                      BorderSide(color: Colors.white, width: 4),
                                  left:
                                      BorderSide(color: Colors.white, width: 4),
                                  right: BorderSide(
                                      color: Colors.white, width: 4))),
                          width: 20,
                          height: 25,
                        )),
                  ),
                ),
                Positioned(
                  left: 100,
                  bottom: 10,
                  child: TweenM(
                    begin: 0.0,
                    end: 1.0,
                    durationinmilli: 1100,
                    type: 'scaley',
                    child: TweenM(
                        alignment: Alignment.bottomCenter,
                        begin: 0.0,
                        end: 1.0,
                        durationinmilli: 1100,
                        type: 'opacity',
                        child: Container(
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              border: Border(
                                  top:
                                      BorderSide(color: Colors.white, width: 4),
                                  left:
                                      BorderSide(color: Colors.white, width: 4),
                                  right: BorderSide(
                                      color: Colors.white, width: 4))),
                          width: 20,
                          height: 25,
                        )),
                  ),
                ),
                Positioned(
                  left: 140,
                  bottom: 10,
                  child: TweenM(
                    begin: 0.0,
                    end: 1.0,
                    durationinmilli: 1200,
                    type: 'scaley',
                    child: TweenM(
                        alignment: Alignment.bottomCenter,
                        begin: 0.0,
                        end: 1.0,
                        durationinmilli: 1200,
                        type: 'opacity',
                        child: Container(
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(2)),
                              border: Border(
                                  top:
                                      BorderSide(color: Colors.white, width: 4),
                                  bottom:
                                      BorderSide(color: Colors.white, width: 4),
                                  right: BorderSide(
                                      color: Colors.white, width: 4))),
                          width: 40,
                          height: 20,
                        )),
                  ),
                ),
                Positioned(
                  left: 130,
                  bottom: 0,
                  child: TweenM(
                    begin: 0.0,
                    end: 1.0,
                    durationinmilli: 1300,
                    type: 'scaley',
                    child: TweenM(
                        alignment: Alignment.bottomCenter,
                        begin: 0.0,
                        end: 1.0,
                        durationinmilli: 1300,
                        type: 'opacity',
                        child: Container(
                          decoration: const BoxDecoration(
                              border: Border(
                                  top:
                                      BorderSide(color: Colors.white, width: 4),
                                  bottom:
                                      BorderSide(color: Colors.white, width: 4),
                                  left: BorderSide(
                                      color: Colors.white, width: 4))),
                          width: 40,
                          height: 20,
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
