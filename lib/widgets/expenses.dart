import 'dart:math';
// Import di dart:math (non usato in questo file, ma probabilmente usato in altre parti del progetto)

import 'package:flutter/material.dart';
// Import del framework Flutter per costruire la UI

import 'package:portafoglio_smart/chart/chart.dart';
// Import del widget Chart che mostra il grafico delle spese

import 'package:portafoglio_smart/widgets/expenses_list/expenses_list.dart';
// Import del widget che mostra la lista delle spese

import 'package:portafoglio_smart/models/expense.dart';
// Import del modello Expense (classe che rappresenta una spesa)

import 'package:portafoglio_smart/widgets/new_expense.dart';
// Import del widget che mostra il form per aggiungere una nuova spesa

// ===============================================================
// WIDGET PRINCIPALE DELLA SCHERMATA DELLE SPESE
// ===============================================================
//
// Questo widget rappresenta l'intera pagina dove l’utente vede:
// - il grafico delle spese
// - la lista delle spese
// - il pulsante per aggiungere nuove spese
//
// È uno StatefulWidget perché la lista delle spese può cambiare
// (aggiunta, rimozione, undo, ecc.)
// ===============================================================
class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState(); // collega il widget al suo stato
  }
}

// ===============================================================
// STATO DEL WIDGET
// ===============================================================
//
// Qui vivono:
// - la lista delle spese
// - i metodi per aggiungere/rimuovere spese
// - la logica per mostrare SnackBar e Undo
// - la costruzione della UI
// ===============================================================
class _ExpensesState extends State<Expenses> {
  // LISTA DELLE SPESE REGISTRATE
  //
  // "final" significa che la LISTA non cambia come riferimento,
  // ma il suo contenuto può essere modificato (aggiungere/rimuovere elementi).
  final List<Expense> _registerExpenses = [
    Expense(
      title: 'Cinema ',
      amount: 15.99,
      date: DateTime.now(),
      category: Category.leisure,
    ),
    Expense(
      title: 'Flutter Course ',
      amount: 19.99,
      date: DateTime.now(),
      category: Category.work,
    ),
  ];

  // ===============================================================
  // METODO PER APRIRE IL MODAL BOTTOM SHEET
  // ===============================================================
  //
  // Viene chiamato quando premi l’icona "+" nell’AppBar.
  // showModalBottomSheet crea un pannello che scorre dal basso.
  // isScrollControlled: true → permette al foglio di espandersi
  // fino quasi a tutto lo schermo (utile per form lunghi).
  // ===============================================================
  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      isScrollControlled: true, // permette al modal di espandersi
      context: context,
      builder: (ctx) => NewExpense(
        onAddExpense: _addExpense, // callback per aggiungere una spesa
      ),
    );
  }

  // ===============================================================
  // METODO PER AGGIUNGERE UNA NUOVA SPESA
  // ===============================================================
  //
  // Viene chiamato dal widget NewExpense quando l’utente salva il form.
  // setState() → dice a Flutter di ricostruire la UI perché la lista è cambiata.
  // ===============================================================
  void _addExpense(Expense expense) {
    setState(() {
      _registerExpenses.add(expense);
    });
  }

  // ===============================================================
  // METODO PER RIMUOVERE UNA SPESA
  // ===============================================================
  //
  // 1. Trova l’indice della spesa da rimuovere
  // 2. La rimuove dalla lista
  // 3. Mostra uno SnackBar con possibilità di "Undo"
  // 4. Se l’utente preme Undo → reinserisce la spesa nella posizione originale
  // ===============================================================
  void _removeExpense(Expense expense) {
    final expenseIndex = _registerExpenses.indexOf(expense);

    setState(() {
      _registerExpenses.remove(expense);
    });

    // Rimuove eventuali SnackBar già presenti
    ScaffoldMessenger.of(context).clearSnackBars();

    // Mostra un nuovo SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 3), // durata visibilità
        content: const Text('Expense deleted'),
        action: SnackBarAction(
          label: 'Undo', // pulsante per annullare
          onPressed: () {
            // Reinserisce la spesa nella posizione originale
            setState(() {
              _registerExpenses.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  // ===============================================================
  // COSTRUZIONE DELLA UI
  // ===============================================================
  @override
  Widget build(BuildContext context) {
    // Widget mostrato quando NON ci sono spese
    Widget mainContent = const Center(
      child: Text('No expense found. Start adding some! '),
    );

    // Se ci sono spese → mostra la lista
    if (_registerExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registerExpenses,
        onRemoveExpense: _removeExpense, // callback per eliminare una spesa
      );
    }

    return Scaffold(
      // ===============================================================
      // APPBAR (barra superiore)
      // ===============================================================
      appBar: AppBar(
        title: Text('Flutter ExpenseTracker'),
        actions: [
          // Icona "+" per aggiungere una nuova spesa
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),

      // ===============================================================
      // CORPO DELLA SCHERMATA
      // ===============================================================
      body: Column(
        children: [
          // Grafico delle spese (widget Chart)
          Chart(expenses: _registerExpenses),

          // Expanded → permette alla lista di occupare tutto lo spazio rimanente.
          // Senza Expanded, ListView darebbe errore perché non ha un'altezza definita.
          Expanded(child: mainContent),
        ],
      ),
    );
  }
}
