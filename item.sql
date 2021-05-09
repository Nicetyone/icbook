USE `essentialmode`; -- tu zamiast essentialmode powinna sie znajdywac nazwa bazy danych.

-- Standardowa konfiguracja
INSERT INTO `items` (`name`, `label`, `limit`, `rare`, `can_remove`) VALUES
	('icphone', 'IC-Phone', 1, 0, 1), 
;

-- Brak mozliwosci zabierania itemu z Inventory
INSERT INTO `items` (`name`, `label`, `limit`, `rare`, `can_remove`) VALUES
	('icphone', 'IC-Phone', 1, 0, 0), 
;


-- JESLI posiadacie ESX v2 oraz weight system, musicie dodac item manualnie przez baze danych. Wazne jest aby zachowac wartosc name = icphone 
-- Reszta, wedlug wlasnych preferencji.