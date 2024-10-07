# Vyhledavač jízdních řádů

## Vize
Vytvořit uživatelsky přívětivou a efektivní webovou aplikaci pro vyhledávání jízdních řádů, která bude sloužit dopravním podnikům a dopravcům. Aplikace bude poskytovat přesné informace o aktuálních jízdních řádech, čímž usnadní plánování cest a zlepší zážitek z veřejné dopravy.

## Popis 
Cílem projektu je sestrojit webovou aplikaci, která umožní zakázníkům ( primárně dopravní podniky, dopravci apod.) vyhledávat v jízdních řádech v uživatelsky přívětivém formátu ("něco jako Idos pro dopravce") . 

### Frontend 
- Responzivní aplikace umožňující intuitivní zadání příslušných filtrů 
- Napovídání existujících zastávek uživateli 
- Rozumné zobrazení výsledků vyhledávání

### Backend
V rámci backendu je nutné několik fází:
1. Import samotných dat z jízdních řádů
2. Transformace dat do rozumné datové struktury připravené pro vyhledávání
3. Vytvoření algoritmu vracející správná data pro dané nastavení filtrů

### Komunikace
Vytvoření REST Api umožňující komunikaci mezi frontendem a backendem. 

## Seznam požadavků
- Git 
- Intersystems Iris
- Pro jednodušší použití Iris bohužel Windows, ačkoliv lze zprovoznit i na Linuxu
- React
	- Node
	- npm
