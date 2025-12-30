//Albero dei Widget (quello che scrivi tu)
//Es:

/*Column(
  children: [
    Text(),
    Row(),
    Icon(),
  ],
)
 */
// È solo una descrizione dell’interfaccia, NON è ciò che viene realmente mostrato sullo schermo.

// L’albero degli Elementi (creato da Flutter in memoria)
//Flutter prende i widget e crea Element, oggetti speciali che:
//- rappresentano i widget in memoria
//- servono per capire cosa deve essere aggiornato
//- vengono riutilizzati quando possibile (per performance)


/*Il metodo build viene chiamato spesso, ma Flutter NON ricrea tutto da zero.
Riutilizza gli Element già esistenti quando può. */

//Esempio:
//- chiami setState()
//- Flutter richiama build()
//- confronta il nuovo albero dei widget con quello precedente
//- aggiorna solo gli Element che sono cambiati

//L’albero di Rendering (quello che disegna davvero sullo schermo)

//È l’albero che contiene i RenderObject, cioè:
//- Dimensioni, posizione, colori, layout, pittura sullo schermo
//È la parte più “pesante” da aggiornare.
//Flutter cerca di toccare il meno possibile l’albero di rendering, perché è costoso.

//Come Flutter aggiorna la UI
//- Tu chiami setState()
//- Flutter richiama build()
//- Flutter confronta il nuovo albero dei widget con quello vecchio
//- Flutter aggiorna l’albero degli Element:
//- riutilizza quelli uguali
//- crea nuovi Element se ci sono nuovi widget
//- rimuove Element se widget sono spariti
//SOLO se necessario, aggiorna l’albero di rendering
//Ridisegna solo le parti cambiate dello schermo

//ANIMAZIONE ASCII — Il viaggio di setState() dentro Flutter
//prendendo in esempio una piccola app con due bottoni yes e no:

// 1. Premi un pulsante → chiami setState()
[Utente preme YES]
        │
        ▼
┌──────────────────────────┐
│     setState() chiamato   │
└──────────────────────────┘
//Flutter segna il widget come “sporco” (dirty) → deve essere ricostruito.

// 2. Flutter richiama build()
setState()
    │
    ▼
┌──────────────────────────┐
│   Flutter richiama build()│
└──────────────────────────┘
        │
        ▼
[Nuovo albero dei Widget creato]
//Tu ricrei TUTTI i widget nella funzione build.
//Ma sono solo descrizioni, non oggetti reali sullo schermo.

//3. Flutter confronta il nuovo albero dei Widget con quello vecchio
[Widget Tree nuovo]
        │
        ▼
┌──────────────────────────────┐
│ Confronto con Widget Tree vecchio │
└──────────────────────────────┘
        │
        ├── Uguale? → riusa Element
        └── Diverso? → crea nuovo Element
//Qui Flutter decide cosa deve essere aggiornato.

//4. Flutter aggiorna l’albero degli Element
[Element Tree]
        │
        ▼
┌──────────────────────────────┐
│  Riutilizza Element esistenti │
│  Crea nuovi Element se servono│
└──────────────────────────────┘
//Esempio:
// Se premi NO → nessun nuovo widget → nessun nuovo Element
// Se premi YES → appare un nuovo Text → Flutter crea un nuovo Element

//5. Flutter aggiorna SOLO le parti necessarie dell’albero di Rendering
[Render Tree]
        │
        ▼
┌──────────────────────────────┐
│ Aggiorna SOLO i RenderObject │
│ che corrispondono ai nuovi   │
│ Element o a quelli cambiati  │
└──────────────────────────────┘
//Non ridisegna tutto lo schermo.
//Ridisegna solo la parte che è cambiata.

//6. Risultato finale: UI aggiornata
[UI aggiornata]
        ▲
        │
┌──────────────────────────┐
│ Solo la parte cambiata   │
│ è stata ridisegnata       │
└──────────────────────────┘

//Flusso completo
Utente preme pulsante
        │
        ▼
┌──────────────┐
│  setState()   │
└──────────────┘
        │
        ▼
┌──────────────┐
│   build()     │  ← ricrea i widget (descrizioni)
└──────────────┘
        │
        ▼
┌──────────────────────────────┐
│ Confronto Widget Tree nuovo  │
│ con Widget Tree precedente   │
└──────────────────────────────┘
        │
        ▼
┌──────────────────────────────┐
│ Element Tree aggiornato       │
│ (riuso + nuovi Element)       │
└──────────────────────────────┘
        │
        ▼
┌──────────────────────────────┐
│ Render Tree aggiornato solo   │
│ nelle parti necessarie         │
└──────────────────────────────┘
        │
        ▼
UI aggiornata sullo schermo




