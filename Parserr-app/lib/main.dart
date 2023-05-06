import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


void main()=>runApp(const MaterialApp(
  home:Parser(),
),
);

class Parser extends StatefulWidget {
  const Parser({Key? key}) : super(key: key);

  @override
  State<Parser> createState() => _ParserState();
}
final myController = TextEditingController();


String pr="";
class _ParserState extends State<Parser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        elevation: 0,

        title: const Text(
          'SYNTAX CHECKER',
          style:TextStyle(
            fontSize: 30,
            color:Colors.black,
          ),
        ),

        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),

      body:
      Center(
        child:
        Container(decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.pinkAccent,
              Colors.white,
            ],
          ),
        ),

          child:Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

                const SizedBox(height: 250.0),

              // Create a TextEditingController

          Padding(
            padding: const EdgeInsets.all(13.0),
            child: TextField(
            controller: myController,
            decoration: InputDecoration(
              hintText: 'Enter your text here',
              fillColor: Colors.white.withOpacity(0.89),
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
        ),
          ),
                const SizedBox(height: 80.0),

                SizedBox(
                height:50,
                width:155,
            child: ElevatedButton(
              child:Text('Check it!'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              elevation: 25,
              // Background color
            ),
            onPressed:() async {
                await chal();
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Second()),
                );

                               },

            ),
            ),



              ],
            ),
          ),
        ),
      ),

      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
    );
  }
}

class Second extends StatefulWidget {
  const Second({Key? key}) : super(key: key);

  @override
  State<Second> createState() => _SecondState();
}

class _SecondState extends State<Second> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
        elevation: 0,

        title: const Text(
        'SYNTAX CHECKER',
        style:TextStyle(
        fontSize: 30,
        color:Colors.black,
    ),
    ),

    centerTitle: true,
    backgroundColor: Colors.transparent,
    ),

    body:Center(

      child:Text(pr,
      style: TextStyle(
        fontSize:25,
      ),),
    ),
    );
  }
}

Future chal() async{
  String textValue = myController.text;
  print(textValue);


   String apiUrl = 'https://syntaxcd.up.railway.app/check?code_str=';
  apiUrl+=textValue;

  final response = await http.post(
    Uri.parse(apiUrl),
  );

  if (response.statusCode == 200) {
    print('POST request sent successfully');
    print('Response body: ${response.body}');
    pr=response.body.toString();
    if(pr[2]=='1')
      pr=pr.substring(6,pr.length-2);
    print(pr);
  } else {
    print('Error sending POST request');
    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

  }

}
