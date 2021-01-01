################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../drivers/src/altera_avalon_jtag_uart_fd.c \
../drivers/src/altera_avalon_jtag_uart_init.c \
../drivers/src/altera_avalon_jtag_uart_ioctl.c \
../drivers/src/altera_avalon_jtag_uart_read.c \
../drivers/src/altera_avalon_jtag_uart_write.c \
../drivers/src/altera_avalon_sysid_qsys.c 

OBJS += \
./drivers/src/altera_avalon_jtag_uart_fd.o \
./drivers/src/altera_avalon_jtag_uart_init.o \
./drivers/src/altera_avalon_jtag_uart_ioctl.o \
./drivers/src/altera_avalon_jtag_uart_read.o \
./drivers/src/altera_avalon_jtag_uart_write.o \
./drivers/src/altera_avalon_sysid_qsys.o 

C_DEPS += \
./drivers/src/altera_avalon_jtag_uart_fd.d \
./drivers/src/altera_avalon_jtag_uart_init.d \
./drivers/src/altera_avalon_jtag_uart_ioctl.d \
./drivers/src/altera_avalon_jtag_uart_read.d \
./drivers/src/altera_avalon_jtag_uart_write.d \
./drivers/src/altera_avalon_sysid_qsys.d 


# Each subdirectory must supply rules for building sources it contributes
drivers/src/%.o: ../drivers/src/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: Nios II GCC C Compiler'
	nios2-elf-gcc -O2 -g -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


