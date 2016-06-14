/* Initial beliefs and rules */
/* Conocimientos que el frayHector tiene del entorno */
ganas_rezar(muchas).
ganas_ir(comedor, muchas).
ganas_ir(habitacion, muchas).
ganas_ir(cocina, muchas).
habitaciones(cocina, abierta).

objetoManoDerecha(nada).
objetoManoIzquierda(nada).

/*Initial goals */
//!invitarA.

/*Plans */
//+ir(location)
//<- yendo(location).

+quiero_ir(capilla)
	: ganas_rezar(ninguna)
		<- .print("mmmm, esta sonando la campana, pero no tengo ganas de ir a rezar...").
		
+quiero_ir(capilla)
	: not ganas_rezar(ninguna)
		<- 	.print("EH! la campana, me apetece ir a rezar");
			voy_a(fHlocation_capilla);
			.wait(15000); //Tiempo rezando (ms)
			-+quiero_ir(cocina)[source(self)].
		
//#############################################################
//#############################################################
//#############################################################

+quiero_ir(comedor)[source(A)] 
	: ganas_ir(comedor, ninguna) & (A == self)
		<- .print("No me apetece ir a comer al comedor.").

+quiero_ir(comedor)[source(A)] 
	: not ganas_ir(comedor, ninguna) & (A == self)
		<- 	.print("Ahora voy a ir a comer al comedor.");
			voy_a(fHlocation_comedor);
			.wait(10000); //Tiempo en el comedor (ms)
			-+quiero_ir(habitacion)[source(self)].
		
//#############################################################
//#############################################################
//#############################################################

+quiero_ir(cocina)[source(A)]
	: ganas_ir(cocina, ninguna) & (A == self)
		<-	.print("Ahora no me apetece hacer nada, me quedar� aqu� de momento").

+quiero_ir(cocina)[source(A)]
	: not ganas_ir(cocina, ninguna) & (A == self) & habitaciones(cocina, abierta)
		<-	.print("Voy a ir a la cocina a trabajar un poco");
			voy_a(fHlocation_cocina);
			.wait(15000); //Tiempo en la cocina (ms)
			-+quiero_ir(comedor)[source(self)].

+quiero_ir(cocina)[source(A)]
	: not ganas_ir(cocina, ninguna) & (A == self) & not habitaciones(cocina, abierta) & objetoManoDerecha(nada)
		<-	.print("�La puerta est� cerrada!");
			-quiero_ir(cocina)[source(self)];
			!buscar(llave).
			
+quiero_ir(cocina)[source(A)]
	: not ganas_ir(cocina, ninguna) & (A == self) & not habitaciones(cocina, abierta) & objetoManoDerecha(llave)
		<-	.print("Ya puedo abrir la puerta");
			voy_a(fHlocation_puerta_cocina);
			.wait(15000); // Tiempo en ir a la puerta de la cocina
			.print("Est� cerrada... �pero tengo la llave!");
			.wait(1000); // Abirendo la puerta
			-+habitaciones(cocina,cerrada);
			-+quiero_ir(cocina)[source(self)].
			
+!buscar(A)
	: A == llave
	<- .print("Voy en pos de la llave");
		voy_a(fHlocation_llave);
		.wait(15000); // Tiempo en ir a por la llave
		-+objetoManoDerecha(nada);
		+quiero_ir(cocina)[source(self)].
		
/**
+quiero_ir(cocina)[source(A)]
	: ganas_ir(cocina, ninguna) & not (A == self)
		<- .print("Aunque ", A, " se ponga a hacer cosas en su escritorio, yo no pienso hacer nada").
 
		
+quiero_ir(cocina)[source(A)] 
	: not ganas_ir(cocina, ninguna) & not (A == self) & habitaciones(cocina, abierta)
		<- 	.print("Pues si ", A, " se pone en su escritorio, yo voy a trabajar en la cocina");
			voy_a(fHlocation_cocina).
			
+quiero_ir(cocina)[source(A)] 
	: not ganas_ir(cocina, ninguna) & not (A == self) & not habitaciones(cocina, abierta)
		<- 	.print("Pues si ", A, " se pone en su escritorio, a mi me gustaria ir a la cocina a trabajar pero ", A," me ha cerrado la puerta").
*/
+cerrada(cocina)
	<-	-habitaciones(cocina, abierta);
		+habitaciones(cocina, cerrada).

//#############################################################
//#############################################################
//#############################################################

+quiero_ir(habitacion)[source(A)]
	: ganas_ir(habitacion, ninguna) & (A == self)
		<-	.print("No tengo que hacer nada en la habitaci�n, me quedar� aqu� de momento").

+quiero_ir(habitacion)[source(A)]
	: not ganas_ir(habitacion, ninguna) & (A == self)
		<-	.print("Voy a ir a la habitaci�n a hacer mis movidas de monje");
			voy_a(fHlocation_mesa_cuarto);
			.wait(15000); //Tiempo en la cocina (ms)
			-+quiero_ir(capilla)[source(self)].



//+!invitarA
//	<- 	.wait(15000); //15 segundos
//		.print("Hola, frayFernando, �Vienes a comer conmigo?");
//		.send(frayFernando,tell,comer).


//+saludo[source(A)] 
//	<-	+ caracter(A,simpatico);	// Agrega un belief de que A es simpatico
//		.print("He sido saludado por ",A);
//     	.send(A,tell,insultame).

//+rezar(X)
//	: caracter(X,simpatico)
//	<- .print("Ire a rezar con ", X).

//+interactuar(PERSONA,ACCION)
//	<- 	.print("Interactuar con ", PERSONA, " con la accion ", ACCION);
//		.send(PERSONA,tell,ACCION).
