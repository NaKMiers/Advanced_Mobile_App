class CurrencyType {
  final String value;
  final String label;
  final String symbol;
  final String locale;

  const CurrencyType({
    required this.value,
    required this.label,
    required this.symbol,
    required this.locale,
  });
}

const List<CurrencyType> currencies = [
  CurrencyType(
    value: 'USD',
    label: 'US Dollar (\$)',
    symbol: '\$',
    locale: 'en-US',
  ),
  CurrencyType(value: 'EUR', label: 'Euro (€)', symbol: '€', locale: 'de-DE'),
  CurrencyType(
    value: 'JPY',
    label: 'Japanese Yen (¥)',
    symbol: '¥',
    locale: 'ja-JP',
  ),
  CurrencyType(
    value: 'GBP',
    label: 'British Pound (£)',
    symbol: '£',
    locale: 'en-GB',
  ),
  CurrencyType(
    value: 'AUD',
    label: 'Australian Dollar (A\$)',
    symbol: 'A\$',
    locale: 'en-AU',
  ),
  CurrencyType(
    value: 'CAD',
    label: 'Canadian Dollar (C\$)',
    symbol: 'C\$',
    locale: 'en-CA',
  ),
  CurrencyType(
    value: 'CHF',
    label: 'Swiss Franc (CHF)',
    symbol: 'CHF',
    locale: 'fr-CH',
  ),
  CurrencyType(
    value: 'CNY',
    label: 'Chinese Yuan (¥)',
    symbol: '¥',
    locale: 'zh-CN',
  ),
  CurrencyType(
    value: 'SEK',
    label: 'Swedish Krona (kr)',
    symbol: 'kr',
    locale: 'sv-SE',
  ),
  CurrencyType(
    value: 'NZD',
    label: 'New Zealand Dollar (NZ\$)',
    symbol: 'NZ\$',
    locale: 'en-NZ',
  ),
  CurrencyType(
    value: 'MXN',
    label: 'Mexican Peso (Mex\$)',
    symbol: 'Mex\$',
    locale: 'es-MX',
  ),
  CurrencyType(
    value: 'SGD',
    label: 'Singapore Dollar (S\$)',
    symbol: 'S\$',
    locale: 'en-SG',
  ),
  CurrencyType(
    value: 'HKD',
    label: 'Hong Kong Dollar (HK\$)',
    symbol: 'HK\$',
    locale: 'zh-HK',
  ),
  CurrencyType(
    value: 'NOK',
    label: 'Norwegian Krone (kr)',
    symbol: 'kr',
    locale: 'nb-NO',
  ),
  CurrencyType(
    value: 'KRW',
    label: 'South Korean Won (₩)',
    symbol: '₩',
    locale: 'ko-KR',
  ),
  CurrencyType(
    value: 'TRY',
    label: 'Turkish Lira (₺)',
    symbol: '₺',
    locale: 'tr-TR',
  ),
  CurrencyType(
    value: 'RUB',
    label: 'Russian Ruble (₽)',
    symbol: '₽',
    locale: 'ru-RU',
  ),
  CurrencyType(
    value: 'INR',
    label: 'Indian Rupee (₹)',
    symbol: '₹',
    locale: 'hi-IN',
  ),
  CurrencyType(
    value: 'BRL',
    label: 'Brazilian Real (R\$)',
    symbol: 'R\$',
    locale: 'pt-BR',
  ),
  CurrencyType(
    value: 'ZAR',
    label: 'South African Rand (R)',
    symbol: 'R',
    locale: 'en-ZA',
  ),
  CurrencyType(
    value: 'PHP',
    label: 'Philippine Peso (₱)',
    symbol: '₱',
    locale: 'tl-PH',
  ),
  CurrencyType(
    value: 'IDR',
    label: 'Indonesian Rupiah (Rp)',
    symbol: 'Rp',
    locale: 'id-ID',
  ),
  CurrencyType(
    value: 'MYR',
    label: 'Malaysian Ringgit (RM)',
    symbol: 'RM',
    locale: 'ms-MY',
  ),
  CurrencyType(
    value: 'THB',
    label: 'Thai Baht (฿)',
    symbol: '฿',
    locale: 'th-TH',
  ),
  CurrencyType(
    value: 'AED',
    label: 'UAE Dirham (د.إ)',
    symbol: 'د.إ',
    locale: 'ar-AE',
  ),
  CurrencyType(
    value: 'ARS',
    label: 'Argentine Peso (ARS\$)',
    symbol: 'ARS\$',
    locale: 'es-AR',
  ),
  CurrencyType(
    value: 'CLP',
    label: 'Chilean Peso (CLP\$)',
    symbol: 'CLP\$',
    locale: 'es-CL',
  ),
  CurrencyType(
    value: 'COP',
    label: 'Colombian Peso (COP\$)',
    symbol: 'COP\$',
    locale: 'es-CO',
  ),
  CurrencyType(
    value: 'EGP',
    label: 'Egyptian Pound (E£)',
    symbol: 'E£',
    locale: 'ar-EG',
  ),
  CurrencyType(
    value: 'VND',
    label: 'Vietnamese Dong (₫)',
    symbol: '₫',
    locale: 'vi-VN',
  ),
  CurrencyType(
    value: 'KZT',
    label: 'Kazakhstani Tenge (₸)',
    symbol: '₸',
    locale: 'kk-KZ',
  ),
  CurrencyType(
    value: 'NGN',
    label: 'Nigerian Naira (₦)',
    symbol: '₦',
    locale: 'en-NG',
  ),
  CurrencyType(
    value: 'PKR',
    label: 'Pakistani Rupee (₨)',
    symbol: '₨',
    locale: 'ur-PK',
  ),
  CurrencyType(
    value: 'BDT',
    label: 'Bangladeshi Taka (৳)',
    symbol: '৳',
    locale: 'bn-BD',
  ),
  CurrencyType(
    value: 'UAH',
    label: 'Ukrainian Hryvnia (₴)',
    symbol: '₴',
    locale: 'uk-UA',
  ),
  CurrencyType(
    value: 'IQD',
    label: 'Iraqi Dinar (ع.د)',
    symbol: 'ع.د',
    locale: 'ar-IQ',
  ),
  CurrencyType(
    value: 'QAR',
    label: 'Qatari Riyal (ر.ق)',
    symbol: 'ر.ق',
    locale: 'ar-QA',
  ),
  CurrencyType(
    value: 'SAR',
    label: 'Saudi Riyal (﷼)',
    symbol: '﷼',
    locale: 'ar-SA',
  ),
  CurrencyType(
    value: 'KWD',
    label: 'Kuwaiti Dinar (KD)',
    symbol: 'KD',
    locale: 'ar-KW',
  ),
  CurrencyType(
    value: 'BHD',
    label: 'Bahraini Dinar (BD)',
    symbol: 'BD',
    locale: 'ar-BH',
  ),
  CurrencyType(
    value: 'OMR',
    label: 'Omani Rial (﷼)',
    symbol: '﷼',
    locale: 'ar-OM',
  ),
  CurrencyType(
    value: 'DZD',
    label: 'Algerian Dinar (د.ج)',
    symbol: 'د.ج',
    locale: 'ar-DZ',
  ),
  CurrencyType(
    value: 'MAD',
    label: 'Moroccan Dirham (د.م.)',
    symbol: 'د.م.',
    locale: 'ar-MA',
  ),
  CurrencyType(
    value: 'LBP',
    label: 'Lebanese Pound (ل.ل)',
    symbol: 'ل.ل',
    locale: 'ar-LB',
  ),
  CurrencyType(
    value: 'SDG',
    label: 'Sudanese Pound (ج.س)',
    symbol: 'ج.س',
    locale: 'ar-SD',
  ),
  CurrencyType(
    value: 'KES',
    label: 'Kenyan Shilling (KSh)',
    symbol: 'KSh',
    locale: 'sw-KE',
  ),
  CurrencyType(
    value: 'TZS',
    label: 'Tanzanian Shilling (TSh)',
    symbol: 'TSh',
    locale: 'sw-TZ',
  ),
  CurrencyType(
    value: 'UGX',
    label: 'Ugandan Shilling (USh)',
    symbol: 'USh',
    locale: 'sw-UG',
  ),
  CurrencyType(
    value: 'GHS',
    label: 'Ghanaian Cedi (₵)',
    symbol: '₵',
    locale: 'en-GH',
  ),
  CurrencyType(
    value: 'XAF',
    label: 'Central African CFA Franc (FCFA)',
    symbol: 'FCFA',
    locale: 'fr-CM',
  ),
  CurrencyType(
    value: 'XOF',
    label: 'West African CFA Franc (CFA)',
    symbol: 'CFA',
    locale: 'fr-BJ',
  ),
  CurrencyType(
    value: 'CDF',
    label: 'Congolese Franc (FC)',
    symbol: 'FC',
    locale: 'fr-CD',
  ),
  CurrencyType(
    value: 'MZN',
    label: 'Mozambican Metical (MT)',
    symbol: 'MT',
    locale: 'pt-MZ',
  ),
  CurrencyType(
    value: 'ETB',
    label: 'Ethiopian Birr (Br)',
    symbol: 'Br',
    locale: 'am-ET',
  ),
];

