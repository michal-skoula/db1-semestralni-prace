## Závěr

Semestrální práce realizovala relační databázi pro správu zoologické zahrady s osmi tabulkami v 3. normální formě. Systém pokrývá evidenci zvířat, ošetřovatelů, výběhů, krmiva, léků a zaznamenává události krmení i veterinárních ošetření.

Během návrhu byly provedeny zjednodušení pro udržení rozsahu projektu. Jednotky krmiva a léků jsou evidovány pouze v kusech, což umožnilo vyzkoušet pokročilejší integritní omezení bez zbytečné komplexity. Skladové zásoby nejsou vedeny formou transakčního deníku - při každém použití je nutné manuálně aktualizovat dostupné množství.

Oproti původnímu návrhu byly názvy entit a atributů změněny do angličtiny pro lepší čitelnost kódu. Finální verze se zaměřuje na každodenní provoz zoo - správu zvířat, jejich krmení a zdravotní péči.
