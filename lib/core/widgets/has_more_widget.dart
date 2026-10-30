import 'package:minimalist_store/store_app.dart';

class HasMoreWidget extends StatelessWidget {
  const HasMoreWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 25.h,
        width: 25.h,
        margin: EdgeInsets.symmetric(vertical: 15.h),
        child: const Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.white,
            color: AppColors.primary,
            strokeWidth: 6,
          ),
        ),
      ),
    );
  }
}
