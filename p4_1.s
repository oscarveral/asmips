
	.data	
	.align	2
jump_table000:
	.word	B6_4
	.word	B6_5
	.word	B6_6
	.word	B6_9
	.word	B6_22
str000:
	.asciiz		"Contenido actual de la agenda:\n"
str001:
	.asciiz		" - Nombre: "
str002:
	.asciiz		", Edad: "
str003:
	.asciiz		", Email: "
str004:
	.asciiz		"\n"
str005:
	.asciiz		"Introduzca el nombre del nuevo contacto: "
str006:
	.asciiz		"Introduzca la edad del nuevo contacto: "
str007:
	.asciiz		"Introduzca el correo del nuevo contacto: "
str008:
	.asciiz		"\nPráctica 4 de ensamblador de ETC\n\n 1 - Estructuras\n 2 - Arrays y cadenas\n 3 - Arrays bidimensionales\n 4 - Estructuras\n 0 - Salir\n\nElige una opción: "
str009:
	.asciiz		"("
str010:
	.asciiz		","
str011:
	.asciiz		") + ("
str012:
	.asciiz		") = ("
str013:
	.asciiz		")\n"
str014:
	.asciiz		"\nFrecuencia de cada letra en el texto:\n"
str015:
	.asciiz		": "
str016:
	.asciiz		"matA:\n"
str017:
	.asciiz		" "
str018:
	.asciiz		"matB:\n"
str019:
	.asciiz		"matC = matA × matB:\n"
str020:
	.asciiz		"¡Adiós!\n"
str021:
	.asciiz		"Opción incorrecta. Pulse cualquier tecla para seguir.\n"

# variables del ejercicio 1
	.align 2 	# Alineao datos para evitar posibles errores.
vb:
        .space 12	# Espacio para 3 enteros.
vc:
  	.space 12	# Espacio para 3 enteros.
va:
       	.space 12	# Espacio para 3 enteros.


# variables del ejercicio 2
texto:
        .asciiz		"En un lugar de la Mancha, de cuyo nombre no quiero acordarme, no ha mucho tiempo que..."
cuentas_letras:
	.align 	2	# Alineo para poder almacenar bien los enteros.
        .space	104	# Array de 26 enteros, 1 para cada letra del abecedario.

# variables del ejercicio 3
matA:   
        .word	3, 4, 5, 6
        .word	2, 1, 3, 0
        .word	7, 8, 7 ,2
        .word	0, 1, 9, 5
        .word	8, 3, 6, 1
matB:   
        .word	7, 8, 2
        .word	3, 7, 1
        .word	9, 0, 1
        .word	1, 2, 4
matC:   
        .space	60	# Espacio para 15 enteros (15*4 = 60 bytes)

# variables del ejercicio 4 y 5
numeroContactos:
	.word 4
agenda:

	.byte 'M','a','r','i','a'
	.space 95
	.word 21
	.byte 'm','a','r','i','a','@','e','x','a','m','p','l','e','.','o','r','g'
	.space 33
	.align 2
	
	.byte 'P','e','p','e'
	.space 96
	.word 20
	.byte 'p','e','p','e','@','e','x','a','m','p','l','e','.','o','r','g'
	.space 34
	.align 2
	
	.byte 'P','a','c','o'
	.space 96
	.word 22
	.byte 'p','a','c','o','@','e','x','a','m','p','l','e','.','o','r','g'
	.space 34
	.align 2
	
	.byte 'L','o','l','a'
	.space 96
	.word 19
	.byte 'l','o','l','a','@','e','x','a','m','p','l','e','.','o','r','g'
	.space 34
	.align 2
	
	.space 155376	# Reserva de 154 bytes para cada uno de los 996 posibles contactos (100 + 4 + 50 + 2(alineamiento))*996

        
	.text	

sumar_vb_vc:
        lw	$t0, vb		# Carga de la variable x de vb
        lw	$t1, vc		# Carga de la variable x de vc
        add	$t1, $t1, $t0	# Suma
        sw	$t1, va		# Almacenamiento de la x de va
        
        lw	$t0, vb+4	# Carga de la variable y de vb
        lw	$t1, vc+4	# Carga de la variable y de vc
        add	$t1, $t1, $t0	# Suma
        sw	$t1, va+4	# Almacenamiento del resultado.
        
        lw	$t0, vb+8	# Carga de la variable z de vb
        lw	$t1, vc+8	# Carga de la variable z de vc
        add	$t1, $t1, $t0	# Suma
        sw	$t1, va+8	# Almacenamiento del resultado.
        
        jr	$ra		# Retorno al procedimiento principal

