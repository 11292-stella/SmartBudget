import 'package:flutter/material.dart';

// ===============================================================
// WIDGET ChartBar
// ===============================================================
//
// Questo widget rappresenta UNA SINGOLA BARRA del grafico delle spese.
// Ogni barra ha un'altezza proporzionale al valore "fill" (0.0 → 0%, 1.0 → 100%).
//
// È Stateless perché:
// - riceve un valore già calcolato (fill)
// - non modifica nulla
// - si limita a disegnare la barra
// ===============================================================
class ChartBar extends StatelessWidget {
  const ChartBar({super.key, required this.fill});

  // "fill" è un valore compreso tra 0 e 1.
  // Rappresenta la percentuale di altezza della barra.
  //
  // Esempi:
  // fill = 1.0 → barra piena (100%)
  // fill = 0.5 → metà altezza
  // fill = 0.0 → barra vuota
  final double fill;

  @override
  Widget build(BuildContext context) {
    // ===============================================================
    // RILEVAZIONE DEL TEMA (CHIARO/SCURO)
    // ===============================================================
    //
    // MediaQuery permette di leggere informazioni sul dispositivo.
    // platformBrightness indica se il sistema è in dark mode o light mode.
    //
    // Questo serve per cambiare il colore della barra in base al tema.
    // ===============================================================
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Expanded(
      // Expanded → la barra occupa tutto lo spazio disponibile
      // all'interno della Row che contiene tutte le barre del grafico.
      //
      // Senza Expanded, le barre non si distribuirebbero in modo uniforme.
      child: Padding(
        // Padding orizzontale per separare le barre tra loro.
        padding: const EdgeInsets.symmetric(horizontal: 4),

        child: FractionallySizedBox(
          // ===============================================================
          // FractionallySizedBox
          // ===============================================================
          //
          // heightFactor controlla l’altezza del contenuto come FRAZIONE
          // dell’altezza disponibile.
          //
          // heightFactor = fill:
          // - se fill = 1.0 → altezza = 100% dello spazio disponibile
          // - se fill = 0.5 → altezza = 50%
          // - se fill = 0.2 → altezza = 20%
          //
          // Questo è il cuore del grafico: la barra cresce in base ai dati.
          // ===============================================================
          heightFactor: fill,

          child: DecoratedBox(
            // DecoratedBox permette di disegnare sfondi, bordi, forme.
            decoration: BoxDecoration(
              shape: BoxShape.rectangle, // forma rettangolare (default)
              // Bordo arrotondato SOLO in alto.
              // Questo rende la barra più elegante.
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),

              // ===============================================================
              // COLORE DELLA BARRA
              // ===============================================================
              //
              // Se il tema è scuro → usa colorScheme.secondary
              // Se il tema è chiaro → usa primary con opacità 65%
              //
              // Questo permette alla barra di adattarsi automaticamente
              // al tema dell’app, mantenendo leggibilità e coerenza.
              // ===============================================================
              color: isDarkMode
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).colorScheme.primary.withOpacity(0.65),
            ),
          ),
        ),
      ),
    );
  }
}
