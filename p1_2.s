	.data
num1: 	.word 1000, 2000, 3000, 4000 		# Cuatro palaras con los valores 1000, 2000, 3000, 4000 respectivamente.

num2:	.half 100, 200, 300, 400 		# Cuatro medias palabras con los valores 100, 200, 300, 400 respectivamente.

num3:	.byte 10, 20, 30, 40 			# Cuatro bytes con los valores 10, 20, 30, 40 respectivamente.

retcar:	.byte '\n'				# Caracter de retorno de carro.

# Podríamos alinear el mensaje para dejar el carácter de retorno de carro solo en un único "segmento" de 4 bytes y hacer que empieze este en otro "segmento".
# Es curioso porque si alineamos aquí con un .align 2 mueve los datos lo justo (gracias al tamaño del mensaje) para que tambíen se quede alineado el dato i. Si se prueba no olvide comentar el otro .align para que no alinees 2 veces.
# Esto podría ser util para evitar dejar 4 bytes en blanco entre la cadena de texto y el dato i después de realizar la alineación.

msg: 	.asciiz "El elemento buscado es:"	# Cadena para imprimir.
	
	# Alineación para poder guardar información en la palabra i.
	# ----------
	.align 2
	# ----------
i: 	.space 4				# 4 bytes para guardar el nº de elemento a buscar.

	.text
# Procedimiento principal.
.globl main
main:	
	li $t0, 2 # Pone en $t0 el no de elemento a cargar
	
	# Modificación para el ejercicio 2. Por si solo no va a hacer nada ya que el dato tiene un tamaño de 4 bytes y no se encuentra en una dirección de memoria múlltiplo de este (dato desalineado), entonces es necesario alinear el dato.
	# Error que salta:  line 22: Runtime exception at 0x00400008: store address not aligned on word boundary 0x10010035
	# ----------- 
	sw $t0, i
	# -----------
	
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
