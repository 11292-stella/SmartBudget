import 'package:intl/intl.dart';
// Pacchetto per formattare date e numeri.
// Installato con: flutter pub add intl

import 'package:flutter/material.dart';
// Import principale di Flutter per usare widget Material Design.

import 'package:portafoglio_smart/widgets/expenses.dart';
// Import del widget principale dell’app (non usato qui direttamente, ma parte del progetto).

import 'package:uuid/uuid.dart';
// Pacchetto esterno per generare ID unici.
// Installato con: flutter pub add uuid

// ===============================================================
// FORMATTER PER LE DATE
// ===============================================================
//
// DateFormat.yMd() crea un formatter che converte una DateTime
// in una stringa leggibile secondo il formato locale (es: 12/28/2025).
//
// Lo usiamo nella getter formattedDate della classe Expense.
//
final formatter = DateFormat.yMd();

// ===============================================================
// ISTANZA DI UUID
// ===============================================================
//
// Uuid() è la classe che genera ID unici.
// uuid.v4() → genera una stringa casuale tipo:
// "a3f1c2d0-9b8e-4c7d-8f1a-123456789abc"
//
// La usiamo per assegnare automaticamente un ID ad ogni Expense.
//
final uuid = Uuid();

// ===============================================================
// ENUM Category
// ===============================================================
//
// Un enum è un insieme di valori costanti.
// Qui rappresenta le categorie possibili di una spesa.
//
// Ogni Expense deve appartenere a una di queste categorie.
//
enum Category { food, travel, leisure, work }

// ===============================================================
// MAPPA categoryIcons
// ===============================================================
//
// Associa ogni categoria a un’icona Material Design.
// Serve per mostrare l’icona giusta in ExpenseItem.
//
// Esempio:
// Category.food → Icons.lunch_dining
//
const categoryIcons = {
  Category.food: Icons.lunch_dining,
  Category.travel: Icons.flight_takeoff,
  Category.leisure: Icons.movie,
  Category.work: Icons.work,
};

// ===============================================================
// CLASSE Expense
// ===============================================================
//
// Rappresenta una singola spesa.
// Contiene:
// - id univoco
// - titolo
// - importo
// - data
// - categoria
//
// Ha anche una getter formattedDate per mostrare la data formattata.
// ===============================================================
class Expense {
  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    // uuid.v4() produce una stringa casuale tipo:
    // "a3f1c2d0-9b8e-4c7d-8f1a-123456789abc"
  }) : id = uuid.v4();
  // Il costruttore assegna automaticamente un ID univoco alla proprietà 'id'.
  // Non devi passarlo tu: viene creato in automatico ogni volta che crei un Expense.

  // Identificatore unico della spesa
  final String id;

  // Titolo o descrizione della spesa
  final String title;

  // Importo della spesa
  final double amount;

  // Data della spesa
  final DateTime date;

  // Categoria della spesa (enum)
  final Category category;

  // Getter che restituisce la data formattata come stringa.
  // Usa il formatter definito sopra.
  //
  // Esempio:
  // date = DateTime(2025, 12, 28)
  // formattedDate → "12/28/2025"
  String get formattedDate {
    return formatter.format(date);
  }
}

// ===============================================================
// CLASSE ExpenseBucket
// ===============================================================
//
// Questa classe rappresenta un "contenitore" di spese filtrate per categoria.
//
// Serve principalmente per il grafico (Chart), dove vogliamo sapere:
// - tutte le spese di una categoria
// - la somma totale di quella categoria
//
// Ha due costruttori:
// 1. ExpenseBucket(category, expenses) → passi tu la lista
// 2. ExpenseBucket.forCategory(allExpenses, category) → filtra automaticamente
//
// ===============================================================
class ExpenseBucket {
  const ExpenseBucket({required this.category, required this.expenses});

  // Costruttore alternativo:
  //
  // Prende TUTTE le spese (allExpenses)
  // e filtra solo quelle che appartengono alla categoria scelta.
  //
  // Esempio:
  // ExpenseBucket.forCategory(allExpenses, Category.food)
  // → contiene solo le spese di tipo food.
  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
    : expenses = allExpenses
          .where((expense) => expense.category == category)
          .toList();

  // Categoria rappresentata da questo "bucket"
  final Category category;

  // Lista delle spese appartenenti a questa categoria
  final List<Expense> expenses;

  // Getter che calcola la somma totale delle spese nel bucket.
  //
  // Esempio:
  // expenses = [10€, 20€, 5€]
  // totalExpenses → 35€
  double get totalExpenses {
    double sum = 0;

    // Ciclo for che somma tutti gli importi
    for (final expense in expenses) {
      sum += expense.amount;
    }

    return sum;
  }
}
