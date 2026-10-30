import 'package:minimalist_store/store_app.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.header,
    this.hintText,
    this.controller,
    this.textInputType,
    this.textInputAction,
    this.error,
    this.onChanged,
    this.isEnable = true,
    this.readOnly = false,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.onSubmitted,
    this.focusNode,
  });

  final String? header, hintText, error;
  final TextEditingController? controller;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final void Function(String value)? onChanged, onSubmitted;
  final bool readOnly, isEnable, obscureText;
  final Widget? prefixIcon, suffixIcon;
  final int? maxLines;
  final FocusNode? focusNode;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.header != null) ...[
          Text(widget.header!, style: styleW600S14),
          8.h.spaceVertical,
        ],
        TextField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          enabled: widget.isEnable,
          readOnly: widget.readOnly,
          obscureText: widget.obscureText,
          keyboardType: widget.textInputType,
          textInputAction: widget.textInputAction,
          maxLines: widget.obscureText ? 1 : widget.maxLines,
          onChanged: widget.onChanged,
          onSubmitted: widget.onSubmitted,
          style: styleW500S16,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: styleW400S14.copyWith(color: AppColors.grey2),
            filled: true,
            fillColor: AppColors.surface,
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.suffixIcon,
            errorText: widget.error,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: 16.h,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2.r),
              borderSide: BorderSide(color: AppColors.text02),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2.r),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2.r),
              borderSide: const BorderSide(color: AppColors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2.r),
              borderSide: const BorderSide(color: AppColors.red),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2.r),
              borderSide: BorderSide(color: AppColors.text01),
            ),
          ),
        ),
      ],
    );
  }
}
