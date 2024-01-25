# BokTips

## Beskrivning

BokTips kommer kunna recensera böckerna, lägga till nya böcker (som admin), veta vilken genre en bok tillhör samt se beskrivningen av boken. Admin kommer även kunna ta bort kommentarer och hela böcker. Som användare kan man även ha en egen profil där man kan se böcker man gillar eller vill läsa. Man kommer även kunna söka efter olika titlar.


## Användare och roller

Här skriver du ner vilka typer av användare (som i inloggade användare) det finns, och vad de har för rättigheter, det vill säga, vad de kan göra (tänk admin, standard användare, etc).

### Exempel (ta bort)

Gästanvändare - oinloggad
. Kan söka efter titlar och se genomsnittligt betyg. Kan inte se eller skriva kommentarer eller sätta egna betyg.

Standardanvändare - inloggad. Kan allt gästanvändare kan, men kan även lägga in nya böcker och skriva kommentarer etc. Kan ta bort sitt eget konto och information kopplat till det.

Adminanvändare - kan ta bort/editera böcker, kommentarer och användare.

## ER-Diagram

![Er-Diagram](./er_diagram.png?raw=true "ER-diagram")

## Gränssnittsskisser

**Login**

![Er-Diagram](./ui_login.png?raw=true "ER-diagram")

**Visa bok**

![Er-Diagram](./ui_show_book.png?raw=true "ER-diagram")
