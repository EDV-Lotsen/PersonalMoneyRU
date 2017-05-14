﻿
&НаКлиенте
Процедура КомандаОбновить(Команда)
	КомандаОбновитьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура НастройкаВыводаПриИзменении(Элемент)
	КомандаОбновитьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	КомандаОбновитьНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	НастройкаВывода = Элементы.НастройкаВывода.СписокВыбора[0].Значение;
	Период.Вариант  = ВариантСтандартногоПериода.ЭтотМесяц;
	КомандаОбновитьНаСервере();
КонецПроцедуры

&НаСервере
Процедура КомандаОбновитьНаСервере()
	Рез   = РегистрыНакопления.ДвижениеДенежныхСредств.Обороты(Период.ДатаНачала,Период.ДатаОкончания,,"СтатьяДДС","СуммаРасход");
	Макет = РеквизитФормыВЗначение("Объект").ПолучитьМакет("РасходыЗаПериод");
	
	мДеревоСтатей = РеквизитФормыВЗначение("ДеревоСтатей");
	
	НоваяСтрока = мДеревоСтатей.Строки.Добавить();
	НоваяСтрока.ЭтоГруппа = Истина;
	
	ВыборкаСправочник = Справочники.СтатьиДДС.ВыбратьИерархически();
	СЧ = 1;
	Пока ВыборкаСправочник.Следующий() Цикл
		ИскомаяСтрока         = мДеревоСтатей.Строки.Найти(ВыборкаСправочник.Родитель,,Истина);
		НоваяСтрока           = ИскомаяСтрока.Строки.Добавить();
		НоваяСтрока.Ссылка    = ВыборкаСправочник.Ссылка;
		НоваяСтрока.ЭтоГруппа =  ВыборкаСправочник.ЭтоГруппа; 
		Если НЕ ВыборкаСправочник.ЭтоГруппа //И ВыборкаСправочник.ОтображатьВОтчетеПоРасходам 
			Тогда
			СтрокаРез          = Рез.Найти(ВыборкаСправочник.Ссылка);
			Если СтрокаРез <> Неопределено Тогда
				НоваяСтрока.СуммаРасход         = СтрокаРез.СуммаРасход;
				НоваяСтрока.ЕстьНенулевыеСтроки = Истина;
				мРодитель = НоваяСтрока.Родитель;
				Пока ЗначениеЗаполнено(мРодитель) Цикл 
					мРодитель.СуммаРасход = мРодитель.СуммаРасход + НоваяСтрока.СуммаРасход;
					Если НоваяСтрока.СуммаРасход <> 0 Тогда
						мРодитель.ЕстьНенулевыеСтроки = Истина;
					КонецЕсли;	
					мРодитель = мРодитель.Родитель;
				КонецЦикла;
			КонецЕсли;	
		КонецЕсли;
	КонецЦикла;	
	
	// Выводим таблицу //
	Результат.Очистить();
	Область = Макет.ПолучитьОбласть("Шапка");
	Результат.Вывести(Область);
	Область = Макет.ПолучитьОбласть("Строка");
	Результат.НачатьАвтогруппировкуСтрок();
	Для Каждого СтрокаТЧ Из мДеревоСтатей.Строки Цикл
		ВывестиОбластьРекурсивно(СтрокаТЧ,Область);
	КонецЦикла;
	Результат.ЗакончитьАвтогруппировкуСтрок();
	
	// Выводим диаграмму //
	Диаграмма.Очистить();
	Диаграмма.Обновление = Ложь;

	Диаграмма.КоличествоТочек = 1;
	Диаграмма.Точки[0].Текст  = "Расход";
	
	КолСерий = -1;
	
	ИскомыеСтроки = мДеревоСтатей.Строки.НайтиСтроки(Новый Структура("ЭтоГруппа,ЕстьНенулевыеСтроки",Ложь,Истина),Истина);
	
	ТабКопия = Новый ТаблицаЗначений;
	ТабКопия.Колонки.Добавить("Ссылка");
	ТабКопия.Колонки.Добавить("СуммаРасход");
	
	Для Каждого ИскомаяСтрока Из ИскомыеСтроки Цикл
		НоваяСтрока = ТабКопия.Добавить();
		НоваяСтрока.Ссылка = ?(НастройкаВывода = "Укрупненно",ИскомаяСтрока.Ссылка.СтатьяПлана,ИскомаяСтрока.Ссылка);
		НоваяСтрока.СуммаРасход = ИскомаяСтрока.СуммаРасход;
	КонецЦикла;	
	
	ТабКопия.Свернуть("Ссылка","СуммаРасход");
	ТабКопия.Сортировать("СуммаРасход УБЫВ");
	
	Для Каждого СтрокаТЧ Из ТабКопия Цикл
		КолСерий    = КолСерий + 1;
		Серия       = Диаграмма.Серии.Добавить();
		Серия.Текст = СтрокаТЧ.Ссылка.Наименование;
		Диаграмма.УстановитьЗначение(0,КолСерий,СтрокаТЧ.СуммаРасход);
	КонецЦикла;	
	
	Диаграмма.Обновление = Истина;
КонецПроцедуры

&НаСервере
Процедура ВывестиОбластьРекурсивно(СтрокаТЧ,Область)
	Если СтрокаТЧ.ЕстьНенулевыеСтроки = ЛОЖЬ Тогда
		Возврат;
	КонецЕсли;	
	
	Область.Параметры.Заполнить(СтрокаТЧ);
	Результат.Вывести(Область,СтрокаТЧ.Уровень());
	Для Каждого СтрокаПодч Из СтрокаТЧ.Строки Цикл
		ВывестиОбластьРекурсивно(СтрокаПодч,Область);
	КонецЦикла;	
КонецПроцедуры	
