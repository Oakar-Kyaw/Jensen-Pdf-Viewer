import "package:flutter/material.dart";



class iconButton extends StatelessWidget {
  iconButton({@required this.icons, this.onPress});
  final IconData icons;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icons, color: Color(0xFF75003B)),
      onPressed: onPress,
    );
  }
}
