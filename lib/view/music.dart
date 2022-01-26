import 'package:chaplin_new_version/controler/connector.dart';
import 'package:chaplin_new_version/controler/wordpress_connector.dart';
import 'package:chaplin_new_version/model/global.dart';
import 'package:chaplin_new_version/model/music.dart';
import 'package:chaplin_new_version/view/no_internet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MusicView extends StatefulWidget {
  const MusicView({Key? key}) : super(key: key);

  @override
  _MusicState createState() => _MusicState();
}

class _MusicState extends State<MusicView> {
  
  int selected_music=0;
  List<Music> music=<Music>[];
  bool loading=false;
  bool initial=true;

  @override
  void initState() {
    // TODO: implement initState
    get_data();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    //get_data();
    return Scaffold(
      body: SafeArea(
          child:  Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height-MediaQuery.of(context).padding.top,
            color: Colors.black87,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(onPressed: (){
                        Navigator.pop(context);
                      }, icon: Icon(Icons.arrow_back_ios,color: Colors.white,)),
                      Text("MUSIC",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
                      IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back_ios,color: Colors.transparent,)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height*0.3,
                    child: Image.asset("assets/CD.gif",fit: BoxFit.cover,),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 15),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height*0.5-MediaQuery.of(context).padding.top,
                    child: !loading?ListView.builder(
                        itemCount: this.music.length,
                        itemBuilder: (context,index){
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: GestureDetector(
                              onTap: (){
                                setState(() {
                                  selected_music=index;
                                });
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width*0.9,
                                      color: Colors.transparent,
                                      child: Row(
                                        children: [
                                          Padding(padding: EdgeInsets.only(right: 10),
                                            child: Container(height: 30,width: 3,color:  selected_music==index?Colors.white:Colors.transparent,),
                                          ),
                                          Text(this.music[index].name,style: TextStyle(color: selected_music==index?Colors.white:Colors.grey,fontSize: 20,fontWeight: FontWeight.bold),)
                                        ],
                                      ),
                                    ),
                                    /**
                                    Row(
                                      children: [
                                        Padding(padding: EdgeInsets.only(right: 10),
                                          child: Container(height: 30,width: 3,color:  selected_music==index?Colors.white:Colors.transparent,),
                                        ),
                                        Text(this.music[index].artist,style: TextStyle(color: selected_music==index?Colors.white:Colors.grey,fontSize: 15),)
                                      ],
                                    ),*/
                                  ],
                                ),
                              ),
                            ),
                          );
                        }):_loading(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: GestureDetector(
                    onTap: (){
                      add_music();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width*0.3,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25)
                      ),
                      child: Center(child: Text("ADD",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),)),
                    ),
                  )
                ),

              ],
            ),
          )
      ),
    );
  }


  get_data(){
    Connecter.check_internet().then((internet) {
      if(internet){
        if(this.music.isEmpty&&initial){
          setState(() {
            //initial=false;
            loading=true;
          });
          Connecter.get_music_list().then((list) {
            setState(() {
              if(list.length>0){
                initial=false;
              }
              this.music.addAll(list);
              loading=false;
            });
          });
        }
      }else{
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const NoInternet()),
        );
      }
    });


  }

  /*get_data(){
    Connecter.check_internet().then((internet) {
      if(internet){
        if(this.music.isEmpty&&initial){
          setState(() {
            //initial=false;
            loading=true;
          });
          WordPressConnecter.get_music().then((list) {
            setState(() {
              if(list.length>0){
                initial=false;
              }
              this.music.addAll(list);
              loading=false;
            });
          });
        }
      }else{
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const NoInternet()),
        );
      }
    });


  }*/
  _loading(){
    return Center(
      child: CircularProgressIndicator(),
    );
  }
  add_music(){
    Connecter.insert_music(this.music[selected_music].name, this.music[selected_music].link);
    setState(() {
      //ToDO add musicc timer
      ///Global.had_music=true;
      Global.music_timer=DateTime.now().toString();
    });
    Navigator.of(context).pop();
  }
}
