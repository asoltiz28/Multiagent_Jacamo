// Agent bob in project smartroom

/* Initial beliefs and rules */


// preference(20). Ya no es necesario porque se define en startroom.jcm


/* Initial goals */

!start.

/* Plans */

//--- con organizacion
+!vote[scheme(S)] <-   // S: cualquier esquema (temp_r1 en este caso)
    // decidir voto
    ?preference(P);
    ?vm::options(Options);
    .sort(Options, OrderedOptions);
    ?my_vote(OrderedOptions, P, Papeleta);
    //enviar voto
    vm::vote(Papeleta);
    .print("He votado: ", Papeleta).

// Cualquier cambio en el artefacto se ve reflejado en las creencias del agente.
//
//----------Con VotingMachine------------------
//
+!servir_cafe <- .print("Aqui tienes tu cafe con pastitias").   // sin contexto no se pone ":"

+!beber_cafe <- .print("Que rico mi cafe ").


+vm::status("close") <- // Este plan es una reacción al ver status de vm a close
    .print("La votación se ha cerrado.").

/*
+vm::status("open") <-
    .print("La votación se ha abierto");
    //decidir voto
    ?preference(P);
    ?vm::options(Options);
    .sort(Options, OrderedOptions);
    ?my_vote(OrderedOptions, P, Papeleta);
    //enviar voto
    vm::vote(Papeleta);
    .print("He votado: ", Papeleta).
*/

// La anterior manera de hacerlo

// Cómo reaccionar a la adición de esta creencia
+open_voting(ConvId, Options, Timeout) <-
    ?preference(P); //Esto se resuelve de 2 maneras.
    ?my_vote(Options, P, V);
    .send(rc, tell, vote(ConvId, V)).

// H: cabeza, T: cola de la lista. P: preferencia, V: voto
my_vote([H|_], P, H) :- P <= H.
my_vote([H|T], P, V) :- my_vote(T, P, V). // :- significa: es un cálculo, la llamada de una función. NO un objetivo
my_vote([H], _, H).

+!start : true
    <- .print("hello world.");
       .date(Y,M,D); .time(H,Min,Sec,MilSec); // get current date & time
       +started(Y,M,D,H,Min,Sec);             // add a new belief
       // +temperature(25).                      // add a new belief
        ?preference(P);                          // query a belief. A veces, es necesario hacer consultas mentales del propio agente.
        .print("Mi preferencia es: ", P).

+!suscripcion<-
    .df_subscribe("dictionary(es-ES)").
+provider(Agente, Servicio) : Servicio == "dictionary(es-ES)" <- // me llega cuando un agente se registra como que sabe hacer un registro.
    .print(" El agente ", Agente, " sabe hacer ", Servicio); // reaccion al registro por que te has suscrito
    .send(Agente, askAll, term("queliceros", Y)).
    //.send(Agente, askOne, term("queliceros", Y)).
    // .send(Agente, tell, term("queliceros")).
+term(X, Y) <-
    .print(X," Significa: ", Y).


{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
{ include("$moise/asl/org-obedient.asl") }
