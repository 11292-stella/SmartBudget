import 'package:flutter/material.dart';
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
    return Padding(
      // Padding aggiunge spazio interno attorno al contenuto.
      // Qui: left = 16, top = 48, right = 16, bottom = 16.
      padding: EdgeInsets.fromLTRB(16, 48, 16, 16),

      child: Column(
        children: [
          // -----------------------------------------------------------
          // CAMPO DI TESTO PER IL TITOLO
          // -----------------------------------------------------------
          TextField(
            controller: _titleController, // collega il controller al TextField
            maxLength: 50, // massimo 50 caratteri
            decoration: InputDecoration(
              label: Text('Title'), // testo visibile sopra/nel campo
            ),
          ),

          // -----------------------------------------------------------
          // RIGA CHE CONTIENE IMPORTO + DATA
          // -----------------------------------------------------------
          Row(
            children: [
              // CAMPO IMPORTO
              //
              // Expanded → fa sì che questo TextField occupi tutto lo spazio
              // orizzontale disponibile nella riga, prima dello SizedBox e dell’altro Expanded.
              Expanded(
                child: TextField(
                  controller: _amountController,
                  keyboardType:
                      TextInputType.number, // tastiera numerica sul telefono
                  decoration: InputDecoration(
                    prefixText:
                        '\$ ', // testo fisso prima del valore (es: simbolo valuta)
                    label: Text('Amount'),
                  ),
                ),
              ),

              const SizedBox(
                width: 16,
              ), // spazio orizzontale tra il campo importo e la parte data
              // SELETTORE DATA (testo + icona calendario)
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end, // allinea a destra
                  children: [
                    // Testo che mostra la data selezionata,
                    // oppure "No date selected" se _selectedDate è null.
                    Text(
                      _selectedDate == null
                          ? 'No date selected'
                          : formatter.format(_selectedDate!),
                    ),

                    // Icona che apre il date picker quando viene premuta.
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
          ), // spazio verticale tra la riga precedente e la successiva
          // -----------------------------------------------------------
          // RIGA CON DROPDOWN CATEGORIA + PULSANTI CANCEL E SAVE
          // -----------------------------------------------------------
          Row(
            children: [
              // MENU A TENDINA PER LA CATEGORIA
              //
              // DropdownButton mostra un elenco di valori tra cui scegliere.
              // Qui usiamo Category.values (tutte le voci dell’enum Category).
              DropdownButton(
                value: _selectedCategory, // valore attualmente selezionato
                items: Category.values
                    .map(
                      (category) => DropdownMenuItem(
                        value: category, // valore che verrà passato a onChanged
                        child: Text(category.name.toUpperCase()),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  // Quando l’utente seleziona una nuova categoria,
                  // aggiorniamo lo stato.
                  setState(() {
                    if (value == null) return;
                    _selectedCategory = value;
                  });
                },
              ),

              Spacer(), // spinge i pulsanti a destra (occupando lo spazio vuoto)
              // PULSANTE "Cancel" → chiude il modal senza salvare nulla.
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // chiude il bottom sheet
                },
                child: Text('Cancel'),
              ),

              // PULSANTE "Save Expense" → tenta di salvare la spesa.
              //
              // Chiama _submitExpenseData(), che:
              // - valida i campi
              // - se validi → crea l’Expense, chiama onAddExpense, chiude il modal
              // - se non validi → mostra un AlertDialog
              ElevatedButton(
                onPressed: _submitExpenseData,
                child: const Text('Save Expense'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
