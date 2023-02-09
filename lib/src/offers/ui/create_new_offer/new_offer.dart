import 'dart:async';
import 'package:another_stepper/another_stepper.dart';
import 'package:another_stepper/widgets/another_stepper.dart';
import 'package:dart_wom_connector/dart_wom_connector.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pos/localization/app_localizations.dart';
import 'package:pos/src/my_logger.dart';
import 'package:pos/src/offers/application/create_offer_notifier.dart';
import 'package:pos/src/offers/application/offers.dart';
import 'package:pos/src/offers/ui/create_new_offer/widgets/common_card.dart';
import 'package:pos/src/offers/ui/create_new_offer/widgets/filter_fields.dart';
import 'package:pos/src/offers/ui/create_new_offer/widgets/summary.dart';
import 'package:pos/src/offers/ui/create_new_offer/widgets/type_selector.dart';
import 'package:pos/src/screens/create_payment/pages/aim_selection/bloc.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class NewOfferScreen extends HookConsumerWidget {
  NewOfferScreen({Key? key}) : super(key: key);

  final stepperList = [
    StepperData(
      title: StepperText(
        "Tipo",
        // textStyle: const TextStyle(
        //   color: Colors.grey,
        // ),
      ),
      // iconWidget: Container(
      //   padding: const EdgeInsets.all(8),
      //   decoration: const BoxDecoration(
      //       color: Colors.green,
      //       borderRadius: BorderRadius.all(Radius.circular(30))),
      //   child: const Icon(Icons.looks_one, color: Colors.white),
      // ),
    ),
    StepperData(
      title: StepperText("Info"),
      // iconWidget: Container(
      //   padding: const EdgeInsets.all(8),
      //   decoration: const BoxDecoration(
      //       color: Colors.green,
      //       borderRadius: BorderRadius.all(Radius.circular(30))),
      //   child: const Icon(Icons.looks_two, color: Colors.white),
      // ),
    ),
    StepperData(
      title: StepperText("Filtri"),
      // iconWidget: Container(
      //   padding: const EdgeInsets.all(8),
      //   decoration: const BoxDecoration(
      //       color: Colors.green,
      //       borderRadius: BorderRadius.all(Radius.circular(30))),
      //   child: const Icon(Icons.looks_3, color: Colors.white),
      // ),
    ),
    StepperData(
      title: StepperText(
        "Sommario",
        // textStyle: const TextStyle(
        //   color: Colors.grey,
        // ),
      ),
    ),
  ];

  showError(BuildContext context, {String? desc}) {
    Alert(
      context: context,
      title: 'Si è verificato un errore',
      desc: desc,
      buttons: [],
    ).show();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createOfferNotifierProvider);
    final activeStep = state.activeStep;
    return WillPopScope(
      onWillPop: () {
        if (activeStep > 0) {
          ref.read(createOfferNotifierProvider.notifier).backStep();
          return Future.value(false);
        }

        return Future.value(true);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text('Nuova offerta'),
          // bottom: PreferredSize(
          //   preferredSize: Size.fromHeight(100),
          //   child: AnotherStepper(
          //     activeBarColor: Colors.yellow,
          //     inActiveBarColor: Colors.white,
          //     activeIndex: activeStep,
          //     stepperList: stepperList,
          //     stepperDirection: Axis.horizontal,
          //     iconWidth: 40,
          //     iconHeight: 40,
          //   ),
          // ),
          // bottom: PreferredSize(
          //   child: Column(
          //     children: [
          //       NumberStepper(
          //         lineColor: Colors.white,
          //         stepColor: Colors.grey[400],
          //         activeStepBorderColor: Colors.white,
          //         activeStepColor: Colors.green,
          //         enableStepTapping: false,
          //         enableNextPreviousButtons: false,
          //         activeStep: activeStep,
          //         numberStyle: TextStyle(
          //           color: Colors.black,
          //           fontWeight: FontWeight.bold,
          //         ),
          //         numbers: [1, 2, 3, 4],
          //       ),
          //       Padding(
          //         padding: const EdgeInsets.symmetric(horizontal: 24.0),
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceAround,
          //           children: [
          //             Expanded(
          //               child: Text(
          //                 'Tipo',
          //                 style: stepperStyle,
          //                 textAlign: TextAlign.center,
          //               ),
          //             ),
          //             Expanded(
          //               child: Text(
          //                 'Info',
          //                 style: stepperStyle,
          //                 textAlign: TextAlign.center,
          //               ),
          //             ),
          //             Expanded(
          //               child: Text(
          //                 'Filtri',
          //                 style: stepperStyle,
          //                 textAlign: TextAlign.center,
          //               ),
          //             ),
          //             Expanded(
          //               child: Text(
          //                 'Sommario',
          //                 style: stepperStyle,
          //                 textAlign: TextAlign.center,
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //       const SizedBox(height: 16),
          //     ],
          //   ),
          //   preferredSize: Size.fromHeight(100),
          // ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              AnotherStepper(
                activeBarColor: Colors.blue,
                // inActiveBarColor: Colors.white,
                activeIndex: activeStep,
                stepperList: stepperList,
                stepperDirection: Axis.horizontal,
                iconWidth: 40,
                iconHeight: 40,
              ),
              const SizedBox(height: 16),
              Text(
                headerText(activeStep),
                style: TextStyle(fontSize: 30),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView(
                  children: [
                    if (activeStep == 0)
                      SelectOfferType()
                    else if (activeStep == 1)
                      MandatoryInfo()
                    else if (activeStep == 2)
                      SimpleFilterBuilder()
                    else if (activeStep == 3)
                      Summary(),
                  ],
                ),
              )
            ],
          ),
        ),
        persistentFooterAlignment: AlignmentDirectional.center,
        persistentFooterButtons: [
          Row(
            children: [
              if (activeStep > 0)
                TextButton(
                  onPressed: () {
                    ref.read(createOfferNotifierProvider.notifier).backStep();
                  },
                  child: Text('Indietro'),
                ),
              Spacer(),
              FloatingActionButton(
                child:
                    Icon(activeStep == 3 ? Icons.check : Icons.navigate_next),
                onPressed: () {
                  if (activeStep == 3) {
                    Alert(
                        context: context,
                        title: 'Vuoi creare l\'offerta?',
                        buttons: [
                          DialogButton(
                            child: Text('Sì'),
                            onPressed: () async {
                              try {
                                await ref
                                    .read(createOfferNotifierProvider.notifier)
                                    .createOffer();
                                ref.invalidate(getOffersProvider(posId:ref.read(selectedPosProvider)?.pos!.id));
                                Navigator.of(context).pop();
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              } catch (ex) {
                                logger.e(ex);
                                Navigator.of(context).pop();
                                showError(context);
                              }
                            },
                          )
                        ]).show();
                  } else {
                    ref.read(createOfferNotifierProvider.notifier).nextStep();
                  }
                },
              ),
            ],
          ),
        ],
        // floatingActionButton: Row(
        //   children: [
        //     if (activeStep > 0)
        //       Padding(
        //         padding: const EdgeInsets.only(left: 32.0),
        //         child: TextButton(
        //           onPressed: () {
        //             ref.read(createOfferNotifierProvider.notifier).backStep();
        //           },
        //           child: Text('Indietro'),
        //         ),
        //       ),
        //     Spacer(),
        //     FloatingActionButton(
        //       child: Icon(activeStep == 3 ? Icons.check : Icons.navigate_next),
        //       onPressed: () {
        //         if (activeStep == 3) {
        //           Alert(
        //               context: context,
        //               title: 'Vuoi creare l\'offerta?',
        //               buttons: [
        //                 DialogButton(
        //                   child: Text('Sì'),
        //                   onPressed: () {
        //                     ref
        //                         .read(createOfferNotifierProvider.notifier)
        //                         .createOffer();
        //                   },
        //                 )
        //               ]).show();
        //         } else {
        //           ref.read(createOfferNotifierProvider.notifier).nextStep();
        //         }
        //       },
        //     ),
        //   ],
        // ),
      ),
    );
  }

  String headerText(int activeStep) {
    switch (activeStep) {
      case 0:
        return 'Tipo di offerta';

      case 1:
        return 'Informazioni necessarie';

      case 2:
        return 'Filtri';

      case 3:
        return 'Resoconto';

      default:
        return 'Offerta';
    }
  }
}

