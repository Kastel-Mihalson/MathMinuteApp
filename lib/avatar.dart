import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'app_state.dart';
import 'levels.dart';
import 'theme.dart';

/// Готовые аватары: иконка и подпись.
const List<IconData> kAvatarIcons = [
  Icons.person_rounded,
  Icons.bolt_rounded,
  Icons.local_fire_department_rounded,
  Icons.spa_rounded,
  Icons.star_rounded,
  Icons.public_rounded,
  Icons.workspace_premium_rounded,
  Icons.track_changes_rounded,
];

const List<String> kAvatarNames = [
  'Силуэт',
  'Молния',
  'Пламя',
  'Росток',
  'Звезда',
  'Планета',
  'Корона',
  'Цель',
];

/// Аватар пользователя: фото или готовый символ в кольце с прогрессом уровня.
class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    this.size = 84,
    this.accent,
    this.showBadge = true,
    this.editable = false,
    this.onTap,
  });

  final double size;

  /// Цвет кольца, символа и значка уровня. По умолчанию акцент стиля.
  final Color? accent;
  final bool showBadge;

  /// Показывать значок «изменить».
  final bool editable;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final pal = context.pal;
    final color = accent ?? pal.primary;
    final badgeText = color == pal.onPrimary ? pal.primary : pal.onPrimary;
    const ring = 5.0;
    final inner = size - (ring + 4) * 2;

    final photo = appState.avatarPhoto;
    final preset = appState.avatarPreset;
    final iconIndex =
        (preset >= 0 && preset < kAvatarIcons.length) ? preset : 0;

    final Widget face = photo != null
        ? ClipOval(
            child: Image.memory(
              photo,
              width: inner,
              height: inner,
              fit: BoxFit.cover,
              gaplessPlayback: true,
              errorBuilder: (_, __, ___) => Icon(
                kAvatarIcons[0],
                size: inner * 0.55,
                color: color,
              ),
            ),
          )
        : Container(
            width: inner,
            height: inner,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.20),
            ),
            child: Icon(kAvatarIcons[iconIndex], size: inner * 0.55, color: color),
          );

    final avatar = SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: 1,
              strokeWidth: ring,
              color: color.withValues(alpha: 0.25),
            ),
          ),
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: levelProgress(appState.xp).clamp(0.02, 1.0).toDouble(),
              strokeWidth: ring,
              strokeCap: StrokeCap.round,
              color: color,
            ),
          ),
          face,
          if (showBadge)
            Positioned(
              right: -4,
              bottom: -2,
              child: Container(
                constraints: const BoxConstraints(minWidth: 28),
                height: 28,
                padding: const EdgeInsets.symmetric(horizontal: 6),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  '${appState.level}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: badgeText,
                  ),
                ),
              ),
            ),
          if (editable)
            Positioned(
              right: -4,
              top: -2,
              child: Container(
                width: 26,
                height: 26,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: pal.card,
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 1.5),
                ),
                child: Icon(Icons.edit_rounded, size: 14, color: color),
              ),
            ),
        ],
      ),
    );

    if (onTap == null) return avatar;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: avatar,
    );
  }
}

/// Окно выбора аватара: фото с камеры, из галереи или готовый символ.
Future<void> showAvatarSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => const _AvatarSheet(),
  );
}

class _AvatarSheet extends StatelessWidget {
  const _AvatarSheet();

  Future<void> _pick(BuildContext context, ImageSource source) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final file = await ImagePicker().pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );
      if (file == null) return;
      final bytes = await file.readAsBytes();
      await appState.setAvatarPhoto(bytes);
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text(
            'Не удалось получить фото. Проверьте доступ к камере и галерее.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final pal = context.pal;
    final tt = Theme.of(context).textTheme;

    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final hasCustom = appState.avatarPhoto != null || appState.avatarPreset >= 0;
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: UserAvatar(size: 104)),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _SourceButton(
                        icon: Icons.photo_camera_rounded,
                        label: 'Сделать фото',
                        onTap: () => _pick(context, ImageSource.camera),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _SourceButton(
                        icon: Icons.photo_library_rounded,
                        label: 'Из галереи',
                        onTap: () => _pick(context, ImageSource.gallery),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                Text(
                  'Готовые аватары',
                  style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  children: [
                    for (var i = 0; i < kAvatarIcons.length; i++)
                      _PresetTile(
                        index: i,
                        selected: appState.avatarPhoto == null &&
                            (appState.avatarPreset == i ||
                                (appState.avatarPreset < 0 && i == 0)),
                      ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  'Фото хранится только на вашем телефоне и никуда не отправляется.',
                  style: tt.bodySmall?.copyWith(color: context.appMuted),
                ),
                if (hasCustom) ...[
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: appState.resetAvatar,
                    icon: Icon(Icons.restart_alt_rounded, color: pal.primary),
                    label: Text(
                      'Сбросить аватар',
                      style: TextStyle(color: pal.primary),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SourceButton extends StatelessWidget {
  const _SourceButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final pal = context.pal;
    return Material(
      color: pal.primary.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Icon(icon, color: pal.primary, size: 28),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PresetTile extends StatelessWidget {
  const _PresetTile({required this.index, required this.selected});

  final int index;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final pal = context.pal;
    return Semantics(
      label: kAvatarNames[index],
      button: true,
      selected: selected,
      child: GestureDetector(
        onTap: () => appState.setAvatarPreset(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: selected
                ? pal.primary.withValues(alpha: 0.18)
                : pal.primary.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: selected ? pal.primary : Colors.transparent,
              width: 2,
            ),
          ),
          child: Icon(kAvatarIcons[index], color: pal.primary, size: 32),
        ),
      ),
    );
  }
}
