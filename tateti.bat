:: Objetivo: Recrear el videojuego "tateti" en batch scripting
:: El juego comenzará directamente y será por turnos
:: El juego finalizará cuando ya no queden movimientos o un jugador gane
:: Al finalizar el juego, se mostrará al ganador en pantalla y se guardará en un archivo en el mismo directorio
:: Así se debería ver el tablero
:: -------------
:: | X | O | X |
:: |-----------|
:: | O | x | O |
:: |-----------|
:: | X | O | X |
:: -------------

:: ------------------------------------
:: Comienzo del programa
:: ------------------------------------

@ECHO OFF
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
SET me=%~n0
SET parent=%~dp0
SET /A juegoTerminado=0
SET /A movimientosRealizados=0

SET /A jugador_actual=1
SET /A jugada_actual=0

CALL :inicializar_posiciones

:juego
CALL :jugar
CALL :actualizar_posicion
CALL :mostrar_tablero
CALL :checkear_si_hay_ganador

IF %movimientosRealizados%==9 GOTO :end
IF %juegoTerminado%==0 GOTO :juego

:end
CALL :cambiar_de_jugador
IF %juegoTerminado%==1 ECHO Ha ganado el jugador: %jugador_actual%
IF %juegoTerminado%==0 ECHO Empate!

IF %juegoTerminado%==1 ECHO %jugador_actual% >> partidas.txt
IF %juegoTerminado%==0 ECHO -1 >> partidas.txt

PAUSE
EXIT /B %ERRORLEVEL%

:: ------------------------------------
:: Funciones
:: ------------------------------------

:inicializar_posiciones
SET tabl[1]=-
SET tabl[2]=-
SET tabl[3]=-
SET tabl[4]=-
SET tabl[5]=-
SET tabl[6]=-
SET tabl[7]=-
SET tabl[8]=-
SET tabl[9]=-
EXIT /B 0

:mostrar_tablero
CLS
ECHO -------------
ECHO ^| %tabl[1]% ^| %tabl[2]% ^| %tabl[3]% ^|
ECHO ^|-----------^|
ECHO ^| %tabl[4]% ^| %tabl[5]% ^| %tabl[6]% ^|
ECHO ^|-----------^|
ECHO ^| %tabl[7]% ^| %tabl[8]% ^| %tabl[9]% ^|
ECHO -------------
EXIT /B 0

:jugar
:args
CALL :mostrar_tablero
SET /P respuesta="Jugador %jugador_actual%, ingrese su jugada: "
SET /A jugada_actual=respuesta

IF %jugada_actual%==0 GOTO :args
IF %jugada_actual% GTR 9 GOTO :args
EXIT /B 0

:actualizar_posicion
IF NOT !tabl[%jugada_actual%]! == - EXIT /B 0
IF %jugador_actual%==1 SET tabl[%jugada_actual%]=X
IF %jugador_actual%==2 SET tabl[%jugada_actual%]=O

CALL :cambiar_de_jugador
SET /A movimientosRealizados=%movimientosRealizados%+1
EXIT /B 0

:cambiar_de_jugador
SET /A copia_jugador=%jugador_actual%
IF %copia_jugador%==1 SET /A jugador_actual=2
IF %copia_jugador%==2 SET /A jugador_actual=1

:checkear_si_hay_ganador
:: Checkeo en filas
IF NOT %tabl[1]%==- (IF %tabl[1]%==%tabl[2]% (IF %tabl[2]%==%tabl[3]% (SET /A juegoTerminado=1)))
IF NOT %tabl[4]%==- (IF %tabl[4]%==%tabl[5]% (IF %tabl[5]%==%tabl[6]% (SET /A juegoTerminado=1)))
IF NOT %tabl[7]%==- (IF %tabl[7]%==%tabl[8]% (IF %tabl[8]%==%tabl[9]% (SET /A juegoTerminado=1)))
:: Checkeo en columnas
IF NOT %tabl[1]%==- (IF %tabl[1]%==%tabl[4]% (IF %tabl[4]%==%tabl[7]% (SET /A juegoTerminado=1)))
IF NOT %tabl[2]%==- (IF %tabl[2]%==%tabl[5]% (IF %tabl[5]%==%tabl[8]% (SET /A juegoTerminado=1)))
IF NOT %tabl[3]%==- (IF %tabl[3]%==%tabl[6]% (IF %tabl[6]%==%tabl[9]% (SET /A juegoTerminado=1)))
:: Checkeo en diagonales
IF NOT %tabl[1]%==- (IF %tabl[1]%==%tabl[5]% (IF %tabl[5]%==%tabl[9]% (SET /A juegoTerminado=1)))
IF NOT %tabl[3]%==- (IF %tabl[3]%==%tabl[5]% (IF %tabl[5]%==%tabl[7]% (SET /A juegoTerminado=1)))


