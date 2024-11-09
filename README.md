# pvs2024

# Popis

## React

### 1. Instalace Node.js a npm

1. Stáhněte Node.js z : https://nodejs.org/ nebo např. pomocí správce balíčků https://chocolatey.org/
2. Nainstaluje a ověřte, jestli se programy přidaly do PATH
   ```
   node --version
   npm --version
   ```

### 2. Vytvoření Vite React projektu

1. React project můžu připravit já a hodit na github - vy si ho pouze vezmete
2. Pokud ho chcete vytvořit sami - otevřete příkazový řádek (doporučuji VSCode - pojede tam i Iris) a přejděte do adresáře, kde chcete vytvořit projekt.
	1. Spusťte následující příkaz pro vytvoření nového Vite projektu:
   ```
   npm create vite@latest jmeno-projektu -- --template react
   ```
   2. Otevře se interaktivní okno, zvolte vytvoření React projektu a JavaScript jako jazyk
	3. Přejděte do nově vytvořeného adresáře projektu:
   ```
   cd jmeno-projektu
   ```

### 3. Instalace závislostí

1. Nainstalujte základní závislosti projektu:
   ```
   npm install
   ```

### 4. Instalace MUI a Axios
Budeme potřebovat knihovnu MUI pro React komponenty, které můžeme využit a Axios pro volání HTTP requestů:

1. MUI a související balíčky:
   ```
   npm install @mui/material @emotion/react @emotion/styled @mui/icons-material
   ```
2. Axios:
   ```
   npm install axios
   ```

### 5. Spuštění projektu

1. Spusťte vývojový server:
   ```
   npm run dev
   ```
