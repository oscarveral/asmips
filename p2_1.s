
	.data	
	.align	2
MAX_LINEAS:
	.word 44
str000:
	.asciiz		"\Práctica 2 de ensamblador de ETC\n"
str001:
	.asciiz		"\n 1 - ¿Es primo? \n 2 - Dibujar triángulo \n 3 - Contar letras \n 4 - Calcular potencias \n 5 - Salir\n\nElige una opción: "
str002:
	.asciiz 	"\n"
str003: 
	.asciiz 	"Introduce un número: "
str004: 
	.asciiz 	"El número es primo."
str005: 
	.asciiz 	"El número no es primo."
str006:
	.asciiz 	"Introduce número de líneas: "
str007:
	.asciiz 	" "
str008:
	.asciiz 	"#"
str009:
	.asciiz 	"Introduce el caracter a contar: "
str010:
	.asciiz		"\nIntroduce el caracter de fin: "
str011:
	.asciiz		"\nEl caracter se ha introducido "
str012:
	.asciiz		"¡Adiós!\n"
str013:
	.asciiz		" veces.\n"
str014: 
	.asciiz		"\nIntroduce caracteres: "
str015: 
	.asciiz		"Introduce un número base: "
str016: 
	.asciiz		"Introduce hasta que potencia calcular: "
str017: 
	.asciiz		"Opción incorrecta. Pulse cualquier tecla para seguir.\n"
 
	.text	
	
# Opción 1. Devuelve true (1) si el número es primo, false (0) en caso contrario
es_primo:                                       # $a0 es num

        blt 	$a0, 2, devuelve0	# Comparación del primer if
        beq 	$a0, 2, devuelve1	# Comparación del segundo if anidado.
	rem 	$t0, $v0, 2		# Establecimiento del resto de la división
	beqz 	$t0, devuelve0		# Comparación del último if anidado
	
	addiu 	$t1, $zero, 3		# Establecimiento de la variable i
bucle_for1:
	bge	$t1, $a0, devuelve1	# Comparación de ruptura de bucle.
	rem 	$t2, $a0, $t1		# Operación para establecer el resto de la división.
	beqz	$t2, devuelve0		# Comparación del resto de la división
	addiu 	$t1, $t1, 2		# Incremento del contador
	j 	bucle_for1		# Salto inconcicional al bucle for de nuevo
	
devuelve1:			# Rutina para la devolución de verdadero.
	li	$v0, 1
        jr 	$ra
devuelve0:			# Rutina para la devolución de falso.
	li 	$v0, 0
	jr 	$ra
        
# Opción 2. Dibuja el triángulo, no devuelve ningún valor
dibujar_triangulo:                              # a0 es num_lineas

	sw	$ra, 0($sp)			# Apilo la dirección de retorno para no perderla

        move 	$t1, $a0			# Establecimiento de la variable max_lineas
        lw	$t6, MAX_LINEAS			# Cargo en $t6 el contenido de MAX_LINEAS para poder hacer comparaciones
      	ble 	$a0, $t6, fin_if		# Comparación del if.
	lw	$t1, MAX_LINEAS	  		# Asignación a max_lineas = MAX_LINEAS
fin_if:	
	move 	$t2, $t1			# Establecimiento inicial de la variable blancos
	addi 	$t2, $t2, -1			# Establecimiento final de la variable blancos.
	li	$t3, 1				# Variable elementos
	
	move	$t4, $zero			# Variable i del primer for.
bucle_for2:
	bge	$t4, $t1, fin_for2		# Comparación de ruptura de bucle.
	
	move 	$t5, $zero			# Variable k de los bucles for anidados
bucle_for2_anidado1:
	bge	$t5, $t2, fin_for2_anidado1	# Comparación de ruptura de bucle
	
	la	$a0, str007			# Dibujado de espacios en blanco (almaceno la dirección de retorno para poder recuperarla despues de llamar a print_string)
	jal	print_string
	
	addiu 	$t5, $t5, 1			# Incremento del contador k
	j 	bucle_for2_anidado1		# Salto incondicional al principio del bucle_for2_anidado1
fin_for2_anidado1:

	move	$t5, $zero			# Reestablecimiento del contador k a 0.
bucle_for2_anidado2:
	bge	$t5, $t3, fin_for2_anidado2	# Comprobación de ruptura de bucle
	
	la	$a0, str008			# Dibujado de almohadillas (almaceno la dirección de retorno para poder recuperarla despues de llamar a print_string)
	jal	print_string

	addiu	$t5, $t5, 1			# Incremento del contador
	j	bucle_for2_anidado2		# Salto incondicional para repetir el bucle.
fin_for2_anidado2:

	la	$a0, str002			# Dibujado del salto de linea para poder hacer el triángulo. ((almaceno la dirección de retorno para poder recuperarla despues de llamar a print_string)
	jal 	print_string
	
	add	$t2, $t2, -1			# Decremento de la variable blancos
	add	$t3, $t3, 2			# Incremento de la variable elementos
	
	addiu 	$t4, $t4, 1			# Incremento del cotador i
	j	bucle_for2			# Salto incondicional al principio del bucle_for2
fin_for2:
	lw	$ra, 0($sp)			# Desapilo la dirección de retorno para poder usarla.
	jr 	$ra				# Vuelta a main.

# Opción 3. Devuelve el número de veces que se ha pulsado una tecla
contar_letras:                                  # a0 es contar_c, a1 es fin_c
        sw	$ra, 0($sp)			# Apilado de la dirección de retorno
        li	$t1, 0				# Contadr de letras
        
