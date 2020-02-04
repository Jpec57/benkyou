const HAh = 12399;
const HAk = 12495;
const WAhk = 12431;
const TSUh = 12387;
const TSUk = 12483;


const YAh = 12419;
const YAk = 12515;
const YUh = 12421;
const YUk = 12517;
const YOh = 12423;
const YOk = 12519;

const HIRAGANA_ALPHABET = {
  1: {
    "a": "\u3042",
    "i": "\u3044",
    "u": "\u3046",
    "e": "\u3048",
    "o": "\u304a",
    "n": "\u3093",
  },
  2: {
    "ka": "\u304b",
    "ki": "\u304d",
    "ku": "\u304f",
    "ke": "\u3051",
    "ko": "\u3053",
    "ga": "\u304c",
    "gi": "\u304e",
    "gu": "\u3050",
    "ge": "\u3052",
    "go": "\u3054",
    "sa": "\u3055",
    "si": "\u3057",
    "su": "\u3059",
    "se": "\u305b",
    "so": "\u305d",
    "za": "\u3056",
    "zi": "\u3058",
    "zu": "\u305a",
    "ze": "\u305c",
    "zo": "\u305e",
    "ta": "\u305f",
    "ti": "\u3061",
    "tu": "\u3064",
    "te": "\u3066",
    "to": "\u3068",
    "da": "\u3060",
    "di": "\u3062",
    "du": "\u3065",
    "de": "\u3067",
    "do": "\u3069",
    "na": "\u306a",
    "ni": "\u306b",
    "nu": "\u306c",
    "ne": "\u306d",
    "no": "\u306e",
    "ha": "\u306f",
    "hi": "\u3072",
    "fu": "\u3075",
    "he": "\u3078",
    "ho": "\u307b",
    "ba": "\u3070",
    "bi": "\u3073",
    "bu": "\u3076",
    "be": "\u3079",
    "bo": "\u307c",
    "pa": "\u3071",
    "pi": "\u3074",
    "pu": "\u3077",
    "pe": "\u307a",
    "po": "\u307d",
    "ma": "\u307e",
    "mi": "\u307f",
    "mu": "\u3080",
    "me": "\u3081",
    "mo": "\u3082",
    "ya": "\u3084",
    "yu": "\u3086",
    "yo": "\u3088",
    "ra": "\u3089",
    "ri": "\u308a",
    "ru": "\u308b",
    "re": "\u308c",
    "ro": "\u308d",
    "wa": "\u308f",
    "wi": "\u3090",
    "we": "\u3091",
    "wo": "\u3092",
    "ja": "\u3058\u3083",
    "ju": "\u3058\u3085",
    "jo": "\u3058\u3087",
    "ji": "\u3058"
  },
  3: {
    "kya": "\u304d\u3083",
    "kyu": "\u304d\u3085",
    "kyo": "\u304d\u3087",
    "sha": "\u3057\u3083",
    "shu": "\u3057\u3085",
    "sho": "\u3057\u3087",
    "shi": "\u3057",
    "tsu": "\u3064",
    "cha": "\u3061\u3083",
    "chu": "\u3061\u3085",
    "cho": "\u3061\u3087",
    "chi": "\u3061",
    "nya": "\u306b\u3083",
    "nyu": "\u306b\u3085",
    "nyo": "\u306b\u3087",
    "hya": "\u3072\u3083",
    "hyu": "\u3072\u3085",
    "hyo": "\u3072\u3087",
    "mya": "\u307f\u3083",
    "myu": "\u307f\u3085",
    "myo": "\u307f\u3087",
    "rya": "\u308a\u3083",
    "ryu": "\u308a\u3085",
    "ryo": "\u308a\u3087",
    "gya": "\u304e\u3083",
    "gyu": "\u304e\u3085",
    "gyo": "\u304e\u3087",
    "bya": "\u3073\u3083",
    "byu": "\u3073\u3085",
    "byo": "\u3073\u3087",
    "pya": "\u3074\u3083",
    "pyu": "\u3074\u3085",
    "pyo": "\u3074\u3087"
  },
  4: {"tsu": "\u3063"}
};
//m not treated as n because otherwise gozaimasu -> gozainasu
const KATAKANA_ALPHABET = {
  1: {
    "a": "\u30a2",
    "i": "\u30a4",
    "u": "\u30a6",
    "e": "\u30a8",
    "o": "\u30aa",
    "n": "\u30f3",
  },
  2: {
    "ka": "\u30ab",
    "ki": "\u30ad",
    "ku": "\u30af",
    "ke": "\u30b1",
    "ko": "\u30b3",
    "ga": "\u30ac",
    "gi": "\u30ae",
    "gu": "\u30b0",
    "ge": "\u30b2",
    "go": "\u30b4",
    "sa": "\u30b5",
    "si": "\u30b7",
    "su": "\u30b9",
    "se": "\u30bb",
    "so": "\u30bd",
    "za": "\u30b6",
    "zi": "\u30b8",
    "zu": "\u30ba",
    "ze": "\u30bc",
    "zo": "\u30be",
    "ta": "\u30bf",
    "ti": "\u30c1",
    "tu": "\u30c3",
    "te": "\u30c6",
    "to": "\u30c8",
    "da": "\u30c0",
    "di": "\u30c2",
    "du": "\u30c4",
    "de": "\u30c6",
    "do": "\u30c8",
    "na": "\u30ca",
    "ni": "\u30cb",
    "nu": "\u30cc",
    "ne": "\u30cd",
    "no": "\u30ce",
    "ha": "\u30cf",
    "hi": "\u30d2",
    "fu": "\u30d5",
    "he": "\u30d6",
    "ho": "\u30da",
    "ba": "\u30cb",
    "bi": "\u30cf",
    "bu": "\u30d3",
    "be": "\u30d7",
    "bo": "\u30db",
    "pa": "\u30d1",
    "pi": "\u30d4",
    "pu": "\u30d7",
    "pe": "\u30da",
    "po": "\u30dd",
    "ma": "\u30de",
    "mi": "\u30df",
    "mu": "\u30e0",
    "me": "\u30e1",
    "mo": "\u30e2",
    "ya": "\u30e4",
    "yu": "\u30e6",
    "yo": "\u30e8",
    "ra": "\u30e9",
    "ri": "\u30ea",
    "ru": "\u30eb",
    "re": "\u30ec",
    "ro": "\u30ed",
    "wa": "\u30ef",
    "wo": "\u30f2",
    "ja": "\u30b8\u30e3",
    "ju": "\u30b8\u30e5",
    "jo": "\u30b8\u30e7",
    "ji": "\u30b8",
    "vi": "\u30f4\u30a3"
  },
  3: {
    "kya": "\u30ad\u30e3",
    "kyu": "\u30ad\u30e5",
    "kyo": "\u30ad\u30e7",
    "sha": "\u30b7\u30e3",
    "shu": "\u30b7\u30e5",
    "sho": "\u30b7\u30e7",
    "shi": "\u30b7",
    "tsu": "\u30c4",
    "cha": "\u30c1\u30e3",
    "chu": "\u30c1\u30e5",
    "cho": "\u30c1\u30e7",
    "chi": "\u30c1",
    "nya": "\u30cb\u30e3",
    "nyu": "\u30cb\u30e5",
    "nyo": "\u30cb\u30e7",
    "hya": "\u30d2\u30e3",
    "hyu": "\u30d2\u30e5",
    "hyo": "\u30d2\u30e7",
    "mya": "\u30df\u30e3",
    "myu": "\u30df\u30e5",
    "myo": "\u30df\u30e7",
    "rya": "\u30ea\u30e3",
    "ryu": "\u30ea\u30e5",
    "ryo": "\u30ea\u30e7",
    "gya": "\u30ae\u30e3",
    "gyu": "\u30ae\u30e5",
    "gyo": "\u30ae\u30e7",
    "bya": "\u30d3\u30e3",
    "byu": "\u30d3\u30e5",
    "byo": "\u30d3\u30e7",
    "pya": "\u30d4\u30e3",
    "pyu": "\u30d4\u30e5",
    "pyo": "\u30d4\u30e7"
  },
  4: {"tsu": "\u30c3"}
};

