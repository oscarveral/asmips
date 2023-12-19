	.data
num1: 	.word 1000, 2000, 3000, 4000 					# Cuatro palaras con los valores 1000, 2000, 3000, 4000 respectivamente.

num2:	.half 100, 200, 300, 400 					# Cuatro medias palabras con los valores 100, 200, 300, 400 respectivamente.

num3:	.byte 10, 20, 30, 40 						# Cuatro bytes con los valores 10, 20, 30, 40 respectivamente.
	
retcar:	.byte '\n'							# Caracter de retorno de carro.

msg: 	.asciiz "El elemento buscado es:"				# Cadena para imprimir.
	
	#Modificación ejercicio 3. 
#---------------------------------------------------------------------------------
	.align 2	# Se alinea para poder guardar datos en i.
#---------------------------------------------------------------------------------------------------------------------------------------------

i: 	.space 4							# 4 bytes para guardar el nº de elemento a buscar.

# Modificación ejercicio 3.
#---------------------------------------------------------------------------------------------------------------------------------------------
msgIn:	.asciiz "Introduce el número de elemento a mostrar (0 -3): "	# Mensaje a mostrar para introducir el número de elemento a buscar.
#---------------------------------------------------------------------------------------------------------------------------------------------

	.text
	
.globl main # Procedimiento principal.
main:	

	# Modificaciones ejercicio 3.
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


	la $a0, msg # Pone en $a0 la dirección de la cadena
	li $v0, 4 # Código syscall para imprimir una cadena
	syscall # Imprime la cadena «El elemento buscado es:»

	li $v0, 1 # Código syscall para imprimir un entero
	move $a0, $t5 # Pone en $a0 el entero a imprimir
	syscall # Imprime el entero

	li $v0, 11 # Código syscall para imprimir un carácter
	lbu $a0, retcar # Carga en $a0 el carácter a imprimir (retcar)
	syscall # Imprime el caracter

	li $v0, 10 # Código syscall de exit
	syscall
	jr $ra
