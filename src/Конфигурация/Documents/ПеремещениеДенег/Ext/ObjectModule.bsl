﻿
Процедура ОбработкаПроведения(Отказ, Режим)
	// регистр ДенежныеСредства Расход
	Движения.ДенежныеСредства.Записывать = Истина;
	Движение = Движения.ДенежныеСредства.Добавить();
	Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
	Движение.Период      = Дата;
	Движение.Кошелек     = Отправитель;
	Движение.Сумма       = СуммаСписания;
	Движение.СтатьяДДС   = СтатьяДДС;

	// регистр ДенежныеСредства Приход
	Движения.ДенежныеСредства.Записывать = Истина;
	Движение = Движения.ДенежныеСредства.Добавить();
	Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
	Движение.Период      = Дата;
	Движение.Кошелек     = Получатель;
	Движение.Сумма       = СуммаОприходования;
	Движение.СтатьяДДС   = СтатьяДДС;
КонецПроцедуры