const rom = {
  12354: "a",
  12356: "i",
  12358: "u",
  12360: "e",
  12362: "o",
  12435: "n",
  12450: "a",
  12452: "i",
  12454: "u",
  12456: "e",
  12458: "o",
  12531: "n",
  12363: "ka",
  12365: "ki",
  12367: "ku",
  12369: "ke",
  12371: "ko",
  12459: "ka",
  12461: "ki",
  12463: "ku",
  12465: "ke",
  12467: "ko",
  12373: "sa",
  12375: "shi",
  12377: "su",
  12379: "se",
  12381: "so",
  12469: "sa",
  12471: "shi",
  12473: "su",
  12475: "se",
  12477: "so",
  12383: "ta",
  12385: "chi",
  12388: "tsu",
  12390: "te",
  12392: "to",
  12479: "ta",
  12481: "chi",
  12484: "tsu",
  12486: "te",
  12488: "to",
  12394: "na",
  12395: "ni",
  12396: "nu",
  12397: "ne",
  12398: "no",
  12490: "na",
  12491: "ni",
  12492: "nu",
  12493: "ne",
  12494: "no",
  12399: "ha",
  12402: "hi",
  12405: "fu",
  12408: "he",
  12411: "ho",
  12495: "ha",
  12498: "hi",
  12501: "fu",
  12504: "he",
  12507: "ho",
  12414: "ma",
  12415: "mi",
  12416: "mu",
  12417: "me",
  12418: "mo",
  12510: "ma",
  12511: "mi",
  12512: "mu",
  12513: "me",
  12514: "mo",
  12420: "ya",
  12422: "yu",
  12424: "yo",
  12516: "ya",
  12518: "yu",
  12520: "yo",
  12425: "ra",
  12426: "ri",
  12427: "ru",
  12428: "re",
  12429: "ro",
  12521: "ra",
  12522: "ri",
  12523: "ru",
  12524: "re",
  12525: "ro",
  12431: "wa",
  12434: "o",
  12527: "wa",
  12530: "o",
  12364: "ga",
  12366: "gi",
  12368: "gu",
  12370: "ge",
  12372: "go",
  12460: "ga",
  12462: "gi",
  12464: "gu",
  12466: "ge",
  12468: "go",
  12374: "za",
  12376: "ji",
  12378: "zu",
  12380: "ze",
  12382: "zo",
  12470: "za",
  12472: "ji",
  12474: "zu",
  12476: "ze",
  12478: "zo",
  12384: "da",
  12386: "ji",
  12389: "zu",
  12391: "de",
  12393: "do",
  12480: "da",
  12482: "ji",
  12485: "zu",
  12487: "de",
  12489: "do",
  12400: "ba",
  12403: "bi",
  12406: "bu",
  12409: "be",
  12412: "bo",
  12496: "ba",
  12499: "bi",
  12502: "bu",
  12505: "be",
  12508: "bo",
  12401: "pa",
  12404: "pi",
  12407: "pu",
  12410: "pe",
  12413: "po",
  12497: "pa",
  12500: "pi",
  12503: "pu",
  12506: "pe",
  12509: "po"
};

