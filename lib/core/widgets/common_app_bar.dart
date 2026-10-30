import 'package:minimalist_store/store_app.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CommonAppBar({
    super.key,
    this.title = '',
    this.titleWidget,
    this.actions,
    this.showBack = true,
    this.onBackTap,
    this.backgroundColor,
    this.centerTitle = false,
  });

  final String title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final bool showBack;
  final VoidCallback? onBackTap;
  final Color? backgroundColor;
  final bool centerTitle;

  bool get _hasActions => actions != null && actions!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      backgroundColor: backgroundColor ?? AppColors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 10,
      shadowColor: AppColors.text01,
      scrolledUnderElevation: 10,
      centerTitle: centerTitle,
      titleSpacing: 0,
      leadingWidth: 0,
      title: Padding(
        padding: EdgeInsets.only(
          left: AppConstants.horizontalPadding - (showBack ? 4.w : 0),
          right: _hasActions ? 8.w : AppConstants.horizontalPadding,
        ),
        child: Row(
          children: [
            if (showBack) ...[
              CommonIconButton(
                icon: Icons.arrow_back_ios_new_rounded,
                borderRadius: 4.r,
                height: 32.w,
                width: 32.w,
                iconSize: 18.h,
                onTap: onBackTap ?? () => context.navigator.pop(),
              ),
              8.w.spaceHorizontal,
            ],
            Expanded(
              child: titleWidget ??
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: styleW500S18,
                  ),
            ),
            if (_hasActions) ...actions!,
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.h);
}
