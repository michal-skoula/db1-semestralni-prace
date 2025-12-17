# Projekt DB1: Management systém pro zoologickou zahradu

Testováno na Databázovém systému postgres verze 18, snažil jsem se ovšem o co nejuniverzálnější SQL kód a kde to dávalo smysl se vyhnout se "SŘBD specifickým vychytávkám"

použití domén pro dodržení DRY

pro zjednodušení a vyzkoušení si pokročilejších integritních omezení jsou jednotky léků a krmiva prostě "ks". Zároveň není implementovaný "ledger" stavů skladu s jídlem a léky, tzn. jsou zde dva zdroje pravdy a musí se vždy odečíst manuálně při použití.

Oproti odevzdanému schématu jsem našel místa pro zlepšení a změnil názvy do angličtiny pro lepší čitelnost, posílám tedy i upravené schéma v DBDiagramu


#### SQL skripty, které ve zvoleném SŘBD:
- založí **fyzický datový model**,  
- naplní datový model **testovacími / ukázkovými daty**,  
- založí **databázové pohledy**,  
- reprezentují **alespoň dva testovací scénáře**  
  (každý scénář v samostatném skriptu),  
- zruší **fyzický datový model včetně databázových pohledů**.

#### Dokumentaci
- ve formátu **PDF**.

## Použité zdroje
- Dokumentace postgresql
- DBDiagram
- Regex101
- github mnestorov/regex-patterns
- Stack Overflow
- GPT 5.2 a Claude Sonnet 4.5

## Použití AI
AI nástroje byly v projektu využity jako podpůrný prostředek, zejména pro rutinní a technické činnosti.

> **Klíčová návrhová rozhodnutí byla provedena samostatně.**

### AI bylo použito pro:
- generování a úpravu DBML schématu na základě existujícího SQL návrhu
- návrh indexů pro cizí klíče
- vytvoření ukázkových seed dat
- vysvětlení vybraných databázových konceptů a syntaxe
- debugging a dodatečnou kontrolu řešení
- jazykovou a syntaktickou korekturu tohoto README

### AI nebylo použito pro:
- návrh databázového modelu a jeho vztahů
- rozhodování o integritních omezeních
- přímé generování SQL skriptů bez porozumění (tzv. „vibe coding“)

