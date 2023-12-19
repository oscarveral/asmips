	.data
#Modificaciones del ejercicio 5.
num1: 	.word 1000, 5000, 3000, 4000 					# Cuatro palaras con los valores 1000, 2000, 3000, 4000 respectivamente.

num2:	.half 100, 500, 300, 400 					# Cuatro medias palabras con los valores 100, 200, 300, 400 respectivamente.

num3:	.byte 10, 50, 30, 40 						# Cuatro bytes con los valores 10, 20, 30, 40 respectivamente.
#------------------------------------
retcar:	.byte '\n'							# Caracter de retorno de carro.

msg: 	.asciiz "Los elementos buscados son:"				# Cadena para imprimir.
	
	#Modificación ejercicio 4. 
#---------------------------------------------------------------------------------
	.align 2	# Se alinea para poder guardar datos en i.
#---------------------------------------------------------------------------------------------------------------------------------------------

i: 	.space 4							# 4 bytes para guardar el nº de elemento a buscar.

# Modificación ejercicio 4.
#---------------------------------------------------------------------------------------------------------------------------------------------
msgIn:	.asciiz "Introduce el número de elemento a mostrar (0 -3): "	# Mensaje a mostrar para introducir el número de elemento a buscar.
espacio: .byte 0x20 							#Codigo ascii del espacio en blanco.
#---------------------------------------------------------------------------------------------------------------------------------------------

	.text
	
.globl main # Procedimiento principal.
main:	

	# Modificaciones ejercicio 4.
#-----------------------------------------------------------------------------------------------------
	# Escritura en pantalla del mensage de introducción.
	li $v0, 4
	la $a0, msgIn
	syscall
	
	# Introducción del elemento a buscar y guardado en memoria de este.
	li $v0, 5
	syscall
	move $t0, $v0 # Pone en $t0 el no de elemento a cargar
	sw $v0, i # Almacena el número de elemento a buscar en la memoria asiganda al dato i.
#------------------------------------------------------------------------------------------------------
	
	la $t1, num1 # Pone en $t1 la dirección de «num1»
	sll $t4, $t0, 2 # Multiplica el no elemento por 4
	add $t4, $t1, $t4 # Suma el desplazamiento a la dirección de comienzo
	lw $t5, 0($t4) # Accede a memoria a leer el elemento

	# Modificaciones ejercicio 4.	
#-----------------------------------------------------------------------------------------------------
	# Como ya se ha guardado el elemento que biuscamos de num1, necesitamos ahora guardar en otros registros los mismos pero de num2 y num3.
	
	# Busqueda del elemento de num2.
	la $t1, num2 # Asigno a $t1 la dirección de num2.
	sll $t4, $t0, 1 # Multiplico el elemento a buscar  por 2 y no por cuatro ya que los elementos de num2 ocupan solo 2 bytes. Este número será nuestro desplazamiento.
	add $t4, $t1, $t4  # Le sumo a mi dirección de comienzo el desplazamiento necesario para llegar al número buscado.
	lh $t6, 0($t4) # Guardo el elemento de la memoria al que apunta $t4, que es el elemento que buscamos.
	
	# Búsqueda del elemento de num3.
	la $t1, num3 # Asigno a $t1 la dirección de num3.
	# Como los elementos de num3 son solo de 1 byte no es necesario realizar desplazamientos para poder acceder correctamente al número de elemento que buscamos.
	add $t1, $t0, $t1 # Le añado a mi dirección de comienzo de num3 el número de elemento que busco. No es necesario ningún registro auxiliar en este caso.
	lb $t7, 0($t1) # Cargo en $t7 el elemento apuntado ahora por $t1.
	
	# Véase que he seguido un proceso parecido al dado originalmente pero teniendo en cuenta el tamaño de los datos y los respectivos desplazamientos.

#-----------------------------------------------------------------------------------------------------

	la $a0, msg # Pone en $a0 la dirección de la cadena
	li $v0, 4 # Código syscall para imprimir una cadena
	syscall # Imprime la cadena «El elemento buscado es:»

	# Impresión de un espacio en blanco.
	li $v0, 11
	lbu $a0, espacio
	syscall

	li $v0, 1 # Código syscall para imprimir un entero
	move $a0, $t5 # Pone en $a0 el entero a imprimir
	syscall # Imprime el entero

	#Modificaciones ejercicio 4.
#-------------------------------------------------------------------------------------------------------
	# Impresión de un espacio en blanco.
	li $v0, 11
	lbu $a0, espacio
	syscall
	
	#Impresión del elemento de num2.
	li $v0, 1
	move $a0, $t6
	syscall
	
	# Impresión de un espacio en blanco.
	li $v0, 11
	lbu $a0, espacio
	syscall
	
	#Impresión del elemento de num 2.
	li $v0, 1
	move $a0, $t7
	syscall
#-------------------------------------------------------------------------------------------------------

	li $v0, 11 # Código syscall para imprimir un carácter
	lbu $a0, retcar # Carga en $a0 el carácter a imprimir (retcar)
	syscall # Imprime el caracter

	li $v0, 10 # Código syscall de exit
	syscall
	jr $ra
