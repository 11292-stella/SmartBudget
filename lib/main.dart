import 'package:flutter/material.dart';
import 'package:portafoglio_smart/widgets/expenses.dart';

// ===============================================================
// DEFINIZIONE DELLA PALETTE COLORI PER IL TEMA CHIARO
// ===============================================================
//
// ColorScheme.fromSeed crea automaticamente una palette completa
// (primary, secondary, background, surface, onPrimary, ecc.)
// partendo da un solo colore "seedColor".
// Questo garantisce coerenza visiva in tutta l'app.
//
var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 111, 23, 170),
);

// ===============================================================
// DEFINIZIONE DELLA PALETTE COLORI PER IL TEMA SCURO
// ===============================================================
//
// Stessa logica, ma con brightness: Brightness.dark.
// Flutter genera una palette ottimizzata per il dark mode.
//
var kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 5, 99, 125),
);

void main() {
  runApp(
    MaterialApp(
      // ===============================================================
      // DEFINIZIONE DEL TEMA SCURO
      // ===============================================================
      //
      // ThemeData.dark() crea un tema scuro di base.
      // copyWith() permette di sovrascrivere SOLO alcune parti del tema,
      // mantenendo tutto il resto del tema scuro standard.
      //
      darkTheme: ThemeData.dark().copyWith(
        // Applica la nostra palette personalizzata al tema scuro.
        colorScheme: kDarkColorScheme,

        // Tema globale per tutte le Card dell'app in dark mode.
        cardTheme: const CardThemeData().copyWith(
          // Colore di sfondo della card → preso dalla palette scura.
          color: kDarkColorScheme.secondaryContainer,

          // Margini standard per tutte le card.
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),

        // Tema globale per tutti gli ElevatedButton in dark mode.
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            // Colore di sfondo del pulsante.
            backgroundColor: kDarkColorScheme.primaryContainer,

            // Colore del testo/icone sopra il pulsante.
            foregroundColor: kDarkColorScheme.onPrimaryContainer,
          ),
        ),
      ),

      // ===============================================================
      // DEFINIZIONE DEL TEMA CHIARO
      // ===============================================================
      //
      // ThemeData() crea un tema base neutro.
      // copyWith() permette di modificare solo ciò che ci interessa.
      //
      theme: ThemeData().copyWith(
        // Applica la palette colori chiara a tutto il tema.
        colorScheme: kColorScheme,

        // Tema globale per tutte le AppBar dell'app.
        appBarTheme: const AppBarTheme().copyWith(
          // Colore dello sfondo dell'appbar.
          backgroundColor: kColorScheme.onPrimaryContainer,

          // Colore del testo e delle icone dell'appbar.
          foregroundColor: kColorScheme.primaryContainer,
        ),

        // Tema globale per tutte le Card dell'app in tema chiaro.
        cardTheme: const CardThemeData().copyWith(
          color: kColorScheme.secondaryContainer,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),

        // Tema globale per tutti gli ElevatedButton in tema chiaro.
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kColorScheme.primaryContainer,
          ),
        ),

        // Tema globale per i testi dell'app.
        textTheme: ThemeData().textTheme.copyWith(
          titleLarge: TextStyle(
            fontWeight: FontWeight.bold,
            color: kColorScheme.onSecondaryContainer,
            fontSize: 17,
          ),
        ),
      ),

      // ===============================================================
      // SCELTA AUTOMATICA DEL TEMA
      // ===============================================================
      //
      // ThemeMode.system → Flutter usa il tema del dispositivo:
      // - se il telefono è in dark mode → usa darkTheme
      // - se è in light mode → usa theme
      //
      themeMode: ThemeMode.system,

      // ===============================================================
      // HOME DELL'APP
      // ===============================================================
      home: Expenses(),
    ),
  );
}
