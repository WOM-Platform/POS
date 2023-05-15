import 'dart:async';
import 'package:another_stepper/another_stepper.dart';
import 'package:dart_wom_connector/dart_wom_connector.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:pos/localization/app_localizations.dart';
import 'package:pos/src/my_logger.dart';
import 'package:pos/src/offers/application/create_offer_notifier.dart';
import 'package:pos/src/offers/application/offers.dart';
import 'package:pos/src/offers/domain/entities/offert_type.dart';
import 'package:pos/src/offers/ui/create_new_offer/widgets/common_card.dart';
import 'package:pos/src/offers/ui/create_new_offer/widgets/filter_fields.dart';
import 'package:pos/src/offers/ui/create_new_offer/widgets/summary.dart';
import 'package:pos/src/offers/ui/create_new_offer/widgets/type_selector.dart';
import 'package:pos/src/utils.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class NewOfferScreen extends HookConsumerWidget {
  NewOfferScreen({Key? key}) : super(key: key);

  showError(BuildContext context, {String? desc}) {
    Alert(
      context: context,
      title: AppLocalizations.of(context)?.translate("somethings_wrong") ?? '-',
      desc: desc,
      buttons: [],
    ).show();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createOfferNotifierProvider);
    final activeStep = state.activeStep;
    final isLoading = useState<bool>(false);
    return WillPopScope(
      onWillPop: () {
        if (activeStep > 0) {
          ref.read(createOfferNotifierProvider.notifier).backStep();
          return Future.value(false);
        }

        return Future.value(true);
      },
      child: LoadingOverlay(
        isLoading: isLoading.value,
        child: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: Text(
                  AppLocalizations.of(context)?.translate('new_offer') ?? '-'),
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
              child: SingleChildScrollView(
                reverse: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        headerText(context, activeStep),
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                    if (activeStep == 0)
                      SelectOfferType()
                    else if (activeStep == 1)
                      MandatoryInfo()
                    else if (activeStep == 2)
                      SimpleFilterBuilder()
                    else if (activeStep == 3)
                      Summary(),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                    ),
                  ],
                ),
              ),
            ),
            // persistentFooterAlignment: AlignmentDirectional.center,
            // persistentFooterButtons: [
            //   Row(
            //     children: [
            //       if (activeStep > 0)
            //         TextButton(
            //           onPressed: () {
            //             ref
            //                 .read(createOfferNotifierProvider.notifier)
            //                 .backStep();
            //           },
            //           child: Text(
            //               AppLocalizations.of(context)?.translate('back') ??
            //                   '-'),
            //         ),
            //       Flexible(
            //         child: Padding(
            //           padding: const EdgeInsets.symmetric(horizontal: 16.0),
            //           child: AnotherStepper(
            //             activeBarColor: Colors.blue,
            //             // inActiveBarColor: Colors.white,
            //             activeIndex: activeStep,
            //             stepperList: [
            //               StepperData(
            //                 // title: StepperText(
            //                 //   AppLocalizations.of(context)?.translate("type") ??
            //                 //       '-',
            //                 // ),
            //               ),
            //               StepperData(
            //                 // title: StepperText(AppLocalizations.of(context)
            //                 //         ?.translate("info") ??
            //                 //     '-'),
            //               ),
            //               StepperData(
            //                 // title: StepperText(AppLocalizations.of(context)
            //                 //         ?.translate("filters") ??
            //                 //     '-'),
            //               ),
            //               StepperData(
            //                   // title: StepperText(
            //                   //   AppLocalizations.of(context)
            //                   //           ?.translate("summary") ??
            //                   //       '-',
            //                   // ),
            //                   ),
            //             ],
            //             stepperDirection: Axis.horizontal,
            //             iconWidth: 30,
            //             iconHeight: 30,
            //           ),
            //         ),
            //       ),
            //       FloatingActionButton(
            //         child: Icon(
            //             activeStep == 3 ? Icons.check : Icons.navigate_next),
            //         onPressed: () {
            //           if (activeStep == 3) {
            //             Alert(
            //                 context: context,
            //                 title: AppLocalizations.of(context)
            //                         ?.translate('do_you_want_create') ??
            //                     '-',
            //                 buttons: [
            //                   DialogButton(
            //                     child: Text(AppLocalizations.of(context)
            //                             ?.translate('yes') ??
            //                         '-'),
            //                     onPressed: () async {
            //                       try {
            //                         Navigator.of(context).pop();
            //                         isLoading.value = true;
            //                         await ref
            //                             .read(createOfferNotifierProvider
            //                                 .notifier)
            //                             .createOffer();
            //                         Navigator.of(context, rootNavigator: true)
            //                             .pop();
            //                       } catch (ex) {
            //                         isLoading.value = false;
            //                         logger.e(ex);
            //                         Navigator.of(context).pop();
            //                         showError(context);
            //                       }
            //                     },
            //                   )
            //                 ]).show();
            //           } else {
            //             ref
            //                 .read(createOfferNotifierProvider.notifier)
            //                 .nextStep();
            //           }
            //         },
            //       ),
            //     ],
            //   ),
            // ],
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: Container(
              margin: EdgeInsets.only(
                bottom: getBottomInsets(context),
              ),
              padding: const EdgeInsets.all(8),
              color: Colors.white,
              child: Row(
                children: [
                  Visibility(
                    maintainState: true,
                    maintainAnimation: true,
                    maintainSize: true,
                    visible: activeStep > 0,
                    child: TextButton(
                      onPressed: () {
                        ref
                            .read(createOfferNotifierProvider.notifier)
                            .backStep();
                      },
                      child: Text(
                          AppLocalizations.of(context)?.translate('back') ??
                              '-'),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: AnotherStepper(
                        stepperDirection: Axis.horizontal,
                        iconWidth: 25,
                        iconHeight: 25,
                        activeBarColor: Colors.blue,
                        // inActiveBarColor: Colors.white,
                        activeIndex: activeStep,
                        stepperList: [
                          StepperData(
                              // title: StepperText(
                              //   AppLocalizations.of(context)?.translate("type") ??
                              //       '-',
                              // ),
                              ),
                          StepperData(
                              // title: StepperText(AppLocalizations.of(context)
                              //         ?.translate("info") ??
                              //     '-'),
                              ),
                          StepperData(
                              // title: StepperText(AppLocalizations.of(context)
                              //         ?.translate("filters") ??
                              //     '-'),
                              ),
                          StepperData(
                              // title: StepperText(
                              //   AppLocalizations.of(context)
                              //           ?.translate("summary") ??
                              //       '-',
                              // ),
                              ),
                        ],
                      ),
                    ),
                  ),
                  FloatingActionButton(
                    child: Icon(
                        activeStep == 3 ? Icons.check : Icons.navigate_next),
                    onPressed: () async {
                      if (activeStep == 3) {
                        final res = await askChoice(
                          context,
                          AppLocalizations.of(context)
                                  ?.translate('do_you_want_create') ??
                              '-',
                        );

                        if (res) {
                          try {
                            Navigator.of(context).pop();
                            isLoading.value = true;
                            await ref
                                .read(createOfferNotifierProvider.notifier)
                                .createOffer();
                            Navigator.of(context, rootNavigator: true).pop();
                          } catch (ex) {
                            isLoading.value = false;
                            logger.e(ex);
                            Navigator.of(context).pop();
                            showError(context);
                          }
                        }
                      } else {
                        ref
                            .read(createOfferNotifierProvider.notifier)
                            .nextStep();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  double getBottomInsets(BuildContext context) {
    if (MediaQuery.of(context).viewInsets.bottom >
        MediaQuery.of(context).viewPadding.bottom) {
      return MediaQuery.of(context).viewInsets.bottom -
          MediaQuery.of(context).viewPadding.bottom;
    }
    return 0;
  }

  String headerText(BuildContext context, int activeStep) {
    switch (activeStep) {
      case 0:
        return AppLocalizations.of(context)?.translate('offer_type') ?? '-';
      case 1:
        return AppLocalizations.of(context)?.translate('mandatory_info') ?? '-';
      case 2:
        return AppLocalizations.of(context)?.translate('filters') ?? '-';
      case 3:
        return AppLocalizations.of(context)?.translate('summary') ?? '-';
      default:
        return AppLocalizations.of(context)?.translate('offer') ?? '-';
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

    final errorTitleText = useState<String?>(null);
    final errorWomText = useState<String?>(null);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          CreateOfferCard(
            title: AppLocalizations.of(context)?.translate('title') ?? '-',
            description:
                AppLocalizations.of(context)?.translate('titleOfferDesc') ??
                    '-',
            mandatory: true,
            child: TextFormField(
              focusNode: titleFocus,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (v) {
                descFocus.requestFocus();
              },
              onChanged: (value) {
                if (value.trim().length < 6) {
                  errorTitleText.value = AppLocalizations.of(context)
                          ?.translate('titleMinLengthWarning') ??
                      '-';
                } else {
                  errorTitleText.value = null;
                }
              },
              controller: ref.watch(titleControllerProvider),
              decoration: InputDecoration(
                hintText:
                    AppLocalizations.of(context)?.translate('write_here') ??
                        '-',
                errorText: errorTitleText.value,
              ),
            ),
          ),
          if (ref.watch(createOfferNotifierProvider).type ==
              OfferType.persistent)
            CreateOfferCard(
              title:
                  AppLocalizations.of(context)?.translate('description') ?? '-',
              description: AppLocalizations.of(context)
                      ?.translate('descriptionOfferDesc') ??
                  '-',
              child: TextFormField(
                focusNode: descFocus,
                maxLines: 4,
                minLines: 1,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (v) {
                  womFocus.requestFocus();
                },
                controller: ref.watch(descControllerProvider),
                decoration: InputDecoration(
                  hintText:
                      AppLocalizations.of(context)?.translate('write_here') ??
                          '-',
                ),
              ),
            ),
          CreateOfferCard(
            title: AppLocalizations.of(context)?.translate('wom_number') ?? '-',
            description:
                AppLocalizations.of(context)?.translate('womNumberDesc') ?? '-',
            mandatory: true,
            child: TextFormField(
              focusNode: womFocus,
              textInputAction: TextInputAction.done,
              controller: ref.watch(womControllerProvider),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[0-9]"))
              ],
              onChanged: (value) {
                if (int.parse(value) == 0) {
                  errorWomText.value = AppLocalizations.of(context)
                          ?.translate('noZeroWomWarning') ??
                      '-';
                } else {
                  errorWomText.value = null;
                }
              },
              decoration: InputDecoration(
                hintText:
                    AppLocalizations.of(context)?.translate('writeWomNumber') ??
                        '-',
                errorText: errorWomText.value,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
