import 'package:flutter/material.dart';
import 'package:portafoglio_smart/chart/chart_bar.dart';
import 'package:portafoglio_smart/models/expense.dart';

// ===============================================================
// WIDGET Chart
// ===============================================================
//
// Questo widget mostra il GRAFICO A BARRE delle spese.
// Ogni barra rappresenta una categoria (food, leisure, travel, work).
// L’altezza di ogni barra è proporzionale alla somma delle spese
// di quella categoria rispetto alla categoria con la spesa maggiore.
//
// È Stateless perché:
// - riceve la lista delle spese già pronta
// - calcola i valori in getter
// - non modifica nulla
// ===============================================================
class Chart extends StatelessWidget {
  const Chart({super.key, required this.expenses});

  // Lista completa delle spese passata dal widget genitore (Expenses).
  final List<Expense> expenses;

  // ===============================================================
  // GETTER buckets
  // ===============================================================
  //
  // Crea 4 "bucket" (contenitori), uno per ogni categoria.
  // Ogni bucket contiene SOLO le spese della sua categoria.
  //
  // ExpenseBucket.forCategory filtra automaticamente le spese.
  // ===============================================================
  List<ExpenseBucket> get buckets {
    return [
      ExpenseBucket.forCategory(expenses, Category.food),
      ExpenseBucket.forCategory(expenses, Category.leisure),
      ExpenseBucket.forCategory(expenses, Category.travel),
      ExpenseBucket.forCategory(expenses, Category.work),
    ];
  }

  // ===============================================================
  // GETTER maxTotalExpense
  // ===============================================================
  //
  // Serve per trovare la categoria con la spesa totale più alta.
  // Questo valore è usato per calcolare l’altezza relativa delle barre.
  //
  // Esempio:
  // food = 100€
  // travel = 50€
  // work = 200€  ← max
  //
  // Le barre saranno:
  // food = 100/200 = 0.5
  // travel = 50/200 = 0.25
  // work = 200/200 = 1.0
  // ===============================================================
  double get maxTotalExpense {
    double maxTotalExpense = 0;

    // Cicla tutti i bucket e trova il totale più alto.
    for (final bucket in buckets) {
      if (bucket.totalExpenses > maxTotalExpense) {
        maxTotalExpense = bucket.totalExpenses;
      }
    }

    return maxTotalExpense;
  }

  @override
  Widget build(BuildContext context) {
    // ===============================================================
    // RILEVAZIONE DARK MODE
    // ===============================================================
    //
    // Serve per cambiare il colore delle icone sotto il grafico.
    // ===============================================================
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Container(
      // Margine esterno del grafico
      margin: const EdgeInsets.all(16),

      // Padding interno del grafico
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),

      // Larghezza massima possibile
      width: double.infinity,

      // Altezza fissa del grafico
      height: 180,

      // ===============================================================
      // DECORAZIONE DEL CONTENITORE
      // ===============================================================
      //
      // - Bordo arrotondato
      // - Sfondo con gradiente verticale
      //
      // Il gradiente va dal basso (più colorato) verso l’alto (trasparente),
      // creando un effetto "sfumatura" dietro le barre.
      // ===============================================================
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),

        gradient: LinearGradient(
          colors: [
            // Colore principale del tema con opacità 30%
            Theme.of(context).colorScheme.primary.withOpacity(0.3),

            // Stesso colore ma completamente trasparente
            Theme.of(context).colorScheme.primary.withOpacity(0.0),
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),

      // ===============================================================
      // CONTENUTO DEL GRAFICO
      // ===============================================================
      child: Column(
        children: [
          // -----------------------------------------------------------
          // SEZIONE SUPERIORE: LE BARRE DEL GRAFICO
          // -----------------------------------------------------------
          Expanded(
            // Expanded → questa parte occupa tutto lo spazio verticale disponibile
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,

              // crossAxisAlignment.end → le barre partono dal basso
              children: [
                // Ciclo for dentro la Row (alternativa a map())
                //
                // Per ogni bucket creiamo una ChartBar.
                // fill = altezza relativa della barra.
                for (final bucket in buckets)
                  ChartBar(
                    fill: bucket.totalExpenses == 0
                        ? 0 // se non ci sono spese → barra vuota
                        : bucket.totalExpenses / maxTotalExpense,
                  ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // -----------------------------------------------------------
          // SEZIONE INFERIORE: LE ICONE DELLE CATEGORIE
          // -----------------------------------------------------------
          Row(
            children: buckets
                .map(
                  (bucket) => Expanded(
                    // Ogni icona occupa lo stesso spazio orizzontale
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),

                      child: Icon(
                        // Icona associata alla categoria
                        categoryIcons[bucket.category],

                        // Colore dell’icona dipendente dal tema
                        color: isDarkMode
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(
                                context,
                              ).colorScheme.primary.withOpacity(0.7),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