bucle_while_letras:
	jal	read_character		# Lectura del caracter introducido en el teclado
	beq 	$v0, $a1, fin_while_letras	# Comparación de ruptura de while
	
	bne	$v0, $a0, fin_if_letras		# Comprobación de si la tecla pulsada es igual a la que queremos contar. Si no es así salta al fin_if_letras
	addi	$t1, $t1, 1			# Incremento del contador de letras
fin_if_letras:

	j	bucle_while_letras
fin_while_letras:
        
        move	$v0, $t1
        lw	$ra, 0($sp)			# Desapilado de la dirección de retorno.
        jr 	$ra				# Vuelta al programa principal

# Opcion 4
calcular_potencias:                             # a0 es base y $a1 num_potencias
        sw	$ra, 0($sp)			# Almacenamiento de la dirección de retorno
        
        move 	$t1, $a0			# Copio la base a $t1 para no perderlo
        move 	$t2, $a1			# Copio el numero de potencias a $t2 para no perderlo
        move 	$t3, $a0			# Copio la base a $t3 para usarlo de registro temporal para almacenar los valores de las potencias
        
       	move	$t0, $zero			# Inicialización de un contador de bucle
bucle_for_potencias:
	bgt	$t0, $t2, fin_bucle_for_potencias	# Comprobación de continuación de bucle
	
	move 	$a0, $t0
	jal	print_integer			# Imprimo el número de potencia actual, que se corresponde con la iteración del bucle
	
	la 	$a0, str007
	jal	print_string			# Imprimo un espacio en blanco (estético)
	
	beqz 	$t0, fin_if_exponente0		# Trato el caso de que el exponente sea 0 para que el resultado sea 1 por definición
	beq	$t0, 1, fin_if_exponente1	# Trato el caso de que el exponente sea 1 ya que la potencia es la misma base
	mul 	$t3, $t3, $t1			# Calculo del valor actual de la potencia.
	move 	$a0, $t3
	j	impresion_potencia		# Salto a la impresión del número
fin_if_exponente0:
	li	$a0, 1 				# Muevo a $a0 la potencia.
	j	impresion_potencia		# Salto a la impresión del número
fin_if_exponente1:
	move	$a0, $t1
impresion_potencia:	
	jal 	print_integer			# Imprimo el valor actual de la potencia
	
	la 	$a0, str002
	jal 	print_string			# Imprimo el salto de linea
	
	addi	$t0, $t0, 1
	j	bucle_for_potencias		# Salto incondicional al principio del bucle
fin_bucle_for_potencias:        

        lw	$ra, 0($sp)			# Desapilado de la dirección de retorno
        jr 	$ra 				# Vuelta al programa principal

	.globl	main
main:
	addiu	$sp, $sp, -12
	sw	$ra, 8($sp)
	sw	$s1, 4($sp)
	sw	$s0, 0($sp)
	jal	clear_screen
	la	$a0, str000
	jal	print_string
B4_2:	
	la	$a0, str001
	jal	print_string
	jal	read_character
	move	$s1, $v0
	la	$a0, str002
	jal	print_string
	beq	$s1, '5', B4_7
	bne	$s1, '4', B4_8
	la 	$a0, str015
	jal 	print_string
	jal 	read_integer
	move 	$s0, $v0
	la 	$a0, str016
	jal 	print_string
	jal 	read_integer
	move 	$a1, $v0
	move 	$a0, $s0
	jal	calcular_potencias
	j	B4_2
B4_7:	la	$a0, str012
	jal	print_string
	li	$a0, 0
	jal	mips_exit
	j	B4_2
B4_8:	bne	$s1, '3', B4_11
	la 	$a0, str009
	jal 	print_string
	jal 	read_character
	move 	$s0, $v0
	la 	$a0, str010
	jal 	print_string
	jal 	read_character
	move 	$a1, $v0
	move 	$a0, $s0
	jal 	contar_letras
	move 	$s0, $v0
	la 	$a0, str011
	jal	print_string
	move 	$a0, $s0
	jal 	print_integer
	la 	$a0, str013
	jal	print_string
	j B4_2
B4_11:	bne	$s1, '2', B4_10
	la	$a0, str006
	jal	print_string
	jal	read_integer
	move	$a0, $v0 
	jal	dibujar_triangulo
	j 	B4_2 
B4_10:  bne	$s1, '1', B4_14
	la 	$a0, str003
	jal 	print_string
	jal	read_integer
	move 	$a0, $v0
	jal 	es_primo
	beqz 	$v0, B4_13
	la 	$a0, str004
	jal 	print_string
	j 	B4_2
B4_13:  la 	$a0, str005
	jal 	print_string
	j 	B4_2
B4_12:	la	$a0, str013
	jal	print_string
	jal	read_character	# 121 read_character(); 
	j	B4_2
B4_14:  la      $a0, str017
        jal     print_string
        jal     read_character
	j	B4_2        
	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	lw	$ra, 8($sp)
	addiu	$sp, $sp, 12
	jr $ra

print_integer:
	li	$v0, 1
	syscall	
	jr	$ra

read_integer:
	li	$v0, 5
	syscall	
	jr	$ra

print_string:
	li	$v0, 4
	syscall	
	jr	$ra

read_character:
	li	$v0, 12
	syscall	
	jr	$ra

clear_screen:
	li	$v0, 39
	syscall	
	jr	$ra

mips_exit:
	li	$v0, 17
	syscall	
	jr	$ra