contar_letras:
        # Inicialización del array cuenta_letras a 0 para cada uno de sus elementos.
        
      	move	$t0, $zero							# Inicialización del contador a 0
	inicializacion_array:
        	bge 	$t0, 104, fin_inicializacion_array 			# Comparación de finalización del bucle (104 = 26*4)
        	sw 	$zero, cuentas_letras($t0)				# Almaceno 0 en todos los elementos del array.
        	addi	$t0, $t0, 4						# Incremento el contador en 4, para permitir acceder de forma directa a cada entero del array
        	j	inicializacion_array					# Salto al inicio de bucle
	fin_inicializacion_array:
	
		# Bucle principal de la función
	
	move 	$t0, $zero							# Inicialización del contador a 0
	contado_letras:
		lb	$t2, texto + 0($t0)					# Cargo en el registro $t2 el contenido correspondiente de la cadena.
		beq 	$t2, '\0' , fin_contado_letras				# Comparación de finalización de bucle.
		
		blt 	$t2, 'a', fin_comprobacion_letra			# Comprobación de si la letra es menor que a
		bgt	$t2, 'z', fin_comprobacion_letra			# Comprobación de si la letra es mayor que z
		sub	$t3, $t2, 'a'						# Almaceno el índice que le correspondería a dicha letra
		mul	$t3, $t3, 4						# Multiplico el índice por 4 para acceder correctamente al array de enteros
		lw	$t1, cuentas_letras + 0($t3)				# Cargo el valor anterior que estaba almacenado en el array en dicha posición
		add	$t1, $t1, 1						# Incremento la cuenta en 1
		sw	$t1, cuentas_letras + 0($t3)				# Almaceno la nueva cantidad en la misma posición en la que vino
		
		fin_comprobacion_letra:
		
		addi	$t0, $t0, 1						# Actualización del contador
		j	contado_letras
	fin_contado_letras:
	
        jr	$ra	
multiplicar_matA_matB:
       move 	$t0, $zero 								# Variable i del bucle
        inicio_for_primario:
        	bge 	$t0, 5, fin_for_primario					# Comparación de ruptura del primer bucle
        	
        	li 	$t1,0 								# Variable j del bucle
        		inicio_for_secundario:
        		bge 	$t1, 3, fin_for_secundario				# Comprobación de ruptura del segundo bucle
        		move	$t2, $zero						# Variable r dentro del bucle
        		
        		move	$t3, $zero						# Variable k del bucle
        			inicio_for_terciario:
        			bge 	$t3, 4, fin_for_terciario			# Comprobación de ruptura del tercer bucle
   
   				sll 	$t6,$t3,2 					
   				mul 	$t5,$t0,16 
   				add 	$t5,$t5,$t6					# Cálculo de la posición relativa del elemento a multiplicar en matA
   				la 	$t7,matA					
   				add 	$t5,$t5,$t7 					# Cálculo de la dirección de memoria del elemento
   	
  				sll 	$t6,$t1,2 
  				mul 	$t7,$t3,12 
  				add 	$t6,$t6,$t7					# Cálculo de la posición relativa del elemento a multiplicar en matB
  				la 	$t4 matB
  				add 	$t6,$t6,$t4  					# Cálculo de la dirección de memoria del elemento
  	
  				lw 	$t5,0($t5)				
   				lw 	$t6,0($t6)					# Carga de los elementos a multiplicar
   	 
   				mul	$t4,$t5,$t6					# Multiplicación de ambos elementos
   				add 	$t2,$t2,$t4					# Cáculo de la suma de las multiplicaciones sucesivas
   				
   				addiu 	$t3,$t3,1					# Incremento del contador de ciclo
        			j inicio_for_terciario					# Salto al inicio del bucle
        			
       			fin_for_terciario: 
       			la 	$t5,matC		
        		mul 	$t7,$t0,12 
        		sll 	$t4,$t1,2 
        		add 	$t4,$t4,$t7
        		add 	$t4,$t4,$t5						# Calculo de la dirección en la que escribir el número
        		sw 	$t2,0($t4)						# Escritura del número resultado de la multipliación de fila por columna
        		
        		addiu $t1,$t1,1    						# Incremento del contador
       	 		j inicio_for_secundario						# Salto al principio de bucle
       	 		
        	fin_for_secundario:
        	addiu $t0,$t0,1								# Incremento del contador
        	j inicio_for_primario							# Salto al inicio del bucle
        	
        fin_for_primario:
        
        jr 	$ra	