String getJapaneseTranslation(String val, {bool onlyJapanese = false,
  bool hasSpace = true}) {
  if (val.isEmpty) {
    return '';
  }
  Map<int, Map<String, String>> alphabet = (val[0].toUpperCase() == val[0]) ? KATAKANA_ALPHABET : HIRAGANA_ALPHABET;
  return getConversion(val, alphabet, onlyJapanese: onlyJapanese, hasSpace: hasSpace) ?? '';
}

String getHiragana(String val, {bool onlyJapanese = false,
  bool hasSpace = true}) {
  return getConversion(val, HIRAGANA_ALPHABET, onlyJapanese: onlyJapanese, hasSpace: hasSpace);
}

String getKatakana(String val, {bool onlyJapanese = false,
  bool hasSpace = true}) {
  return getConversion(val, KATAKANA_ALPHABET, onlyJapanese: onlyJapanese, hasSpace: hasSpace);
}

String getRomaji(int val) {
  return rom[val];
}
String getRomConversion(String val, {bool onlyRomaji = false}) {
  var res = "";
//  return getWordToRom(val, onlyRomaji: onlyRomaji);
  RegExp regExp = RegExp(' |　');
  List<String> listStrings = val.split(regExp);
  int nbStrings = listStrings.length;
  for (var i = 0; i < nbStrings; i++) {
    String wordRes = getWordToRom(listStrings[i], onlyRomaji: onlyRomaji);
    if (wordRes != null){
      res += wordRes;
    }
    if (i < nbStrings - 1){
      res += ' ';
    }
  }
  return res;
}

