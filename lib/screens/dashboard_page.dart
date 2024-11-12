import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_app/data/currency_mapper.dart';
import 'package:new_app/screens/forms_page.dart';
// import 'package:new_app/screens/forms_page.dart';
import 'package:new_app/screens/upload_page.dart';
import 'package:new_app/services/theme_service.dart';
import 'package:new_app/widgets/custom_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  bool isDarkMode = Get.isDarkMode;

  Country selectedCountry = Country(
    name: 'India',
    countryCode: 'IN',
    phoneCode: '91',
    level: 1,
    geographic: true,
    e164Sc: 1,
    example: '',
    displayName: '',
    displayNameNoCountryCode: '',
    e164Key: '',
  );

  Currency selectedCurrency = Currency(code: 'INR', name: 'Indian Rupee');

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? countryCode = prefs.getString('selectedCountryCode');
    String? countryName = prefs.getString('selectedCountryName');
    String? currencyCode = prefs.getString('selectedCurrencyCode') ?? 'INR';
    String? currencyName =
        prefs.getString('selectedCurrencyName') ?? 'Indian Rupee';

    if (countryCode != null && countryName != null) {
      setState(() {
        selectedCountry = Country(
          name: countryName,
          countryCode: countryCode,
          phoneCode: '',
          level: 1,
          geographic: true,
          e164Sc: 1,
          example: '',
          displayName: '',
          displayNameNoCountryCode: '',
          e164Key: '',
        );
        selectedCurrency = Currency(code: currencyCode, name: currencyName);
      });
    }

    String? languageCode = prefs.getString('selectedLanguageCode') ?? 'en';
    String? countryLangCode =
        prefs.getString('selectedCountryLangCode') ?? 'US';
    Get.updateLocale(Locale(languageCode, countryLangCode));
  }

  Future<void> _saveSelectedCountry(Country country) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedCountryCode', country.countryCode);
    await prefs.setString('selectedCountryName', country.name);
    setState(() {
      selectedCountry = country;
    });
    _updateCurrencyBasedOnCountry(country);
  }

  void _updateCurrencyBasedOnCountry(Country country) {
    selectedCurrency =
        CurrencyMapper.getCurrencyByCountryCode(country.countryCode);
    _saveSelectedCurrency(selectedCurrency);
  }

  Future<void> _saveSelectedCurrency(Currency currency) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedCurrencyCode', currency.code);
    await prefs.setString('selectedCurrencyName', currency.name);
    setState(() {
      selectedCurrency = currency;
    });
  }

  void _saveSelectedLanguage(
      String languageCode, String countryLangCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguageCode', languageCode);
    await prefs.setString('selectedCountryLangCode', countryLangCode);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static final List<Widget> _widgetOptions = <Widget>[
    Center(child: Text('dashboard_content'.tr)),
    const FormsPage(),
    const UploadPage(), // Ensure this widget is correct and not empty
    Center(child: Text('form_content'.tr)),
    Center(child: Text('upload_content'.tr)), // Add a widget for upload page
    Center(child: Text('export_content'.tr)),
  ];

  void _showLanguageSelectionDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('multilanguage_support'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('English'),
              onTap: () {
                Get.updateLocale(const Locale('en', 'US'));
                _saveSelectedLanguage('en', 'US');
                Get.back();
              },
            ),
            ListTile(
              title: const Text('हिन्दी'),
              onTap: () {
                Get.updateLocale(const Locale('hi', 'IN'));
                _saveSelectedLanguage('hi', 'IN');
                Get.back();
              },
            ),
            ListTile(
              title: const Text('తెలుగు'),
              onTap: () {
                Get.updateLocale(const Locale('te', 'IN'));
                _saveSelectedLanguage('te', 'IN');
                Get.back();
              },
            ),
            ListTile(
              title: const Text('中文'),
              onTap: () {
                Get.updateLocale(const Locale('zh', 'CN'));
                _saveSelectedLanguage('zh', 'CN');
                Get.back();
              },
            ),
            ListTile(
              title: const Text('Español'),
              onTap: () {
                Get.updateLocale(const Locale('es', 'ES'));
                _saveSelectedLanguage('es', 'ES');
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCountryPickerDialog() {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      showSearch: true,
      onSelect: (Country country) {
        _saveSelectedCountry(country);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Selected country: ${country.name}')),
        );
      },
    );
  }

  void _showCurrencySelectionDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              'Currency: ${selectedCurrency.name} (${selectedCurrency.code})')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/logo.png',
              height: 50,
              width: 50,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 8),
            Text('app_title'.tr),
          ],
        ),
        actions: <Widget>[
          PopupMenuButton<int>(
            onSelected: (item) {
              if (item == 1) {
                _showLanguageSelectionDialog();
              } else if (item == 2) {
                _showCountryPickerDialog();
              } else if (item == 3) {
                _showCurrencySelectionDialog();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 0,
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('theme'.tr),
                        Switch(
                          value: isDarkMode,
                          onChanged: (value) {
                            ThemeService().switchTheme();
                            setState(() {
                              isDarkMode = !isDarkMode;
                            });
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
              PopupMenuItem<int>(
                value: 1,
                child: Text('multilanguage_support'.tr),
              ),
              PopupMenuItem<int>(
                value: 2,
                child: Row(
                  children: [
                    Text(
                        'Country: ${selectedCountry.flagEmoji} ${selectedCountry.name}'),
                  ],
                ),
              ),
              PopupMenuItem<int>(
                value: 3,
                child: Row(
                  children: [
                    Text(
                        'Currency: ${selectedCurrency.name} (${selectedCurrency.code})'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.dashboard),
            label: 'dashboard'.tr,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.description),
            label: 'forms_page'.tr,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.upload_file),
            label: 'upload'.tr, // Upload option
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.explore),
            label: 'export'.tr,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        unselectedItemColor: Theme.of(context).colorScheme.onSurface,
        onTap: _onItemTapped,
      ),
    );
  }
}

// import 'package:country_picker/country_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:new_app/data/currency_mapper.dart';
// import 'package:new_app/main.dart';
// import 'package:new_app/screens/forms_page.dart';
// import 'package:new_app/screens/upload_page.dart';
// import 'package:new_app/services/theme_service.dart';
// import 'package:new_app/widgets/custom_drawer.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class DashboardPage extends StatefulWidget {
//   const DashboardPage({super.key});

//   @override
//   _DashboardPageState createState() => _DashboardPageState();
// }

// class _DashboardPageState extends State<DashboardPage> {
//   final navigationController = Get.find<NavigationController>();
//   bool isDarkMode = Get.isDarkMode;

//   Country selectedCountry = Country(
//     name: 'India',
//     countryCode: 'IN',
//     phoneCode: '91',
//     level: 1,
//     geographic: true,
//     e164Sc: 1,
//     example: '',
//     displayName: '',
//     displayNameNoCountryCode: '',
//     e164Key: '',
//   );

//   Currency selectedCurrency = Currency(code: 'INR', name: 'Indian Rupee');

//   @override
//   void initState() {
//     super.initState();
//     _loadPreferences();
//   }

//   Future<void> _loadPreferences() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? countryCode = prefs.getString('selectedCountryCode');
//     String? countryName = prefs.getString('selectedCountryName');
//     String? currencyCode = prefs.getString('selectedCurrencyCode') ?? 'INR';
//     String? currencyName = prefs.getString('selectedCurrencyName') ?? 'Indian Rupee';

//     if (countryCode != null && countryName != null) {
//       setState(() {
//         selectedCountry = Country(
//           name: countryName,
//           countryCode: countryCode,
//           phoneCode: '',
//           level: 1,
//           geographic: true,
//           e164Sc: 1,
//           example: '',
//           displayName: '',
//           displayNameNoCountryCode: '',
//           e164Key: '',
//         );
//         selectedCurrency = Currency(code: currencyCode, name: currencyName);
//       });
//     }

//     String? languageCode = prefs.getString('selectedLanguageCode') ?? 'en';
//     String? countryLangCode = prefs.getString('selectedCountryLangCode') ?? 'US';
//     Get.updateLocale(Locale(languageCode, countryLangCode));
//   }

//   Future<void> _saveSelectedCountry(Country country) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString('selectedCountryCode', country.countryCode);
//     await prefs.setString('selectedCountryName', country.name);
//     setState(() {
//       selectedCountry = country;
//     });
//     _updateCurrencyBasedOnCountry(country);
//   }

//   void _updateCurrencyBasedOnCountry(Country country) {
//     selectedCurrency = CurrencyMapper.getCurrencyByCountryCode(country.countryCode);
//     _saveSelectedCurrency(selectedCurrency);
//   }

//   Future<void> _saveSelectedCurrency(Currency currency) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString('selectedCurrencyCode', currency.code);
//     await prefs.setString('selectedCurrencyName', currency.name);
//     setState(() {
//       selectedCurrency = currency;
//     });
//   }

//   void _saveSelectedLanguage(String languageCode, String countryLangCode) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString('selectedLanguageCode', languageCode);
//     await prefs.setString('selectedCountryLangCode', countryLangCode);
//   }

//   static final List<Widget> _widgetOptions = <Widget>[
//     Center(child: Text('dashboard_content'.tr)),
//     const FormsPage(),
//     const UploadPage(),
//     Center(child: Text('export_content'.tr)),
//   ];

//   void _showLanguageSelectionDialog() {
//     Get.dialog(
//       AlertDialog(
//         title: Text('multilanguage_support'.tr),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ListTile(
//               title: const Text('English'),
//               onTap: () {
//                 Get.updateLocale(const Locale('en', 'US'));
//                 _saveSelectedLanguage('en', 'US');
//                 Get.back();
//               },
//             ),
//             ListTile(
//               title: const Text('हिन्दी'),
//               onTap: () {
//                 Get.updateLocale(const Locale('hi', 'IN'));
//                 _saveSelectedLanguage('hi', 'IN');
//                 Get.back();
//               },
//             ),
//             ListTile(
//               title: const Text('తెలుగు'),
//               onTap: () {
//                 Get.updateLocale(const Locale('te', 'IN'));
//                 _saveSelectedLanguage('te', 'IN');
//                 Get.back();
//               },
//             ),
//             ListTile(
//               title: const Text('中文'),
//               onTap: () {
//                 Get.updateLocale(const Locale('zh', 'CN'));
//                 _saveSelectedLanguage('zh', 'CN');
//                 Get.back();
//               },
//             ),
//             ListTile(
//               title: const Text('Español'),
//               onTap: () {
//                 Get.updateLocale(const Locale('es', 'ES'));
//                 _saveSelectedLanguage('es', 'ES');
//                 Get.back();
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showCountryPickerDialog() {
//     showCountryPicker(
//       context: context,
//       showPhoneCode: true,
//       showSearch: true,
//       onSelect: (Country country) {
//         _saveSelectedCountry(country);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Selected country: ${country.name}')),
//         );
//       },
//     );
//   }

//   void _showCurrencySelectionDialog() {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Currency: ${selectedCurrency.name} (${selectedCurrency.code})'),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Row(
//           children: [
//             Image.asset(
//               'assets/logo.png',
//               height: 50,
//               width: 50,
//               fit: BoxFit.contain,
//             ),
//             const SizedBox(width: 8),
//             Text('app_title'.tr),
//           ],
//         ),
//         actions: <Widget>[
//           PopupMenuButton<int>(
//             onSelected: (item) {
//               if (item == 1) {
//                 _showLanguageSelectionDialog();
//               } else if (item == 2) {
//                 _showCountryPickerDialog();
//               } else if (item == 3) {
//                 _showCurrencySelectionDialog();
//               }
//             },
//             itemBuilder: (context) => [
//               PopupMenuItem<int>(
//                 value: 0,
//                 child: StatefulBuilder(
//                   builder: (context, setState) {
//                     return Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text('theme'.tr),
//                         Switch(
//                           value: isDarkMode,
//                           onChanged: (value) {
//                             ThemeService().switchTheme();
//                             setState(() {
//                               isDarkMode = !isDarkMode;
//                             });
//                           },
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//               ),
//               PopupMenuItem<int>(
//                 value: 1,
//                 child: Text('multilanguage_support'.tr),
//               ),
//               PopupMenuItem<int>(
//                 value: 2,
//                 child: Row(
//                   children: [
//                     Text('Country: ${selectedCountry.flagEmoji} ${selectedCountry.name}'),
//                   ],
//                 ),
//               ),
//               PopupMenuItem<int>(
//                 value: 3,
//                 child: Row(
//                   children: [
//                     Text('Currency: ${selectedCurrency.name} (${selectedCurrency.code})'),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//       drawer: const CustomDrawer(),
//       body: Obx(() => Center(
//         child: _widgetOptions.elementAt(navigationController.selectedIndex),
//       )),
//       bottomNavigationBar: Obx(() => BottomNavigationBar(
//         items: <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: const Icon(Icons.dashboard),
//             label: 'dashboard'.tr,
//           ),
//           BottomNavigationBarItem(
//             icon: const Icon(Icons.description),
//             label: 'forms_page'.tr,
//           ),
//           BottomNavigationBarItem(
//             icon: const Icon(Icons.upload_file),
//             label: 'upload'.tr,
//           ),
//           BottomNavigationBarItem(
//             icon: const Icon(Icons.explore),
//             label: 'export'.tr,
//           ),
//         ],
//         currentIndex: navigationController.selectedIndex,
//         selectedItemColor: Theme.of(context).colorScheme.secondary,
//         unselectedItemColor: Theme.of(context).colorScheme.onSurface,
//         onTap: navigationController.changePage,
//         type: BottomNavigationBarType.fixed,
//       )),
//     );
//   }
// }