mostrar_agenda:
        addi	$sp, $sp, -4								# Ampliación de la pila
	sw	$ra, 0($sp)								# Almacenamiento de la dirección de retorno en la pila
        
        la	$a0, str000
  	jal	print_string								# Impresión de la primera cadena de texto
  	
  	move	$t0, $zero								# Varibale del bucle for
  	for_agenda:
  		lw	$t1, numeroContactos						# Cargo la variable de comparación
  		bge	$t0, $t1, fin_for_agenda					# Comparación de ruptura de bucle
  		
  		move	$a0, $t0
  		jal	print_integer							# Impresión de i
  		la	$a0, str001
  		jal	print_string							# Impresión de la cadena pre nombre
  		
  		mul	$t2, $t0, 156							# Obtengo la dirección de memoria del inicio del contacto
  		
  		la	$a0, agenda($t2)						# Carga del nombre en el registro de variable
  		jal	print_string							# Impresión del nombre
  		
  		la	$a0, str002
  		jal	print_string							# Impresión de la cadena pre edad
  		
  		lw	$a0, agenda + 100($t2)
  		jal	print_integer							# Impresión de la edad
  		
  		la	$a0, str003
  		jal	print_string							# Impresión de la cadena pre email
  		
  		la	$a0, agenda + 104($t2)
  		jal	print_string							# Impresión del email
  		
  		la	$a0, str004
  		jal	print_string							# Impresión del salto de linea
  		
  		addiu	$t0, $t0, 1							# Incremento de contador
  		j	for_agenda							# Salto al inicio del bucle
        fin_for_agenda:
        
        lw	$ra, 0($sp)								# Carga de la dirección de retorno
        addi	$sp, $sp, 4								# Disminución de la pila
        jr	$ra			

read_line:
	addiu	$sp, $sp, -32
	sw	$ra, 28($sp)
	sw	$s1, 24($sp)
	sw	$s0, 20($sp)
	move	$s0, $a1
	move	$s1, $a0
	jal	read_string
	slti	$t8, $s0, 1
	bnez	$t8, B4_6
	li	$v0, 0
	li	$v1, 10
B4_2:	addu	$a0, $s1, $v0
	lbu	$a1, 0($a0)
	beqz	$a1, B4_6
	bne	$a1, $v1, B4_5
	sb	$zero, 0($a0)
B4_5:	addiu	$v0, $v0, 1
	slt	$t8, $v0, $s0
	bnez	$t8, B4_2
B4_6:	lw	$s0, 20($sp)
	lw	$s1, 24($sp)
	lw	$ra, 28($sp)
	addiu	$sp, $sp, 32
	jr	$ra

