//! moment.js locale configuration
//! locale : Klingon [tlh]
//! author : Dominika Kruk : https://github.com/amaranthrose
!function(a,e){"object"==typeof exports&&"undefined"!=typeof module&&"function"==typeof require?e(require("../moment")):"function"==typeof define&&define.amd?define(["../moment"],e):e(a.moment)}(this,function(a){"use strict";function e(a){var e=a;return e=-1!==a.indexOf("jaj")?e.slice(0,-3)+"leS":-1!==a.indexOf("jar")?e.slice(0,-3)+"waQ":-1!==a.indexOf("DIS")?e.slice(0,-3)+"nem":e+" pIq"}function j(a){var e=a;return e=-1!==a.indexOf("jaj")?e.slice(0,-3)+"Hu\u2019":-1!==a.indexOf("jar")?e.slice(0,-3)+"wen":-1!==a.indexOf("DIS")?e.slice(0,-3)+"ben":e+" ret"}function r(a,e,j){var r=t(a);switch(j){case"mm":return r+" tup";case"hh":return r+" rep";case"dd":return r+" jaj";case"MM":return r+" jar";case"yy":return r+" DIS"}}function t(a){var e=Math.floor(a%1e3/100),j=Math.floor(a%100/10),r=a%10,t="";return e>0&&(t+=n[e]+"vatlh"),j>0&&(t+=(""!==t?" ":"")+n[j]+"maH"),r>0&&(t+=(""!==t?" ":"")+n[r]),""===t?"pagh":t}var n="pagh_wa\u2019_cha\u2019_wej_loS_vagh_jav_Soch_chorgh_Hut".split("_"),_=a.defineLocale("tlh",{months:"tera\u2019 jar wa\u2019_tera\u2019 jar cha\u2019_tera\u2019 jar wej_tera\u2019 jar loS_tera\u2019 jar vagh_tera\u2019 jar jav_tera\u2019 jar Soch_tera\u2019 jar chorgh_tera\u2019 jar Hut_tera\u2019 jar wa\u2019maH_tera\u2019 jar wa\u2019maH wa\u2019_tera\u2019 jar wa\u2019maH cha\u2019".split("_"),monthsShort:"jar wa\u2019_jar cha\u2019_jar wej_jar loS_jar vagh_jar jav_jar Soch_jar chorgh_jar Hut_jar wa\u2019maH_jar wa\u2019maH wa\u2019_jar wa\u2019maH cha\u2019".split("_"),monthsParseExact:!0,weekdays:"lojmItjaj_DaSjaj_povjaj_ghItlhjaj_loghjaj_buqjaj_ghInjaj".split("_"),weekdaysShort:"lojmItjaj_DaSjaj_povjaj_ghItlhjaj_loghjaj_buqjaj_ghInjaj".split("_"),weekdaysMin:"lojmItjaj_DaSjaj_povjaj_ghItlhjaj_loghjaj_buqjaj_ghInjaj".split("_"),longDateFormat:{LT:"HH:mm",LTS:"HH:mm:ss",L:"DD.MM.YYYY",LL:"D MMMM YYYY",LLL:"D MMMM YYYY HH:mm",LLLL:"dddd, D MMMM YYYY HH:mm"},calendar:{sameDay:"[DaHjaj] LT",nextDay:"[wa\u2019leS] LT",nextWeek:"LLL",lastDay:"[wa\u2019Hu\u2019] LT",lastWeek:"LLL",sameElse:"L"},relativeTime:{future:e,past:j,s:"puS lup",m:"wa\u2019 tup",mm:r,h:"wa\u2019 rep",hh:r,d:"wa\u2019 jaj",dd:r,M:"wa\u2019 jar",MM:r,y:"wa\u2019 DIS",yy:r},ordinalParse:/\d{1,2}\./,ordinal:"%d.",week:{dow:1,doy:4}});return _});