String getWordToRom(String word, {bool onlyRomaji = false}){
  String res = "";

  int wordLength = word.length;
  for (var j = 0; j < wordLength; j++) {
    int ch = word.codeUnitAt(j);

    if ((ch == HAk || ch == HAh) && word.length == 1) {
      ch = WAhk;
    }
    if ((ch == TSUh || ch == TSUk)
    ) {
      String nextch = (j + 1 < wordLength) ? getRomaji(word.codeUnitAt(j + 1)) : null;
      if (nextch != null) {
        res += nextch.substring(0, 1);
        j++;
        ch = word.codeUnitAt(j);
      }
    }

    String tmpch = getRomaji(ch);
    int nch = (j + 1 < wordLength) ? word.codeUnitAt(j + 1) : null;
    if (tmpch != null &&
          nch != null &&
        (nch == YAh ||
            nch == YAk ||
            nch == YUh ||
            nch == YUk ||
            nch == YOh ||
            nch == YOk)) {
      String beg = tmpch.substring(0, tmpch.length - 1);
      String en = getRomaji((nch + 1));
      if (beg == 'sh' || beg == 'ch' || beg == 'j') {
        tmpch = beg + en.substring(1);
      } else {
        tmpch = beg + en;
      }
      j++;
    }
    if (tmpch != null) {
      res += tmpch;
    } else {
      //Add the non-translated term to the string for continuous translation
      if (!onlyRomaji){
        res += word[j];
      }
    }
  }
  return res;
}

String getMatchingCharacterInAlphabet(int nbCaracters, val, alphabet) {
  if (val == null) {
    return null;
  }
  var obj = alphabet[nbCaracters];
  return obj[val];
}

String getSafeSubstring(String str, int startIndex, int size, int strLength) {
  return (strLength < startIndex + size)
      ? null
      : str.substring(startIndex, startIndex + size);
}

String getConversion(String val, alphabet, {bool onlyJapanese = false,
  bool hasSpace = true}) {
  int i = 0;
  String res = "";
  String tmpChar;
  int wordLength;
  List<String> wordList = val.toLowerCase().split(" ");
  int listLength = wordList.length;

  for (int j = 0; j < listLength; j++){
    String word = wordList[j];
    i = 0;
    wordLength = word.length;
    if (wordLength == 0){
      continue;
    }
    while (i < wordLength) {
      //3 letter syllable
      tmpChar = getMatchingCharacterInAlphabet(
          3, getSafeSubstring(word, i, 3, wordLength), alphabet);

      //Compound syllable
      if (tmpChar == null) {
        var ch1 = getSafeSubstring(word, i, 1, wordLength);
        var ch2 = getSafeSubstring(word, i + 1, 2, wordLength);

        if (ch1 != null &&
            ch2 != null &&
            ch1 != 'n' &&
            getMatchingCharacterInAlphabet(2, ch2, alphabet) != null &&
            (ch1 == getSafeSubstring(ch2, 0, 1, 2))) {
          tmpChar = getMatchingCharacterInAlphabet(2, ch2, alphabet);
          res += getMatchingCharacterInAlphabet(4, "tsu", alphabet);
        }
      }

      //2 letter syllable
      if (tmpChar != null) {
        i += 2;
      } else {
        var char = getSafeSubstring(word, i, 2, wordLength);
        //Particular case
        if (char == 'wa' && char == word) {
          char = "ha";
        }
        tmpChar = getMatchingCharacterInAlphabet(2, char, alphabet);
        if (tmpChar != null) {
          i += 1;
        } else {
          //1 letter syllable
          tmpChar = getMatchingCharacterInAlphabet(
              1, getSafeSubstring(word, i, 1, wordLength), alphabet);
        }
      }
      //particular case with little tsu then three characters like sshi cchi ttsu
      var ch3 = getSafeSubstring(word, i + 1, 3, wordLength);
      if (tmpChar == null && ch3 != null){
        res += getMatchingCharacterInAlphabet(4, "tsu", alphabet);
        tmpChar = getMatchingCharacterInAlphabet(3, ch3, alphabet);
        i += 3;
      }
      // We've found a solution with 1, 2 or 3 characters
      if (tmpChar != null) {
        res += tmpChar;
      } else {
        //Add the non-translated term to the string for continuous translation
        if (!onlyJapanese){
          res += word[i];
        }
      }
      i++;
    }
    if (hasSpace && j != listLength - 1){
      res += " ";
    }
  }
  return res;
}