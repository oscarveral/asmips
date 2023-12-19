	.data
num1: 	.word 1000, 2000, 3000, 4000 		# Cuatro palaras con los valores 1000, 2000, 3000, 4000 respectivamente.

num2:	.half 100, 200, 300, 400 		# Cuatro medias palabras con los valores 100, 200, 300, 400 respectivamente.

num3:	.byte 10, 20, 30, 40 			# Cuatro bytes con los valores 10, 20, 30, 40 respectivamente.

retcar:	.byte '\n'				# Caracter de retorno de carro.
	.align 2
msg: 	.asciiz "El elemento buscado es:"	# Cadena para imprimir.

i: 	.space 4				# 4 bytes para guardar el nº de elemento a buscar.

# Ejercicio 1.
	
	# Las direcciones de memoria se ven en el segmento de datos.
	# Direcciones de memoria de los números apuntados por la etiqueta num1:	0x10010000 apunta a la palabra 1000, 
	#									0x10010004 apunta a la palabra 2000, 
	#									0x10010008 apunta a la palabra 3000, 
	#									0x1001000c apunta a la palabra 4000.

	# Para las direcciones de los datos a los que apunta la etiqueta num2 tendremos que los cuatro datos ocuparán 8 bytes (2 cada uno). Además de llevar cuidado con el orden en el que se almacenan en memoria little-endian.
	# Direcciones de memoria:	0x10010010 apunta a la media palabra 200,
	#				0x10010012 apunta a la media palabra 100,
	#				0x10010014 apunta a la media palabra 400,
	#				0x10010016 apunta a la media palabra 300.

	# Para las direcciones de los datos apuntados por la etiqueta num3 tendremos que todos los datos ocupan 4 bytes (1 cada uno). Cuidado con el orden de almacenamiento de los datos little-endian.
	# Direcciones de memoria: 	0x10010018 apunta al byte que almacena el valor 40,
	#				0x10010019 apunta al byte que almacena el valor 30,
	#				0x1001001a apunta al byte que almacena el valor 20,
	#				0x1001001b apunta al byte que almacena el valor 10.
	
	# Dirección del caracter de retorno de carro:	0x1001001c apunta al byte que contiene el caracter '\n'
	
	# Dirección de comienzo de la cadena msg: 0x1001001d apunta al comienzo de la cadena.
	
	# Dirección a la variable i: 0x10010035 apunta a la variable i.


	.text
# Procedimiento principal.
.globl main
main:	
	li $t0, 2 # Pone en $t0 el no de elemento a cargar

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
