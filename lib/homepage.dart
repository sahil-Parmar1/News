import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news/searchscreen.dart';
import 'dart:convert';
import 'userselection.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'themes.dart';
class NewsArticle {
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final String? content;

  NewsArticle(
      {required this.title, required this.description, required this.url, required this.urlToImage,required this.content});

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      urlToImage: json['urlToImage'] ?? '',
      content:json['content']??'',
    );
  }
}

class NewsService {
  static const _apiKey = '04c3557c65f442cc89ce0e8d43c2021f';


  Future<List<NewsArticle>> fetchNews({String? category,String? keyword,int page=1,int pageSize=10}) async {
    if(category != null)
    {
      String url='https://newsapi.org/v2/top-headlines?country=${user.country?.code}&category=$category&page=$page&pageSize=$pageSize&apiKey=$_apiKey';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> articles = data['articles'];
        print("for find articles ===>>${data['articles']}");
        return articles.map((json) => NewsArticle.fromJson(json)).toList().sublist(0, 10);
      } else {
        throw Exception('Failed to load news');
      }
    }
    else if(keyword != null)
    {

        String url = 'https://newsapi.org/v2/top-headlines?q=$keyword&apiKey=$_apiKey';
        final response = await http.get(Uri.parse(url));
        print("\n\n\n$keyword news is fetched....\n\n\n");

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          final List<dynamic> articles = data['articles'];

          // Check the length of the articles list before creating a sublist
          if (articles.isNotEmpty) {
            final endIndex = articles.length < 10 ? articles.length : 10;
            return articles.map((json) => NewsArticle.fromJson(json)).toList().sublist(0, endIndex);
          } else {
            return [];
          }
        } else {
          throw Exception('Failed to load news');
        }


    }
    else
    {
      String url='https://newsapi.org/v2/top-headlines?country=${user.country?.code}&page=$page&pageSize=$pageSize&apiKey=$_apiKey';
      final response = await http.get(Uri.parse(url));
      print("\n\n\n$keyword news is fetched....\n\n\n");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> articles = data['articles'];

        // Check the length of the articles list before creating a sublist
        if (articles.isNotEmpty) {
          final endIndex = articles.length < 10 ? articles.length : 10;
          return articles.map((json) => NewsArticle.fromJson(json)).toList().sublist(0, endIndex);
        } else {
          return [];
        }
      } else {
        throw Exception('Failed to load news');
      }
    }

  }
}

