﻿&НаСервере
Процедура ОбновитьОстаткиДС()
	ОстаткиДС.Очистить();
	ТЗ = РегистрыНакопления.ДенежныеСредства.Остатки();
	
	Выборка = Справочники.Кошельки.Выбрать();
	Пока Выборка.Следующий() Цикл
		Если Не Выборка.ЭтоГруппа И Выборка.БыстрыйДоступКОстаткам И ТЗ.Найти(Выборка.Ссылка,"Кошелек") = Неопределено Тогда
			НоваяСтрока         = ТЗ.Добавить();
			НоваяСтрока.Кошелек = Выборка.Ссылка;
		КонецЕсли;	
	КонецЦикла;
	
	ТЗ.Сортировать("Кошелек");
	Для Каждого СтрокаТЧ Из ТЗ Цикл
		Если СтрокаТЧ.Кошелек.БыстрыйДоступКОстаткам Тогда
			НоваяСтрока = ОстаткиДС.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока,СтрокаТЧ);
			НоваяСтрока.Валюта = НоваяСтрока.Кошелек.Валюта;
		КонецЕсли;	
	КонецЦикла;	
	Элементы.ОстаткиДС.ВысотаВСтрокахТаблицы = ОстаткиДС.Количество();
КонецПроцедуры	

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	// ВМЕСТО МОДУЛЯ ПРИЛОЖЕНИЯ //
	ОбщийМодульСервер.ПроверитьВыполнитьПервоначальноеЗаполнение();
	ОбщийМодульСервер.ПроверитьВыполнитьОбновление();
	// ВМЕСТО МОДУЛЯ ПРИЛОЖЕНИЯ //
	ОбновитьОстаткиДС();
КонецПроцедуры

// КЛИЕНТСКИЕ  ПРОЦЕДУРЫ И ФУНКЦИИ //

// ДОКУМЕНТЫ //

&НаКлиенте
Процедура НовыйПриходДенег(Команда)
	ОткрытьФорму("Документ.ПриходДенег.ФормаОбъекта");
КонецПроцедуры

&НаКлиенте
Процедура НовыйРасходДенег(Команда)
	ОткрытьФорму("Документ.РасходДенег.ФормаОбъекта");
КонецПроцедуры

&НаКлиенте
Процедура НовоеПеремещениеДенег(Команда)
	ОткрытьФорму("Документ.ПеремещениеДенег.ФормаОбъекта");
КонецПроцедуры

&НаКлиенте
Процедура КомандаДокументы(Команда)
	ОткрытьФорму("ОбщаяФорма.Документы");
КонецПроцедуры

// ОТЧЕТЫ //

&НаКлиенте
Процедура КомандаОбновитьОстаткиДС(Команда)
	ОбновитьОстаткиДС();
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОтчетОстаткиДС(Команда)
	ОткрытьФорму("Обработка.ОстаткиДС.Форма.Форма");
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПанельОтчетов(Команда)
	ОткрытьФорму("ОбщаяФорма.ПанельОтчетов");
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПланирование(Команда)
	ОткрытьФорму("ОбщаяФорма.Планирование");
КонецПроцедуры

// НСИ //

&НаКлиенте
Процедура КомандаСправочники(Команда)
	ОткрытьФорму("ОбщаяФорма.Справочники");
КонецПроцедуры

// Обработка оповещения //

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ЗаписьДокумента" Тогда
		ОбновитьОстаткиДС();
	КонецЕсли;	
КонецПроцедуры

// Помощь //

&НаКлиенте
Процедура КомандаПомощь(Команда)
	ОткрытьФорму("ОбщаяФорма.Справка");
КонецПроцедуры

&НаКлиенте
Процедура КомандаСервис(Команда)
	ОткрытьФорму("ОбщаяФорма.Сервис");
КонецПроцедуры

// Откроем журнал транзакций //

&НаКлиенте
Процедура ОстаткиДСВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ТекСтрока = Элементы.ОстаткиДС.ТекущиеДанные;
	Если ТекСтрока <> Неопределено Тогда
		ОткрытьФорму("Обработка.ЖурналТранзакций.Форма.Форма",Новый Структура("Кошелек",ТекСтрока.Кошелек));
	КонецЕсли;	
КонецПроцедуры

// Проверим необходимость авторизации //

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если ПроверитьНеобходимостьАвторизации() Тогда
		ОткрытьФормуМодально("ОбщаяФорма.ФормаАвторизации");	
	КонецЕсли;	
КонецПроцедуры

&НаСервере
Функция ПроверитьНеобходимостьАвторизации ()
	Возврат Константы.ИспользоватьАвторизацию.Получить();	
КонецФункции	

