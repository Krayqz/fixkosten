# Fixkosten-Rechner

Eine kleine Website, die zeigt, wie viel Geld bis zum nächsten Lohn übrig bleibt: Einkommen (Hauptjob und Minijob) minus Fixkosten, plus Einzahlungen, minus Ausgaben.

- **Hosting:** GitHub Pages (statische Dateien, kein Build-Schritt)
- **Login und Daten:** [Supabase](https://supabase.com) (E-Mail und Passwort, eine Zeile pro Konto in der Tabelle `budgets`)

## Dateien

| Datei | Inhalt |
| --- | --- |
| `index.html` | Die ganze Seite: Aussehen, Rechnung, Login |
| `config.js` | Supabase-Adresse und öffentlicher Schlüssel |
| `supabase.sql` | Legt die Tabelle und die Zugriffsregeln an |
| `manifest.webmanifest`, Icons | Damit die Seite auf dem Handy-Home-Bildschirm wie eine App aussieht |

## Einrichtung

1. **Supabase-Projekt anlegen** und unter *SQL Editor* den Inhalt von `supabase.sql` ausführen.
2. Unter *Project Settings → API* die **Project URL** und den **anon/publishable key** in `config.js` eintragen. Den `service_role`- oder `secret`-Schlüssel nie in den Code schreiben.
3. Unter *Authentication → URL Configuration* die **Site URL** auf die Adresse der Website setzen (z. B. `https://<name>.github.io/fixkosten/`), damit Links aus Bestätigungs- und Passwort-E-Mails dorthin führen.
4. **GitHub Pages einschalten:** Repository → *Settings → Pages* → *Deploy from a branch* → `main` / `(root)`.
5. Auf der Website ein Konto erstellen. Danach unter *Authentication → Sign In / Providers* die Option **Allow new users to sign up** ausschalten, damit sich niemand sonst registrieren kann.

## Daten umziehen

Auf der alten Seite unter „Daten sichern“ eine Sicherung herunterladen und auf der neuen Seite mit „Sicherung laden“ einspielen.

## Hinweis

Kostenlose Supabase-Projekte werden nach etwa einer Woche ohne Nutzung pausiert. Wer die Seite regelmäßig öffnet, merkt davon nichts; ein pausiertes Projekt lässt sich im Supabase-Dashboard mit einem Klick wieder starten.
