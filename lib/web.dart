import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:connectivity/connectivity.dart';

class Webfform extends StatefulWidget {
  const Webfform({Key? key}) : super(key: key);

  @override
  _WebfformState createState() => _WebfformState();
}

class _WebfformState extends State<Webfform> {
  late String urlWithCredentials;
  bool _isLoading = true;
  bool _showAppBar = false;
  bool _showBottomNavBar = false;
  late WebViewController _webViewController;
  int _selectedIndex = 0; // Track the selected index
  bool _isConnected = true; // Track internet connectivity

  @override
  void initState() {
    super.initState();
    checkConnectivity(); // Check connectivity when the widget initializes
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        _isConnected = (result != ConnectivityResult.none);
      });
    });

    final username = Uri.encodeComponent('11164003');
    final password = Uri.encodeComponent('60-dayfreetrial');
    urlWithCredentials =
        'http://$username:$password@mohabadaa-001-site1.gtempurl.com/welcome.aspx';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _showAppBar
          ? AppBar(
              backgroundColor: Colors.blue,
              title: const Text(
                'Kismayo Library',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
              elevation: 8,
            )
          : null,
      bottomNavigationBar: _showBottomNavBar
          ? BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home,
                      color: _selectedIndex == 0 ? Colors.blue : Colors.black),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search,
                      color: _selectedIndex == 1 ? Colors.blue : Colors.black),
                  label: 'Visitation',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.history,
                      color: _selectedIndex == 2 ? Colors.blue : Colors.black),
                  label: 'History',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person,
                      color: _selectedIndex == 3 ? Colors.blue : Colors.black),
                  label: 'User',
                ),
              ],
              onTap: _isConnected
                  ? _onItemTapped
                  : null, // Disable tapping when not connected
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.black,
              type: BottomNavigationBarType.fixed,
              selectedLabelStyle: const TextStyle(
                color: Colors.blue,
              ),
              unselectedLabelStyle: const TextStyle(
                color: Colors.black,
              ),
            )
          : null,
      body: _isConnected ? buildWebView() : buildNoInternetMessage(),
    );
  }

  Widget buildWebView() {
    return Stack(
      children: [
        WebView(
          initialUrl: urlWithCredentials,
          javascriptMode: JavascriptMode.unrestricted,
          onPageStarted: (url) {
            setState(() {
              _isLoading = true;
              _showAppBar = !url.contains('studentlgn.aspx');
              _showBottomNavBar = !url.contains('studentlgn.aspx');
            });
          },
          onPageFinished: (finish) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebViewCreated: (WebViewController webViewController) {
            _webViewController = webViewController;
          },
          onWebResourceError: (error) {
            setState(() {
              _isConnected = false;
            });
          },
        ),
        _isLoading
            ? Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Color.fromARGB(255, 134, 51, 159),
                ),
              )
            : Container(),
      ],
    );
  }

  Widget buildNoInternetMessage() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.signal_wifi_off, // This is the icon indicating no internet
            size: 64,
            color: Colors.red,
          ),
          SizedBox(height: 16),
          Text(
            'No Internet Connection',
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Update the URL based on the selected index
    updateUrlWithCredentials();

    // Load the updated URL
    _webViewController.loadUrl(urlWithCredentials);
  }

  Future<void> checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _isConnected = false;
      });
    } else {
      setState(() {
        _isConnected = true;
      });
    }
  }

  void updateUrlWithCredentials() {
    final username = Uri.encodeComponent('11164003');
    final password = Uri.encodeComponent('60-dayfreetrial');

    switch (_selectedIndex) {
      case 0:
        urlWithCredentials =
            'http://$username:$password@mohabadaa-001-site1.gtempurl.com/welcome.aspx';
        break;
      case 1:
        urlWithCredentials =
            'http://$username:$password@mohabadaa-001-site1.gtempurl.com/thestudent.aspx';
        break;
      case 2:
        urlWithCredentials =
            'http://$username:$password@mohabadaa-001-site1.gtempurl.com/studentvisithistory.aspx';
        break;
      case 3:
        urlWithCredentials =
            'http://$username:$password@mohabadaa-001-site1.gtempurl.com/userdetails.aspx';
        break;
      default:
        urlWithCredentials =
            'http://$username:$password@mohabadaa-001-site1.gtempurl.com/welcome.aspx';
    }
  }
}
