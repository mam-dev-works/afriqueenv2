Jeevan Koiri plan: 

1. Slowly migrate all the things to bloc. no Getx neither getx storage nor getx navigation. 
Because: 
GetX Navigation - KEEP for now because:
It's used 169 times across the entire app. Removing it would require:

Rewriting all navigation code
Testing every screen transition
High risk of breaking the app


Current problems: 
262 setState calls (clean these up first)
Duplicate logic everywhere
Missing error handling
No tests
