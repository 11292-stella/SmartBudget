import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:portafoglio_smart/models/expense.dart';

// Formatter globale per convertire una DateTime in una stringa leggibile
// es: 12/28/2025, secondo la localizzazione del dispositivo.
final formatter = DateFormat.yMd();

// ===============================================================
// WIDGET NewExpense
// ===============================================================
//
// Questo widget rappresenta il FORM per creare una nuova spesa.
// È uno StatefulWidget perché:
// - deve gestire input dell’utente (titolo, importo, data, categoria)
// - deve aggiornare l’interfaccia quando questi valori cambiano.
//
// Inoltre riceve una funzione di callback (onAddExpense) dal widget genitore,
// che userà per "restituire" la nuova spesa creata al genitore.
// ===============================================================
class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  // Callback che il genitore (Expenses) passa a questo widget.
  // Quando l’utente preme "Save", viene chiamata questa funzione
  // e le si passa un oggetto Expense appena creato.
  final void Function(Expense expense) onAddExpense;

  @override
  State<StatefulWidget> createState() {
    // Collega il widget al suo stato (_NewExpenseState),
    // dove vive tutta la logica del form.
    return _NewExpenseState();
  }
}

// ===============================================================
// STATO DI NewExpense
// ===============================================================
//
// Qui vivono:
// - i TextEditingController per leggere i valori inseriti
// - la data selezionata
// - la categoria selezionata
// - i metodi per aprire il date picker, validare e inviare i dati
// ===============================================================
class _NewExpenseState extends State<NewExpense> {
  // CONTROLLER PER IL TITOLO
  // Tiene il testo inserito nel TextField del titolo.
  // Possiamo recuperare il valore con _titleController.text.
  final _titleController = TextEditingController();

  // CONTROLLER PER L'IMPORTO
  // Stesso funzionamento del titolo, ma per l’importo.
  final _amountController = TextEditingController();

  // VARIABILE PER LA DATA SELEZIONATA
  // Inizialmente null → nessuna data scelta.
  // Quando l’utente sceglie una data nel date picker, la salviamo qui.
  DateTime? _selectedDate;

  // VARIABILE PER LA CATEGORIA SELEZIONATA
  // Category è un enum definito nel modello Expense.
  // Qui partiamo con un valore di default: leisure.
  Category _selectedCategory = Category.leisure;

  // ===============================================================
  // METODO PER APRIRE IL DATE PICKER
  // ===============================================================
  //
  // async → la funzione è asincrona, perché deve "aspettare" la scelta
  // dell’utente nel date picker (operazione che avviene nel futuro).
  // ===============================================================
  void _presentDatePicker() async {
    final now = DateTime.now(); // data e ora attuale
    // Data minima selezionabile: un anno fa rispetto ad oggi.
    final firstDate = DateTime(now.year - 1, now.month, now.day);

    // Mostra il date picker di sistema e attende la scelta dell’utente.
    // showDatePicker restituisce:
    // - una DateTime se l’utente conferma una data
    // - null se l’utente annulla (es. preme indietro)
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now, // data pre-selezionata nel calendario
      firstDate: firstDate, // limite minimo
      lastDate: now, // limite massimo (oggi)
    );

