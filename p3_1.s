        .data
msg1:   .asciiz "Introduce un número entre 1 y 99 (cualquier otro para salir):"
msg2:   .asciiz "El número "
msg3:   .asciiz " es par."
msg4:   .asciiz " es impar."
msg5:   .asciiz "Iteración: " 

        .text
	.globl	main
main:   
	#Ejercicio 2. Salvamos en la pila el valor de todos los registros preservados y $ra para evitar que sean borrados. Hemos sustituido todos los registros temporales por preservados para respetar el convenio de uso de registros.
	addi	$sp, $sp, -20
	sw	$s0, 16($sp)
	sw	$s1, 12($sp)
	sw	$s7, 8($sp)
	sw	$s2, 4($sp)
	sw	$ra, 0($sp)
	
        li      $s7, 0                  # Almacena los enteros que hemos pedido hasta ahora
        li      $s0, 1                  # Cota inferior para los enteros válidos
        li      $s1, 99                 # Cota superior para los enteros válidos
        
        # Ejercicio 1. El error del programa se encontraba aquí ya que saltaba al fin del programa despues de comparar $at con 10 cuando este registro es de uso exclusivo del ensamblador.
otro:   beq     $s7, 10, fin            # Acabamos cuando se hayan introducido 10 enteros
        la      $a0, msg5               # Imprimos la iteración por la que vamos
        jal     print_string
        move    $a0, $s7
        jal     print_integer
        jal     print_cr
        
       	move 	$a0, $s0
       	move 	$a1, $s1
	jal     pide_entero_rango       # Se pide un número entero en el rango [$t0, $t1] 
	
        beqz    $v0, fin                # Si el número no es válido, se acaba.
        move    $s2, $v0                # Guardamos el valor del número leído
        move    $a0, $v0                
        jal     es_par                  # Comprobamos si el número es par
        
        # Ejercicio 3. Necesitamos guardar el valor retornado por la función para poder compararlo después
        move 	$t0, $v0
        
        la      $a0, msg2               
        jal     print_string            # Imprimimos: "El número "
        move    $a0, $s2
        jal     print_integer           # Imprimimos el número
        
        # Problema del ejercicio 3. Se está comparándo $v0 con 0 cuando este registro contiene el código syscall que usó la llamada anterior. Habría que comparar con el registro $t0 en el que se ha guardado nuestro número.
        beqz    $t0, impar              # El número es impar
        la      $a0, msg3
        j       sigue
impar:  la      $a0, msg4
sigue:  jal     print_string
        jal     print_cr
        addi    $s7, $s7, 1
        j       otro        	
fin:    
	# Ejercicio 2. Desapilo los datos de los registros que estaba utilizando para devolverlos a su estado original.
	lw	$ra, 0($sp)
	lw 	$s2, 4($sp)
	lw	$s7, 8($sp)
	lw	$s1, 12($sp)
	lw	$s0, 16($sp)
	addi	$sp, $sp, 20
	
	li      $v0, 10                 # Código syscall de exit
        syscall         
	jr      $ra
	
pide_entero_rango: # Obtiene un entero por teclado y devuelve 0 si <= 1er argumento o >= 2do argumento. En otro caso, devuelve el entero leído.

	#Solución del problema del ejercicio 2. Apilar la dirección de vuelta para no perderla cuando se llamen a otras funciones
	addi	$sp, $sp, -4
	sw	$ra, 0($sp)
        
        #Solución ejercicio 2. Guardar el parámetro de entrada $a0 en un registro temporal ya que el regitro del parámetro de entrada va a ser sobreescrito justo después.
        move 	$t0, $a0
                                                                                                  
	la      $a0, msg1       # Mensaje para pedir el entero
	jal     print_string    # Imprime el mensaje
	jal     read_integer    # Lee un entero
	
	#Solución del ejercicio 2. Como el retorno de read_integer se guara en %v0 y al llamar a print_cr este registro va a ser sobreescrito es encesario guardar el valor en un regirstro temporal.
	move 	$t1, $v0
	
	jal     print_cr        # Imprime retorno de carro
	
	# Ejercicio 2. Ahora la comparación funciona bien al comparar con el registro temporal que almacenó el rango y no con el registro $a0 que contenía la dirección de memoria de la cadena de texto
	blt     $t1, $t0, per1  # Si el valor leído <= $a0, devuelve 0 
	bgt     $t1, $a1, per1  # Si el valor leído >= $a1, devuelve 0
	j       per2            # En otro caso, devuelve el entero leído
per1:   move    $v0,$zero
	j	final_procedimiento
per2:   
	# Retornamos el valor entero leido.
	move	$v0, $t1
final_procedimiento:	#Solución al ejercicio 2.  Desapilar ahora el valor de la dirección de retorno para poder regresar al programa principal.
	lw	$ra, 0($sp)
	addi	$sp, $sp, 4
	jr      $ra

es_par: # Recibe un número y devuelve 0 si impar y 1 si par
	not     $v0, $a0        # Negamos para que el bit menos significativo quede con el resultado buscado
	andi    $v0, $v0, 0x01  # Nos quedamos con el bit menos significativo 
	jr      $ra
		
print_integer: # Recibe un entero y lo imprime por consola
	li      $v0, 1          # Código de la llamada al sistema de imprimir entero
	syscall
	jr      $ra
					
print_string: # Recibe una cadena asciiz y la imprime por consola
	li      $v0, 4          # Código de la llamada al sistema de imprimir cadena
	syscall
	jr      $ra
	
print_cr: # Imprime un retorno de carro
	li      $a0, '\n'       # Cargamos el código ascii del retorno de carro
	li      $v0, 11         # Imprimimos el retorno de carro
	syscall                 # Llamada al sistema
	jr      $ra		
	
read_integer: # Devuelve un número entero leído por teclado
	li      $v0, 5          # Código de la llamada al sistema de leer entero
	syscall
	jr      $ra

