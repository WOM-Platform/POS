import 'package:dart_wom_connector/dart_wom_connector.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_overlay/loading_overlay.dart';

import 'package:pos/src/add_image/ui/add_image.dart';
import 'package:pos/src/blocs/authentication/authentication_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pos/src/blocs/authentication/authentication_state.dart';
import 'package:pos/src/my_logger.dart';
import 'package:pos/src/offers/application/offers.dart';
import 'package:pos/src/screens/settings/settings.dart';
import 'package:pos/src/services/user_repository.dart';
import 'package:pos/src/signup/ui/screens/create_merchant.dart';

class POSManagerScreen extends HookConsumerWidget {
  static const String path = 'posManager';
  const POSManagerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final posUser = ref.watch(posUserProvider);
    final posCount = posUser?.merchants.fold<int>(
        0, (previousValue, element) => previousValue + element.posList.length) ?? 0;
    final tabController = useTabController(initialLength: posCount);
    final merchants = posUser?.merchants ?? [];
    // final List<PointOfSale> list = merchants.expand((e) => e.posList).toList();
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            color: Colors.white,
            onPressed: () {
              context.go('/${SettingsScreen.path}/${POSManagerScreen.path}/${CreateMerchantScreen.path}');
            },
          ),
        ],
        title: Text('handlePos'.tr()),
        bottom: TabBar(
          isScrollable: true,
          controller: tabController,
          tabs: [
            for (var m in merchants)
              for (var pos in m.posList)
                Tab(
                  text: pos.name,
                  // icon: Icon(Icons.directions_car),
                ),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          for (var m in merchants)
            for (var pos in m.posList)
              POSHandler(
                pos,
                m.access == MerchantAccess.admin,
              ),
        ],
      ),
    );
  }
}

class POSHandler extends ConsumerWidget {
  final PointOfSale pos;
  final bool canEdit;

