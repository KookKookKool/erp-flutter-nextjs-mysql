import 'package:flutter/material.dart';
import 'package:frontend/core/l10n/app_localizations.dart';
import 'package:frontend/core/theme/sun_theme.dart';

class AnnouncementSearchBar extends StatefulWidget {
  final String value;
  final ValueChanged<String> onChanged;
  final VoidCallback? onClear;

  const AnnouncementSearchBar({
    super.key,
    required this.value,
    required this.onChanged,
    this.onClear,
  });

  @override
  State<AnnouncementSearchBar> createState() => _AnnouncementSearchBarState();
}

class _AnnouncementSearchBarState extends State<AnnouncementSearchBar> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(AnnouncementSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: SunTheme.sunSearchBoxDecoration,
      child: TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          hintText: l10n.localeName == 'th'
              ? 'ค้นหาประกาศ...'
              : 'Search announcements...',
          prefixIcon: Icon(Icons.search, color: SunTheme.textSecondary),
          suffixIcon: widget.value.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _controller.clear();
                    widget.onChanged('');
                    widget.onClear?.call();
                  },
                )
              : null,
          hintStyle: TextStyle(color: SunTheme.textSecondary, fontSize: 16),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 20,
          ),
        ),
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
