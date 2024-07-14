import 'package:flutter/material.dart';
import 'package:news/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
class countryClass {
  String name;
  String code;

  countryClass({required this.name, required this.code});
  // Convert Country object to JSON Map
  Map<String, dynamic> toJson() => {
    'name': name,
    'code': code,
  };

  // Create Country object from JSON Map
  factory countryClass.fromJson(Map<String, dynamic> json) {
    return countryClass(
      name:json['name'],
      code:json['code'],
    );
  }
}
List<countryClass> defaultCountry = [
  countryClass(name: 'United Arab Emirates', code: 'AE'),
  countryClass(name: 'Argentina', code: 'AR'),
  countryClass(name: 'Austria', code: 'AT'),
  countryClass(name: 'Australia', code: 'AU'),
  countryClass(name: 'Belgium', code: 'BE'),
  countryClass(name: 'Bulgaria', code: 'BG'),
  countryClass(name: 'Brazil', code: 'BR'),
  countryClass(name: 'Canada', code: 'CA'),
  countryClass(name: 'Switzerland', code: 'CH'),
  countryClass(name: 'China', code: 'CN'),
  countryClass(name: 'Colombia', code: 'CO'),
  countryClass(name: 'Cuba', code: 'CU'),
  countryClass(name: 'Czech Republic', code: 'CZ'),
  countryClass(name: 'Germany', code: 'DE'),
  countryClass(name: 'Egypt', code: 'EG'),
  countryClass(name: 'France', code: 'FR'),
  countryClass(name: 'United Kingdom', code: 'GB'),
  countryClass(name: 'Greece', code: 'GR'),
  countryClass(name: 'Hong Kong', code: 'HK'),
  countryClass(name: 'Hungary', code: 'HU'),
  countryClass(name: 'Indonesia', code: 'ID'),
  countryClass(name: 'Ireland', code: 'IE'),
  countryClass(name: 'Israel', code: 'IL'),
  countryClass(name: 'India', code: 'IN'),
  countryClass(name: 'Italy', code: 'IT'),
  countryClass(name: 'Japan', code: 'JP'),
  countryClass(name: 'South Korea', code: 'KR'),
  countryClass(name: 'Lithuania', code: 'LT'),
  countryClass(name: 'Latvia', code: 'LV'),
  countryClass(name: 'Morocco', code: 'MA'),
  countryClass(name: 'Mexico', code: 'MX'),
  countryClass(name: 'Malaysia', code: 'MY'),
  countryClass(name: 'Nigeria', code: 'NG'),
  countryClass(name: 'Netherlands', code: 'NL'),
  countryClass(name: 'Norway', code: 'NO'),
  countryClass(name: 'New Zealand', code: 'NZ'),
  countryClass(name: 'Philippines', code: 'PH'),
  countryClass(name: 'Poland', code: 'PL'),
  countryClass(name: 'Portugal', code: 'PT'),
  countryClass(name: 'Romania', code: 'RO'),
  countryClass(name: 'Serbia', code: 'RS'),
  countryClass(name: 'Russia', code: 'RU'),
  countryClass(name: 'Saudi Arabia', code: 'SA'),
  countryClass(name: 'Sweden', code: 'SE'),
  countryClass(name: 'Singapore', code: 'SG'),
  countryClass(name: 'Slovenia', code: 'SI'),
  countryClass(name: 'Slovakia', code: 'SK'),
  countryClass(name: 'Thailand', code: 'TH'),
  countryClass(name: 'Turkey', code: 'TR'),
  countryClass(name: 'Taiwan', code: 'TW'),
  countryClass(name: 'Ukraine', code: 'UA'),
  countryClass(name: 'United States', code: 'US'),
  countryClass(name: 'Venezuela', code: 'VE'),
  countryClass(name: 'South Africa', code: 'ZA'),
];
//for store user information
class user
{
  static countryClass? country=countryClass(name:'',code: '');
  static List<String> categery=[];
  static bool isdark=false;
  static Future<void> getCountry() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? countryJson = prefs.getString('country');
    if (countryJson != null) {
      country = countryClass.fromJson(jsonDecode(countryJson));
    } else {
      // Handle case where no country data is found
      country = null;
    }

  }

  static Future<void> setCountry(countryClass? country) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (country != null) {
      String countryJson = jsonEncode(country.toJson()); // Convert object to JSON string
      await prefs.setString('country', countryJson); // Save JSON string to SharedPreferences
    } else {
      await prefs.remove('country'); // Remove the 'country' key if country is null
    }
  }

}

//user select the location or country
class selectCountry extends StatefulWidget
{
  @override
  State<selectCountry> createState() => _selectCountryState();
}

class _selectCountryState extends State<selectCountry> {
  countryClass? mycountry;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     Refresh();
  }
  void Refresh()async
  {
    await user.getCountry();
    mycountry=user.country;
    setState(() {});
    print(mycountry?.name);
  }
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: Text("Country"),

      ),
      body: ListView.builder(
        itemCount: defaultCountry.length,
        itemBuilder: (context, index) {
          countryClass country = defaultCountry[index];
          if(country?.name == mycountry?.name)
            {
              return ListTile(
                leading: CircleAvatar(
                  child: Text(country.code),
                  backgroundColor: Colors.green,
                ),
                title: Text(country.name,style: TextStyle(color: Colors.green),),
                onTap: () async{
                  user.setCountry(country);
                  Refresh();
                  // Handle onTap event if needed
                  Navigator.pushReplacement(
                      context, 
                    MaterialPageRoute(builder: (context)=>homeScreen())
                   );
                },
                
              );
            }
          return ListTile(
            leading: CircleAvatar(
              child: Text(country.code),
            ),
            title: Text(country.name),
            onTap: () async{
              // Handle onTap event if needed
               user.setCountry(country);
              Refresh();
               Navigator.pushReplacement(
                   context,
                   MaterialPageRoute(builder: (context)=>homeScreen())
               );
            },
          );
        },
      ),
    );
  }
}