PROJ_NAME=stm32f4_Gamepad

################################################################################
#                   SETUP TOOLS                                                #
################################################################################

CC      = arm-none-eabi-gcc
OBJCOPY = arm-none-eabi-objcopy
GDB     = arm-none-eabi-gdb
AS      = arm-none-eabi-as

##### Preprocessor options

# directories to be searched for header files
INCLUDE = $(addprefix -I,$(INC_DIRS))

# #defines needed when working with the STM peripherals library
DEFS = -DUSE_STDPERIPH_DRIVER -DSTM32F4XX -DMANGUSTA_DISCOVERY -DUSE_USB_OTG_FS -DHSE_VALUE=8000000

##### Assembler options

AFLAGS  = -mcpu=cortex-m4 
AFLAGS += -mthumb
AFLAGS += -mthumb-interwork
AFLAGS += -mlittle-endian
AFLAGS += -mfloat-abi=hard
AFLAGS += -mfpu=fpv4-sp-d16

##### Compiler options

CFLAGS  = -ggdb
CFLAGS += -O0
CFLAGS += -Wall -Wextra -Warray-bounds
CFLAGS += $(AFLAGS)

##### Linker options

# tell ld which linker file to use
# (this file is in the current directory)
LFLAGS  = -Tstm32_flash.ld


################################################################################
#                   SOURCE FILES DIRECTORIES                                   #
################################################################################
# Specify the root of you STM32f4 FW
STM_ROOT         =../STM32F4-Discovery_FW_V1.1.0

STM_SRC_DIR      = $(STM_ROOT)/Libraries/STM32F4xx_StdPeriph_Driver/src
STM_SRC_DIR     += $(STM_ROOT)/Utilities/STM32F4-Discovery
STM_SRC_DIR     += $(STM_ROOT)/Libraries/STM32_USB_OTG_Driver/src/
STM_SRC_DIR     += $(STM_ROOT)/Libraries/STM32_USB_Device_Library/Class/hid/src
STM_SRC_DIR     += $(STM_ROOT)/Libraries/STM32_USB_Device_Library/Core/src
STM_STARTUP_DIR += $(STM_ROOT)/Libraries/CMSIS/ST/STM32F4xx/Source/Templates/TrueSTUDIO

vpath %.c $(STM_SRC_DIR)
vpath %.s $(STM_STARTUP_DIR)


################################################################################
#                   HEADER FILES DIRECTORIES                                   #
################################################################################

# The header files we use are located here
INC_DIRS  = $(STM_ROOT)/Utilities/STM32F4-Discovery
INC_DIRS += $(STM_ROOT)/Libraries/CMSIS/Include
INC_DIRS += $(STM_ROOT)/Libraries/CMSIS/ST/STM32F4xx/Include
INC_DIRS += $(STM_ROOT)/Libraries/STM32F4xx_StdPeriph_Driver/inc
INC_DIRS += $(STM_ROOT)/Libraries/STM32_USB_Device_Library/Class/hid/inc
INC_DIRS += $(STM_ROOT)/Libraries/STM32_USB_Device_Library/Core/inc
INC_DIRS += $(STM_ROOT)/Libraries/STM32_USB_OTG_Driver/inc
INC_DIRS += .


################################################################################
#                   SOURCE FILES TO COMPILE                                    #
################################################################################

SRCS += main.c \
	stm32f4xx_it.c \
	system_stm32f4xx.c \
	usb_bsp.c \
	usbd_desc.c \
	usbd_usr.c \
	stm32f4_discovery.c \
	stm32f4xx_syscfg.c \
	misc.c \
	stm32f4xx_exti.c \
	stm32f4xx_gpio.c \
	stm32f4xx_rcc.c \
	stm32f4xx_tim.c \
	usb_dcd_int.c \
	usb_core.c \
	usb_dcd.c \
	usbd_hid_core.c \
	usbd_req.c \
	usbd_core.c \
	usbd_ioreq.c

# startup file, calls main
ASRC  = startup_stm32f4xx.s

OBJS  = $(SRCS:.c=.o)
OBJS += $(ASRC:.s=.o)


######################################################################
#                         SETUP TARGETS                              #
######################################################################

.PHONY: all

all: $(PROJ_NAME).elf

%.o : %.c
	@echo "[Compiling  ]  $^"
	$(CC) -c -o $@ $(INCLUDE) $(DEFS) $(CFLAGS) $^

%.o : %.s
	@echo "[Assembling ]" $^
	$(AS) $(AFLAGS) $< -o $@


$(PROJ_NAME).elf: $(OBJS)
	@echo "[Linking    ]  $@"
	$(CC) $(CFLAGS) $(LFLAGS) $^ -o $@ 
	$(OBJCOPY) -O ihex $(PROJ_NAME).elf   $(PROJ_NAME).hex
	$(OBJCOPY) -O binary $(PROJ_NAME).elf $(PROJ_NAME).bin

clean:
	rm -f *.o $(PROJ_NAME).elf $(PROJ_NAME).hex $(PROJ_NAME).bin

