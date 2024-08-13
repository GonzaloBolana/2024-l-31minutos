% Cancion, Compositores,  Reproducciones
cancion(bailanSinCesar, [pabloIlabaca, rodrigoSalinas], 10600177).
cancion(yoOpino, [alvaroDiaz, carlosEspinoza, rodrigoSalinas], 5209110).
cancion(equilibrioEspiritual, [danielCastro, alvaroDiaz, pabloIlabaca, pedroPeirano, rodrigoSalinas], 12052254).
cancion(tangananicaTanganana, [danielCastro, pabloIlabaca, pedroPeirano], 5516191).
cancion(dienteBlanco, [danielCastro, pabloIlabaca, pedroPeirano], 5872927). 
cancion(lala, [pabloIlabaca, pedroPeirano], 5100530).
cancion(meCortaronMalElPelo, [danielCastro, alvaroDiaz, pabloIlabaca, rodrigoSalinas], 3428854).

% Mes, Puesto, Cancion
rankingTop3(febrero, 1, lala).
rankingTop3(febrero, 2, tangananicaTanganana).
rankingTop3(febrero, 3, meCortaronMalElPelo).
rankingTop3(marzo, 1, meCortaronMalElPelo).
rankingTop3(marzo, 2, tangananicaTanganana).
rankingTop3(marzo, 3, lala).
rankingTop3(abril, 1, tangananicaTanganana).
rankingTop3(abril, 2, dienteBlanco).
rankingTop3(abril, 3, equilibrioEspiritual).
rankingTop3(mayo, 1, meCortaronMalElPelo).
rankingTop3(mayo, 2, dienteBlanco).
rankingTop3(mayo, 3, equilibrioEspiritual).
rankingTop3(junio, 1, dienteBlanco).
rankingTop3(junio, 2, tangananicaTanganana).
rankingTop3(junio, 3, lala).

%Punto 1: Saber si una canción es un hit, lo cual ocurre si aparece en el ranking top 3 de todos los meses.
esUnHit(Cancion):-
    cancion(Cancion,_,_),
    forall(rankingTop3(Mes,_,_),rankingTop3(Mes,_,Cancion)).
    %Para todos los ranking top 3 del mes hay una cancion.

%Punto 2:
/*
Saber si una canción no es reconocida por los críticos, 
lo cual ocurre si tiene muchas reproducciones y nunca estuvo en el ranking. 
Una canción tiene muchas reproducciones si tiene más de 7000000 reproducciones.

*/

noEsReconocidaPorLosCriticos(Cancion):-
    cancion(Cancion, _,  Reproducciones),
    Reproducciones > 7000000,
    not(rankingTop3(_,_,Cancion)).


% Punto 3: Saber si dos compositores son colaboradores, lo cual ocurre si compusieron alguna canción juntos

sonColaboradores(Compositor,OtroCompositor):-
    componeEn(Compositor,Cancion),
    componeEn(OtroCompositor,OtraCancion),
    Cancion = OtraCancion. % Si componen juntos significa que compusieron la misma cancion.

componeEn(Compositor,Cancion):-
    cancion(Cancion,Compositores,_),
    member(Compositor,Compositores). %Compositor es miembro de compositores.


%Punto 4:
/*
Modelar en la solución a los siguientes trabajadores:
- Tulio, conductor con 5 años de experiencia.
- Bodoque, periodista con 2 años de experiencia con un título de licenciatura, y también reportero con 5 años de experiencia y 300 notas realizadas.
- Mario Hugo, periodista con 10 años de experiencia con un posgrado.
- Juanin, que es un conductor que recién empieza así que no tiene años de experiencia.

*/

trabajador(tulio,conductor(5)). %Sueldo 50k
trabajador(bodoque,periodista(2,licenciatura)). %Sueldo 12k
trabajador(bodoque,reportero(5,300)). %Sueldo 80k
trabajador(marioHugo,periodista(10,posgrado)). %Sueldo 67,5k
trabajador(juanin,conductor(0)). %Sueldo 0
trabajador(messi,futbolista(20,45)).

%Punto 5:

/*
Conocer el sueldo total de una persona, el cual está dado por la suma de los sueldos de cada uno de sus trabajos. 
*El sueldo de cada trabajo se calcula de la siguiente forma:
- El sueldo de un conductor es de 10000 por cada año de experiencia
- El sueldo de un reportero también es 10000 por cada año de experiencia más  100 por cada nota que haya hecho en su carrera.
- Los periodistas, por cada año de experiencia reciben 5000, pero se les aplica un porcentaje de incremento del 20% cuando tienen una licenciatura o
  del 35% si tienen un posgrado.

  Tulio gana total 50k
  Bodoque gana total 92k
  Mario Hugo gana total 67,5k
  Juanin gana total 0k
*/

sueldoTotal(Persona,SueldoTotal):-
    trabajador(Persona,_),
    findall(Sueldo, sueldoSegunTrabajo(Persona,Sueldo), Sueldos),
    sum_list(Sueldos, SueldoTotal).

sueldoSegunTrabajo(Persona,Sueldo):-
    trabajador(Persona,TipoTrabajo),
    sueldo(TipoTrabajo,Sueldo).


sueldo(conductor(AniosExperiencia),Sueldo):-
    Sueldo is AniosExperiencia * 10000.

sueldo(reportero(AniosExperiencia,NotasRealizadas),Sueldo):-
    Sueldo is AniosExperiencia * 10000 + 100 * NotasRealizadas.

sueldo(periodista(AniosExperiencia,Titulo),Sueldo):-
    aumentoSegunTitulo(Titulo,Aumento),
    Sueldo is AniosExperiencia * 5000 * (1+Aumento/100).

aumentoSegunTitulo(licenciatura,20).
aumentoSegunTitulo(posgrado,35).
aumentoSegunTitulo(cuarentaycinco,450).
%Punto 6: 
trabajador(messi,futbolista(20,cuarentaycinco)).

sueldo(futbolista(AniosExperiencia,Titulo),Sueldo):-
    aumentoSegunTitulo(Titulo,Aumento),
    Sueldo is AniosExperiencia * 16000 * (1+Aumento/100).