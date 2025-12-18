## Popis schématu

Tato sekce dokumentace popisuje jednotlivé entity (tabulky) databázového modelu pro systém správy zoologické zahrady.

Pro zjednodušení a výukové účely jsem změnil entity `medications` a `feed_items` z číslo + jednotka na jednodušší univerzální jednotku ks. Zároveň jsem zjednodušil sledování stavu skladových zásob na systém, kde se musí sklad manuálně aktualizovat namísto "ledger" logiky jako známe např. z bankovních systémů, jelikož bych přesáhl doporučený limit 10 tabulek a přidal vyšší míru komplexity.

Oproti původnímu schématu jsem pro lepší čitelnost kódu a vyvarování se "čechoanglickým výrazům" napsal schéma v angličtině.

### caretakers (Ošetřovatelé)

Tabulka uchovává informace o zaměstnancích zoo, kteří se starají o zvířata. Každý ošetřovatel má evidováno jméno, příjmení, e-mail a telefonní číslo. E-mail i telefon musí být unikátní a jsou validovány pomocí vlastních domén - e-mail musí obsahovat znak @ a telefon musí odpovídat českému formátu. Volitelně lze ke každému ošetřovateli přidat poznámky, například o jeho specializaci či kvalifikaci.

### habitats (Výběhy)

Tabulka reprezentuje jednotlivé výběhy či prostory, ve kterých jsou zvířata umístěna. Každý výběh má unikátní název a volitelný popis. Výběhy slouží k logickému seskupení zvířat podle jejich umístění v zoo.

### animals (Zvířata)

Hlavní tabulka obsahující informace o jednotlivých zvířatech v zoo. U každého zvířete je evidováno jeho jméno, druh a datum narození. Každé zvíře musí být přiřazeno k jednomu výběhu prostřednictvím cizího klíče na tabulku habitats.

### feed_items (Krmivo)

Tabulka eviduje druhy krmiva dostupné v zoo. Kromě unikátního názvu a volitelného popisu sleduje i aktuální množství na skladě. Množství je vyjádřeno v kusech a nesmí klesnout pod nulu.

### medications (Léky)

Tabulka eviduje léky a léčiva používaná pro ošetření zvířat. Každý lék má unikátní název, povinné pokyny pro podání a volitelný popis. Podobně jako u krmiva se sleduje dostupné množství na skladě v kusech.

### feeding_events (Události krmení)

Tabulka zaznamenává jednotlivé události krmení zvířat. Každý záznam propojuje konkrétní zvíře, ošetřovatele a druh krmiva pomocí cizích klíčů. Dále obsahuje časové razítko krmení, spotřebované množství krmiva a volitelné poznámky. Množství použitého krmiva musí být vždy kladné.

### treatments (Ošetření)

Tabulka zaznamenává lékařská ošetření a podání léků zvířatům. Struktura je obdobná jako u událostí krmení - každý záznam propojuje zvíře, ošetřovatele a použitý lék. Obsahuje časové razítko podání, spotřebované množství léku a volitelné poznámky k průběhu ošetření.

### animal_caretaker (Přiřazení ošetřovatelů ke zvířatům)

Vazební tabulka realizující vztah M:N mezi zvířaty a ošetřovateli. Určuje, kteří ošetřovatelé jsou zodpovědní za která zvířata. Primární klíč je složený z cizích klíčů na obě propojované tabulky. Navíc se u každého přiřazení eviduje datum a čas, kdy bylo vytvořeno.
