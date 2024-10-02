        .globl __start
__start:
        la $a0, prm1         # Cargar la dirección de prm1 en $a0
        li $v0, 4            # Código para imprimir cadena
        syscall               # Llamada al sistema para imprimir

        la $a0, orig         # Cargar la cadena original
        li $v0, 4            # Código para imprimir cadena
        syscall               # Llamada al sistema para imprimir

        la $s0, orig         # Apuntar al inicio de la cadena original
        li $t0, 0            # Inicializar contador a 0
        li $t2, 1            # Indicador para saber si se leyó un espacio
        li $t3, 0            # Indicador de rango de minúsculas
        li $t4, 0            # Indicador para caracteres fuera de rango
        li $t6, 0x20         # ASCII para espacio
        li $t7, 0x61         # ASCII para 'a'
        li $t8, 0x7A         # ASCII para 'Z'

loop:   
        lb $t1, 0($s0)       # Cargar el byte actual en $t1
        beq $t1, $zero, endLoop # Si es nulo, terminar el bucle

        slt $t3, $t1, $t7     # $t3 = 1 si $t1 < 'a'
        slt $t4, $t8, $t1     # $t4 = 1 si $t1 > 'z'
        or $t3, $t3, $t4      # $t3 = 1 si está fuera del rango minúscula

        beq $t2, $zero, nospace # Si no se leyó espacio antes
        bne $t3, $zero, nospace # Si no está en rango minúscula

        addi $t1, $t1, -32    # Convertir a mayúscula (restar 32)
        sb $t1, 0($s0)        # Almacenar el byte cambiado en la cadena

nospace:
        bne $t1, $t6, nospacenow # Si no es espacio, seguir
        li $t2, 1              # Se leyó espacio
        j endspace

nospacenow:
        li $t2, 0              # No se leyó espacio

endspace:
        addi $s0, $s0, 1       # Avanzar al siguiente carácter
        j loop                  # Repetir el bucle

endLoop:
        la $a0, prm2          # Cargar el mensaje "Upcased"
        li $v0, 4             # Código para imprimir cadena
        syscall                # Llamada al sistema para imprimir

        la $a0, orig          # Cargar la cadena original
        li $v0, 4             # Código para imprimir cadena
        syscall                # Llamada al sistema para imprimir

        li $v0, 10            # Código para terminar el programa
        syscall                # Llamada al sistema para terminar

.data
orig:   .asciiz "La cadena original con letras todas minusculas"
prm1:   .asciiz "Original: "
prm2:   .asciiz "\nUpcased: "