anadir_contacto:
      	
      	add	$sp, $sp, -4
      	sw	$ra, 0($sp)					# Guardado de la dirección de retorno
      	
      	la	$a0, str005
      	jal	print_string					# Impresión de la cadena pre nombre
      	
      	lw	$t0, numeroContactos				# Cargo la cantidad de contactos en un registro
      	mul	$t1, $t0, 156					# Calculo la dirección de memoria que ocupará el nuevo contacto (no hace falta sumar 1 ya que hemos empezado a sumar desde 0)
      	
      	la	$a0, agenda($t1)				# Primer parámetro, dirección de escritura
      	li	$a1, 100					# Segundo parámetro, tamaño máximo de la cadena
      	jal 	read_line					# Lectura de cadena
      	
      	la	$a0, str006				
      	jal	print_string					# Impresión de la cadena pre edad
      	
      	jal 	read_integer					# Lectura de la edad
      	sw	$v0, agenda + 100($t1)				# Guardado de la edad
      	
      	la	$a0, str007					
      	jal	print_string					# Impresión de la cadena pre email
      	
      	la	$a0, agenda + 104($t1)				# Dirección donde se guardará el email
      	li	$a1, 50						# Tamaño máximo del email
      	jal	read_line					# Lectura de la cadena
      	
      	#Bucle para poner el email en minusculas.
      	move	$t2, $zero					# Variable de recorrido del bucle
      	la	$t1, agenda + 104($t1)				# Cargo la dirección de memoria del primer caracter del email que toca modificar
      	inicio_bucle:
      		bge	$t2, 50, fin_bucle			# Primera condición de fin de bucle
      		lb	$t3, 0($t1)				# Cargo el contenido del caracter que quiero en $t3
      		beq	$t3, '\0', fin_bucle			# Segunda condición de fin de bucle
      		
      		blt	$t3, 'A', fin_if_email			# Primera condición del if
      		bgt	$t3, 'Z', fin_if_email			# Segunda condición del if
      		add	$t3, $t3, 32				# Cálculo de la nueva letra
      		sb	$t3,0($t1)				# Guardado de la nueva letra
      		fin_if_email:
      		add	$t1, $t1, 1				# Incremento la posición de la dirección de memoria del caracter que quiero evaluar.
      		add	$t2, $t2, 1				# Incremento el contador
      		j	inicio_bucle				# Regreso al inicio del bucle
      	fin_bucle:
      	
      	add	$t0, $t0, 1					# Aumento del contador de contactos
      	sw	$t0, numeroContactos				# Guardado del nuevo contador de contactos
      	
      	lw	$ra, 0($sp)
      	addiu	$sp, $sp, 4					# Cargado de la dirección de retorno
	jr	$ra						# Retorno al programa principal
	
	.globl	main
main:
	addiu	$sp, $sp, -112
	sw	$ra, 108($sp)
	sw	$fp, 104($sp)
	sw	$s7, 100($sp)
	sw	$s6, 96($sp)
	sw	$s5, 92($sp)
	sw	$s4, 88($sp)
	sw	$s3, 84($sp)
	sw	$s2, 80($sp)
	sw	$s1, 76($sp)
	sw	$s0, 72($sp)
	jal	clear_screen
	la	$t8, str008
	sw	$t8, 64($sp)
	la	$t8, str004
	sw	$t8, 60($sp)
	la	$t8, str021
	sw	$t8, 56($sp)
	la	$t8, str020
	sw	$t8, 52($sp)
	la	$t8, str009
	sw	$t8, 48($sp)
	la	$s2, str010
	la	$t8, str011
	sw	$t8, 44($sp)
	la	$t8, str012
	sw	$t8, 40($sp)
	la	$t8, str013
	sw	$t8, 36($sp)
	la	$t8, str014
	sw	$t8, 32($sp)
	la	$t8, str015
	sw	$t8, 68($sp)
	la	$t8, str016
	sw	$t8, 28($sp)
	la	$s4, str017
	li	$s1, 5
	la	$t8, str018
	sw	$t8, 24($sp)
	la	$t8, str019
	sw	$t8, 20($sp)
	j	B6_2
B6_1:	lw	$a0, 56($sp)
	jal	print_string
	jal	read_character
B6_2:	lw	$a0, 64($sp)
	jal	print_string
	jal	read_character
	move	$fp, $v0
	lw	$s3, 60($sp)
	move	$a0, $s3
	jal	print_string
	move	$a0, $s3
	jal	print_string
	sll	$t8, $fp, 24
	sra	$t8, $t8, 24
	addiu	$v0, $t8, -48
	li	$t8, 4
	sltu	$t8, $t8, $v0
	bnez	$t8, B6_1
	sll	$t8, $v0, 2
	lw	$t8, jump_table000($t8)
	jr	$t8
B6_4:	lw	$a0, 52($sp)
	jal	print_string
	li	$a0, 0
	jal	mips_exit
	j	B6_2
