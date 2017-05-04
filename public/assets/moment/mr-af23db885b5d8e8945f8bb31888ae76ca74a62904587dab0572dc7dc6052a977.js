//! moment.js locale configuration
//! locale : Marathi [mr]
//! author : Harshad Kale : https://github.com/kalehv
//! author : Vivek Athalye : https://github.com/vnathalye
!function(e,a){"object"==typeof exports&&"undefined"!=typeof module&&"function"==typeof require?a(require("../moment")):"function"==typeof define&&define.amd?define(["../moment"],a):a(e.moment)}(this,function(e){"use strict";function a(e,a,r){var s="";if(a)switch(r){case"s":s="\u0915\u093e\u0939\u0940 \u0938\u0947\u0915\u0902\u0926";break;case"m":s="\u090f\u0915 \u092e\u093f\u0928\u093f\u091f";break;case"mm":s="%d \u092e\u093f\u0928\u093f\u091f\u0947";break;case"h":s="\u090f\u0915 \u0924\u093e\u0938";break;case"hh":s="%d \u0924\u093e\u0938";break;case"d":s="\u090f\u0915 \u0926\u093f\u0935\u0938";break;case"dd":s="%d \u0926\u093f\u0935\u0938";break;case"M":s="\u090f\u0915 \u092e\u0939\u093f\u0928\u093e";break;case"MM":s="%d \u092e\u0939\u093f\u0928\u0947";break;case"y":s="\u090f\u0915 \u0935\u0930\u094d\u0937";break;case"yy":s="%d \u0935\u0930\u094d\u0937\u0947"}else switch(r){case"s":s="\u0915\u093e\u0939\u0940 \u0938\u0947\u0915\u0902\u0926\u093e\u0902";break;case"m":s="\u090f\u0915\u093e \u092e\u093f\u0928\u093f\u091f\u093e";break;case"mm":s="%d \u092e\u093f\u0928\u093f\u091f\u093e\u0902";break;case"h":s="\u090f\u0915\u093e \u0924\u093e\u0938\u093e";break;case"hh":s="%d \u0924\u093e\u0938\u093e\u0902";break;case"d":s="\u090f\u0915\u093e \u0926\u093f\u0935\u0938\u093e";break;case"dd":s="%d \u0926\u093f\u0935\u0938\u093e\u0902";break;case"M":s="\u090f\u0915\u093e \u092e\u0939\u093f\u0928\u094d\u092f\u093e";break;case"MM":s="%d \u092e\u0939\u093f\u0928\u094d\u092f\u093e\u0902";break;case"y":s="\u090f\u0915\u093e \u0935\u0930\u094d\u0937\u093e";break;case"yy":s="%d \u0935\u0930\u094d\u0937\u093e\u0902"}return s.replace(/%d/i,e)}var r={1:"\u0967",2:"\u0968",3:"\u0969",4:"\u096a",5:"\u096b",6:"\u096c",7:"\u096d",8:"\u096e",9:"\u096f",0:"\u0966"},s={"\u0967":"1","\u0968":"2","\u0969":"3","\u096a":"4","\u096b":"5","\u096c":"6","\u096d":"7","\u096e":"8","\u096f":"9","\u0966":"0"},t=e.defineLocale("mr",{months:"\u091c\u093e\u0928\u0947\u0935\u093e\u0930\u0940_\u092b\u0947\u092c\u094d\u0930\u0941\u0935\u093e\u0930\u0940_\u092e\u093e\u0930\u094d\u091a_\u090f\u092a\u094d\u0930\u093f\u0932_\u092e\u0947_\u091c\u0942\u0928_\u091c\u0941\u0932\u0948_\u0911\u0917\u0938\u094d\u091f_\u0938\u092a\u094d\u091f\u0947\u0902\u092c\u0930_\u0911\u0915\u094d\u091f\u094b\u092c\u0930_\u0928\u094b\u0935\u094d\u0939\u0947\u0902\u092c\u0930_\u0921\u093f\u0938\u0947\u0902\u092c\u0930".split("_"),monthsShort:"\u091c\u093e\u0928\u0947._\u092b\u0947\u092c\u094d\u0930\u0941._\u092e\u093e\u0930\u094d\u091a._\u090f\u092a\u094d\u0930\u093f._\u092e\u0947._\u091c\u0942\u0928._\u091c\u0941\u0932\u0948._\u0911\u0917._\u0938\u092a\u094d\u091f\u0947\u0902._\u0911\u0915\u094d\u091f\u094b._\u0928\u094b\u0935\u094d\u0939\u0947\u0902._\u0921\u093f\u0938\u0947\u0902.".split("_"),monthsParseExact:!0,weekdays:"\u0930\u0935\u093f\u0935\u093e\u0930_\u0938\u094b\u092e\u0935\u093e\u0930_\u092e\u0902\u0917\u0933\u0935\u093e\u0930_\u092c\u0941\u0927\u0935\u093e\u0930_\u0917\u0941\u0930\u0942\u0935\u093e\u0930_\u0936\u0941\u0915\u094d\u0930\u0935\u093e\u0930_\u0936\u0928\u093f\u0935\u093e\u0930".split("_"),weekdaysShort:"\u0930\u0935\u093f_\u0938\u094b\u092e_\u092e\u0902\u0917\u0933_\u092c\u0941\u0927_\u0917\u0941\u0930\u0942_\u0936\u0941\u0915\u094d\u0930_\u0936\u0928\u093f".split("_"),weekdaysMin:"\u0930_\u0938\u094b_\u092e\u0902_\u092c\u0941_\u0917\u0941_\u0936\u0941_\u0936".split("_"),longDateFormat:{LT:"A h:mm \u0935\u093e\u091c\u0924\u093e",LTS:"A h:mm:ss \u0935\u093e\u091c\u0924\u093e",L:"DD/MM/YYYY",LL:"D MMMM YYYY",LLL:"D MMMM YYYY, A h:mm \u0935\u093e\u091c\u0924\u093e",LLLL:"dddd, D MMMM YYYY, A h:mm \u0935\u093e\u091c\u0924\u093e"},calendar:{sameDay:"[\u0906\u091c] LT",nextDay:"[\u0909\u0926\u094d\u092f\u093e] LT",nextWeek:"dddd, LT",lastDay:"[\u0915\u093e\u0932] LT",lastWeek:"[\u092e\u093e\u0917\u0940\u0932] dddd, LT",sameElse:"L"},relativeTime:{future:"%s\u092e\u0927\u094d\u092f\u0947",past:"%s\u092a\u0942\u0930\u094d\u0935\u0940",s:a,m:a,mm:a,h:a,hh:a,d:a,dd:a,M:a,MM:a,y:a,yy:a},preparse:function(e){return e.replace(/[\u0967\u0968\u0969\u096a\u096b\u096c\u096d\u096e\u096f\u0966]/g,function(e){return s[e]})},postformat:function(e){return e.replace(/\d/g,function(e){return r[e]})},meridiemParse:/\u0930\u093e\u0924\u094d\u0930\u0940|\u0938\u0915\u093e\u0933\u0940|\u0926\u0941\u092a\u093e\u0930\u0940|\u0938\u093e\u092f\u0902\u0915\u093e\u0933\u0940/,meridiemHour:function(e,a){return 12===e&&(e=0),"\u0930\u093e\u0924\u094d\u0930\u0940"===a?4>e?e:e+12:"\u0938\u0915\u093e\u0933\u0940"===a?e:"\u0926\u0941\u092a\u093e\u0930\u0940"===a?e>=10?e:e+12:"\u0938\u093e\u092f\u0902\u0915\u093e\u0933\u0940"===a?e+12:void 0},meridiem:function(e){return 4>e?"\u0930\u093e\u0924\u094d\u0930\u0940":10>e?"\u0938\u0915\u093e\u0933\u0940":17>e?"\u0926\u0941\u092a\u093e\u0930\u0940":20>e?"\u0938\u093e\u092f\u0902\u0915\u093e\u0933\u0940":"\u0930\u093e\u0924\u094d\u0930\u0940"},week:{dow:0,doy:6}});return t});