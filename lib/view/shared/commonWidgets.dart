import 'package:flutter/material.dart';
import 'package:food_recipes_afame/utils/colors.dart';
import 'package:get/get.dart';

Widget commonText(
  String text, {
  double size = 12.0,
  Color color = Colors.black,
  bool isBold = false,
  softwarp,
  maxline = 1000,
  bool haveUnderline = false,
  fontWeight,
  TextAlign textAlign = TextAlign.left,
}) {
  return Text(
    text.tr,
    overflow: TextOverflow.ellipsis,
    maxLines: maxline,
    softWrap: softwarp,
    textAlign: textAlign,

    style: TextStyle(
      fontSize: size,
      decoration:
          (haveUnderline) ? TextDecoration.underline : TextDecoration.none,
      color: color,

      fontWeight:
          isBold
              ? FontWeight.bold
              : (fontWeight != null)
              ? fontWeight
              : FontWeight.normal,
    ),
  );
}



Widget commonTextfieldWithTitle(
  String title,
  TextEditingController controller, {
  FocusNode? focusNode,
  String hintText = "",
  bool isBold = true,
  bool issuffixIconVisible = false,
  bool isPasswordVisible = false,
  enable,
  textSize = 14.0,
  suffixIcon,
  borderWidth = 0.0,
  double? scale = 3.0,
  optional = false,
  changePasswordVisibility,
  TextInputType keyboardType = TextInputType.text,
  String? assetIconPath,
  Color borderColor = Colors.grey,
  int maxLine = 1,
  Function(String)? onsubmit,
  Function(String)? onChnage,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          commonText(title, size: textSize, fontWeight: FontWeight.w500),
          if (optional)
            commonText("(Optional)", size: textSize, color: Colors.grey),
        ],
      ),
      const SizedBox(height: 8),
      Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: borderColor, width: borderWidth),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: TextField(
              controller: controller,
              enabled: enable,
              focusNode: focusNode,
              onChanged: onChnage,
              keyboardType: keyboardType,
              onSubmitted: onsubmit,
              maxLines: maxLine,
              obscureText: isPasswordVisible,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(12.0),
                hintText: hintText.tr,
                fillColor: AppColors.white,
                filled: true,
                hintStyle: TextStyle(fontSize: 14, color: AppColors.gray),
                border: InputBorder.none,
                suffixIcon:
                    (issuffixIconVisible)
                        ? (!isPasswordVisible)
                            ? InkWell(
                              onTap: changePasswordVisibility,
                              child: Icon(Icons.visibility),
                            )
                            : InkWell(
                              onTap: changePasswordVisibility,
                              child: Icon(Icons.visibility_off_outlined),
                            )
                        : suffixIcon,
                prefixIcon:
                    assetIconPath != null
                        ? Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(assetIconPath, scale: scale),
                        )
                        : null,
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

void navigateToPage(
  Widget page, {
  bool replace = false,
  bool clearStack = false,
  ontap,
  Transition transition = Transition.rightToLeft,
  Duration duration = const Duration(milliseconds: 400),
}) {
  if (clearStack) {
    Get.offAll(
      page,
      transition: transition,
      duration: duration,
    )!.then(ontap ?? (e) {});
  } else if (replace) {
    Get.off(
      page,
      transition: transition,
      duration: duration,
    )!.then(ontap ?? (e) {});
  } else {
    Get.to(
      page,
      transition: transition,
      duration: duration,
    )!.then(ontap ?? (e) {});
  }
}

Widget commonButton(
  String title, {
  Color? color = AppColors.primary,
  Color textColor = Colors.white,
  double textSize = 18,
  double width = double.infinity,
  double height = 50,
  VoidCallback? onTap,
  TextAlign textalign = TextAlign.left,
  boarder,
  double boarderRadious = 10.0,
  Widget? iconWidget,
  bool isLoading = false,
  bool haveNextIcon = false,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(boarderRadious)),
        color: color,
        border: boarder,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child:
              isLoading
                  ? const CircularProgressIndicator()
                  : FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (iconWidget != null) iconWidget,
                        commonText(
                          textAlign: textalign,
                          title,
                          size: textSize,
                          color: textColor,
                          fontWeight: FontWeight.w500,
                        ),
                        if (haveNextIcon)
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Container(
                              padding: const EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                color: AppColors.background.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Icon(
                                Icons.arrow_forward_rounded,
                                color: textColor,
                                size: 24,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
        ),
      ),
    ),
  );
}