final CurrencyType defaultCurrency = currencies.firstWhere(
  (c) => c.value == 'USD',
  orElse: () => currencies[0],
);

class LanguageType {
  final String value;
  final String label;
  final String alternative;

  const LanguageType({
    required this.value,
    required this.label,
    required this.alternative,
  });
}

const List<LanguageType> languages = [
  LanguageType(value: 'en', label: 'English', alternative: 'English'),
  LanguageType(value: 'zh', label: '简体中文', alternative: 'Chinese (Simplified)'),
  LanguageType(
    value: 'zh-Hant',
    label: '繁體中文',
    alternative: 'Chinese (Traditional)',
  ),
  LanguageType(value: 'hi', label: 'हिन्दी', alternative: 'Hindi'),
  LanguageType(value: 'es', label: 'Español', alternative: 'Spanish'),
  LanguageType(value: 'ar', label: 'العربية', alternative: 'Arabic'),
  LanguageType(value: 'bn', label: 'বাংলা', alternative: 'Bengali'),
  LanguageType(value: 'pt', label: 'Português', alternative: 'Portuguese'),
  LanguageType(value: 'ru', label: 'Русский', alternative: 'Russian'),
  LanguageType(value: 'ur', label: 'اردو', alternative: 'Urdu'),
  LanguageType(
    value: 'id',
    label: 'Bahasa Indonesia',
    alternative: 'Indonesian',
  ),
  LanguageType(value: 'de', label: 'Deutsch', alternative: 'German'),
  LanguageType(value: 'ja', label: '日本語', alternative: 'Japanese'),
  LanguageType(value: 'fr', label: 'Français', alternative: 'French'),
  LanguageType(value: 'te', label: 'తెలుగు', alternative: 'Telugu'),
  LanguageType(value: 'ta', label: 'தமிழ்', alternative: 'Tamil'),
  LanguageType(value: 'ko', label: '한국어', alternative: 'Korean'),
  LanguageType(value: 'tr', label: 'Türkçe', alternative: 'Turkish'),
  LanguageType(value: 'ml', label: 'മലയാളം', alternative: 'Malayalam'),
  LanguageType(value: 'vi', label: 'Tiếng Việt', alternative: 'Vietnamese'),
  LanguageType(value: 'it', label: 'Italiano', alternative: 'Italian'),
  LanguageType(value: 'th', label: 'ไทย', alternative: 'Thai'),
  LanguageType(value: 'gu', label: 'ગુજરાતી', alternative: 'Gujarati'),
  LanguageType(value: 'kn', label: 'ಕನ್ನಡ', alternative: 'Kannada'),
  LanguageType(value: 'ms', label: 'Bahasa Melayu', alternative: 'Malay'),
  LanguageType(value: 'nl', label: 'Nederlands', alternative: 'Dutch'),
];

LanguageType defaultLanguage = languages.firstWhere(
  (l) => l.value == 'en',
  orElse: () => languages[0],
);
