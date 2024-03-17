import 'package:flutter/material.dart';

class LikeButton extends StatelessWidget {
  final bool isLiked;
  void Function()? onTap;
  
  LikeButton({super.key, required this.isLiked,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        isLiked ? Icons.favorite: Icons.favorite_border,
        color: isLiked? const Color.fromARGB(255, 204, 116, 145): Colors.grey,
      )
    );
  }
}