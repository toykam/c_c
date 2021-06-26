import 'package:c_c/models/currency.dart';
import 'package:c_c/utils/api_helper.dart';
import 'package:c_c/utils/end_points.dart';
import 'package:flutter/cupertino.dart';

class CurrencyConverterProvider extends ChangeNotifier {


  static final CurrencyConverterProvider _currencyConverterProvider = CurrencyConverterProvider.createInstance();
  CurrencyConverterProvider.createInstance();
  
  List<Currency> currencies = [];
  bool loading = true;
  bool errorOccurred = false;
  String message = '0';

  Currency from;
  Currency to;
  TextEditingController amountController = TextEditingController(text: '0');
  String conversionResult = '0';

  OperationState operationState = OperationState(inProgress: false, errorOccurred: false, message: '');

  CurrencyConverterProvider() {
    initialize();
  }
  void initialize() async {

    loading = true;

    try {

      var response = await ApiHelper.makeGetRequest(GET_CURRENCIES_ENDPOINT);

      loading = false;
      if (response.statusCode == 200) {
        // print("Currency list of currencies arrived...");
        var data = response.data;
        // print("Currencies");
        // print(data);
        Map.from(data['symbols']).forEach((key, value) {
          // print("$key ==><== $value");
          var currency = Currency(currencyId: key, currencyName: value, currencySymbol: key);
          currencies.add(currency);
        });
        from = currencies.first;
        to = currencies.last;
        errorOccurred = false;
        message = '';
        // print(currencies);
      } else {
        print("Error occurred...");
        errorOccurred = true;
        message = response.statusMessage;
      }
      notifyListeners();
    } catch (error) {
      loading = false;
      errorOccurred = true;
      message = error.toString();
      notifyListeners();
    }
  }


  selectFromCurrency(symbolId) {
    from = currencies.where((element) => element.currencySymbol == symbolId).toList().first;
    notifyListeners();
    convert();
  }

  selectToCurrency(symbolId) {
    to = currencies.where((element) => element.currencySymbol == symbolId).toList().first;
    notifyListeners();
    convert();
  }

  void convert() async {
    try {
      if (amountController.text.length > 0 && amountController.text != '0') {
        operationState.inProgress = true;
        operationState.message = 'Converting ${amountController.text} of ${from.currencySymbol} to ${to.currencySymbol}';
        notifyListeners();
        var appended = "?from=${from.currencyId}&to=${to.currencyId}&amount=${amountController.text}";
        var response = await ApiHelper.makeGetRequest(CONVERT_CURRENCY_ENDPOINT+"$appended");
        conversionResult = response.data['result'].toString();
        operationState.inProgress = false;
        if (response.data['success'] == true) {
          operationState.errorOccurred = false;
        } else {
          operationState.errorOccurred = false;
          operationState.message = response.data['error']['info'];
        }
      }
      notifyListeners();
    } catch (error) {
      operationState.inProgress = false;
      operationState.message = error.toString();
      operationState.errorOccurred = true;
      notifyListeners();
    }
  }

  void retry () {
    initialize();
  }

  switchCurrency (){
    Currency tos = to;
    to = from;
    from = tos;
    notifyListeners();
    convert();
  }
}


class OperationState {
  bool inProgress;
  String message;
  bool errorOccurred;

  OperationState({this.inProgress, this.message, this.errorOccurred});
}