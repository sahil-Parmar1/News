import 'package:flutter/material.dart';
import 'homepage.dart';
import 'package:url_launcher/url_launcher.dart';
class searchscreeen extends StatefulWidget
{
  @override
  State<searchscreeen> createState() => _searchscreeenState();
}

class _searchscreeenState extends State<searchscreeen> {
  TextEditingController _searchController=TextEditingController();
  String hintText='search..';
  List<NewsArticle> result=[];
  bool _go=false;
  bool _issearched=false;
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
       appBar: AppBar(
         title: Row(
           children: [
             Expanded(
               child: TextFormField(
                 controller: _searchController,
                 decoration: InputDecoration(
                   hintText: 'search..',
                   border: OutlineInputBorder(
                     borderRadius: BorderRadius.circular(30.0),
                     borderSide: BorderSide.none,
                   ),
                   filled: true,

                   contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
                   prefixIcon: Icon(Icons.search,),
                 ),
                 style: TextStyle(fontSize: 18.0),
                 onChanged: (value) {
                   setState(() {
                     if (value.isNotEmpty) {
                       _go = true;
                     } else {
                       _go = false;
                     }
                   });
                 },
               ),

             ),
             _go
                 ? ElevatedButton(
              child: Icon(Icons.arrow_forward,),
               onPressed: () async {
                 print(_searchController.text);
                 result = await NewsService().fetchNews(
                     keyword: _searchController.text);
                 print(result);
                 setState(() {
                   _issearched = true;
                   hintText=_searchController.text;

                 });
                 FocusScope.of(context).unfocus();
               },
             )
                 : SizedBox.shrink(),
           ],
         ),
       ),
      body: (_issearched==true&&result.length>0)?ListView.builder(
          itemCount: result.length,
          itemBuilder: (context,index)
          {
            NewsArticle article = result[index];
            double screenWidth = MediaQuery.of(context).size.width;
           return GestureDetector(
             onTap: () {
               Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context) => fullArticle(article: article)),
               );
             },
             child: Card(
               elevation: 4,
               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
               margin: EdgeInsets.all(8),
               child: Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     article.urlToImage.isNotEmpty
                         ? ClipRRect(
                       borderRadius: BorderRadius.circular(8),
                       child:article.urlToImage.isNotEmpty && Uri.tryParse(article.urlToImage)?.hasAbsolutePath == true
                           ? Image.network(
                         article.urlToImage,
                         width: double.infinity,
                         height: screenWidth * 0.4, // Adjust height as needed
                         fit: BoxFit.cover,
                         errorBuilder: (context, error, stackTrace) {
                           return SizedBox.shrink();
                         },
                       )
                           : SizedBox.shrink(),
                     )
                         : SizedBox.shrink(),
                     SizedBox(height: 8),
                     Text(
                       article.title,
                       style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                       maxLines: 2,
                       overflow: TextOverflow.ellipsis,
                     ),
                     SizedBox(height: 4),
                     Text(
                       article.description,
                       maxLines: 2,
                       overflow: TextOverflow.ellipsis,
                     ),
                   ],
                 ),
               ),
             ),
           );
          }
      ):Center(
        child: Container(
          child: (_issearched==true&&result.length==0)?Text("No News Available on Today  '${hintText}' "):Text("search to see news"),),
      ),
    );

  }
}





//aboutscreen
class AboutScreen extends StatelessWidget {
  final String instagramUrl = 'https://www.instagram.com/this_is_sahilparmar?igsh=MXI3NjFwam8xcGxpcQ==';
  final String linkedInUrl = 'https://linkedin.com/in/sahil-parmar-6b2656306';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: () {
                  launch(instagramUrl); // Launch Instagram profile link
                },
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/logo.png'), // Add your logo asset
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Our App',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Version: 1.0.0',
              style: TextStyle(
                fontSize: 16,

              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'About Us',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'This app provides the latest news updates from various sources. '
                  'Stay informed with our real-time news feed and user-friendly interface.',
              style: TextStyle(
                fontSize: 16,

              ),
            ),
            SizedBox(height: 16.0),

            Text(
              'Contact Us',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Email: sahilforxyz@gmail.com',
              style: TextStyle(
                fontSize: 16,

              ),
            ),
            SizedBox(height: 8.0),
            GestureDetector(
              onTap: () async{
                await launchURL('https://sahilparmar.my.canva.site'); // Launch Instagram profile link
              },
              child: Text(
                'Website: www.sahilparmar.odoo.com',
                style: TextStyle(
                  fontSize: 16,

                ),
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async{
                      await launchURL(instagramUrl); // Launch Instagram profile link
                    },
                    child: Image.asset('assets/instagram_icon.png', height: 50),
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: GestureDetector(
                    onTap: () async{
                      await launchURL(linkedInUrl); // Launch LinkedIn profile link
                    },
                    child: Image.asset('assets/linkedin_icon.png', height: 50),
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}

