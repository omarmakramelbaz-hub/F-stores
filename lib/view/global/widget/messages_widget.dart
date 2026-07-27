import '../chat/model/chat_model.dart';
import '../../layout/vendor/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../helpers/theme/app_colors.dart';
import '../../../../helpers/theme/app_text_style.dart';
import '../../../../helpers/utils/date_methods.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget({super.key, required this.message});
  final ChatMessageModel message;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: int.tryParse(message.userId.toString()) == context.read<AuthController>().profile?.id
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // isMe
            //     ? const SizedBox()
            //     : ClipOval(
            //         child: CustomNetworkImage(
            //           height: 40,
            //           width: 40,
            //           imageUrl: userImage ?? Urls.testUserImage,
            //           fit: BoxFit.cover,
            //         ),
            //       ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    int.tryParse(message.userId.toString()) == context.read<AuthController>().profile?.id
                        ? Positioned(
                            bottom: 0,
                            right: -20,
                            child: CustomPaint(
                              size: const Size(20, 30),
                              painter: MeTrianglePainter(color: AppColor.greyColor(context).withOpacity(.100)),
                            ),
                          )
                        : Positioned(
                            bottom: 0,
                            left: -20,
                            child: CustomPaint(
                              size: const Size(24, 30),
                              painter: TrianglePainter(color: AppColor.mainAppColor(context).withOpacity(.100)),
                            ),
                          ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                      decoration: BoxDecoration(
                        color: int.tryParse(message.userId.toString()) == context.read<AuthController>().profile?.id
                            ? AppColor.lightTextColor(context).withOpacity(.10)
                            : AppColor.mainAppColor(context).withOpacity(.100),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        message.message ?? '',
                        maxLines: 5,
                        style: int.tryParse(message.userId.toString()) == context.read<AuthController>().profile?.id
                            ? AppTextStyle.text14RL(context)
                            : AppTextStyle.text14RL(context),
                      ),
                    ),
                    Positioned(
                      left: int.tryParse(message.userId.toString()) == context.read<AuthController>().profile?.id
                          ? 0
                          : -20,
                      right: int.tryParse(message.userId.toString()) == context.read<AuthController>().profile?.id
                          ? -20
                          : 0,
                      bottom: -30,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // isMe
                          //     ? ClipOval(
                          //         child: CustomNetworkImage(
                          //           height: 20,
                          //           width: 20,
                          //           imageUrl: userImage ?? Urls.testUserImage,
                          //           fit: BoxFit.cover,
                          //         ),
                          //       )
                          //     : const SizedBox(),
                          // isMe ? const Gap(15) : const SizedBox(),
                          Text(
                            DateMethods.formatToTime(message.messageTime?.toIso8601String()),
                            style: int.tryParse(message.userId.toString()) == context.read<AuthController>().profile?.id
                                ? AppTextStyle.text14RL(context)
                                : AppTextStyle.text14RL(context),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  TrianglePainter({this.color});
  final Color? color;
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color =
          color ??
          Colors
              .white // Change color as needed
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) {
    return false;
  }
}

class MeTrianglePainter extends CustomPainter {
  MeTrianglePainter({this.color});
  final Color? color;
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color =
          color ??
          Colors
              .white // Change color as needed
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(MeTrianglePainter oldDelegate) {
    return false;
  }
}
