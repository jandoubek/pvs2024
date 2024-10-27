# Vyhledavač jízdních řádů

## Vize
Uživatelsky přívětivá a intuitivní aplikace umožňuje dopravcům a organizátorům dopravy efektivnější plánování
a koncovým zákazníkům lepší zážitek z veřejné dopravy.

## Popis 
Cílem projektu je sestrojit webovou aplikaci, která umožní zakázníkům (primárně dopravní podniky, dopravci, ale i koncoví zákazníci) vyhledávat v jízdních řádech v uživatelsky přívětivém formátu. Cílem je pokrýt 
základní funkcionality a do budoucna implementovat možná rozšíření.

## Rozpis práce

### Frontend
Miroslav Baša

- Webová aplikace umožňující intuitivní zadání příslušných filtrů 
- Napovídání uživateli během zadávání filtrů
- Přehledné zobrazení výsledků vyhledávání

### REST Api
Martin Jochec 

- Vytvoření webové aplikace a REST Api v Intersystems Iris

### Backend
Jan Miesbauer 

- Import dat z jízdních řádů a některých API funkcí z firemního serveru do našeho lokálního prostředí
- Převod dat do vhodné datové struktury umožňující efektivní vyhledávání
- Implementace vhodného algoritmu, např. [Round-Based Public Transport Routing](https://www.microsoft.com/en-us/research/wp-content/uploads/2012/01/raptor_alenex.pdf) 

## Seznam požadavků

### Softwarové požadavky
- Git 
- Intersystems Iris
- Node.js
- Vite

### Funkční požadavky
- Pokrýt funkcionalitu aplikací jako [idos](https://idos.cz) nebo [bileto](https://bileto.cz)
- Umět vyhledat spoje mezi dvěma městy pro zvolené hodnoty filtrů (např. maximální počet přestupů, typ dopravy atd.)
- Přidat featury navíc
	- Pokročilé pěší přechody mezi spojema
	- Moderní mobilní aplikace

## User stories

- Jako cestující chci jednoduše najít nejrychlejší spojení mezi dvěma městy.
- Jako pravidelný uživatel veřejné dopravy bych chtěl mít možnost uložit si své oblíbené spoje.
- Jako organizátor dopravy chci mít přehlednou vizualizaci jízdních řádů, která by nám pomohla k lepšímu plánování.
- Chci mít možnost vyhledávat spoje s pěšíma přechodama mezi jednotlivýma zastávkama.