class MandatoryInfo extends HookConsumerWidget {
  const MandatoryInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleFocus = useFocusNode();
    final descFocus = useFocusNode();
    final womFocus = useFocusNode();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          CreateOfferCard(
            title: 'Titolo',
            description: 'Il titolo dell\'offerta è importante...',
            mandatory: true,
            child: TextFormField(
              focusNode: titleFocus,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (v) {
                descFocus.requestFocus();
              },
              controller: ref.watch(titleControllerProvider),
              decoration: InputDecoration(hintText: 'Scrivi qui'),
            ),
          ),
          CreateOfferCard(
            title: 'Descrizione',
            description:
                'Una descrizione può aiutare l utente a comprendere come....',
            child: TextFormField(
              focusNode: descFocus,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (v) {
                womFocus.requestFocus();
              },
              controller: ref.watch(descControllerProvider),
              decoration: InputDecoration(hintText: 'Scrivi qui'),
            ),
          ),
          CreateOfferCard(
            title: 'Numero di WOM',
            description: 'Il numero di WOM necessari per aderire all offerta',
            mandatory: true,
            child: TextFormField(
              focusNode: womFocus,
              textInputAction: TextInputAction.done,
              controller: ref.watch(womControllerProvider),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[0-9]"))
              ],
              decoration: InputDecoration(hintText: 'Digita il numero di wom'),
            ),
          ),
        ],
      ),
    );
  }
}
