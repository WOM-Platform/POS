import 'dart:async';
import 'package:another_stepper/another_stepper.dart';
import 'package:dart_wom_connector/dart_wom_connector.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_overlay/loading_overlay.dart';

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
  static const String path = 'newOffer';

  NewOfferScreen({Key? key}) : super(key: key);

  showError(BuildContext context, {String? desc}) {
    Alert(
      context: context,
      title: 'somethings_wrong'.tr(),
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
                'new_offer'.tr(),
              ),
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
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
                      child: Text('back'.tr()),
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
                              //   "type") ??
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
                        final navigator = GoRouter.of(context);
                        final res = await askChoice(
                          context,
                          'do_you_want_create'.tr(),
                        );

                        if (res) {
                          try {
                            isLoading.value = true;
                            await ref
                                .read(createOfferNotifierProvider.notifier)
                                .createOffer();
                            Navigator.of(context, rootNavigator: true).pop();
                          } on ServerException catch (ex, st) {
                            logger.e(ex);
                            logger.e(st);
                            isLoading.value = false;
                            Alert(
                              context: context,
                              title:
                                  'Spiacenti si è verificato un errore imprevisto',
                              buttons: [
                                DialogButton(
                                  child: Text('Ok'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ).show();
                          } catch (ex, st) {
                            isLoading.value = false;
                            logger.e(ex);
                            logger.e(st);
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
        return 'offer_type'.tr();
      case 1:
        return 'mandatory_info'.tr();
      case 2:
        return 'filters'.tr();
      case 3:
        return 'summary'.tr();
      default:
        return 'offer'.tr();
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
            title: 'title'.tr(),
            description: 'titleOfferDesc'.tr(),
            mandatory: true,
            child: TextFormField(
              focusNode: titleFocus,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (v) {
                descFocus.requestFocus();
              },
              onChanged: (value) {
                if (value.trim().length < 6) {
                  errorTitleText.value = 'titleMinLengthWarning'.tr();
                } else {
                  errorTitleText.value = null;
                }
              },
              controller: ref.watch(titleControllerProvider),
              decoration: InputDecoration(
                hintText: 'write_here'.tr(),
                errorText: errorTitleText.value,
              ),
            ),
          ),
          if (ref.watch(createOfferNotifierProvider).type ==
              OfferType.persistent)
            CreateOfferCard(
              title: 'description'.tr(),
              description: 'descriptionOfferDesc'.tr(),
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
                  hintText: 'write_here'.tr(),
                ),
              ),
            ),
          CreateOfferCard(
            title: 'wom_number'.tr(),
            description: 'womNumberDesc'.tr(),
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
                  errorWomText.value = 'noZeroWomWarning'.tr();
                } else {
                  errorWomText.value = null;
                }
              },
              decoration: InputDecoration(
                hintText: 'writeWomNumber'.tr(),
                errorText: errorWomText.value,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