B6_5:	li	$t8, 7
	sw	$t8, vb
	la	$s6, vb
	li	$t8, 8
	sw	$t8, 4($s6)
	li	$t8, 9
	sw	$t8, 8($s6)
	li	$t8, 3
	sw	$t8, vc
	la	$fp, vc
	li	$t8, 4
	sw	$t8, 4($fp)
	li	$t8, 2
	sw	$t8, 8($fp)
	jal	sumar_vb_vc
	lw	$a0, 48($sp)
	jal	print_string
	lw	$a0, vb
	jal	print_integer
	move	$a0, $s2
	jal	print_string
	lw	$a0, 4($s6)
	jal	print_integer
	move	$a0, $s2
	jal	print_string
	lw	$a0, 8($s6)
	jal	print_integer
	lw	$a0, 44($sp)
	jal	print_string
	lw	$a0, vc
	jal	print_integer
	move	$a0, $s2
	jal	print_string
	lw	$a0, 4($fp)
	jal	print_integer
	move	$a0, $s2
	jal	print_string
	lw	$a0, 8($fp)
	jal	print_integer
	lw	$a0, 40($sp)
	jal	print_string
	lw	$a0, va
	jal	print_integer
	move	$a0, $s2
	jal	print_string
	la	$s3, va
	lw	$a0, 4($s3)
	jal	print_integer
	move	$a0, $s2
	jal	print_string
	lw	$a0, 8($s3)
	jal	print_integer
	lw	$a0, 36($sp)
	jal	print_string
	j	B6_2
B6_6:	jal	contar_letras
	lw	$a0, 32($sp)
	jal	print_string
	la	$s6, cuentas_letras
	li	$fp, 97
B6_7:	sll	$t8, $fp, 24
	sra	$a0, $t8, 24
	jal	print_character
	lw	$a0, 68($sp)
	jal	print_string
	lw	$a0, 0($s6)
	jal	print_integer
	la	$a0, str004
	jal	print_string
	addiu	$fp, $fp, 1
	li	$t8, 123
	addiu	$s6, $s6, 4
	bne	$fp, $t8, B6_7
	j	B6_2
B6_9:	jal	multiplicar_matA_matB
	lw	$a0, 28($sp)
	jal	print_string
	la	$fp, matA
	li	$s6, 0
B6_10:	li	$s3, 4
	move	$s5, $fp
B6_11:	lw	$a0, 0($s5)
	jal	print_integer
	move	$a0, $s4
	jal	print_string
	addiu	$s3, $s3, -1
	addiu	$s5, $s5, 4
	bnez	$s3, B6_11
	la	$a0, str004
	jal	print_string
	addiu	$s6, $s6, 1
	addiu	$fp, $fp, 16
	bne	$s6, $s1, B6_10
	lw	$a0, 24($sp)
	jal	print_string
	la	$s5, matB
	li	$s6, 0
B6_14:	li	$s3, 3
	move	$fp, $s5
B6_15:	lw	$a0, 0($fp)
	jal	print_integer
	la	$a0, str017
	jal	print_string
	addiu	$s3, $s3, -1
	addiu	$fp, $fp, 4
	bnez	$s3, B6_15
	la	$a0, str004
	jal	print_string
	addiu	$s6, $s6, 1
	li	$t8, 4
	addiu	$s5, $s5, 12
	bne	$s6, $t8, B6_14
	lw	$a0, 20($sp)
	jal	print_string
	la	$fp, matC
	li	$s6, 0
B6_18:	li	$s3, 3
	move	$s5, $fp
B6_19:	lw	$a0, 0($s5)
	jal	print_integer
	la	$a0, str017
	jal	print_string
	addiu	$s3, $s3, -1
	addiu	$s5, $s5, 4
	bnez	$s3, B6_19
	la	$a0, str004
	jal	print_string
	addiu	$s6, $s6, 1
	addiu	$fp, $fp, 12
	bne	$s6, $s1, B6_18
	j	B6_2
B6_22:	jal	anadir_contacto
	jal	mostrar_agenda
	j	B6_2
	lw	$ra, 108($sp)
	lw	$fp, 104($sp)
	lw	$s7, 100($sp)
	lw	$s6, 96($sp)
	lw	$s5, 92($sp)
	lw	$s4, 88($sp)
	lw	$s3, 84($sp)
	lw	$s2, 80($sp)
	lw	$s1, 76($sp)
	lw	$s0, 72($sp)
	addiu	$sp, $sp, 112
        jr      $ra

print_integer:
	li	$v0, 1
	syscall	
	jr	$ra

read_integer:
	li	$v0, 5
	syscall	
	jr	$ra

read_string:
	li	$v0, 8
	syscall	
	jr	$ra

print_character:
	li	$v0, 11
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
