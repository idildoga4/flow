import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flow/components/drawer.dart';
import 'package:flow/components/flow_post.dart';
import 'package:flow/components/text_field.dart';
import 'package:flow/pages/profile_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final currentUser= FirebaseAuth.instance.currentUser!;
  final textController= TextEditingController();
  void signOut(){
   FirebaseAuth.instance.signOut(); 
  }

  void postMessage()
  {
    if(textController.text.isNotEmpty)
    {
      FirebaseFirestore.instance.collection("User Posts").add({
        'UserEmail': currentUser.email,
        'Message': textController.text,
        'TimeStamp': Timestamp.now(),
        'Likes': [],
      });
    }

    setState(() {
      textController.clear();
    });
  }
  void goToProfilePage()
  {
    Navigator.pop(context);
    Navigator.push(context,MaterialPageRoute(builder: (context) => ProfilePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 196, 194, 194),
      appBar:AppBar(title: Text("The Flow"),
      backgroundColor:Colors.grey[900],
      
      actions:[
       IconButton(onPressed: signOut,icon: Icon(Icons.logout)) 
      ]),
      drawer: MyDrawer(
        onProfileTap: goToProfilePage,
        onSignOut: signOut,
      ),
      body: Center(
        child: Column(
          children:[
            Expanded(
              child: StreamBuilder(
              stream: FirebaseFirestore.instance.
              collection("User Posts").
              orderBy("TimeStamp"
              ,descending:false
              )
              .snapshots(),
             builder: (context,snapshot)
              {
                if(snapshot.hasData)
                {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context,index)
                  {
                    final post=snapshot.data!.docs[index];
                    
                    return FlowPost(message: post['message'], 
                    user: post['UserEmail'], 
                    postId:post.id,
                    time: post[''],
                    likes:List<String>.from(post['Likes']?? []));
                  },
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}')
                  );
                }
                return const Center(child: CircularProgressIndicator(),);
              }
            ),
            ),

            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                children: [
                  Expanded(
                    child: MyTextField(
                      controller: textController,
                      hintText: "Write something",
                      obscureText: false,
                    )
                  ),
                  IconButton(onPressed:postMessage ,
                  icon: const Icon(Icons.arrow_circle_up ))
                ]
              ),
            ),
            Text("Logged in as: "+ currentUser.email!),
          ]
        ),
      )
    );
  }
}