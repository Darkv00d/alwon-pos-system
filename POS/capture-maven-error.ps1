$ErrorActionPreference = "Continue"
cd "c:\Users\algam\.gemini\antigravity\scratch\Alwon\POS\backend\auth-service"
mvn clean compile -DskipTests -e *>&1 | Tee-Object -FilePath "..\..\maven-error.log"
Write-Host "`n`n=== ERROR LOG SAVED TO maven-error.log ===`n"
Get-Content "..\..\maven-error.log" -Tail 100
