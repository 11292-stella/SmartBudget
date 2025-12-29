import 'package:flutter/material.dart';
import 'package:portafoglio_smart/models/expense.dart';

// ===============================================================
// WIDGET ExpenseItem
// ===============================================================
//
// Questo widget rappresenta UNA SINGOLA spesa nella lista.
// Mostra:
// - titolo
// - importo
// - icona della categoria
// - data formattata
//
// È Stateless perché:
// - non modifica dati
// - riceve un oggetto Expense già pronto
// - si limita a mostrarlo
// ===============================================================
class ExpenseItem extends StatelessWidget {
  const ExpenseItem(this.expense, {super.key});

  // L’oggetto Expense da mostrare.
  // Contiene: title, amount, date, category, id, formattedDate
  final Expense expense;

  @override
  Widget build(BuildContext context) {
    return Card(
      // Card = contenitore Material con bordo arrotondato e ombra leggera.
      // Perfetto per rappresentare un elemento della lista.
      child: Padding(
        // Padding interno della Card.
        padding: const EdgeInsets.symmetric(
          horizontal: 20, // spazio a sinistra e destra
          vertical: 16, // spazio sopra e sotto
        ),

        // La Card contiene una colonna verticale:
        // 1. Titolo
        // 2. Riga con importo + icona categoria + data
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          // crossAxisAlignment.start → allinea tutto a sinistra
          children: [
            // ===============================================================
            // TITOLO DELLA SPESA
            // ===============================================================
            //
            // Usa lo stile definito nel tema:
            // Theme.of(context).textTheme.titleLarge
            // Questo permette al titolo di adattarsi automaticamente
            // al tema chiaro/scuro e ai colori scelti nel main.dart.
            Text(expense.title, style: Theme.of(context).textTheme.titleLarge),

            const SizedBox(height: 4), // piccolo spazio verticale
            // ===============================================================
            // RIGA CON IMPORTO + ICONA CATEGORIA + DATA
            // ===============================================================
            Row(
              children: [
                // IMPORTO
                //
                // toStringAsFixed(2) → mostra sempre 2 decimali
                // es: 15 → 15.00
                // es: 15.9 → 15.90
                Text('\$${expense.amount.toStringAsFixed(2)}'),

                // Spacer → spinge gli elementi successivi completamente a destra
                const Spacer(),

                // ===============================================================
                // SOTTO-RIGA CON ICONA CATEGORIA + DATA
                // ===============================================================
                Row(
                  children: [
                    // ICONA DELLA CATEGORIA
                    //
                    // categoryIcons è una mappa definita nel modello Expense:
                    // { Category.food: Icons.fastfood, Category.work: Icons.work, ... }
                    //
                    // expense.category → categoria della spesa
                    // categoryIcons[...] → icona associata
                    Icon(categoryIcons[expense.category]),

                    const SizedBox(width: 8), // spazio tra icona e data
                    // DATA FORMATTATA
                    //
                    // formattedDate è una getter definita nel modello Expense
                    // che usa DateFormat per convertire la data in stringa leggibile.
                    Text(expense.formattedDate),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