  const POSHandler(this.pos, this.canEdit, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final keyStyle = TextStyle(color: Colors.grey);
    return ListView(
      // padding: const EdgeInsets.symmetric(vertical: 16.0),
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
            children: [
              if (pos.cover?.midDensityFullWidthUrl != null)
                Positioned.fill(
                  child: CachedNetworkImage(
                    imageUrl: pos.cover!.midDensityFullWidthUrl,
                    fit: BoxFit.contain,
                  ),
                )
              else
                Container(
                  color: Colors.grey[300],
                  child: Center(
                    child: Icon(
                      Icons.image,
                      size: 120,
                    ),
                  ),
                ),
              if (canEdit)
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: CircleButton(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => AddImageScreen(
                            aspectRatio: 16 / 9,
                            onSave: (bytes) async {
                              final userRepo = ref.read(userRepositoryProvider);
                              final token = await userRepo.getToken();
                              if (token == null) {
                                return;
                              }
                              await ref
                                  .read(getPosProvider)
                                  .updateCover(pos.id, bytes, token);
                              ref.read(authNotifierProvider.notifier).refresh();
                            },
                          ),
                        ),
                      );
                    },
                    icon: Icons.edit,
                  ),
                )
            ],
          ),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Text(
                    'name'.tr(),
                    style: keyStyle,
                  ),
                  const SizedBox(width: 8),
                  if (canEdit)
                    CircleButton(
                      radius: 10,
                      icon: Icons.edit,
                      onTap: () {
                        edit(
                          ref: ref,
                          initialText: pos.name,
                          title: 'posName' 'try_again'.tr(),
                          maxLength: 28,
                          minLength: 4,
                          maxLines: 1,
                          onSave: (title) => updateFields(
                              ref, title, pos.description, pos.url),
                        );
                      },
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      pos.name,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    decoration: BoxDecoration(
                        color: pos.isActive ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(16)),
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: Text(
                      pos.isActive ? 'active'.tr() : 'inactive'.tr(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Text(
                    'description'.tr(),
                    style: keyStyle,
                  ),
                  const SizedBox(width: 8),
                  if (canEdit)
                    CircleButton(
                      radius: 10,
                      icon: Icons.edit,
                      onTap: () {
                        edit(
                          ref: ref,
                          initialText: pos.description,
                          title: 'posDescription'.tr(),
                          maxLength: 4096,
                          maxLines: 3,
                          onSave: (description) =>
                              updateFields(ref, pos.name, description, pos.url),
                        );
                      },
                    ),
                ],
              ),
              Text(
                pos.description ?? '',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Text(
                    'website'.tr(),
                    style: keyStyle,
                  ),
                  const SizedBox(width: 8),
                  if (canEdit)
                    CircleButton(
                      radius: 10,
                      icon: Icons.edit,
                      onTap: () {
                        edit(
                          ref: ref,
                          initialText: pos.url,
                          title: 'edit_url'.tr(),
                          maxLines: 1,
                          onSave: (url) =>
                              updateFields(ref, pos.name, pos.description, url),
                        );
                      },
                    ),
                ],
              ),
              Text(
                pos.url ?? '-',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
        if (pos.latitude != null && pos.longitude != null)
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: GoogleMap(
                zoomGesturesEnabled: false,
                rotateGesturesEnabled: false,
                scrollGesturesEnabled: false,
                zoomControlsEnabled: false,
                markers: {
                  Marker(
                      markerId: MarkerId(pos.id),
                      position: LatLng(pos.latitude!, pos.longitude!))
                },
                initialCameraPosition: CameraPosition(
                  target: LatLng(pos.latitude!, pos.longitude!),
                  zoom: 18,
                ),
              ),
            ),
          ),
        const SizedBox(height: 24),
      ],
    );
  }

  void edit({
    required WidgetRef ref,
    required String title,
    String? initialText,
    int? maxLines,
    int? maxLength,
    int? minLength,
    Future Function(String)? onSave,
  }) {
    showDialog(
      context: ref.context,
      builder: (BuildContext context) {
        return Dialog(
          child: EditTextDialog(
            title: title,
            initialText: initialText,
            onSave: onSave,
            maxLines: maxLines ?? 1,
            minLength: minLength,
            maxLength: maxLength,
          ),
        );
      },
    );
  }

  Future<void> updateFields(
    WidgetRef ref,
    String title,
    String? description,
    String? url,
  ) async {
    final authState = ref.read(authNotifierProvider);

    if (authState is! AuthenticationAuthenticated) return;

    final newPos =
        pos.copyWith(name: title, description: description, url: url);
    if (pos == newPos) return;
    await ref.read(getPosProvider).updatePos(newPos, authState.token);
    await ref.read(authNotifierProvider.notifier).refresh();
  }
}

class CircleButton extends StatelessWidget {
  final Function()? onTap;
  final double radius;
  final IconData icon;

  const CircleButton({
    Key? key,
    this.onTap,
    required this.icon,
    this.radius = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: CircleAvatar(
        radius: radius,
        child: Icon(
          icon,
          size: radius + 4,
        ),
      ),
    );
  }
}

class EditTextDialog extends HookConsumerWidget {
  final String? initialText;
  final String title;
  final int maxLines;
  final int? maxLength;
  final int? minLength;
  final Future Function(String)? onSave;

  const EditTextDialog({
    Key? key,
    this.initialText,
    this.onSave,
    this.maxLength,
    this.minLength,
    this.maxLines = 1,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tc = useTextEditingController(text: initialText);
    final isLoading = useState<bool>(false);
    final errorText = useState<String?>(null);
    return Container(
      constraints: BoxConstraints(maxHeight: 180.0 + (maxLines * 24.0)),
      child: LoadingOverlay(
        isLoading: isLoading.value,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            // mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: tc,
                maxLines: maxLines,
                maxLength: maxLength,
                onChanged: (v) {
                  if (v.length < (minLength ?? 0)) {
                    errorText.value = '${'minLengthWarn2'.tr()} $minLength';
                  } else {
                    errorText.value = null;
                  }
                },
                decoration: InputDecoration(
                  errorText: errorText.value,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: errorText.value == null
                    ? () async {
                        try {
                          isLoading.value = true;
                          await onSave?.call(tc.text.trim());
                          isLoading.value = false;
                          Navigator.of(context).pop();
                        } catch (ex) {
                          logger.e(ex);
                          isLoading.value = false;
                        }
                      }
                    : null,
                child: Text(
                  'update'.tr(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
