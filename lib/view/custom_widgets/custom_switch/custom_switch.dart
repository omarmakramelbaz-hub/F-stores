import 'package:flutter/material.dart';

class CustomSwitch extends StatefulWidget {
  final bool value;
  final void Function()? onTap;
  const CustomSwitch({super.key, required this.value, required this.onTap});

  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: 30,
        width: 60,
        padding: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: widget.value ? const Color(0xff00FF22) : Colors.redAccent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: widget.value ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (widget.value == true) ...{
              const SizedBox(width: 4),
              const Text(
                'ON',
                style: TextStyle(color: Colors.white, fontSize: 13, fontFamily: '', fontWeight: FontWeight.w400),
              ),
              const Spacer(),
            },
            const CircleAvatar(backgroundColor: Colors.white, radius: 13),
            if (widget.value == false) ...{
              const Spacer(),
              const Text(
                'OFF',
                style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w400, fontFamily: ''),
              ),
              const SizedBox(width: 4),
            },
          ],
        ),
      ),
    );
  }
}
