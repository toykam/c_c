import 'package:c_c/providers/cc_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({ Key key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.monetization_on),
          title: Text("Currency Converter"),
        ),
        body: Consumer<CurrencyConverterProvider>(
          builder: (BuildContext context, CurrencyConverterProvider currencyConverter, Widget child) {
            if (currencyConverter.loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (currencyConverter.errorOccurred) {
                return Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("${currencyConverter.message}"),
                      SizedBox(height: 20,),
                      TextButton(onPressed: () {
                        currencyConverter.retry();
                      }, child: Text("Retry"))
                    ],
                  ),
                );
              } else {
                return SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // From
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Select Current to Convert From: ", style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600
                            ),),
                            SizedBox(height: 5,),
                            DropdownButton(
                              isExpanded: true,
                              value: currencyConverter.from.currencyId,
                              hint: Text('Select a currency'),
                              onChanged: (val) {
                                currencyConverter.selectFromCurrency(val);
                              },
                              items: [
                                ...currencyConverter.currencies.map(
                                  (e) => DropdownMenuItem(child: Text('${e.currencyName}'), value: e.currencySymbol,)
                                ).toList()
                              ],
                            )
                          ],
                        ),
                      ),
                      // Icon(Icons.swap_calls_rounded, size: 40,),
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: TextFormField(
                          controller: currencyConverter.amountController,
                          decoration: InputDecoration(
                              hintText: "Amount of BTC to covert",
                              helperText: 'Input the amount to ${currencyConverter.from.currencySymbol} to convert',
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16)
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(height: 20),

                      Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Select Currency to Convert To: ", style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600
                            ),),
                            SizedBox(width: 5,),
                            DropdownButton(
                              value: currencyConverter.to.currencyId,
                              onChanged: (val) {
                                print("To Value: $val");
                                currencyConverter.selectToCurrency(val);
                              },
                              items: [
                                ...currencyConverter.currencies.map(
                                    (e) => DropdownMenuItem(child: Text('${e.currencyName}'), value: e.currencySymbol,)
                                ).toList()
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        child: Center(
                          child: Text("${currencyConverter.to.currencySymbol} ${currencyConverter.conversionResult}", style: TextStyle(
                              fontSize: 40
                          )),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                child: Text('Convert'),
                                onPressed: ((currencyConverter.to.currencyId == currencyConverter.from.currencyId) || currencyConverter.operationState.inProgress) ? null : () => currencyConverter.convert(),
                              ),
                            ),
                            SizedBox(width: 10,),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateColor.resolveWith((states) => Colors.green)
                              ),
                              child: Icon(Icons.swap_horiz),
                              onPressed: (
                                  (currencyConverter.to == null || currencyConverter.from == null)
                                  || currencyConverter.operationState.inProgress) ? null : () => currencyConverter.switchCurrency(),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      if (currencyConverter.to.currencyId == currencyConverter.from.currencyId)
                        ...[
                          Center(child: Text('Both currency cannot be the same', style: TextStyle(color: Colors.red),))
                        ],
                      if (currencyConverter.operationState.inProgress)
                        ...[
                          Center(child: Text('${currencyConverter.operationState.message}', style: TextStyle(color: Colors.green),))
                        ],
                      if (!currencyConverter.operationState.inProgress && currencyConverter.operationState.errorOccurred)
                        ...[
                          Center(child: Text('${currencyConverter.operationState.message}', style: TextStyle(color: Colors.red),))
                        ],

                    ],
                  ),
                );
              }
            }
          },
        ),
        persistentFooterButtons: [
          Text('made by @toykam')
        ],
      ),
    );
  }
}