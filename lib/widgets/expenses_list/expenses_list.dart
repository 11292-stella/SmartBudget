import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:portafoglio_smart/models/expense.dart';
import 'package:portafoglio_smart/widgets/expenses_list/expense_item.dart';

// ===============================================================
// WIDGET ExpensesList
// ===============================================================
//
// Questo widget mostra una LISTA di oggetti Expense.
// È uno StatelessWidget perché:
// - non gestisce stato interno
// - riceve la lista delle spese dal widget genitore
// - riceve una funzione per rimuovere una spesa
//
// La logica (aggiunta/rimozione) è gestita dal widget genitore (Expenses).
// Questo widget si limita a MOSTRARE la lista.
// ===============================================================
class ExpensesList extends StatelessWidget {
  const ExpensesList({
    super.key,
    required this.expenses,
    required this.onRemoveExpense,
  });

  // Callback che il genitore passa a questo widget.
  // Quando una spesa viene eliminata (swipe), chiamiamo questa funzione
  // e passiamo l’Expense da rimuovere.
  final void Function(Expense expense) onRemoveExpense;

  // Lista delle spese da mostrare.
  // Viene passata dal widget genitore (Expenses).
  final List<Expense> expenses;

  @override
  Widget build(BuildContext context) {
    // ===============================================================
    // ListView.builder
    // ===============================================================
    //
    // È il modo più efficiente per creare liste dinamiche:
    // - crea solo gli elementi visibili sullo schermo
    // - ricicla gli elementi quando scorri
    // - perfetto per liste lunghe o variabili
    //
    // itemCount → quanti elementi deve creare
    // itemBuilder → funzione che costruisce ogni singolo elemento
    // ===============================================================
    return ListView.builder(
      itemCount: expenses.length,

      // itemBuilder viene chiamato una volta per ogni elemento della lista.
      // index → posizione dell’elemento (0, 1, 2, ...)
      itemBuilder: (ctx, index) => Dismissible(
        // ===============================================================
        // Dismissible
        // ===============================================================
        //
        // Widget che permette di eliminare un elemento con uno swipe.
        // Funziona così:
        // - l’utente trascina l’elemento verso destra o sinistra
        // - appare un background colorato (rosso)
        // - quando lo swipe supera una certa soglia → onDismissed viene chiamato
        //
        // Serve SEMPRE una key unica per identificare l’elemento.
        // ===============================================================

        // Sfondo che appare mentre l’utente trascina l’elemento per eliminarlo.
        background: Container(
          // Colore rosso preso dal tema dell’app (colorScheme.error)
          color: Theme.of(context).colorScheme.error.withOpacity(0.75),

          // Margine orizzontale preso dinamicamente dal tema delle Card.
          // Così lo sfondo si allinea perfettamente con le Card della lista.
          margin: EdgeInsets.symmetric(
            horizontal: Theme.of(context).cardTheme.margin!.horizontal,
          ),
        ),

        // KEY UNICA
        //
        // Necessaria per far capire a Flutter quale elemento è stato eliminato.
        // Senza una key unica, Dismissible non può funzionare correttamente.
        key: ValueKey(expenses[index]),

        // CALLBACK quando l’elemento viene eliminato con lo swipe.
        //
        // direction → direzione dello swipe (non la usiamo qui).
        // Chiamiamo la funzione passata dal genitore per rimuovere la spesa.
        onDismissed: (direction) {
          onRemoveExpense(expenses[index]);
        },

        // child → il contenuto visibile della riga.
        // Qui usiamo un widget separato ExpenseItem per mostrare la spesa.
        child: ExpenseItem(expenses[index]),
      ),
    );
  }
}