void Refresh() async {
  await user.getCountry();
}
class homeScreen extends StatefulWidget {
  @override
  _homeScreenState createState() => _homeScreenState();
}
class _homeScreenState extends State<homeScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<String> categories = [
    'top-headlines',
    'Business',
    'Entertainment',
    'General',
    'Health',
    'Science',
    'Sports',
    'Technology',
  ];

  Map<String, List<NewsArticle>> articlesMap = {};
  Map<String, int> pageMap = {};
  Map<String, bool> loadingMap = {};
  late Timer _timer2;
 

  @override
  void initState() {
    super.initState();
    // Access TimerProvider instance
    final timerProvider = Provider.of<TimerProvider>(context, listen: false);

    // Start the timer when the app starts
    timerProvider.startTimer();
    _timer2 = Timer.periodic(Duration(seconds: 15), (Timer t) {
       // Notify listeners after updating state
      timerProvider.stopSearchbar();


    });
    //Refresh();

  }
  void dispose()
  {
   super.dispose();

  }



  Future<void> _fetchMoreNews(String category) async {
    if (loadingMap[category] == true) return;

    loadingMap[category] = true;

    int currentPage = pageMap[category] ?? 1;
    List<NewsArticle> currentArticles = articlesMap[category] ?? [];

    final newArticles = await NewsService().fetchNews(category: category == 'top-headlines' ? null : category, page: currentPage);

    setState(() {
      articlesMap[category] = currentArticles..addAll(newArticles);
      pageMap[category] = currentPage + 1;
      loadingMap[category] = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        appBar: AppBar(
          title: Consumer<TimerProvider>(
            builder: (context,timerProvider,_) {
              return Row(
                children: [

                    Expanded(
                      child: TextButton(
                        onPressed: () async {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => selectCountry()));
                        },
                        child: Text('${user.country?.name} News',style:TextStyle(fontSize: 19),),
                      ),
                    ),
                  timerProvider.searching?Container(
                    width: MediaQuery.of(context).size.width/3, // Adjust the width as needed
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child:GestureDetector(
                        key: ValueKey(0),
                        onTap: () {
                          Navigator.push(context,
                          MaterialPageRoute(builder: (context)=>searchscreeen())
                          );
                        },
                        child: Container(
                          height: 40.0,
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: Text(
                                  timerProvider.hints[timerProvider.hintIndex],
                                  style: TextStyle(color: Colors.grey,fontSize: 14),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),

                              Icon(Icons.search, color: Colors.black),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ):IconButton(onPressed: (){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context)=>searchscreeen())
                    );
                  }, icon:Icon(Icons.search)),
                ],
              );
            }
          ),

          bottom: TabBar(
            isScrollable: true,
            tabs: categories.map((title) => Tab(text: title)).toList(),
          ),
        ),
        drawer:Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,

                  ),
                  child: Text(
                    '${user.country?.name} News',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListTile(
                  onTap: (){
                    Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                  },
                  leading: !user.isdark?Icon(Icons.dark_mode):Icon(Icons.light_mode),
                  title: Text('Dark Mode'),
                  trailing: Switch(
                    value: !user.isdark, // Replace with actual logic to toggle
                    onChanged: (value) {

                      Provider.of<ThemeProvider>(context, listen: false).toggleTheme();

                      // Implement logic to change dark mode
                    },
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text('Home'),
                  onTap: () {
                    Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context)=>homeScreen())
                    );
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.language),
                  title: Text('Location'),
                  subtitle: Text('${user.country?.name}'),
                  onTap: () {
                    // Navigate to language selection screen
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context)=>selectCountry())
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.info),
                  title: Text('About'),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context)=>AboutScreen()));
                  },
                ),
              ],
            ),
          ),
        body: TabBarView(
          children: categories.map((title) {
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                if (!articlesMap.containsKey(title)) {
                  _fetchMoreNews(title);
                }

                _scrollController.addListener(() {
                  if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
                    _fetchMoreNews(title);
                  }
                });

                List<NewsArticle> articles = articlesMap[title] ?? [];

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: articles.length + 1, // +1 for loading indicator
                  itemBuilder: (context, index) {
                    if (index == articles.length) {
                      return loadingMap[title] == true
                          ? Center(child: CircularProgressIndicator())
                          : SizedBox.shrink();
                    }

                    final article = articles[index];
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
                  },
                );
              },
            );
          }).toList(),
        ),

      ),
    );
  }
}

//for particuler article screen
class fullArticle extends StatefulWidget
{
  dynamic article;
  fullArticle({
    required this.article
});

  @override
  State<fullArticle> createState() => _fullArticleState();
}

class _fullArticleState extends State<fullArticle> {
  bool isbookmarked=false;

  @override
  Widget build(BuildContext context)
  {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(""),

      ),
      body:Container(
        width: screenWidth,
        height: screenHeight, // Use MediaQuery to get screen dimensions
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image Section
              (widget.article.urlToImage!= null && widget.article.urlToImage!.isNotEmpty && Uri.tryParse(widget.article.urlToImage!)?.hasAbsolutePath == true)
                  ? Image.network(
                    widget.article.urlToImage!,
                    width: screenWidth,
                    height: screenHeight * 0.5,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return SizedBox.shrink();
                    },
                  )
                  : SizedBox.shrink(),
              SizedBox(height: 20), // Adjust spacing between image and text

              // Text Content Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.article.title ?? '',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10), // Adjust spacing between title and description
                    Text(
                      widget.article.description ?? '',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18,),
                    ),
                    SizedBox(height: 20), // Adjust spacing before content
                    Text(
                      widget.article.content ?? '',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, ),
                    ),
                    SizedBox(height: 40), // Extra spacing at the end of content
                    TextButton(
                      onPressed: () async {
                        await launchURL(widget.article.url.toString());
                      },
                      child: Text("Read More", style: TextStyle(color: Colors.blue)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )

      ,


    );
  }
}
//for running or launch in brower
Future<void> launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}