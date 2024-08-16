class Currency
{
  String name;
  double base_multiplier;

  Currency({required this.name, required this.base_multiplier});

  static List<Currency> getCurrencies()
  {
    List<Currency> currencies = [];
    currencies.add(Currency(name: 'Copper', base_multiplier: 0.01));
    currencies.add(Currency(name: 'Silver', base_multiplier: 0.1));
    currencies.add(Currency(name: 'Electrum', base_multiplier: 0.5));
    currencies.add(Currency(name: 'Gold', base_multiplier: 1));
    currencies.add(Currency(name: 'Platinum', base_multiplier: 10));

    return currencies;
  }
}