2. V prohlížeči přejdětě na port, který je vidět v konzoli (typicky http://localhost:5173).

### 6. Krátký popis projektu
Nejdůležitější složka je `src`, zejména soubor `App.jsx` kde je entry point pro napsaný kód, který je aktuálně vidět v okně prohlížeče.

## Intersystems Iris
Intersystems Iris je DBMS s vlastnín programovacím jazykem Objectscript umožňující manipulaci s daty.

### Instalace Iris

1. Vytvořit Intersystems účet na https://login.intersystems.com/login/SSO.UI.Register.cls (personal use only, vyplnit pouze povinné položky)
2. Přihlásit se k Intersystems účtu a stáhnout Intersystems Iris [https://evaluation.intersystems.com/Eval/index.html](https://evaluation.intersystems.com/Eval/index.html) 
	1. Download Community Edition
	2. Zvolit Intersystems Iris Community, instalaci pro Windows, a poslední verzi
3. Nainstalovat Iris - viz. https://community.intersystems.com/post/how-download-and-install-intersystems-iris od kroku 3
		- při vytváření jména a hesla zvolit default System username!!
		- username a password pro jednoduchost zvolit např. jako test, test
4. Ve VSCode stáhnout extensions pro práci s Iris:
- Intersystems Language Server
- Intersystems Objectscript
- Intersystems Server Manager
5. Vytvořit lokálním server ve VSCode
- Ctrl+Shift+P, napsat Intersystems, nabídne Intersystems Server Manager: Add server
- Vyjede lišta nahoře v okně
- Jméno serveru **iris**, odkliknout enterem
- Popis odkliknout enterem
- host - localhost
- port - 52773
- username - zadané během instalace, tj. např. test
- http
- K serveru se pak budete přihlašovat z intersystems ikonky, která by se měla objevit v liště vlevo dole po nainstalování extension, tam si můžete vybrat server, a přihlásit se k němu pomocí zadaných hodnot. Pokud vše proběhne správně, uvidíte pod serverem složku Namespaces
6. Přihlásit se do Managment Portalu http://localhost:52773/csp/sys/UtilHome.csp, jméno a heslo zadané během instalace
7. Pro zprovoznění Irisu z Githubu přeskočím na sekci **Iris z Githubu**
8. Po úspěšném přihlášení k lokální instanci, rozkliknout ve VSCode název serveru -> Namespaces a ikonkou tužky (Edit Code in Namespace) otevřít Namespace USER.
9. Kliknout pravým tlačítkem na [nazev serveru]:USER, přidat složku např. Rest
10. Ve složce Rest vytvořit soubor např. RestApi.cls
11. V souboru RestApi.cls vytvořit testovací metodu: 
```
Class Rest.RestApi Extends %RegisteredObject
{

ClassMethod Test()
{
	w  "Pepa"
}

}
```
11. Spustit aplikaci terminal Iris a přihlásit se vašimi přihlašovacími údajemi, tj. např. test, test, pokud budete přihlášeni, příkazová řádka bude začínat na USER>
12. V terminálu zavolejte metodu pomocí Do ##class(Rest.RestApi).Test(), pokud se vypíše Pepa, je vše připravené, pokud ne, bude potřeba opravit
### Pro Martina: 
 - Krátký Iris tutoriál, který ukazuje práci s Managment Portalem i vytvoření jednoduchého Rest Api: 
https://play.instruqt.com/embed/intersystems/tracks/full-stack-tutorial?token=em_eozcmi6tqablziyt
- Tutoriál/dokumentace jazyka, který Iris používá (Objectscript) https://docs-intersystems-com.translate.goog/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=TOS_Part01&_x_tr_sl=en&_x_tr_tl=cs&_x_tr_hl=cs&_x_tr_pto=sc
- Dokumentace k Restu v Iris https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=GREST_intro
- Případně Chat udělá základní kostru API
### Pro Mirka: 
- Až bude existovat testovací GET funkce, můžeš zkusit zavolat pomocí Axios, zaklad url by měl být: `const  API_BASE_URL  =  'http://localhost:52773/csp/user';`

### Iris z Githubu
https://docs.intersystems.com/components/csp/docbook/DocBook.UI.Page.cls?KEY=GVSCO_clientflow
1. Sync s Githubem -> mam v repu složku Backend
2. Otevřu složku ve VSCode
3. Kliknout na Intersystems extension v levé liště
4. Připojím se k vytvořenému serveru `iris`
5. V prostřední sekci Explorer a zkusím přidat server Iris  a Namespace USER (občas může blbnout a je nutné zkusit vícekrát)
6. Rozkliknu Namespaces -> User -> Edit Code in Namespace (ikona tužky)
7. Vrátím se zpátky do souborů a kliknu pravým tlačítkem na
	- src/ALVA
	- src/User
a dát Import and Compile. Tím se soubory naimportí do lokálního Iris serveru. Během kompilace budou nějaké chyby, ale pro naše potřeby by to teď nemělo vadit. Pokud to proběhne a budete mít naimportěná data (viz. další sekce), měly by se vám v Reactí aplikaci načíst zastávky.

### Import dat z jízdních řádů
1. Stahnout vyexportovana (.gof soubor)
2. Otevřít Managment portal, viz. výše
3. V Managment portal: System Explorer -> Globals -> Go
4. **Nachazet se v namespace USER** (možnost přepnout v liště vlevo)
5. V horní liště kliknout na `import` vybrat .gof soubor a proklikat naimportění, měly by se objevit globaly `JRL`, `JRZ`, `JRLAPL`

---

## Zadani do hodiny 29.10.2024
### Základní layout
- Vytvoření základního layoutu s dvěma vyhledávacími políčky a tlačítkem.
- Ověření přístupu k datům v databázi a jejich následné zpracování.
- Návrh potřebných HTTP metod a interakcí, včetně definice endpointů.

## Zadani do hodiny 15.10.2024

### Upravovani stejnych radku

- Nasledujici tri bloky odpovidaji vasim sbeznym informacim, ktere jsem ziskal rychlym google searchem s vasim jmenem. Takze jsem cerpal z informaci o vasich jmenovcich.
- Uvedte informace na pravou miru a pridejte jednu informaci ke kazdemu z vasich kolegu (Pravdivou prosim).

### Basa Miroslav

- 1) Milovník asijské kuchyně
- 2) Hráč na kytaru
- 3) Student FJFI, napsal Bc. práci na téma 'Procedurální generování prostředí'
- 4) Má mnoho mazlíčků

### Jochec Martin

- 1) Zajímá se o Elektroniku, Auta a Vesmír
- 2) Neustále filosofuje
- 3) Student FJFI, napsal Bc. práci na téma 'Adaptace autonomního agenta na chování uživatele'
- 4) Vášnivý hráč her
     
### Miesbauer Jan

- 1) Student FJFI, napsal Bc. Práci na téma 'Hledání parametrů diferenciálních rovnic'
- 2) Programátor ve společnosti M-line
- 3) Žije v Prachaticích - Nebahovy
- 4) Studuje Matematické Inženýrství

## Zadani do hodiny 8.10.2024 

- Nahrajte do github repositare textovy .md soubor s popisem Vaseho projektu.
- V textu by mela byt jasne stanovena aktualni Vize - jak jsme si ji na hodine definovali.
- Na konci uvedte seznam Pozadavku/Requirements.