    // Aggiorna lo stato con la data scelta.
    // Se pickedDate è null, _selectedDate diventerà null.
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  // ===============================================================
  // METODO CHE VALIDA I DATI E CREA LA NUOVA SPESA
  // ===============================================================
  //
  // Questo metodo viene chiamato quando l’utente preme "Save Expense".
  // Passi principali:
  // 1. Legge i valori dai controller e dalle variabili di stato
  // 2. Valida (titolo non vuoto, importo valido, data selezionata)
  // 3. Se non validi → mostra un AlertDialog di errore
  // 4. Se validi → crea un Expense e lo passa al genitore via callback
  // 5. Chiude il modal con Navigator.pop(context)
  // ===============================================================
  void _submitExpenseData() {
    // Prova a convertire il testo dell’importo in double.
    // Se la stringa non è un numero valido, tryParse ritorna null.
    final enteredAmount = double.tryParse(_amountController.text);

    // Controllo se l’importo è nullo o <= 0 (non accettiamo importi negativi o zero).
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;

    // IF DI VALIDAZIONE
    //
    // Controlla:
    // - se il titolo è vuoto (trim() rimuove spazi iniziali e finali)
    // - se l’importo non è valido
    // - se la data non è stata selezionata
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      // Se uno dei controlli fallisce, mostriamo un popup (AlertDialog)
      // per informare l’utente che ci sono errori nei campi.
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Invalid input'),
          content: const Text(
            'Please make sure all fields are filled correctly.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Chiude il dialog di errore.
                Navigator.pop(ctx);
              },
              child: Text('Okay'),
            ),
          ],
        ),
      );

      // Uscita anticipata dal metodo: non proseguiamo con la creazione della spesa.
      return;
    }

    // Se i dati sono validi, arriviamo qui.
    // Creiamo un nuovo oggetto Expense usando i valori validati.
    //
    // Nota: _selectedDate! → "!" dice a Dart:
    // "Sono sicuro che qui non è null, perché l’ho già controllato nell’if sopra."
    widget.onAddExpense(
      Expense(
        title: _titleController.text,
        amount: enteredAmount,
        date: _selectedDate!,
        category: _selectedCategory,
      ),
    );

    // Dopo aver notificato il genitore con la nuova spesa,
    // chiudiamo il modal bottom sheet e torniamo alla schermata precedente.
    Navigator.pop(context);
  }

  // ===============================================================
  // METODO DEL CICLO DI VITA: dispose()
  // ===============================================================
  //
  // Viene chiamato quando questo widget viene definitivamente tolto
  // dall'albero dei widget (es. quando chiudi il modal).
  //
  // Serve per liberare le risorse usate dai controller, evitando memory leak.
  // ===============================================================
  @override
  void dispose() {
    _titleController.dispose(); // libera la memoria del controller del titolo
    _amountController
        .dispose(); // libera la memoria del controller dell’importo
    super.dispose();
  }

  // ===============================================================
  // METODO build: COSTRUZIONE DELLA UI DEL FORM
  // ===============================================================
  @override
  Widget build(BuildContext context) {
    // ===============================================================
    // MediaQuery.of(context).viewInsets.bottom
    // ===============================================================
    //
    // Restituisce lo spazio occupato dalla tastiera quando è aperta.
    // Lo usiamo per aggiungere padding extra in basso, così il contenuto
    // del form non viene coperto dalla tastiera in modalità orizzontale.
    //
    // Risultato: quando la tastiera appare, il form "si solleva".
    // ===============================================================
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    return LayoutBuilder(
      // ===============================================================
      // LayoutBuilder
      // ===============================================================
      //
      // Permette di ottenere i vincoli del layout (es: larghezza disponibile).
      // Lo usiamo per creare un layout responsive:
      // - se width < 600 → layout mobile
      // - se width >= 600 → layout tablet/orizzontale
      // ===============================================================
      builder: (ctx, constraints) {
        final width = constraints.maxWidth;

        return SizedBox(
          height: double.infinity, // necessario per permettere lo scroll
          child: SingleChildScrollView(
            // ===============================================================
            // SingleChildScrollView
            // ===============================================================
            //
            // Serve per evitare overflow quando:
            // - la tastiera è aperta
            // - il dispositivo è in orizzontale
            // - il contenuto supera l’altezza dello schermo
            //
            // Permette al form di diventare scrollabile.
            // ===============================================================
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 48, 16, keyboardSpace + 16),

              child: Column(
                children: [
                  // ===============================================================
                  // TITOLO — layout responsive
                  // ===============================================================
                  //
                  // Se lo schermo è largo (>=600), mostriamo il titolo in una Row
                  // per sfruttare meglio lo spazio orizzontale.
                  //
                  // Altrimenti, usiamo il layout classico verticale.
                  // ===============================================================
                  if (width >= 600)
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _titleController,
                            maxLength: 50,
                            decoration: InputDecoration(label: Text('Title')),
                          ),
                        ),
                        const SizedBox(width: 24),
                      ],
                    )
                  else
                    TextField(
                      controller: _titleController,
                      maxLength: 50,
                      decoration: InputDecoration(label: Text('Title')),
                    ),

                  // ===============================================================
                  // RIGA IMPORTO + DATA
                  // ===============================================================
                  //
                  // Questa Row contiene due elementi principali:
                  //
                  // 1) Il campo di testo per inserire l'importo
                  // 2) Il selettore della data (testo + icona calendario)
                  //
                  // La Row li mette uno accanto all’altro orizzontalmente.
                  // Entrambi sono avvolti da Expanded per dividere equamente lo spazio
                  // e impedire overflow orizzontali.
                  //
                  Row(
                    children: [
                      // -----------------------------------------------------------
                      // CAMPO IMPORTO
                      // -----------------------------------------------------------
                      //
                      // Expanded → questo TextField occupa metà della riga.
                      // Senza Expanded, rischierebbe di comprimere o spingere fuori
                      // il selettore della data.
                      //
                      Expanded(
                        child: TextField(
                          controller:
                              _amountController, // legge il valore inserito
                          keyboardType:
                              TextInputType.number, // apre tastiera numerica
                          decoration: InputDecoration(
                            prefixText:
                                '\$ ', // simbolo valuta davanti al numero
                            label: Text('Amount'), // etichetta del campo
                          ),
                        ),
                      ),

                      const SizedBox(width: 16), // spazio tra importo e data
                      // -----------------------------------------------------------
                      // SELETTORE DATA (TESTO + ICONA)
                      // -----------------------------------------------------------
                      //
                      // Anche questo Expanded occupa metà della riga.
                      // Dentro c’è un’altra Row per allineare testo e icona a destra.
                      //
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,

                          // allinea tutto a destra per un layout più pulito
                          children: [
                            // Mostra la data selezionata oppure un placeholder
                            Text(
                              _selectedDate == null
                                  ? 'No date selected'
                                  : formatter.format(_selectedDate!),
                            ),

                            // Icona che apre il date picker
                            IconButton(
                              onPressed: _presentDatePicker,
                              icon: const Icon(Icons.calendar_month),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 16,
                  ), // spazio verticale prima della sezione successiva
                  // ===============================================================
                  // CATEGORIA + CANCEL + SAVE
                  // ===============================================================
                  //
                  // Questa Row contiene:
                  // - il menu a tendina per scegliere la categoria
                  // - un grande Spacer() che spinge i pulsanti a destra
                  // - il pulsante Cancel
                  // - il pulsante Save
                  //
                  // È la riga finale del form.
                  //
                  Row(
                    children: [
                      // -----------------------------------------------------------
                      // MENU A TENDINA PER LA CATEGORIA
                      // -----------------------------------------------------------
                      //
                      // DropdownButton mostra tutte le categorie definite nell’enum.
                      // Quando l’utente cambia categoria, aggiorniamo lo stato.
                      //
                      DropdownButton(
                        value: _selectedCategory,
                        items: Category.values
                            .map(
                              (category) => DropdownMenuItem(
                                value: category,
                                child: Text(category.name.toUpperCase()),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            if (value == null) return;
                            _selectedCategory = value;
                          });
                        },
                      ),

                      // -----------------------------------------------------------
                      // Spacer()
                      // -----------------------------------------------------------
                      //
                      // Occupa tutto lo spazio libero tra il dropdown e i pulsanti.
                      // Risultato: i pulsanti vengono spinti completamente a destra.
                      //
                      Spacer(),

                      // -----------------------------------------------------------
                      // PULSANTE CANCEL
                      // -----------------------------------------------------------
                      //
                      // Chiude il modal senza salvare nulla.
                      //
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel'),
                      ),

                      // -----------------------------------------------------------
                      // PULSANTE SAVE
                      // -----------------------------------------------------------
                      //
                      // Chiama _submitExpenseData():
                      // - valida i campi
                      // - crea l’Expense
                      // - chiude il modal
                      //
                      ElevatedButton(
                        onPressed: _submitExpenseData,
                        child: const Text('Save Expense'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
