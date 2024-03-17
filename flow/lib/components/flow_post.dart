import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flow/components/like_button.dart';
import 'package:flutter/material.dart';

class FlowPost extends StatefulWidget {
  final String message;
  final String user;
  final String time;
  final String postId;
  final List<String> likes;
  const FlowPost({super.key,required this.message,required this.user,required this.time,required this.likes,required this.postId});

  @override
  State<FlowPost> createState() => _FlowPostState();
}

class _FlowPostState extends State<FlowPost> {
  final currentUser=FirebaseAuth.instance.currentUser!;
  bool isLiked= false;

  @override

  void initState(){
    super.initState();
    isLiked=widget.likes.contains(currentUser.email);
  }

  void toggleLike()
  {
    setState(() {
      isLiked=!isLiked;
    });
    DocumentReference postRef= 
    FirebaseFirestore.instance.collection('User Posts').doc(widget.postId);
    if (isLiked)
    {
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color:Colors.white,
      borderRadius: BorderRadius.circular(8)),
      margin:EdgeInsets.only(top:25,left:25,right:25),
      padding: EdgeInsets.all(25),
      child:Row(
      children:[
        Container(
          decoration: BoxDecoration(shape: BoxShape.circle, color:Colors.grey),
          padding:EdgeInsets.all(10),
          child: const Icon( Icons.person,
          color:Colors.white)
        ),

        const SizedBox(height: 15,),
        Column(
          children:[
            LikeButton(isLiked:true , onTap: toggleLike)
          ]
        ),
        Column(
          crossAxisAlignment:CrossAxisAlignment.start ,
          children: [
          Text(widget.user,
          style:TextStyle(color:Colors.grey[500]),),
          const SizedBox(height: 10),
          Text(widget.message),
        ],)
      ]
      ),
    );
  }
}