Widget commonImageErrorWidget({
  double width = double.infinity,
  
  double iconSize = 48,
  String message = "Image\nnot available",
}) {
  return Container(
    width: width,
    
padding: EdgeInsets.all(16),
    color: Colors.grey.shade300,
    child: Stack(
alignment: Alignment.center,
      children: [
        Icon(Icons.broken_image, size: iconSize, color: Colors.grey),
   
        commonText(
          message,textAlign: TextAlign.center,
          isBold: true

        ),
      ],
    ),
  );
}


Widget buildOTPTextField(
  TextEditingController controller,
  int index,
  BuildContext context,
) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: AppColors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 6,
          offset: const Offset(-3, 0),
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 6,
          offset: const Offset(3, 0),
        ),
      ],
    ),
    width: 55,
    height: 55,
    child: TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      cursorColor: Colors.black,
      style: const TextStyle(fontSize: 20),
      maxLength: 1,
      decoration: InputDecoration(
        counterText: '',
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onChanged: (value) {
        if (value.length == 1 && index < 5) {
          FocusScope.of(context).nextFocus();
        } else if (value.isEmpty && index > 0) {
          FocusScope.of(context).previousFocus();
        }
      },
    ),
  );
}

Widget commonNumberInputField({
  required String hintText,
  required int value,
  required TextEditingController controller,
  required Function(int) onChanged,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      commonText(hintText, size: 16, fontWeight: FontWeight.w500),
      SizedBox(height: 4),
      Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Row(
          children: [
            SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hintText.tr,
                  hintStyle: const TextStyle(color: Colors.grey),
                  isCollapsed: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                ),
                onChanged: (text) {
                  final parsed = int.tryParse(text);
                  if (parsed != null) {
                    onChanged(parsed);
                  }
                },
                style: const TextStyle(fontSize: 14),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  child: const Icon(Icons.arrow_drop_up_outlined),
                  onTap: () {
                    final current = int.tryParse(controller.text) ?? 0;
                    final updated = current + 1;
                    controller.text = updated.toString();
                    onChanged(updated);
                  },
                ),
                InkWell(
                  child: const Icon(Icons.arrow_drop_down),
                  onTap: () {
                    final current = int.tryParse(controller.text) ?? 0;
                    if (current > 0) {
                      final updated = current - 1;
                      controller.text = updated.toString();
                      onChanged(updated);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}

Widget commonTextField({
  TextEditingController? controller,
  String? hintText,
  TextInputType keyboardType = TextInputType.number,
  void Function(String)? onChanged,
}) {
  return SizedBox(
    width: 50,
    height: 50,
    child: TextField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: keyboardType,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        hintText: hintText?.tr,
        hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
    ),
  );
}

Widget commonCheckbox({
  required bool value,
  required Function(bool?) onChanged,
  String label = '',
}) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Checkbox(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.gray,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        side: const BorderSide(color: Colors.black26),
      ),
      if (label.isNotEmpty) Flexible(child: commonText(label, size: 14)),
    ],
  );
}

Widget commonDropdown<T>({
  required List<T> items,
  required T? value,
  required String hint,
  required void Function(T?) onChanged,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: DropdownButton<T>(
      isExpanded: true,
      underline: SizedBox(),
      value: value,
      icon: Icon(Icons.keyboard_arrow_down_rounded),
      hint: commonText(hint, size: 14),
      borderRadius: BorderRadius.circular(8),
      items:
          items.map<DropdownMenuItem<T>>((T item) {
            return DropdownMenuItem<T>(
              value: item,
              child: commonText(item.toString(), size: 14),
            );
          }).toList(),
      onChanged: onChanged,
    ),
  );
}

AppBar authAppBar(String title) {
  return AppBar(
    backgroundColor: AppColors.primary,
    elevation: 0,
    leading: IconButton(
      icon: const Icon(Icons.arrow_back, color: AppColors.white),
      onPressed: () => Get.back(),
    ),
    title: commonText(title, size: 20, isBold: true, color: Colors.white),
    centerTitle: true,
  );
}
