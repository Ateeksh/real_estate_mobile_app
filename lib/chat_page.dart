import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'chat_message.dart';
import 'data_provider.dart';
import 'summary_page.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = [];
  int _step = 0;
  Map<String, dynamic> _responses = {};
  Map<String, List<List<dynamic>>> _baseRateData = {};
  bool _dataLoaded = false;

  final Map<String, Map<String, double>> discountPremiumData = {
    "Size (BUA)": {
      "0 to 300": -5.00,
      "301 to 800": 0.00,
      "801 to 1500": -2.50,
      "1501 to 3000": -5.00,
    },
    "Public Transport Avail": {
      "Train": 2.50,
      "Bus": 2.50,
      "Metro": 2.50,
      "None of the above": -5.00,
    },
    "Age of Property": {
      "0 to 10": 5.0,
      "11 to 20": 0.0,
      "21 to 30": -2.5,
      "31 to 40": -5.0,
    },
    "Building Amenities": {
      "Swimming pools": 2.50,
      "Fitness centers": 2.50,
      "Clubhouses": 2.50,
      "Rooftop gardens": 2.50,
      "Social areas": 2.50,
      "Outdoor areas (playgrounds, dog park)": 2.50,
      "Private theaters": 2.50,
      "Spa facilities": 2.50,
      "Concierge services": 2.50,
      "Outdoor kitchens": 2.50,
      "Golf simulators": 2.50,
      "On-site retail space": 2.50,
    },
    "Condition of Property": {
      "Fully Furnished": 5.0,
      "Semi Furnished": 0.0,
      "Repair & Maintenance Require": -2.50,
      "Bare Shell": -5.0,
    },
    "Residential": {
      "Location & Visibility": -10.00,
      "Amenities & Parking": 10.00,
    },
    "Commercial/Office/Shops": {
      "Location & Visibility": -10.00,
      "Amenities & Parking": 10.00,
    },
  };

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    _baseRateData = {
  _responses['property_type']: await DataProvider.loadBaseRateData(
    type: _responses['property_type'],
    village: _responses['village'],
    locality: _responses['locality'],
    taluka: _responses['taluka'],
    district: _responses['district'],
    state: _responses['state'],
  )
};
    setState(() {
      _dataLoaded = true;
      _askNextQuestion();
    });
  }

  void _askNextQuestion() {
    if (!_dataLoaded) {
      _messages.insert(0, ChatMessage(text: "Loading data..."));
      setState(() {});
      return;
    }

    ChatMessage message;
    List<String> options = [];
    String question = "";

    switch (_step) {
      case 0:
        question =
            "Welcome to the Real Estate Property Valuation Chatbot! Let's start.";
        _messages.insert(0, ChatMessage(text: question));
        question = "What type of property are you looking to value today?";
        options = ["Flat", "Office", "Shop"];
        _step = 1;
        break;
      case 1:
        question = "Purpose of valuation?";
        options = ["Sale", "Purchase", "Mortgage", "Insurance", "Other"];
        _step = 2;
        break;
      case 2:
        final propType = _responses['property_type'];
        final data = _baseRateData[propType]!.sublist(1);
        options = data.map((row) => row[5].toString()).toSet().toList();
        question = "State?";
        _step = 3;
        break;
      case 3:
        final propType = _responses['property_type'];
        final state = _responses['state'];
        final data = _baseRateData[propType]!.sublist(1);
        options = data
            .where((row) => row[5] == state)
            .map((row) => row[4].toString())
            .toSet()
            .toList();
        question = "District?";
        _step = 4;
        break;
      case 4:
        final propType = _responses['property_type'];
        final district = _responses['district'];
        final data = _baseRateData[propType]!.sublist(1);
        options = data
            .where((row) => row[4] == district)
            .map((row) => row[3].toString())
            .toSet()
            .toList();
        question = "Taluka?";
        _step = 5;
        break;
      case 5:
        final propType = _responses['property_type'];
        final taluka = _responses['taluka'];
        final data = _baseRateData[propType]!.sublist(1);
        options = data
            .where((row) => row[3] == taluka)
            .map((row) => row[1].toString())
            .toSet()
            .toList();
        if (options.isNotEmpty) {
          question = "Village?";
          _step = 6;
        } else {
          question = "Locality?";
          _step = 7;
        }
        break;
      case 6:
        final propType = _responses['property_type'];
        final village = _responses['village'];
        final data = _baseRateData[propType]!.sublist(1);
        options = data
            .where((row) => row[1] == village)
            .map((row) => row[2].toString())
            .toSet()
            .toList();
        question = "Locality?";
        _step = 7;
        break;
      case 7:
        question = "Flat No.";
        _step = 8;
        break;
      case 8:
        question = "Floor No.";
        _step = 9;
        break;
      case 9:
        question = "Wing";
        _step = 10;
        break;
      case 10:
        question = "Building/Society";
        _step = 11;
        break;
      case 11:
        question = "CTS No.";
        _step = 12;
        break;
      case 12:
        question = "Plot No.";
        _step = 13;
        break;
      case 13:
        question = "Area/Sector/Locality";
        _step = 14;
        break;
      case 14:
        question = "Pincode";
        _step = 15;
        break;
      case 15:
        question = "Document Type?";
        options = ["Agreement", "Sale Deed", "Gift Deed", "Other"];
        _step = 16;
        break;
      case 16:
        question = "Agreement Date?";
        options = ["Select Date"];
        _step = 17;
        break;
      case 17:
        question = "Buyer Name?";
        _step = 18;
        break;
      case 18:
        question = "Seller Name?";
        _step = 19;
        break;
      case 19:
        question = "Built-up area (sq.ft)?";
        _step = 20;
        break;
      case 20:
        question = "Other Document Notes?";
        _step = 21;
        break;
      case 21:
        question = "Size of Property (BUA category)?";
        options = discountPremiumData["Size (BUA)"]!.keys.toList();
        _step = 22;
        break;
      case 22:
        question = "Select available public transport options:";
        options = ["Select Options"];
        _step = 23;
        break;
      case 23:
        question = "Construction Year?";
        options = ["Select Year"];
        _step = 24;
        break;
      case 24:
        question = "Select available building amenities:";
        options = ["Select Options"];
        _step = 25;
        break;
      case 25:
        question = "Condition of Property?";
        options = discountPremiumData["Condition of Property"]!.keys.toList();
        _step = 26;
        break;
      case 26:
        question = "Any other important details?";
        _step = 27;
        break;
      case 27:
        question = "Other adjustment %? (e.g., 2.5 or -1)";
        _step = 28;
        break;
      case 28:
        _calculateFMV();
        return;
    }

    message = ChatMessage(
      text: question,
      options: options.isNotEmpty ? options : null,
    );
    _messages.insert(0, message);
    setState(() {});
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {
      _messages.insert(0, ChatMessage(text: text, isUser: true));
    });

    switch (_step) {
      case 1:
        _responses['property_type'] = text;
        break;
      case 2:
        _responses['purpose'] = text;
        break;
      case 3:
        _responses['state'] = text;
        break;
      case 4:
        _responses['district'] = text;
        break;
      case 5:
        _responses['taluka'] = text;
        break;
      case 6:
        _responses['village'] = text;
        break;
      case 7:
        _responses['locality'] = text;
        break;
      case 8:
        _responses['address_details'] = {'Flat No.': text};
        break;
      case 9:
        _responses['address_details']['Floor No.'] = text;
        break;
      case 10:
        _responses['address_details']['Wing'] = text;
        break;
      case 11:
        _responses['address_details']['Building / Society'] = text;
        break;
      case 12:
        _responses['address_details']['CTS No.'] = text;
        break;
      case 13:
        _responses['address_details']['Plot No.'] = text;
        break;
      case 14:
        _responses['address_details']['Area/Sector/Locality'] = text;
        break;
      case 15:
        _responses['address_details']['Pincode'] = text;
        break;
      case 16:
        _responses['doc_type'] = text;
        break;
      case 17:
        if (text == "Select Date") {
          _showDatePicker();
          return;
        }
        _responses['agreement_date'] = text;
        break;
      case 18:
        _responses['buyer'] = text;
        break;
      case 19:
        _responses['seller'] = text;
        break;
      case 20:
        _responses['built_up_area'] = double.tryParse(text) ?? 0.0;
        break;
      case 21:
        _responses['other_notes'] = text;
        break;
      case 22:
        _responses['area_cat'] = text;
        break;
      case 23:
        if (text == "Select Options") {
          _showMultiSelect("Public Transport Avail");
          return;
        }
        _responses['transport_opts'] = [text];
        break;
      case 24:
        if (text == "Select Year") {
          _showDatePicker(isConstructionYear: true);
          return;
        }
        _responses['construction_year'] = int.tryParse(text) ?? DateTime.now().year;
        break;
      case 25:
        if (text == "Select Options") {
          _showMultiSelect("Building Amenities");
          return;
        }
        _responses['amenities'] = [text];
        break;
      case 26:
        _responses['condition'] = text;
        break;
      case 27:
        _responses['additional_details'] = text;
        break;
      case 28:
        _responses['other_adj'] = double.tryParse(text) ?? 0.0;
        break;
    }

    _askNextQuestion();
  }

  void _calculateNewFMV() {
    final propType = _responses['property_type'];
    final baseRate = 100.0; // From screenshot

    double totalPremiumDiscount = 0;
    if (_responses['premium_discount_factors'] != null) {
      for (String factor in _responses['premium_discount_factors']) {
        totalPremiumDiscount += discountPremiumData[propType]![factor] ?? 0.0;
      }
    }

    final adoptedRate = baseRate * (1 + totalPremiumDiscount / 100);

    final totalBua = _responses['built_up_area'];
    final costOfConstruction = 30.0; // From screenshot
    final totalCostOfConstruction = totalBua * costOfConstruction;

    final approvalCharges = totalCostOfConstruction * 0.10;
    final costOfFinance = totalCostOfConstruction * 0.40 * 0.12 * 2;
    final legalArchitectEtc = totalCostOfConstruction * 0.05;
    final adminOtherExpenses = totalCostOfConstruction * 0.04;
    final otherMiscExpenses = totalCostOfConstruction * 0.03;
    final marketingFees = (totalBua * adoptedRate) * 0.02;
    final developersProfit = (totalBua * adoptedRate) * 0.12;

    final totalExpenses =
        totalCostOfConstruction +
        approvalCharges +
        costOfFinance +
        legalArchitectEtc +
        adminOtherExpenses +
        otherMiscExpenses +
        marketingFees +
        developersProfit;

    final totalRevenue = totalBua * adoptedRate;
    final grossValue = totalRevenue - totalExpenses;
    final netValue = grossValue - (grossValue * 0.28); // Assuming 28% tax
    final presentValue = netValue * 0.73; // Assuming PV factor of 73%

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => SummaryPage(
          responses: _responses,
          baseRate: baseRate,
          totalAdj: totalPremiumDiscount,
          adoptedRate: adoptedRate,
          fmv: presentValue,
        ),
      ),
    );
  }

  void _calculateFMV() {
    final propType = _responses['property_type'];
    final village = _responses['village'];
    final locality = _responses['locality'];

    final rateRow = _baseRateData[propType]!.firstWhere(
      (row) => row[1] == village && row[2] == locality,
      orElse: () => [],
    );

    final baseRate = rateRow.isNotEmpty
        ? double.tryParse(rateRow[5].toString()) ?? 0.0
        : 0.0;

    final areaAdj =
        discountPremiumData["Size (BUA)"]![_responses['area_cat']] ?? 0.0;
    final transportAdj = (_responses['transport_opts'] as List<String>)
        .map((e) => discountPremiumData["Public Transport Avail"]![e] ?? 0.0)
        .reduce((a, b) => a + b);
    final yearAdj =
        discountPremiumData["Age of Property"]![_responses['age_cat']] ?? 0.0;
    final amenityAdj = (_responses['amenities'] as List<String>)
        .map((e) => discountPremiumData["Building Amenities"]![e] ?? 0.0)
        .reduce((a, b) => a + b);
    final conditionAdj =
        discountPremiumData["Condition of Property"]![_responses['condition']] ??
        0.0;
    final otherAdj = _responses['other_adj'] ?? 0.0;

    final totalAdj =
        areaAdj + transportAdj + yearAdj + amenityAdj + conditionAdj + otherAdj;
    final adoptedRate = baseRate * (1 + totalAdj / 100);
    final builtUpArea = _responses['built_up_area'];
    final fmv = builtUpArea * adoptedRate;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => SummaryPage(
          responses: _responses,
          baseRate: baseRate,
          totalAdj: totalAdj,
          adoptedRate: adoptedRate,
          fmv: fmv,
        ),
      ),
    );
  }

  Future<void> _showDatePicker({bool isConstructionYear = false}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      if (isConstructionYear) {
        _responses['construction_year'] = picked.year;
        final age = DateTime.now().year - picked.year;
        if (age <= 10) {
          _responses['age_cat'] = "0 to 10";
        } else if (age <= 20) {
          _responses['age_cat'] = "11 to 20";
        } else if (age <= 30) {
          _responses['age_cat'] = "21 to 30";
        } else {
          _responses['age_cat'] = "31 to 40";
        }
        _step = 24;
      } else {
        _responses['agreement_date'] = picked.toIso8601String().substring(
          0,
          10,
        );
        _step = 17;
      }
      _askNextQuestion();
    }
  }

  void _showMultiSelect(String key) {
    final items = discountPremiumData[key]!.keys
        .map((e) => MultiSelectItem<String>(e, e))
        .toList();

    showDialog(
      context: context,
      builder: (ctx) {
        return MultiSelectDialog(
          items: items,
          initialValue: [],
          onConfirm: (values) {
            if (key == "Public Transport Avail") {
              _responses['transport_opts'] = values;
              _step = 23;
            } else {
              _responses['amenities'] = values;
              _step = 25;
            }
            _askNextQuestion();
          },
        );
      },
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).colorScheme.secondary),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration: const InputDecoration.collapsed(
                  hintText: "Send a message",
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: const Icon(Icons.send),
                onPressed: () => _handleSubmitted(_textController.text),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Valuation Chatbot')),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (_, int index) {
                final message = _messages[index];
                return _buildMessage(message);
              },
              itemCount: _messages.length,
            ),
          ),
          const Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(ChatMessage message) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(child: Text(message.isUser ? "U" : "A")),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  message.isUser ? "User" : "Assistant",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: Text(message.text),
                ),
                if (message.options != null)
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: message.options!
                        .map(
                          (option) => ElevatedButton(
                            onPressed: () => _handleSubmitted(option),
                            child: Text(option),
                          ),
                        )
                        .toList(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
