﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ПерепровестиДокументыСервер();
	Сообщить("Документы перепроведены!");
КонецПроцедуры

&НаСервере
Процедура ПерепровестиДокументыСервер () 
	ОбщийМодульСервер.ПерепровестиДокументыСервер();
КонецПроцедуры	